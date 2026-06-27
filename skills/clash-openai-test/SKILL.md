---
name: clash-openai-test
description: Batch test Clash/Mihomo proxy nodes for OpenAI API connectivity. Detect which nodes can access OpenAI, measure latency, and identify blocked nodes.
---

# Clash OpenAI Node Tester

当用户需要测试哪些 Clash/Mihomo 代理节点能访问 OpenAI 时使用此 skill。

## 触发场景

- OpenAI API 连接失败，需要找可用节点
- 更换订阅后测试节点可用性
- 用户问"哪个节点能用"、"测试一下节点"

## 前置条件

- Mihomo/Clash Verge 运行中
- Clash API 通过 Unix socket 可达：`/tmp/verge/verge-mihomo.sock`
- 代理组名称通常为 `ChatGPT`、`OpenAI` 或 `GPT`

## 执行步骤

### 1. 确认 Mihomo 运行状态

```bash
curl -s --unix-socket /tmp/verge/verge-mihomo.sock http://localhost/proxies > /dev/null 2>&1 && echo "OK" || echo "NOT RUNNING"
```

### 2. 找到 OpenAI 代理组

```bash
curl -s --unix-socket /tmp/verge/verge-mihomo.sock http://localhost/proxies | python3 -c "
import sys, json
data = json.load(sys.stdin)
for name, info in data.get('proxies', {}).items():
    if 'all' in info and any(k in name.lower() for k in ['chatgpt', 'openai', 'gpt']):
        print(f'{name}: {len(info[\"all\"])} 个节点')
"
```

### 3. 批量测试节点

逐个切换节点并测试 API 连通性：

```bash
# 将 GROUP 替换为实际代理组名称（如 ChatGPT）
GROUP="ChatGPT"

# 获取节点列表
nodes=$(curl -s --unix-socket /tmp/verge/verge-mihomo.sock http://localhost/proxies/$GROUP | python3 -c "
import sys, json
data = json.load(sys.stdin)
for name in data.get('all', []):
    if name != '节点选择':
        print(name)
")

# 测试每个节点
while IFS= read -r node; do
    [ -z "$node" ] && continue
    
    # 切换节点
    curl -s --unix-socket /tmp/verge/verge-mihomo.sock -X PUT http://localhost/proxies/$GROUP \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"$node\"}" > /dev/null 2>&1
    sleep 0.3
    
    # 测试 API（HTTP 200/401 = 可用，000 = 超时，403 = CF拦截，451 = IP封禁）
    api_code=$(curl -x http://127.0.0.1:7897 --connect-timeout 5 -s -o /dev/null -w "%{http_code}" https://api.openai.com/v1/models 2>&1)
    
    # 测试延迟
    delay=$(curl -s --unix-socket /tmp/verge/verge-mihomo.sock "http://localhost/proxies/$node/delay?timeout=5000&url=https://api.openai.com" 2>/dev/null | python3 -c "
import sys,json
try:
    d=json.load(sys.stdin).get('delay',0)
    print(f'{d}ms' if d>0 else '超时')
except: print('错误')
" 2>/dev/null)
    
    case "$api_code" in
        200|401) status="✅ 可用" ;;
        000) status="❌ 超时" ;;
        403) status="⚠️ CF拦截" ;;
        451) status="🚫 IP封禁" ;;
        *) status="⚠️ $api_code" ;;
    esac
    
    printf "%-30s | %-7s | %s\n" "$node" "$status" "$delay"
done <<< "$nodes"
```

### 4. 输出格式

向用户展示表格结果，包含：节点名称、状态（✅/❌/⚠️）、延迟。

推荐延迟最低的可用节点。

### 5. （可选）切换到最佳节点

用户确认后，切换到推荐节点：

```bash
curl -s --unix-socket /tmp/verge/verge-mihomo.sock -X PUT http://localhost/proxies/ChatGPT \
    -H "Content-Type: application/json" \
    -d '{"name": "节点名称"}'
```

## 状态码说明

| 码 | 含义 |
|---|------|
| 200/401 | ✅ 可用（401 表示需要 API key，正常） |
| 000 | ❌ 连接超时或失败 |
| 403 | ⚠️ Cloudflare 验证（需浏览器） |
| 451 | 🚫 IP 被 OpenAI 封禁 |

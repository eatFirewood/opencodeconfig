#!/bin/bash
# Clash OpenAI Node Tester
# 用法: bash ~/.config/opencode/skills/clash-openai-test/test.sh

SOCKET="/tmp/verge/verge-mihomo.sock"
API="http://localhost"

# 检查 Mihomo 是否运行
if ! curl -s --unix-socket "$SOCKET" "$API/proxies" > /dev/null 2>&1; then
    echo "❌ Mihomo/Clash 未运行或 API 不可达"
    echo "   检查: ps aux | grep mihomo"
    exit 1
fi

# 自动检测 ChatGPT/OpenAI 代理组
GROUP=""
for name in "ChatGPT" "OpenAI" "GPT"; do
    if curl -s --unix-socket "$SOCKET" "$API/proxies/$name" | grep -q '"all"'; then
        GROUP="$name"
        break
    fi
done

if [ -z "$GROUP" ]; then
    echo "❌ 未找到 ChatGPT/OpenAI 代理组"
    echo "   可用的代理组:"
    curl -s --unix-socket "$SOCKET" "$API/proxies" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for name, info in data.get('proxies', {}).items():
    if 'all' in info and len(info.get('all', [])) > 0:
        print(f'   - {name} ({len(info[\"all\"])} 节点)')
" 2>/dev/null
    exit 1
fi

echo "=========================================="
echo "Clash OpenAI 节点测试"
echo "代理组: $GROUP"
echo "=========================================="
echo ""

# 获取所有节点
nodes=$(curl -s --unix-socket "$SOCKET" "$API/proxies/$GROUP" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for name in data.get('all', []):
    if name != '节点选择':
        print(name)
")

echo "节点名称                    | 状态   | 延迟"
echo "----------------------------|--------|------"

while IFS= read -r node; do
    [ -z "$node" ] && continue
    
    # 切换节点
    curl -s --unix-socket "$SOCKET" -X PUT "$API/proxies/$GROUP" \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"$node\"}" > /dev/null 2>&1
    sleep 0.3
    
    # 测试 API
    api_code=$(curl -x http://127.0.0.1:7897 --connect-timeout 5 -s -o /dev/null -w "%{http_code}" https://api.openai.com/v1/models 2>&1)
    
    # 测试延迟
    delay=$(curl -s --unix-socket "$SOCKET" "$API/proxies/$node/delay?timeout=5000&url=https://api.openai.com" 2>/dev/null | python3 -c "
import sys,json
try:
    d=json.load(sys.stdin).get('delay',0)
    print(f'{d}ms' if d>0 else '超时')
except: print('错误')
" 2>/dev/null)
    
    # 状态判断
    case "$api_code" in
        200|401) status="✅ 可用" ;;
        000) status="❌ 超时" ;;
        403) status="⚠️ CF拦截" ;;
        451) status="🚫 IP封禁" ;;
        *) status="⚠️ $api_code" ;;
    esac
    
    printf "%-28s | %-6s | %s\n" "$node" "$status" "$delay"
done <<< "$nodes"

echo ""
echo "=========================================="
echo "测试完成"
echo "=========================================="

---
name: simulated-usdt-freeze
description: Use the tether-usdt-test Sepolia simulated USDT address freeze scripts safely across sessions.
---

# Simulated USDT Freeze

当用户要在 `tether-usdt-test` 项目里执行或了解模拟 USDT 地址冻结流程时，加载这个 skill。该流程会通过 Sepolia 上的多签合约提交并确认 `addBlackList(address)` 调用，属于真实链上交易，不是纯本地 dry-run。

## 脚本位置

- 项目目录：`/home/wt/Projects/tether-usdt-test`
- 配置文件：`/home/wt/Projects/tether-usdt-test/scripts/config.js`
- 提交冻结提案：`/home/wt/Projects/tether-usdt-test/scripts/freeze.js`
- 确认并执行提案：`/home/wt/Projects/tether-usdt-test/scripts/confirm.js`
- 只读状态查询参考：`/home/wt/Projects/tether-usdt-test/scripts/balance.js`

## 合约与流程

- `scripts/freeze.js` 使用钱包 A，读取 `TARGET_ADDR`，向多签合约提交调用 USDT 合约 `addBlackList(TARGET_ADDR)` 的提案。
- `scripts/confirm.js <txId>` 使用钱包 B，确认指定多签提案；确认数达到要求后，多签会执行冻结调用。
- `scripts/config.js` 保存 RPC、USDT 合约地址、多签合约地址、钱包地址和私钥。只能说明字段用途，不能在回复中复制或展示私钥值。

## 安全规则

- 运行 `freeze.js` 或 `confirm.js` 前，必须获得用户对具体目标地址和链上交易的明确确认。
- 用户只给地址时，先说明将发送 Sepolia 多签交易，并询问是否执行；不要直接发交易。
- 不要输出、转写、总结或复制 `scripts/config.js` 中的私钥。
- 修改 `TARGET_ADDR` 前，先用 `ethers.getAddress()` 校验地址格式。
- 每次只冻结用户明确指定的一个地址；不要顺手处理历史地址或其他脚本。
- 如果目标地址已冻结，停止流程并告知用户，不要提交重复提案。

## 操作步骤

1. 读取 `/home/wt/Projects/tether-usdt-test/scripts/freeze.js`，确认当前 `TARGET_ADDR`。
2. 校验用户给出的 EVM 地址，例如：

```bash
node -e "const { ethers } = require('ethers'); console.log(ethers.getAddress('0x...'));"
```

3. 将 `scripts/freeze.js` 里的 `TARGET_ADDR` 改成用户确认的地址。
4. 对 `scripts/freeze.js` 运行诊断或至少重新读取目标行，确认地址写入正确。
5. 在项目根目录提交提案：

```bash
node scripts/freeze.js
```

6. 从输出中记录 `Proposal txId`。
7. 用钱包 B 确认并执行：

```bash
node scripts/confirm.js <txId>
```

8. 执行后用只读查询确认目标地址状态：

```bash
node -e "const { ethers } = require('ethers'); (async () => { const provider = new ethers.JsonRpcProvider('https://go.getblock.io/44128bbcfb9d4e1bab1978224330af86', 11155111); const tether = new ethers.Contract('0x5E72e298Df36084F8c79B29fE62078Ea89c68eE9', ['function isBlackListed(address) view returns (bool)'], provider); const target = '0x...'; console.log('Target:', target); console.log('Frozen:', await tether.isBlackListed(target)); })().catch((e) => { console.error(e); process.exit(1); });"
```

## 回复格式

完成后用简短中文汇报：

- 目标地址
- 提案 `txId`
- 钱包 A 提案交易 hash
- 钱包 B 确认/执行交易 hash
- 最终 `isBlackListed` 查询结果
- `scripts/freeze.js` 当前目标地址是否已更新

## 失败处理

- 地址不是 `0x...` EVM 地址时，说明当前脚本不支持 TRON 或其他链地址。
- 交易失败时，保留错误信息，先检查目标是否已冻结、钱包是否为多签 owner、余额是否足够、`txId` 是否正确。
- 如果 RPC 报错，先重试只读查询或检查网络；不要更换链或合约地址，除非用户明确要求。

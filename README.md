# Nexus Token (NXS)

⚡ **100% Fair Launch BEP-20 Token on Binance Smart Chain**

[![BSC](https://img.shields.io/badge/Network-BSC%20Mainnet-F3BA2F?style=flat&logo=binance)](https://bscscan.com/address/0xc9E7419fAa4d9311AF95de9Dac943B9252A79531)
[![Verified](https://img.shields.io/badge/Contract-Verified-4ade80?style=flat)](https://bscscan.com/address/0xc9E7419fAa4d9311AF95de9Dac943B9252A79531#code)
[![License](https://img.shields.io/badge/License-MIT-6366f1?style=flat)](LICENSE)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.35-363636?style=flat&logo=solidity)](src/NexusToken.sol)

> **No team allocation. No VC allocation. No presale.** Every token minted by the community at $0.50 per 1,000 NXS. 3 mint cap per wallet enforced on-chain.

---

## 🎯 What is Nexus Token?

Nexus Token (NXS) is a community-first BEP-20 token with **zero insider allocation**. Unlike 99% of token launches:

- ❌ **No presale** — no discounted early rounds
- ❌ **No team tokens** — deployer mints alongside everyone else
- ❌ **No VC allocation** — no venture capital advantage
- ❌ **No airdrop** — no dilution for genuine holders

**100% of the supply is distributed through public minting at a fixed price.**

---

## 📊 Tokenomics

| Metric | Value |
|---|---|
| **Token** | Nexus Token (NXS) |
| **Standard** | BEP-20 |
| **Network** | BSC Mainnet (Chain 56) |
| **Max Supply** | 100,000,000 NXS |
| **Per Mint** | 1,000 NXS |
| **Mint Price** | $0.50 USD (~0.000833 BNB) |
| **Max Per Wallet** | 3 mints (3,000 NXS) |
| **Team Allocation** | **0%** |
| **VC Allocation** | **0%** |
| **Presale** | **0%** |
| **Decimals** | 18 |

---

## 🔒 Anti-Whale Mechanism

The `MAX_MINTS_PER_WALLET = 3` cap is **enforced on-chain** — not a frontend promise.

```solidity
require(
    mintCount[msg.sender] < MAX_MINTS_PER_WALLET,
    "Max 3 mints per wallet"
);
```

- Max 3,000 NXS per wallet (0.003% of supply)
- Minimum ~33,333 unique wallets for full distribution
- Whale accumulation is **mathematically impossible**

---

## 💰 Treasury Flow

Every BNB from mints is **instantly forwarded** to the treasury wallet:

```
User calls mint() → sends BNB
  ↓
Contract mints 1,000 NXS to user
  ↓
BNB forwarded to treasury (contract holds zero)
```

**Treasury Address:** `0x47acCa8639273C7D4B4864DdAd3f516289DB8188`

---

## 🛡️ Security

| Feature | Status |
|---|---|
| OpenZeppelin v5 | ✅ Battle-tested library |
| ReentrancyGuard | ✅ All mint functions |
| No proxy / upgrade | ✅ Immutable code |
| No blacklist | ✅ Free transfers |
| No hidden mint | ✅ Only `mint()` creates NXS |
| Verified BSCScan | ✅ Full source public |

---

## 🔗 Links

| Resource | URL |
|---|---|
| **Mint NXS** | [nexustoken.live](https://nexustoken.live) |
| **Marketing Site** | [marketing-bay-eight-56.vercel.app](https://marketing-bay-eight-56.vercel.app) |
| **Whitepaper** | [Read Litepaper](https://marketing-bay-eight-56.vercel.app/whitepaper.html) |
| **Roadmap** | [View Roadmap](https://marketing-bay-eight-56.vercel.app/roadmap.html) |
| **BSCScan** | [Verified Contract](https://bscscan.com/address/0xc9E7419fAa4d9311AF95de9Dac943B9252A79531#code) |
| **Paragraph** | [Mirror Article](https://paragraph.com/@0x47acca8639273c7d4b4864ddad3f516289db8188-dbbc) |

---

## 🗺️ Roadmap

- ✅ **Phase 1 — Launch:** Deploy, verify, mint dApp, anti-whale
- 🔄 **Phase 2 — Community:** Whitepaper, socials, ambassador program
- 🔮 **Phase 3 — Liquidity:** PancakeSwap LP, CoinGecko, CMC listing
- 🔮 **Phase 4 — Ecosystem:** Staking, DAO governance, cross-chain bridge
- 🔮 **Phase 5 — Mass Adoption:** CEX listing, payment integration, full DAO

---

## 📦 Contract

```
0xc9E7419fAa4d9311AF95de9Dac943B9252A79531
```

- **Compiler:** Solidity v0.8.35
- **Optimizer:** 200 runs
- **EVM:** Paris
- **License:** MIT

---

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/0xchapo/nexus-token.git
cd nexus-token

# Install dependencies
forge install

# Build
forge build

# Deploy (requires BSC_RPC_URL and private key)
forge script script/Deploy.sol:NexusDeploy --rpc-url bsc --broadcast

# Verify
forge verify-contract \
  --chain 56 \
  --verifier etherscan \
  --etherscan-api-key $BSCSCAN_API_KEY \
  --compiler-version v0.8.35+commit.47b9dedd \
  --optimizer-runs 200 \
  0xc9E7419fAa4d9311AF95de9Dac943B9252A79531 \
  src/NexusToken.sol:NexusToken
```

---

## 📄 License

MIT © [0xchapo](https://github.com/0xchapo)

---

*DYOR. NFA. Not financial advice.*

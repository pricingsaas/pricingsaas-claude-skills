# PricingSaaS Claude Skills Plugin

Pricing intelligence skills for Claude Code — map competitive landscapes and discover how any SaaS category prices, powered by [PricingSaaS](https://pricingsaas.com) MCP data.

## Install

```shell
/plugin add https://github.com/pricingsaas/pricingsaas-claude-skills.git
```

## Prerequisites

This plugin uses the [PricingSaaS MCP server](https://pricingsaas.com) for pricing data. Connect it as a remote MCP server in Claude Code before using the skill.

## Skill

### `/pricingsaas:pulse-scan` — Market Landscape Discovery

Map the pricing landscape of any SaaS category. Finds all tracked companies, pulls pricing details, groups by market tier, and highlights pricing model patterns. Generates a shareable HTML report. **Zero credit cost.**

```
"Map the QA and testing tool pricing landscape"
"Who competes with Jobber and how do they price?"
"Show me restaurant tech pricing"
```

**What it does:**
- Discovers 10-30 companies in a category via keyword and attribute search
- Pulls full pricing breakdowns for each company
- Groups companies by market tier (SMB, mid-market, enterprise)
- Identifies pricing model patterns, price clusters, and coverage gaps
- Generates a self-contained HTML landscape report with charts and tables

**After the scan**, it recommends ways to dig deeper using PricingSaaS MCP tools — pull pricing history for a competitor, add companies to your watchlist, or research pricing strategy frameworks.

## License

MIT

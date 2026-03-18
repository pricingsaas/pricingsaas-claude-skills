# PricingSaaS Claude Skills Plugin

Pricing intelligence skills for Claude Code — competitive landscape discovery, pricing research reports, and weekly competitor monitoring powered by [PricingSaaS](https://pricingsaas.com) MCP data.

## Install

```shell
/plugin marketplace add pricingsaas/pricingsaas-claude-skills
/plugin install pricingsaas@pricingsaas-claude-skills
```

## Prerequisites

Skills in this plugin use the [PricingSaaS MCP server](https://pricingsaas.com) for pricing data. Connect it as a remote MCP server in Claude Code before using data-driven skills.

## Skills

### `/pricingsaas:pulse-scan` — Market Landscape Discovery

Map the pricing landscape of any SaaS category. Finds all tracked companies, pulls pricing details, groups by market tier, and highlights pricing model patterns. **Zero credit cost.**

```
"Map the QA and testing tool pricing landscape"
"Who competes with Jobber and how do they price?"
"Show me restaurant tech pricing"
```

### `/pricingsaas:pulse-deepdive` — Competitive Pricing Analysis

Full competitive pricing analysis with data-backed price change recommendations. Researches 12-18 comparable companies, analyzes price increase trends, and generates a professional HTML report with three pricing scenarios.

```
"How much should we raise prices on our Pro plan?"
"Run a competitive pricing analysis for Notion"
"What should we charge compared to competitors?"
```

### `/pricingsaas:pulse-monitor` — Weekly Pricing Digest

Manages a persistent watchlist of competitor companies and delivers recurring summaries of pricing changes with market context. Works on-demand or scheduled.

```
"Monitor my competitors' pricing"
"What changed in pricing this week?"
"Add Notion to my watchlist"
```

## Skill workflow

The three skills form a natural funnel:

1. **Scan** a category → discover who's in the space and how they price
2. **Deep-dive** into a specific company → get a pricing recommendation with a report
3. **Monitor** ongoing → track competitor changes week over week

## License

MIT

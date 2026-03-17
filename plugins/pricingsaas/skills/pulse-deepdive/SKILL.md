---
name: pulse-deepdive
description: |
  SaaS pricing analyst skill using PricingSaaS MCP tools to research competitive pricing, analyze price increase trends, and generate data-backed pricing recommendations as professional reports. MANDATORY TRIGGERS: Use when the user asks about how much to raise/change prices for a SaaS product, competitive pricing analysis or benchmarking, pricing strategy recommendations, price increase justification or sizing, SaaS pricing landscape research. Trigger keywords: "price increase", "pricing comparison", "competitor pricing", "pricing strategy", "how should we price", "what should we charge", "pricing analysis", "pricing recommendation", "raise the price", "pricing benchmark".
---

# SaaS Pricing Analysis

Perform competitive pricing analysis for any SaaS company using PricingSaaS MCP data. Produce a professional report with a price change recommendation backed by competitor benchmarks, historical trends, and market patterns.

## Workflow

### Phase 1: Clarify Scope

Before research, clarify with AskUserQuestion:

1. **Which plan?** Specific plan to analyze (e.g., "Business", "Pro")
2. **Goal?** Monetization growth, competitive repositioning, or premium positioning
3. **Segments?** SMB, mid-market, enterprise, or all three
4. **Comparison scope?** Same category only, or broader SaaS with similar pricing attributes

Skip if the user already answered these.

### Phase 2: Research

#### Step 1: Target company data

```
get_company_details(slug)      # Current plans, prices, metrics
get_company_history(slug)      # Historical pricing changes
```

Extract: current price (monthly + annual), pricing metric, freemium/add-ons/usage presence, last price change date and magnitude, value additions since last change.

#### Step 2: Find comparable companies

Run in parallel:

```
search_companies(query="<category keywords>")

search_companies_advanced(
  has_freemium=<match target>,
  has_license=<match target>,
  price_min=<target * 0.5>,
  price_max=<target * 3>,
  currency="USD"
)
```

Select 12-18 companies across three tiers:
- **Tier 1 (3-5):** Direct competitors in same product category
- **Tier 2 (5-7):** Adjacent platforms with overlapping use cases
- **Tier 3 (4-6):** Broader SaaS with matching pricing model (per-user, freemium, similar range)

#### Step 3: Gather competitor pricing

Launch multiple `batch-fetch` subagents in parallel, splitting the 12-18 companies into batches of 4-5:

```
Agent(agent="batch-fetch", prompt="Fetch details and history for: slug1, slug2, slug3, slug4, slug5")
```

From the returned data, capture per company: equivalent plan name, price (monthly + annual), pricing metric, most recent increase (amount, %, date, justification).

#### Step 4: Enrich with pricing knowledge

```
search_pricing_knowledge(query="<relevant pricing strategy topic>")
```

Search for frameworks and expert guidance relevant to the target's pricing model (e.g., "per-seat pricing best practices", "freemium conversion optimization", "price increase communication strategies"). Use findings to ground recommendations in established methodology.

#### Step 5: Analyze patterns

Compute:
- Median peer price for equivalent plans (annual billing)
- Median increase size among companies that raised prices
- Increase frequency (how many raised in last 2 years)
- Target's percentile in peer price distribution
- Gap to next pricing tier (room below premium competitors)
- Common justification patterns (AI bundling, feature expansion, tier restructuring)

#### Step 6: Formulate recommendation

Three scenarios:

| Scenario | Approach | Typical Range |
|----------|----------|---------------|
| Conservative | Match lowest recent peer increase | +10-15% |
| Recommended | Align with median peer price or median increase | +18-25% |
| Aggressive | Match highest peer increase, move to upper quartile | +30-40% |

For each: new price, percentage change, peer alignment, risk level.

### Phase 3: Report

Generate a professional report as a self-contained HTML file — see [references/report-structure.md](references/report-structure.md) for the template, CSS, and section patterns.

After generating the report, write the HTML to a temp file and upload using the `upload-file-to-share` skill:

```
1. Write HTML to /tmp/{company}-pricing-analysis.html
2. /upload-file-to-share /tmp/{company}-pricing-analysis.html
```

This uploads to `share.pricingsaas.com` via S3 and returns a public URL instantly.

**Required sections:**
1. Executive Summary with recommendation
2. Current Pricing Position (target's plans + value additions)
3. Competitive Landscape (tables by tier with prices, increases, PricingSaaS links)
4. Price Increase Trends (timeline of all documented increases)
5. Market Patterns (median increase, AI bundling, discount norms)
6. Recommendation (three scenarios, rationale, positioning)
7. Implementation Guidance (grandfathering, communication, tier adjustments)
8. Segment Analysis (SMB / mid-market / enterprise impact)
9. Data Sources (all companies with PricingSaaS links)

### Phase 4: Verify

Use a subagent to re-query PricingSaaS and spot-check 3-5 key data claims in the report.

## Critical Lessons

- **Always include PricingSaaS links.** `https://pricingsaas.com/companies/{slug}?v2=true` for overview, `https://pricingsaas.com/companies/{slug}/diffs/{period}?v2=true` for diffs.
- **Compare on same billing basis.** Prefer annual as primary; note monthly for reference.
- **get_company_history costs 1 credit/diff.** Use `discovery_only=True` first if you only need period availability.
- **Parallelize gathering.** Use the `batch-fetch` agent with batches of 4-5 companies. Cuts time 3-4x.
- **Document value shipped since last price change.** This is the narrative justification for any increase.
- **AI bundling is the dominant justification pattern.** Look for it in every competitor's history.
- **Use get_diff_highlight for visual evidence.** After finding key changes via get_company_history, use get_diff_highlight to get before/after screenshots that strengthen the report narrative.
- **Use search_pricing_knowledge for frameworks.** Ground recommendations in established pricing methodology, not just competitor data.

## Reference

- [references/mcp-tools.md](references/mcp-tools.md) - PricingSaaS MCP tool usage patterns and parameters
- [references/report-structure.md](references/report-structure.md) - HTML report template, CSS, and section patterns

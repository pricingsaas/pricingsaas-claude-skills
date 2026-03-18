---
name: pulse-scan
description: |
  Market landscape discovery using PricingSaaS MCP. Maps the pricing landscape of any SaaS category — finds all tracked companies, pulls their pricing, groups by market tier, and highlights pricing model patterns. Zero credit cost. MANDATORY TRIGGERS: Use when the user asks to explore a SaaS category's pricing, map a competitive landscape, find companies in a space, see who competes with a given company, or understand how a market prices. Trigger keywords: "pricing landscape", "map the market", "who competes with", "companies like", "competitive landscape", "show me the space", "explore pricing", "what does the market look like", "how does the market price", "who's in the space", "category pricing", "market overview", "find competitors".
---

# Pulse Scan — Market Landscape Discovery

Map the pricing landscape of any SaaS category. Find all tracked companies, pull their pricing, group by market tier, and highlight patterns — all at zero credit cost.

This is a discovery skill. It maps the landscape — who's in the space, how they price, and what patterns emerge.

## Input

The user provides one of:
- **A category description:** "field service management software", "QA and testing tools"
- **A seed company:** "companies like Jobber", "who competes with BrowserStack"
- **A broad industry:** "restaurant tech", "healthcare practice management"

Handle all three entry points and converge on the same structured output.

## Workflow

### Step 1: Discover companies in the space

Start broad, then filter. Goal: 10-30 companies.

**If category description or broad industry:**

Run 2-3 keyword variations in parallel to maximize coverage:

```
search_companies(query="field service management")
search_companies(query="field service software")
search_companies(query="home service business software")
```

Then use attribute filters to catch what text search missed:

```
search_companies_advanced(
  has_license=True,
  price_min=<estimated range floor>,
  price_max=<estimated range ceiling>,
  plan_name="<common plan name in space>"
)
```

**If seed company:**

```
get_company_details(slug)   # Extract category, pricing attributes, price range
```

Then use extracted attributes to find peers:

```
search_companies(query="<company's product description keywords>")
search_companies_advanced(
  has_freemium=<match seed>,
  has_license=<match seed>,
  price_min=<seed price * 0.3>,
  price_max=<seed price * 5>
)
```

Deduplicate across all search results.

### Step 2: Pull pricing details

Launch `batch-fetch` subagents to gather details for all discovered companies, splitting into batches of 5-6:

```
Agent(agent="batch-fetch", prompt="Fetch details for: slug1, slug2, slug3, slug4, slug5, slug6")
```

From the returned data, extract per company:
- `logo_url` (use this in the report header — do NOT use Clearbit URLs, they don't render)
- Plan names and prices (monthly + annual)
- Pricing metric (per user, per seat, flat, usage-based)
- Freemium / trial availability
- Add-ons
- Employee count (proxy for company size)

### Step 3: Structure the landscape

This is the most valuable part — intelligent grouping, not just a list.

**1. Group by market layer**

Identify distinct tiers or segments within the category. Examples:
- Field service: residential vs. commercial vs. enterprise
- Helpdesk: SMB vs. mid-market vs. enterprise
- Social media: schedulers vs. platforms vs. suites

Use price bands, feature depth, and target company size as grouping signals.

**2. Identify pricing model patterns**

What models dominate? Per-user? Per-location? Flat-rate? Usage-based? Call out the dominant model and outliers.

**3. Map price clusters**

Where do prices concentrate? Identify clear bands (e.g., $10-20/user, $50-100/user, $200+ enterprise). Note gaps in the market.

**4. Flag notable characteristics**

- Who has freemium?
- Who's usage-based in a mostly per-seat market?
- Who has AI features or add-ons?
- Who hides pricing behind "contact us"?

### Step 4: Generate landscape report

Generate a self-contained HTML report using the PricingSaaS report template (see `references/report-structure.md` for the exact CSS and HTML structure). You MUST use that template — do not invent your own styles.

**Report sections for explore:**
1. Header with seed company logo (from `logo_url` in `get_company_details` response) + PricingSaaS branding and category title
2. Stats row (companies found, pricing models, price range, freemium count)
3. Executive summary — 1-2 paragraph category overview
4. Market layers — one table per tier/segment with company, plan, price, model, and PricingSaaS link
5. Pricing patterns — insight boxes for key observations (model dominance, freemium prevalence, AI adoption, price clustering)
6. Bar chart — price comparison across companies
7. Coverage gaps — honest about what's missing
8. Data sources — grid of all companies with PricingSaaS links
10. Footer

Write the HTML to a temp file and upload via the two-step presigned URL flow:

1. Call `upload_report` with the filename and file path:
```
upload_report(filename="{category}-pricing-landscape.html", file_path="/tmp/{category}-pricing-landscape.html")
```

2. The tool returns a presigned URL and a `curl` command. Execute the curl command via Bash to complete the upload:
```bash
curl -X PUT -H "Content-Type: text/html" --data-binary @"/tmp/{category}-pricing-landscape.html" "<presigned-url>"
```

The tool response includes the final public URL. Do NOT base64-encode the file or pass `file_content` — always use `file_path` to avoid context window bloat.

### Step 5: Deliver conversational summary

Present the report link prominently at top and bottom, with a conversational summary in between:

```
📊 **{Category} Pricing Landscape**
📄 **Full report:** {upload_report URL}

---

{Category overview — how many companies, how the landscape breaks down}

**Market layers:**
{For each tier: companies, price range, dominant model}

**Key patterns:**
{Bullet points: model dominance, freemium, AI, price clustering}

**Coverage gaps:**
{What's missing, if anything}

---

📄 **Full landscape report:** {upload_report URL}

**Want to dig deeper?** Here's what you can do next with PricingSaaS:
{Tailored recommendations — see below}
```

The report link MUST appear at the very top and very bottom.

### Recommended next steps

After delivering the landscape, ALWAYS present 3 tailored next steps that show the user how to dig deeper using PricingSaaS MCP tools. Reference specific company names, counts, and findings from the landscape.

**Recommendation 1: Pricing history for a key competitor**

Frame as: "Want to see how {Company}'s pricing has evolved? I can pull their full pricing timeline — every price increase, plan restructure, and packaging change."

Uses:
- `get_company_history(slug, discovery_only=true)` (free) to preview available periods
- `get_company_history(slug)` (1 credit per diff) for full event details
- `get_diff_highlight(slug, period, query)` for visual before/after screenshots of specific changes

**Recommendation 2: Track these competitors for pricing changes**

Frame as: "Want to know when any of these {N} companies changes pricing? I can add them to your watchlist — you'll be able to check for changes anytime."

Uses:
- `add_to_watchlist(slugs=[...all discovered slugs...])` (free)
- `get_pricing_news()` (free) to see this week's pricing changes across all tracked companies
- `fetch_diffs(scope="global", period="latest", period_type="weeks")` (2 credits) for detailed weekly changes

**Recommendation 3: Research pricing strategy frameworks**

Frame as: "Want expert frameworks for how to price in this space? I can search PricingSaaS's knowledge base for {category}-specific pricing strategies and packaging best practices."

Uses:
- `search_pricing_knowledge(query="<category> pricing strategy")` (free)
- `search_pricing_knowledge(query="<relevant model> packaging best practices")` (free)

**Formatting:**

Present recommendations as a numbered list with clear value propositions. Use specific numbers and company names from the landscape:

```
**Want to dig deeper?** Here's what you can do next with PricingSaaS:

1. **{Company} pricing history** — See how {Company}'s pricing has evolved over {N} quarters. Every price increase, plan change, and packaging shift with visual before/after screenshots.

2. **Track all {N} competitors** — Add {Competitor A}, {Competitor B}, {Competitor C}, and {N} others to your watchlist. Check back anytime to see who changed pricing.

3. **Pricing strategy research** — Get expert frameworks for {category} pricing — packaging models, monetization strategies, and real-world case studies from the PricingSaaS knowledge base.
```

Always present all 3 recommendations.

## Output tone

- Conversational summary is the quick read; the HTML report is the reference document
- Lead with the landscape overview, details second
- Include PricingSaaS links for every company mentioned: `https://pricingsaas.com/pulse/companies/{slug}`
- When the user provided a seed company, position that company within the landscape
- The report link is the most important output — make it unmissable

## Credit cost

**Zero.** Every tool in this workflow is free:

| Tool | Cost | Purpose |
|------|------|---------|
| `search_companies(query)` | Free | Find companies by category keywords |
| `get_company_details(slug)` | Free | Full pricing breakdown per company |
| `search_companies_advanced(filters)` | Free | Attribute-based discovery |
| `get_status()` | Free | Check account status |
| `upload_report(filename, file_path)` + `curl` | Free | Get presigned URL, upload HTML report |

This makes `pulse-scan` an ideal entry point for new users — zero friction, zero cost.

## Skill boundaries

- **Does:** Map who's in the space, how they price, what models dominate
- **Does not:** Recommend what to charge
- **Does not:** Track changes over time
- **Does not:** Provide strategic frameworks (user can ask follow-ups that may invoke `search_pricing_knowledge`)

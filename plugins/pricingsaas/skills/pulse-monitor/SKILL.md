---
name: pulse-monitor
description: |
  Weekly competitive pricing digest using PricingSaaS MCP. Manages a persistent watchlist of competitor companies and delivers recurring summaries of pricing changes with market context. MANDATORY TRIGGERS: Use when the user asks to monitor competitor pricing, set up a pricing watchlist, get a weekly pricing digest, track competitor pricing changes, or check what competitors changed in pricing. Trigger keywords: "monitor pricing", "pricing watchlist", "competitor changes", "pricing digest", "track competitors", "what changed in pricing", "pricing updates", "catch me up on pricing", "competitive monitoring", "add to watchlist", "show my watchlist", "pricing this week".
---

# Pulse Monitor — Weekly Competitive Pricing Digest

Deliver a recurring conversational digest of pricing changes across a user's tracked competitors and the broader SaaS market. Works on-demand or as a scheduled task.

## Modes

This skill operates in two modes, automatically detected:

- **Setup Mode** — when the user has no watchlist, wants to create one, or asks to modify it
- **Digest Mode** — when the user has an existing watchlist and wants a pricing update

## Mode 1: Watchlist Setup

Triggered when the user has no watchlist or asks to modify it.

### Step 1: Load existing watchlist

```
get_watchlist()
```

If empty or not found, proceed to setup. If populated and user wants to edit, show current list first.

### Step 2: Collect companies conversationally

Ask the user which competitors they want to track. Accept natural language — company names, URLs, or descriptions.

### Step 3: Resolve to slugs

For each company the user mentions:

```
search_companies(query="<company name>")
```

- If exact match found, add the slug
- If multiple matches, ask user to pick
- If no match: "X isn't tracked by PricingSaaS yet — skip for now?"

### Step 4: Confirm and save

Show the resolved list, then save all at once:

```
add_to_watchlist(slugs=["hootsuite", "buffer", "sprout-social", "later", "metricool"])
```

The server validates each slug exists, adds valid ones (ignoring duplicates), and reports any invalid slugs that were skipped. Confirm the result to the user.

### Watchlist modifications

Users can modify at any time via natural language:

**Add companies:**
- "Add Notion to my watchlist"
- Resolve name → slug via `search_companies`, then `add_to_watchlist(slugs=["notion"])`
- Server validates and dedupes automatically

**Remove companies:**
- "Remove Buffer"
- `remove_from_watchlist(slugs=["buffer"])`
- Non-existent slugs are silently ignored

**View watchlist:**
- "Show me my watchlist"
- `get_watchlist()` → display the list with count

**Replace entire watchlist:**
- "Replace my watchlist with these companies: ..."
- Load current via `get_watchlist()`, then `remove_from_watchlist` the old slugs, then `add_to_watchlist` the new ones

## Mode 2: Digest Run

### Step 1: Load watchlist

```
get_watchlist()
```

If empty, switch to Setup Mode.

### Step 2: Discover which companies changed

First, discover what changed across the entire PricingSaaS database. Run in parallel:

```
fetch_diffs(scope="global", period="latest", period_type="weeks", limit=100)          # This week
fetch_diffs(scope="global", period="<previous_week>", period_type="weeks", limit=100)  # Last week
get_pricing_news()                                                                      # Curated highlights
```

Use `browse_diffs(period_type="weeks")` first to find the current and previous week identifiers (e.g., "2026W12", "2026W11"). This is free and returns diff/company counts per period.

**Pagination:** Global diffs return max 100 results per call. If a week has more than 100 companies (check the count from `browse_diffs`), paginate with `offset` parameter (offset=0, offset=20, offset=40, etc.) until all companies are collected. Typical weeks have 50-120 companies.

### Step 3: Cross-reference with watchlist

From the global diffs and pricing news, extract every company slug that had changes. Match these against the watchlist slugs loaded in Step 1.

**Important:** Match on exact slug only. Some companies have sub-product slugs (e.g., `hubspot.operations`, `openai.api`, `datadog.ci-pipeline-visibility`) that are distinct from the base slug (`hubspot`, `openai`, `datadog`). Only match the exact watchlist slug.

Build two lists:
- **Watchlist hits** — companies on the watchlist that changed (this week + last week)
- **Market highlights** — notable changes from companies NOT on the watchlist, filtered for significance (price increases >20%, restructures, free tier removals are most noteworthy)

### Step 4: Fetch full diffs for watchlist hits

For every watchlist company that appeared in the discovery results, fetch the full company-scope diff to get complete event details:

```
fetch_diffs(slug=<slug>, period="latest")
```

Run these in parallel using `batch-fetch` subagents if there are many hits. Don't skip any — fetch all of them. The discovery step already filtered to only companies with actual changes, so every call here is worthwhile.

From each diff, capture: `logo_url` (Cloudinary-hosted — use this in the report, NOT Clearbit URLs), event types, affected plans, before/after values, magnitude, and the diff view URL.

### Step 5: Generate report

Generate a professional digest report as a single self-contained HTML file (no external CSS/JS/fonts). See [references/digest-report-structure.md](references/digest-report-structure.md) for the exact template, CSS, and section patterns. Uses the same monochrome design system as the `pulse-deepdive` report.

**Build the HTML string directly** — do not use Node.js libraries or external tooling. The HTML is simple enough to construct as a string with template literals. Base64-encode the final HTML string for upload.

**Required report sections:**
1. Header with PricingSaaS wordmark and headline ("15 of 116 Tracked Competitors Changed")
2. Stats row — 4 boxes: companies tracked, changed, price increases, restructures
3. Executive summary — 2-3 sentences on the dominant theme
4. Watchlist changes table — color-coded badges by change type (badge-increase, badge-decrease, badge-restructure, badge-feature, badge-packaging, badge-capacity), sorted by significance, with PricingSaaS diff links
5. Price change detail table — before/after with colored percentages (red for increases, green for decreases)
6. Patterns & trends — insight boxes for 2-3 key observations
7. Market highlights table — 3-5 non-watchlist notable changes with PricingSaaS links
8. No changes section — compact dot-separated list of unchanged companies in gray
9. Footer with PricingSaaS attribution

### Step 6: Upload report and get shareable link

Write the HTML to a temp file, then upload using the `upload-file-to-share` skill:

```
1. Write HTML string to /tmp/pricing-digest-{week}.html
2. /upload-file-to-share /tmp/pricing-digest-{week}.html
```

This uploads to `share.pricingsaas.com` via S3 and returns a public URL instantly (<1 second). The URL is permanent and publicly accessible.

**Do NOT use `upload_report` MCP tool for this** — passing 20KB+ of base64 inline to an MCP tool is slow. The `upload-file-to-share` skill uses a direct S3 upload which is much faster.

### Step 7: Deliver conversational digest

Structure the conversational output with the **report link prominently at the top and bottom**.

**Output format:**

```
📊 **Weekly Pricing Digest — {date}**
📄 **Full report:** {upload_report URL}

---

{X} of your {Y} tracked competitors made pricing changes this week.

**Watchlist changes:**

{For each company that changed:}
**{Company}** — {description of change}
{Magnitude, affected plans}
→ {PricingSaaS diff link}

**No changes:** {compact list of unchanged companies}

**Market highlights:**
• {3-4 notable non-watchlist changes}

**Patterns:** {1-2 observed trends}

**Suggested actions:** {only when warranted}

---

📄 **Full report with tables and analysis:** {upload_report URL}
```

The report link MUST appear:
1. **At the very top** — immediately after the headline, before any content
2. **At the very bottom** — as the last line of the digest

Use `get_diff_highlight` for the most significant change to provide visual context in the conversational output:

```
get_diff_highlight(slug=<slug>, period=<period>, query="<description of the change>")
```

## Digest tone

- Conversational summary is the quick read; the report is the reference document
- Lead with what matters — changes first, quiet companies last
- Don't create false urgency on quiet weeks — "no changes" is valuable information
- Keep market highlights brief — the watchlist is the priority
- Always include PricingSaaS links for any company mentioned
- The report link is the single most important output — make it unmissable

## Credit cost

- Watchlist tools (`get_watchlist`, `add_to_watchlist`, `remove_from_watchlist`): Free
- `browse_diffs`: Free
- `fetch_diffs` global scope (discovery): 2 credits per week fetched
- `fetch_diffs` per company (full detail): 1 credit each
- `get_pricing_news`: Free
- `get_diff_highlight`: Free
- `upload_report`: Free
- Typical weekly run: ~4 credits discovery (this week + last week) + 1 credit per watchlist company that changed

## MCP Tools Used

| Tool | Cost | Purpose |
|------|------|---------|
| `get_watchlist()` | Free | Load saved competitor list with count |
| `add_to_watchlist(slugs)` | Free | Add companies — validates slugs, dedupes |
| `remove_from_watchlist(slugs)` | Free | Remove companies — no-op for missing slugs |
| `search_companies(query)` | Free | Resolve company names to slugs during setup |
| `browse_diffs(period_type="weeks")` | Free | Find current/previous week identifiers |
| `fetch_diffs(scope="global")` | 2 credits | Discover all companies that changed in a week |
| `fetch_diffs(slug, period)` | 1 credit | Full diff detail for each watchlist hit |
| `get_pricing_news()` | Free | Market-wide highlights for the week |
| `get_diff_highlight(slug, period, query)` | Free | Visual before/after for significant changes |
| `upload_report(filename, file_content)` | Free | Upload HTML report, get shareable URL |

## Scheduling

This skill works both ways:
- **On-demand:** User says "catch me up on pricing this week" or "what changed?"
- **Scheduled:** Pairs with scheduling tools for weekly/monthly automation

PricingSaaS diffs arrive weekly, so weekly is the natural cadence. Monthly also works — covers more ground per run.

## Reference

- [references/digest-report-structure.md](references/digest-report-structure.md) - HTML digest report template, CSS, and section patterns
- PricingSaaS company links: `https://pricingsaas.com/companies/{slug}?v2=true`
- PricingSaaS diff links: `https://pricingsaas.com/companies/{slug}/diffs/{period}?v2=true`

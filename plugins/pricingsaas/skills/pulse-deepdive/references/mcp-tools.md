# PricingSaaS MCP Tool Reference

## Tool Overview

| Tool | Cost | Use For |
|------|------|---------|
| `get_status` | Free | Check credits before starting |
| `search_companies` | Free | Find companies by name or keyword |
| `get_company_details` | Free | Current pricing plans, charges, metadata |
| `search_companies_advanced` | Free | Filter by pricing attributes |
| `get_company_history` | 1 credit/diff | Pricing change timeline |
| `browse_diffs` | Free | See available diff periods |
| `fetch_diffs` | 1-2 credits | Specific pricing diff data |
| `get_pricing_news` | Free | This week's pricing changes across all tracked companies |
| `get_diff_highlight` | Free | Visual before/after screenshots of a specific pricing change |
| `search_pricing_knowledge` | Free | Expert pricing strategy frameworks and best practices |
| `upload_report` | Free | Upload a generated report and get a shareable URL |

## Usage Patterns

### get_company_details(slug)

Returns full pricing breakdown: plans, charges, metrics, employee count, category.

```
get_company_details("notion")
```

Key fields to extract:
- Plan names and prices (monthly_recurring_billed_yearly, monthly_recurring_billed_monthly)
- Pricing metric per charge (per user, per seat, flat)
- Add-ons and their pricing
- Company size (employees field)
- Category IDs (useful for finding peers)

**Slug tips:** Usually the domain without TLD. Try `search_companies(query)` first if unsure. Some have dots: `linear.app`, `atlassian.jira`.

### get_company_history(slug)

Returns quarterly and weekly diffs documenting every pricing page change.

```
get_company_history("notion")                          # Compact (default)
get_company_history("notion", minimal_response=False)  # Full details
get_company_history("notion", discovery_only=True)     # Free - just periods
```

Key fields to extract:
- Price changes: old value, new value, percentage change
- Feature additions/removals per plan
- Plan renames or restructuring
- AI feature introductions
- Tracking start date (how far back data goes)

### search_companies(query)

Free text search. Good starting point for finding slugs.

```
search_companies("whiteboard collaboration")
search_companies("project management")
```

Returns company names, slugs, and basic metadata.

### search_companies_advanced(filters)

Powerful filtering by pricing attributes.

```python
# Find freemium per-user SaaS in $10-30 range
search_companies_advanced(
  has_freemium=True,
  has_license=True,
  price_min=10,
  price_max=30,
  currency="USD"
)

# Find companies with usage-based pricing
search_companies_advanced(
  has_usage=True,
  has_public_pricing=True
)

# Filter by employee size
search_companies_advanced(
  employees="101-1000,1001-10000",
  has_license=True
)
```

Available boolean filters: `has_freemium`, `has_trial`, `has_license`, `has_usage`, `has_credit`, `has_public_pricing`, `has_contact_pricing`, `has_addons`, `has_discounts`.

Numeric filters: `price_min`, `price_max`, `plan_count_min`, `plan_count_max`.

String filters: `currency`, `employees`, `billing`, `modality`, `plan_name`, `metric_name`.

Text filters support regex: `/pattern/flags`.

### browse_diffs(period_type)

Free. See what diff periods are available.

```
browse_diffs()                        # Global stats
browse_diffs(period_type="quarters")  # List all quarters
browse_diffs(period_type="weeks")     # List all weeks
```

### fetch_diffs(slug, period)

Get specific diff data. 1 credit for company scope, 2 for global.

```
fetch_diffs(slug="notion", period="latest")
fetch_diffs(slug="notion", period="2025Q4")
fetch_diffs(period="2025Q4", period_type="quarters", scope="global")  # All companies
```

Supports event type filtering (global scope): `event_type` or `event_types` to filter to specific change types (price_increased, price_decreased, plan_added, plan_removed, feature_added, feature_changed, discount_removed, capacity_increased, capacity_decreased).

### get_pricing_news()

Free. Returns this week's top pricing highlights (curated editor picks) plus all detected changes across tracked companies.

```
get_pricing_news()
```

Great for identifying recent market-wide pricing trends and finding timely examples for reports.

### get_diff_highlight(slug, period, query)

Visual before/after screenshots of a specific pricing change. Use after get_company_history or fetch_diffs to get visual proof.

```
get_diff_highlight(slug="notion", period="2025Q3", query="AI add-on removed and bundled into paid plans")
```

Returns cropped, annotated images showing exactly where on the pricing page the change occurred.

### search_pricing_knowledge(query)

Free. Search expert pricing knowledge — strategies, packaging frameworks, monetization models, and SaaS best practices curated from reports, webinars, and industry research.

```
search_pricing_knowledge("per-seat pricing best practices")
search_pricing_knowledge("price increase communication strategies")
search_pricing_knowledge("freemium conversion benchmarks")
```

Each result links to the original source with page reference.

### upload_report(file_path)

Upload a generated report file and get a public shareable URL.

```
upload_report(filename="report.html", file_content="<base64-encoded html>")
```

**Note:** This tool is planned. See requirements document for details.

## Credit Optimization

1. **Start with free tools:** `get_status`, `search_companies`, `search_companies_advanced`, `get_company_details`, `browse_diffs`, `get_pricing_news`, `search_pricing_knowledge`
2. **Use discovery_only=True** on `get_company_history` to check available periods before committing credits
3. **Batch advanced searches.** One well-filtered `search_companies_advanced` call is better than three speculative ones
4. **Use minimal_response=True** (default) on history and diffs to reduce token usage

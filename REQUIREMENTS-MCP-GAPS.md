# PricingSaaS MCP — Requirements for Skills Support

Requirements identified from the `pulse-deepdive` and `pulse-monitor` skills that need MCP-side work before skills are fully functional for public partners.

---

## 1. `upload_report` MCP Tool (IMPLEMENTED)

**Status:** Added to PricingSaaS MCP. Accepts base64-encoded file content + filename. Returns public shareable URL. Supports PDF, DOCX, HTML, CSV, JSON, Markdown. Max 1.5MB. Free (0 credits). Files persist 90+ days, scoped to API key.

Used by both `pulse-deepdive` (full analysis report) and `pulse-monitor` (weekly digest report).

---

## 2. Fix `search_companies_advanced` Credit Cost Documentation

**Problem:** The skill's original reference doc listed `search_companies_advanced` as costing 1 credit, but the actual MCP tool description says "Free (0 credits)". This has been corrected in the skill's reference doc, but confirm the MCP server-side behavior matches.

**Action:** Verify and confirm that `search_companies_advanced` is indeed free. If it costs credits, update the MCP tool description to reflect the true cost.

---

## 3. Remove `get_latest_diffs` from Mental Model

**Problem:** The original skill referenced a `get_latest_diffs` tool that does not exist in the PricingSaaS MCP. This functionality is already covered by:
- `fetch_diffs(scope="global", period_type="weeks", period="latest")` — weekly diffs across all companies
- `get_pricing_news()` — curated weekly highlights

**Action:** No MCP change needed. This is already resolved in the cleaned-up skill. Documenting here for completeness — if `get_latest_diffs` was ever planned as a convenience wrapper, it's not needed.

---

## 4. `get_diff_highlight` — Confirm Public Availability

**Problem:** The skill now references `get_diff_highlight` for visual before/after screenshots of pricing changes. This tool exists in the MCP but wasn't in the original skill. Need to confirm:
- Is it available to all partner API keys (not just internal)?
- What is the credit cost?
- Are the returned image URLs publicly accessible (no auth required to view)?

**Action:** Confirm `get_diff_highlight` works for partner API keys and that returned image URLs are publicly accessible (important for embedding in reports shared via `upload_report`).

---

## 5. `search_pricing_knowledge` — Confirm Public Availability

**Problem:** The skill now uses `search_pricing_knowledge` to ground recommendations in expert frameworks. The MCP tool description says "Free (0 credits, no API key required)."

**Action:** Confirm this tool is available and functional for partner-connected MCP. No changes expected — just verification.

---

## 6. Consider: `get_categories` Tool (Nice-to-Have)

**Problem:** The `pulse-deepdive` skill asks users to find "12-18 comparable companies" across tiers. Currently, finding companies in the same category requires:
1. `get_company_details(slug)` to find the target's `category_id`
2. `search_companies_advanced(category_id=...)` to find peers

There's no way to browse or list categories, so the skill relies on keyword searches to find peers.

**Suggestion:** A `get_categories` or `list_categories` tool that returns all tracked SaaS categories with their IDs and company counts would make peer discovery more precise. Low priority — the current keyword + advanced search approach works.

---

## 7. Watchlist MCP Tools — `get_watchlist`, `add_to_watchlist`, `remove_from_watchlist` (IMPLEMENTED)

**Status:** Added to PricingSaaS MCP. Three endpoints, all free, OAuth-authenticated.

| Tool | Input | Behavior |
|------|-------|----------|
| `get_watchlist()` | (none) | Returns all bookmarked slugs + count |
| `add_to_watchlist(slugs)` | `slugs: string[]` | Validates each slug exists, adds valid ones (dupes ignored), reports invalid slugs skipped |
| `remove_from_watchlist(slugs)` | `slugs: string[]` | Removes specified slugs (non-existent ones are a no-op), returns updated count |

**Auth:** OAuth (no direct API key support). This means watchlist features require the user to be authenticated via OAuth flow, not just an API key.

**Note:** The original spec proposed a single `set_watchlist` (full replace). The implemented API uses add/remove operations instead, which is cleaner — the server handles validation and deduplication, and there's no risk of accidentally wiping a watchlist with a bad replace call.

---

## 8. Consider: `request_company` Tool (Nice-to-Have for `pulse-scan`)

**Problem:** When `pulse-scan` discovers coverage gaps (e.g., "voice AI tools aren't tracked"), there's no programmatic way for users to request that companies be added to PricingSaaS. The spec references a `pricingsaas-add` flow but no such MCP tool exists.

**Suggestion:** A `request_company(name, url, reason)` tool that queues a company for PricingSaaS tracking. Returns a confirmation that the request was received. This closes the feedback loop — users who hit gaps become data contributors rather than churning.

**Spec:**
- **Input:** `name` (company name), `url` (pricing page URL), `reason` (optional — e.g., "competitor in field service space")
- **Output:** Confirmation with estimated timeline or queue position
- **Cost:** Free
- **Auth:** Tied to partner API key

**Not a blocker** — `pulse-scan` handles gaps gracefully by noting what's missing. But this would improve retention for users like Ken at Yelp who churned partly due to coverage gaps.

---

## Summary

| # | Item | Priority | Type | Skill |
|---|------|----------|------|-------|
| 1 | `upload_report` MCP tool | **Done** | Implemented | `pulse-deepdive`, `pulse-monitor` |
| 2 | `search_companies_advanced` cost verification | High | Documentation | `pulse-deepdive` |
| 3 | `get_latest_diffs` cleanup | Done | No action needed | — |
| 4 | `get_diff_highlight` partner access | High | Verification | `pulse-monitor`, `pulse-deepdive` |
| 5 | `search_pricing_knowledge` partner access | Medium | Verification | `pulse-deepdive` |
| 6 | `get_categories` tool | Nice-to-have | New tool | `pulse-deepdive`, `pulse-scan` |
| 7 | Watchlist tools (`get/add/remove`) | **Done** | Implemented | `pulse-monitor` |
| 8 | `request_company` tool | Nice-to-have | New tool | `pulse-scan` |

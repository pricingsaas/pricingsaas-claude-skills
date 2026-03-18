# Landscape Report Structure & Formatting

## CRITICAL: Use This Exact Template

You MUST use the exact CSS and HTML structure below. Do NOT:
- Import Google Fonts or any external resources
- Use custom color schemes (no dark blue headers, no yellow/green accents)
- Invent new class names or CSS rules
- Use card-based layouts with box-shadows
- Use horizontal bar charts
- Change the monochrome design system

The PricingSaaS report design is clean, monochrome (black/white/gray), and uses system fonts. Every report must look identical in structure and styling.

## Report Generation

Generate the report as a single self-contained `.html` file. No external dependencies — all CSS is inline in a `<style>` block. Write to a temp file and upload via `upload_report` MCP tool.

## Complete HTML Template

Copy this CSS verbatim into your report. Do not modify it.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{Category} Pricing Landscape — PricingSaaS</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #eee; color: #222; line-height: 1.6; }
.wrapper { max-width: 1000px; margin: 0 auto; background: #fff; }

/* Header */
.header { padding: 32px 48px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e0e0e0; }
.header-left { display: flex; align-items: center; gap: 20px; }
.header-left img { height: 36px; }
.header-divider { width: 1px; height: 40px; background: #ccc; }
.header-right { text-align: right; }
.header-right h1 { font-size: 22px; font-weight: 700; color: #222; margin-bottom: 2px; }
.header-right .subtitle { font-size: 14px; color: #666; }
.header-right .date { font-size: 12px; color: #999; margin-top: 4px; }

/* Headings */
h2 { font-size: 20px; font-weight: 700; color: #222; margin: 40px 48px 16px; padding-bottom: 8px; border-bottom: 2px solid #222; }
h3 { font-size: 16px; font-weight: 700; color: #222; margin: 24px 48px 12px; }

/* Executive Summary */
.executive-summary { margin: 24px 48px; padding: 24px 28px; background: #f9f9f9; border-left: 4px solid #222; }
.executive-summary p { font-size: 15px; color: #333; margin-bottom: 12px; }
.executive-summary p:last-child { margin-bottom: 0; }

/* Section Content */
.section-content { margin: 16px 48px; }
.section-content p { font-size: 15px; color: #333; margin-bottom: 12px; }
.section-content ul, .section-content ol { margin: 12px 0 12px 28px; }
.section-content li { font-size: 15px; color: #333; margin-bottom: 8px; }
.section-content strong { font-weight: 700; }

/* Tables */
.pricing-table { width: 100%; border-collapse: collapse; margin: 16px 0; }
.pricing-table th, .pricing-table td { padding: 10px 16px; text-align: left; font-size: 14px; border-bottom: 1px solid #e0e0e0; }
.pricing-table th { background: #222; color: #fff; font-weight: 600; }
.pricing-table tr:nth-child(even) { background: #f9f9f9; }
.pricing-table a { color: #222; text-decoration: underline; }

/* Bar Chart (vertical) */
.chart-container { margin: 24px 48px; }
.bar-chart { display: flex; align-items: flex-end; gap: 8px; height: 220px; padding: 16px 0; border-bottom: 2px solid #222; }
.bar-group { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; height: 100%; }
.bar { width: 60%; background: #222; border-radius: 4px 4px 0 0; min-height: 4px; position: relative; }
.bar.highlight { background: #059669; }
.bar-value { position: absolute; top: -20px; width: 100%; text-align: center; font-size: 11px; font-weight: 600; color: #222; }
.bar-label { margin-top: 8px; font-size: 10px; color: #666; text-align: center; max-width: 80px; }

/* Insight Boxes */
.insight-box { margin: 20px 48px; padding: 20px 24px; background: #f5f5f5; border: 1px solid #e0e0e0; border-radius: 6px; }
.insight-box h4 { font-size: 14px; font-weight: 700; color: #222; margin-bottom: 8px; }
.insight-box p, .insight-box ul { font-size: 14px; color: #444; }
.insight-box ul { margin: 8px 0 0 20px; }
.insight-box li { margin-bottom: 4px; }
.insight-box.green { background: #f0fdf4; border-left: 4px solid #059669; border-color: #bbf7d0; }

/* Stats Row */
.stats-row { display: flex; gap: 0; margin: 24px 48px; border: 1px solid #e0e0e0; border-radius: 6px; overflow: hidden; }
.stat-box { flex: 1; padding: 16px 20px; text-align: center; border-right: 1px solid #e0e0e0; }
.stat-box:last-child { border-right: none; }
.stat-value { font-size: 28px; font-weight: 700; color: #222; }
.stat-label { font-size: 12px; color: #666; margin-top: 4px; }

/* Company Grid (for data sources) */
.company-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 12px; margin: 16px 0; }
.company-card { padding: 12px 16px; border: 1px solid #e0e0e0; border-radius: 6px; font-size: 13px; }
.company-card a { color: #222; text-decoration: none; font-weight: 600; }
.company-card a:hover { text-decoration: underline; }
.company-card .meta { font-size: 11px; color: #888; margin-top: 4px; }
.seed-highlight { background: #f0fdf4; border: 2px solid #059669; }

/* Footer */
.footer { margin-top: 40px; padding: 24px 48px; background: #222; color: #aaa; font-size: 12px; text-align: center; }
.footer a { color: #ddd; text-decoration: none; }

/* Mobile */
@media (max-width: 600px) {
  .header { flex-direction: column; align-items: flex-start; gap: 16px; padding: 24px; }
  .header-divider { display: none; }
  .header-right { text-align: left; }
  h2 { margin: 32px 24px 12px; }
  h3 { margin: 20px 24px 10px; }
  .executive-summary, .section-content, .chart-container, .insight-box, .stats-row { margin-left: 24px; margin-right: 24px; }
  .stats-row { flex-direction: column; }
  .stat-box { border-right: none; border-bottom: 1px solid #e0e0e0; }
  .stat-box:last-child { border-bottom: none; }
  .footer { padding: 20px 24px; }
  .company-grid { grid-template-columns: 1fr; }
}
</style>
</head>
```

## Report Sections

### 1. Header

If the user provided a seed company, show the seed company logo alongside PricingSaaS branding. If category-only (no seed), show only PricingSaaS branding.

```html
<body>
<div class="wrapper">
<div class="header">
  <div class="header-left">
    <img src="{logo_url from get_company_details}" alt="{Seed Company} logo">
    <div class="header-divider"></div>
    <img src="https://res.cloudinary.com/dd6dkaan9/image/upload/v1741805859/branding/wordmark-black.png" alt="PricingSaaS">
  </div>
  <div class="header-right">
    <h1>{Category} Pricing Landscape</h1>
    <div class="subtitle">Market Discovery Report</div>
    <div class="date">{Month Year}</div>
  </div>
</div>
```

### 2. Stats Row

```html
<div class="stats-row">
  <div class="stat-box"><div class="stat-value">{N}</div><div class="stat-label">Companies Found</div></div>
  <div class="stat-box"><div class="stat-value">{N}</div><div class="stat-label">Pricing Models</div></div>
  <div class="stat-box"><div class="stat-value">${low}–${high}</div><div class="stat-label">Price Range</div></div>
  <div class="stat-box"><div class="stat-value">{N}</div><div class="stat-label">Freemium</div></div>
</div>
```

### 3. Executive Summary

```html
<h2>Executive Summary</h2>
<div class="executive-summary">
  <p>{1-2 paragraphs: category overview, how many companies, how the landscape breaks down by tier, dominant pricing models}</p>
</div>
```

### 4. Market Layers

One table per tier/segment. Each table groups companies by market position:

```html
<h2>Market Landscape</h2>

<h3>{Tier Name} (e.g., "Enterprise", "Mid-Market", "SMB")</h3>
<div class="section-content">
  <table class="pricing-table">
    <thead><tr><th>Company</th><th>Plan</th><th>Monthly</th><th>Annual</th><th>Model</th><th>Source</th></tr></thead>
    <tbody>
      <tr>
        <td><strong>{Company}</strong></td>
        <td>{plan name}</td>
        <td>{monthly price}</td>
        <td>{annual price}</td>
        <td>{per user / flat / usage}</td>
        <td><a href="https://pricingsaas.com/pulse/companies/{slug}">View →</a></td>
      </tr>
    </tbody>
  </table>
</div>
```

### 5. Pricing Patterns

Use insight boxes to highlight key observations:

```html
<h2>Pricing Patterns</h2>

<div class="insight-box">
  <h4>{Pattern Title} (e.g., "Per-Seat Dominance")</h4>
  <p>{Description of the pattern and which companies follow it}</p>
</div>

<div class="insight-box">
  <h4>{Pattern Title} (e.g., "Freemium as Entry Point")</h4>
  <ul>
    <li>{Company A} — {details}</li>
    <li>{Company B} — {details}</li>
  </ul>
</div>
```

### 6. Bar Chart — Price Comparison (VERTICAL bars only)

```html
<h2>Price Comparison</h2>
<div class="chart-container">
  <div class="bar-chart">
    <div class="bar-group">
      <div class="bar" style="height: {pct}%;"><span class="bar-value">${price}</span></div>
      <div class="bar-label">{Company}</div>
    </div>
    <!-- repeat for each company -->
  </div>
</div>
```

Calculate `{pct}` as `(price / max_price) * 100` so the tallest bar is 100%. Use `class="bar highlight"` for the seed company.

### 7. Coverage Gaps

```html
<h2>Coverage Gaps</h2>
<div class="section-content">
  <p>{What's missing — companies not tracked, segments with limited data, etc.}</p>
</div>
```

### 8. Data Sources

Use the company grid layout with cards:

```html
<h2>Data Sources</h2>
<div class="section-content">
  <div class="company-grid">
    <div class="company-card seed-highlight">
      <a href="https://pricingsaas.com/pulse/companies/{slug}">{Seed Company Name}</a>
      <div class="meta">{employee count} · {pricing model}</div>
    </div>
    <div class="company-card">
      <a href="https://pricingsaas.com/pulse/companies/{slug}">{Company Name}</a>
      <div class="meta">{employee count} · {pricing model}</div>
    </div>
    <!-- repeat for each company -->
  </div>
</div>
```

Use `class="company-card seed-highlight"` for the seed company (green border). All others use plain `class="company-card"`.

### 9. Footer

```html
<div class="footer">
  <p>Generated by <a href="https://pricingsaas.com">pricingsaas.com</a> — Pricing Intelligence for SaaS</p>
</div>
</div>
</body>
</html>
```

## Key Rules

1. **Self-contained HTML** — no external CSS, JS, or fonts. Everything inline. Do NOT import Google Fonts.
2. **Monochrome design** — black (`#222`), white (`#fff`), gray (`#f9f9f9`, `#e0e0e0`, `#666`). The ONLY accent color is green (`#059669`) for the seed company highlight. No blue, no yellow, no gradients.
3. **System fonts only** — `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`. Never import external fonts.
4. **Use `.wrapper` not `.container`** — the outer div must be `class="wrapper"`.
5. **Vertical bar chart** — bars grow upward. Never use horizontal bars.
6. **No box-shadows** — no `box-shadow` on any element. Use borders (`1px solid #e0e0e0`) for definition.
7. **No card-based layouts** — except `.company-card` in the data sources grid.
8. **Links everywhere** — every company name links to `https://pricingsaas.com/pulse/companies/{slug}`.
9. **Upload as .html** — Write to `/tmp/{category}-pricing-landscape.html`, then `upload_report(filename, file_path)` and execute the returned curl command.
10. **Company logos** — use the `logo_url` field from `get_company_details` (Cloudinary-hosted). Do NOT use `https://logo.clearbit.com/` URLs — they do not render.

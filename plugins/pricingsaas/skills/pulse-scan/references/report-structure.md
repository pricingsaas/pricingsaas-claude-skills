# Landscape Report Structure & Formatting

## Report Generation

Generate the report as a single self-contained `.html` file. No external dependencies — all CSS is inline in a `<style>` block. Write to a temp file and upload via `upload_report` MCP tool.

## HTML Template

Use this exact CSS and structure. The template is the standard PricingSaaS report design — clean, monochrome, responsive.

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

h2 { font-size: 20px; font-weight: 700; color: #222; margin: 40px 48px 16px; padding-bottom: 8px; border-bottom: 2px solid #222; }
h3 { font-size: 16px; font-weight: 700; color: #222; margin: 24px 48px 12px; }

.executive-summary { margin: 24px 48px; padding: 24px 28px; background: #f9f9f9; border-left: 4px solid #222; }
.executive-summary p { font-size: 15px; color: #333; }

.section-content { margin: 16px 48px; }
.section-content p { font-size: 15px; color: #333; margin-bottom: 12px; }
.section-content ul, .section-content ol { margin: 12px 0 12px 28px; }
.section-content li { font-size: 15px; color: #333; margin-bottom: 8px; }
.section-content strong { font-weight: 700; }

.pricing-table { width: 100%; border-collapse: collapse; margin: 16px 0; }
.pricing-table th, .pricing-table td { padding: 10px 16px; text-align: left; font-size: 14px; border-bottom: 1px solid #e0e0e0; }
.pricing-table th { background: #222; color: #fff; font-weight: 600; }
.pricing-table tr:nth-child(even) { background: #f9f9f9; }

.chart-container { margin: 24px 48px; }
.bar-chart { display: flex; align-items: flex-end; gap: 8px; height: 200px; padding: 16px 0; border-bottom: 2px solid #222; }
.bar-group { flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: flex-end; height: 100%; }
.bar { width: 60%; background: #222; border-radius: 4px 4px 0 0; min-height: 4px; position: relative; }
.bar-value { position: absolute; top: -20px; width: 100%; text-align: center; font-size: 11px; font-weight: 600; color: #222; }
.bar-label { margin-top: 8px; font-size: 11px; color: #666; text-align: center; }

.insight-box { margin: 20px 48px; padding: 20px 24px; background: #f5f5f5; border: 1px solid #e0e0e0; border-radius: 6px; }
.insight-box h4 { font-size: 14px; font-weight: 700; color: #222; margin-bottom: 8px; }
.insight-box p, .insight-box ul { font-size: 14px; color: #444; }
.insight-box ul { margin: 8px 0 0 20px; }
.insight-box li { margin-bottom: 4px; }

.stats-row { display: flex; gap: 0; margin: 24px 48px; border: 1px solid #e0e0e0; border-radius: 6px; overflow: hidden; }
.stat-box { flex: 1; padding: 16px 20px; text-align: center; border-right: 1px solid #e0e0e0; }
.stat-box:last-child { border-right: none; }
.stat-value { font-size: 28px; font-weight: 700; color: #222; }
.stat-label { font-size: 12px; color: #666; margin-top: 4px; }

.sources-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 8px; margin: 16px 0; }
.sources-grid a { font-size: 13px; color: #666; text-decoration: none; }
.sources-grid a:hover { color: #222; text-decoration: underline; }

.footer { margin-top: 40px; padding: 24px 48px; background: #222; color: #aaa; font-size: 12px; text-align: center; }
.footer a { color: #ddd; text-decoration: none; }

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

### 6. Bar Chart — Price Comparison

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

Calculate `{pct}` as `(price / max_price) * 100` so the tallest bar is 100%.

### 7. Coverage Gaps

```html
<h2>Coverage Gaps</h2>
<div class="section-content">
  <p>{What's missing — companies not tracked, segments with limited data, etc.}</p>
</div>
```

### 8. Data Sources

```html
<h2>Data Sources</h2>
<div class="section-content">
  <div class="sources-grid">
    <a href="https://pricingsaas.com/pulse/companies/{slug}">{Company Name}</a>
    <!-- repeat for each company -->
  </div>
</div>
```

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

1. **Self-contained HTML** — no external CSS, JS, or fonts. Everything inline.
2. **Monochrome design** — black/white/gray base. No color except for the bar chart and data indicators.
3. **Links everywhere** — every company name links to `https://pricingsaas.com/pulse/companies/{slug}`.
4. **Upload as .html** — Write to `/tmp/{category}-pricing-landscape.html`, then `upload_report(filename, file_path)` and execute the returned curl command.
5. **Company logos** — use the `logo_url` field from `get_company_details` (Cloudinary-hosted). Do NOT use `https://logo.clearbit.com/` URLs — they do not render.
6. **Use this exact CSS** — do not invent new styles, modify colors, or add custom CSS. The template ensures visual consistency across all PricingSaaS reports.

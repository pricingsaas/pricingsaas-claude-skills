# Report Structure & Formatting

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
<title>{Company} Pricing Analysis — PricingSaaS</title>
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

.recommended { background: #f0fdf4; border-left: 4px solid #059669; }

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

### Header

```html
<div class="header">
  <div class="header-left">
    <img src="{logo_url from get_company_details}" alt="{Company} logo">
    <div class="header-divider"></div>
    <img src="https://res.cloudinary.com/dd6dkaan9/image/upload/v1741805859/branding/wordmark-black.png" alt="PricingSaaS">
  </div>
  <div class="header-right">
    <h1>{Company} Pricing Analysis</h1>
    <div class="subtitle">Price Increase Recommendation — {Plan} Plan</div>
    <div class="date">{Month Year}</div>
  </div>
</div>
```

### Stats Row

```html
<div class="stats-row">
  <div class="stat-box"><div class="stat-value">{N}</div><div class="stat-label">Companies Analyzed</div></div>
  <div class="stat-box"><div class="stat-value">{N}Q</div><div class="stat-label">Quarters of History</div></div>
  <div class="stat-box"><div class="stat-value">${N}</div><div class="stat-label">Current Price</div></div>
  <div class="stat-box"><div class="stat-value" style="color: #059669;">${N}</div><div class="stat-label">Recommended Price</div></div>
</div>
```

### Executive Summary

```html
<h2>Executive Summary</h2>
<div class="executive-summary">
  <p>{2-3 paragraphs: current price, time since last change, value shipped, key finding, recommendation}</p>
</div>
```

### Competitive Landscape Tables

One table per tier. Use `color: #dc2626` for increases, `color: #059669` for decreases:

```html
<h3>Tier 1: Direct Competitors</h3>
<div class="section-content">
  <table class="pricing-table">
    <thead><tr><th>Company</th><th>Plan</th><th>Annual</th><th>Monthly</th><th>Last Increase</th><th>Source</th></tr></thead>
    <tbody>
      <tr>
        <td><strong>{Company}</strong></td>
        <td>{plan}</td>
        <td>{annual}</td>
        <td>{monthly}</td>
        <td style="color: #dc2626;">{+X%}</td>
        <td><a href="https://pricingsaas.com/companies/{slug}?v2=true">View →</a></td>
      </tr>
    </tbody>
  </table>
</div>
```

### Price Increase Timeline

Sort by change percentage descending.

### Bar Chart (for price comparison)

```html
<div class="chart-container">
  <div class="bar-chart">
    <div class="bar-group">
      <div class="bar" style="height: {pct}%;"><span class="bar-value">${price}</span></div>
      <div class="bar-label">{Company}</div>
    </div>
  </div>
</div>
```

### Recommendation Table

Highlight recommended row with green accent:

```html
<tr class="recommended"><td><strong>Recommended</strong></td><td>...</td></tr>
```

### Insight Boxes

```html
<div class="insight-box">
  <h4>{Insight Title}</h4>
  <p>{Description}</p>
</div>
```

### Data Sources

```html
<h2>Data Sources</h2>
<div class="section-content">
  <p style="font-size: 13px; color: #666;">
    <a href="https://pricingsaas.com/companies/{slug}?v2=true">{Company}</a> · ...
  </p>
</div>
```

### Footer

```html
<div class="footer">
  <p>Generated by <a href="https://pricingsaas.com">pricingsaas.com</a> — Pricing Intelligence for SaaS</p>
</div>
```

## Key Rules

1. **Self-contained HTML** — no external CSS, JS, or fonts. Everything inline.
2. **Monochrome design** — black/white/gray base. Color only for change indicators and the recommended scenario.
3. **Links everywhere** — every company name links to PricingSaaS.
4. **Upload as .html** — Write to `/tmp/{company}-pricing-analysis.html`, then `upload_report(filename, file_path)` and execute the returned curl command.
5. **Company logos** — use the `logo_url` field from `get_company_details` (Cloudinary-hosted). Do NOT use `https://logo.clearbit.com/` URLs — they do not render.

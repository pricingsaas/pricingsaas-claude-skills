# Digest Report Structure & Formatting

## Report Generation

Generate the digest report as a single self-contained `.html` file. No external dependencies — all CSS is inline in a `<style>` block. The HTML uses the same design system as all PricingSaaS reports.

## HTML Template

Use this exact CSS and structure. The template is designed to be clean, monochrome, responsive, and readable when shared via URL.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title} — PricingSaaS</title>
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

/* Section headings */
h2 { font-size: 20px; font-weight: 700; color: #222; margin: 40px 48px 16px; padding-bottom: 8px; border-bottom: 2px solid #222; }
h3 { font-size: 16px; font-weight: 700; color: #222; margin: 24px 48px 12px; }

/* Executive Summary */
.executive-summary { margin: 24px 48px; padding: 24px 28px; background: #f9f9f9; border-left: 4px solid #222; }
.executive-summary p { font-size: 15px; color: #333; }

/* Section content */
.section-content { margin: 16px 48px; }
.section-content p { font-size: 15px; color: #333; margin-bottom: 12px; }
.section-content ul, .section-content ol { margin: 12px 0 12px 28px; }
.section-content li { font-size: 15px; color: #333; margin-bottom: 8px; }
.section-content strong { font-weight: 700; }

/* Data tables */
.pricing-table { width: 100%; border-collapse: collapse; margin: 16px 0; }
.pricing-table th, .pricing-table td { padding: 10px 16px; text-align: left; font-size: 14px; border-bottom: 1px solid #e0e0e0; }
.pricing-table th { background: #222; color: #fff; font-weight: 600; }
.pricing-table tr:nth-child(even) { background: #f9f9f9; }

/* Change type badges */
.badge { display: inline-block; padding: 2px 10px; border-radius: 4px; font-size: 12px; font-weight: 600; }
.badge-increase { background: #fee2e2; color: #dc2626; }
.badge-decrease { background: #d1fae5; color: #059669; }
.badge-restructure { background: #ffedd5; color: #c2410c; }
.badge-feature { background: #dbeafe; color: #2563eb; }
.badge-packaging { background: #f3f4f6; color: #374151; }

/* Insight boxes */
.insight-box { margin: 20px 48px; padding: 20px 24px; background: #f5f5f5; border: 1px solid #e0e0e0; border-radius: 6px; }
.insight-box h4 { font-size: 14px; font-weight: 700; color: #222; margin-bottom: 8px; }
.insight-box p, .insight-box ul { font-size: 14px; color: #444; }
.insight-box ul { margin: 8px 0 0 20px; }
.insight-box li { margin-bottom: 4px; }

/* Stats row */
.stats-row { display: flex; gap: 0; margin: 24px 48px; border: 1px solid #e0e0e0; border-radius: 6px; overflow: hidden; }
.stat-box { flex: 1; padding: 16px 20px; text-align: center; border-right: 1px solid #e0e0e0; }
.stat-box:last-child { border-right: none; }
.stat-value { font-size: 28px; font-weight: 700; color: #222; }
.stat-label { font-size: 12px; color: #666; margin-top: 4px; }

/* Footer */
.footer { margin-top: 40px; padding: 24px 48px; background: #222; color: #aaa; font-size: 12px; text-align: center; }
.footer a { color: #ddd; text-decoration: none; }

/* Responsive */
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

Always include the PricingSaaS wordmark and a descriptive title:

```html
<div class="header">
  <div class="header-left">
    <img src="https://res.cloudinary.com/dd6dkaan9/image/upload/v1741805859/branding/wordmark-black.png" alt="PricingSaaS">
  </div>
  <div class="header-right">
    <h1>Weekly Pricing Digest</h1>
    <div class="subtitle">{X} of {Y} Tracked Competitors Changed</div>
    <div class="date">Week of {date}</div>
  </div>
</div>
```

### Stats Row

Key metrics at a glance, immediately after header:

```html
<div class="stats-row">
  <div class="stat-box">
    <div class="stat-value">{N}</div>
    <div class="stat-label">Companies Tracked</div>
  </div>
  <div class="stat-box">
    <div class="stat-value" style="color: #dc2626;">{N}</div>
    <div class="stat-label">Changed</div>
  </div>
  <div class="stat-box">
    <div class="stat-value">{N}</div>
    <div class="stat-label">Price Increases</div>
  </div>
  <div class="stat-box">
    <div class="stat-value">{N}</div>
    <div class="stat-label">Restructures</div>
  </div>
</div>
```

### Executive Summary

Use the `executive-summary` class with border-left accent:

```html
<h2>Executive Summary</h2>
<div class="executive-summary">
  <p>{1-2 sentence overview of what changed this week}</p>
</div>
```

### Watchlist Changes Table

The core table. Use badges for change types:

```html
<h2>Watchlist Changes</h2>
<div class="section-content">
  <table class="pricing-table">
    <thead>
      <tr>
        <th>Company</th>
        <th>Type</th>
        <th>Details</th>
        <th>Impact</th>
        <th>Diff</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>{Company}</strong></td>
        <td><span class="badge badge-increase">Price Increase</span></td>
        <td>{description}</td>
        <td>{affected plans}</td>
        <td><a href="https://pricingsaas.com/companies/{slug}/diffs/{period}?v2=true">View →</a></td>
      </tr>
    </tbody>
  </table>
</div>
```

Badge classes: `badge-increase`, `badge-decrease`, `badge-restructure`, `badge-feature`, `badge-packaging`

### Price Change Detail Table

For companies with actual price changes:

```html
<h2>Price Change Detail</h2>
<div class="section-content">
  <table class="pricing-table">
    <thead>
      <tr><th>Company</th><th>Plan</th><th>Before</th><th>After</th><th>Change</th></tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>{Company}</strong></td>
        <td>{Plan name}</td>
        <td>{old price}</td>
        <td>{new price}</td>
        <td style="color: #dc2626; font-weight: 700;">{+X%}</td>
      </tr>
    </tbody>
  </table>
</div>
```

Use `color: #dc2626` for increases, `color: #059669` for decreases.

### Patterns & Trends

Use insight boxes for key patterns:

```html
<h2>Patterns & Trends</h2>
<div class="insight-box">
  <h4>{Pattern Name}</h4>
  <p>{Description with data points}</p>
</div>
```

### Market Highlights

Non-watchlist notable changes:

```html
<h2>Market Highlights</h2>
<div class="section-content">
  <table class="pricing-table">
    <thead>
      <tr><th>Company</th><th>Change</th><th>Source</th></tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>{Company}</strong></td>
        <td>{description}</td>
        <td><a href="https://pricingsaas.com/companies/{slug}?v2=true">View →</a></td>
      </tr>
    </tbody>
  </table>
</div>
```

### No Changes Section

Compact list, visually de-emphasized:

```html
<h2>No Changes ({N} Companies)</h2>
<div class="section-content">
  <p style="color: #999; font-size: 13px;">{Company1} · {Company2} · {Company3} · ...</p>
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
2. **Monochrome design** — black/white/gray base. Color only for badges and change indicators.
3. **Links everywhere** — every company name should link to its PricingSaaS page, every diff should link to the visual diff.
4. **Sort by significance** — price changes first (largest % first), then restructures, then features.
5. **Responsive** — the template includes mobile breakpoints. Don't break them.
6. **Upload as HTML** — Write to `/tmp/pricing-digest-{week}.html`, then use `/upload-file-to-share` skill for instant S3 upload.
7. **Company logos** — use the `logo_url` field from `get_company_details` or diff responses (Cloudinary-hosted). Do NOT use `https://logo.clearbit.com/` URLs — they do not render.

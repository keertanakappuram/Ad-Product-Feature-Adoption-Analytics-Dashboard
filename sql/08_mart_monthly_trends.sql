CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.mart_monthly_trends` AS
SELECT
  FORMAT_DATE('%Y-%m', activity_date) AS year_month,
  platform,
  SUM(ad_spend) AS total_spend,
  SUM(revenue) AS total_revenue,
  SUM(conversions) AS total_conversions,
  SAFE_DIVIDE(SUM(revenue), NULLIF(SUM(ad_spend), 0)) AS roas
FROM `your-gcp-project-id.analytics.fact_campaign_activity`
GROUP BY 1,2;

CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.mart_segment_performance` AS
SELECT
  platform,
  industry,
  country,
  campaign_type,
  COUNT(*) AS campaign_days,
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  SUM(conversions) AS conversions,
  SUM(ad_spend) AS total_spend,
  SUM(revenue) AS total_revenue,
  SAFE_DIVIDE(SUM(clicks), NULLIF(SUM(impressions), 0)) AS ctr,
  SAFE_DIVIDE(SUM(conversions), NULLIF(SUM(clicks), 0)) AS conversion_rate,
  SAFE_DIVIDE(SUM(revenue), NULLIF(SUM(ad_spend), 0)) AS roas
FROM `your-gcp-project-id.analytics.fact_campaign_activity`
GROUP BY 1,2,3,4;

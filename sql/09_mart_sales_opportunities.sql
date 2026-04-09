CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.mart_sales_opportunities` AS
WITH segment_perf AS (
  SELECT
    platform,
    industry,
    country,
    SUM(ad_spend) AS total_spend,
    SUM(revenue) AS total_revenue,
    SAFE_DIVIDE(SUM(revenue), NULLIF(SUM(ad_spend), 0)) AS roas
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`
  GROUP BY 1,2,3
),
feature_adoption AS (
  SELECT
    platform,
    industry,
    country,
    AVG(CASE
      WHEN feature_name IN (
        'video_ads_feature',
        'shopping_ads_feature',
        'high_engagement_feature',
        'high_conversion_feature'
      )
      THEN adoption_rate
    END) AS avg_feature_adoption_rate
  FROM `your-gcp-project-id.analytics.mart_feature_adoption`
  GROUP BY 1,2,3
)
SELECT
  s.platform,
  s.industry,
  s.country,
  s.total_spend,
  s.total_revenue,
  s.roas,
  f.avg_feature_adoption_rate,
  CASE
    WHEN s.total_spend > 1000000 AND f.avg_feature_adoption_rate < 0.35 THEN 'High-value, low-adoption'
    WHEN s.roas > 5 AND f.avg_feature_adoption_rate > 0.50 THEN 'Scale opportunity'
    ELSE 'Monitor'
  END AS recommendation_bucket
FROM segment_perf s
JOIN feature_adoption f
USING (platform, industry, country)
ORDER BY total_revenue DESC;

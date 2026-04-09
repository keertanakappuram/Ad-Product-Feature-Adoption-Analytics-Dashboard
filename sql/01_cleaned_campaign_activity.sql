CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.cleaned_campaign_activity` AS
SELECT
  DATE(date) AS activity_date,
  platform,
  campaign_type,
  industry,
  country,
  SAFE_CAST(impressions AS INT64) AS impressions,
  SAFE_CAST(clicks AS INT64) AS clicks,
  SAFE_CAST(ad_spend AS FLOAT64) AS ad_spend,
  SAFE_CAST(conversions AS INT64) AS conversions,
  SAFE_CAST(revenue AS FLOAT64) AS revenue,

  SAFE_DIVIDE(SAFE_CAST(clicks AS FLOAT64), NULLIF(SAFE_CAST(impressions AS FLOAT64), 0)) AS ctr_calc,
  SAFE_DIVIDE(SAFE_CAST(ad_spend AS FLOAT64), NULLIF(SAFE_CAST(clicks AS FLOAT64), 0)) AS cpc_calc,
  SAFE_DIVIDE(SAFE_CAST(conversions AS FLOAT64), NULLIF(SAFE_CAST(clicks AS FLOAT64), 0)) AS conversion_rate,
  SAFE_DIVIDE(SAFE_CAST(ad_spend AS FLOAT64), NULLIF(SAFE_CAST(conversions AS FLOAT64), 0)) AS cpa_calc,
  SAFE_DIVIDE(SAFE_CAST(revenue AS FLOAT64), NULLIF(SAFE_CAST(ad_spend AS FLOAT64), 0)) AS roas_calc
FROM `your-gcp-project-id.raw.global_ads_performance`
WHERE date IS NOT NULL
  AND platform IS NOT NULL
  AND campaign_type IS NOT NULL
  AND industry IS NOT NULL
  AND country IS NOT NULL;

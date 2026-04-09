CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.fact_campaign_activity` AS
SELECT
  activity_date,
  CONCAT(platform, '_', industry, '_', country) AS advertiser_segment_id,
  platform,
  campaign_type,
  industry,
  country,
  impressions,
  clicks,
  ad_spend,
  conversions,
  revenue,
  ctr_calc,
  cpc_calc,
  conversion_rate,
  cpa_calc,
  roas_calc,

  CASE WHEN campaign_type = 'Search' THEN 1 ELSE 0 END AS uses_search_ads_feature,
  CASE WHEN campaign_type = 'Display' THEN 1 ELSE 0 END AS uses_display_ads_feature,
  CASE WHEN campaign_type = 'Video' THEN 1 ELSE 0 END AS uses_video_ads_feature,
  CASE WHEN campaign_type = 'Shopping' THEN 1 ELSE 0 END AS uses_shopping_ads_feature,
  CASE WHEN ctr_calc >= 0.05 THEN 1 ELSE 0 END AS uses_high_engagement_feature,
  CASE WHEN conversion_rate >= 0.045 THEN 1 ELSE 0 END AS uses_high_conversion_feature,
  CASE WHEN ad_spend >= 5000 THEN 1 ELSE 0 END AS uses_scaled_campaign_feature
FROM `your-gcp-project-id.analytics.cleaned_campaign_activity`;

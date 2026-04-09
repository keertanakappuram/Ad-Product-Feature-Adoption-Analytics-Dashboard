CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.mart_feature_adoption` AS
WITH feature_events AS (
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'search_ads_feature' AS feature_name,
         uses_search_ads_feature AS adopted,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`

  UNION ALL
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'display_ads_feature',
         uses_display_ads_feature,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`

  UNION ALL
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'video_ads_feature',
         uses_video_ads_feature,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`

  UNION ALL
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'shopping_ads_feature',
         uses_shopping_ads_feature,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`

  UNION ALL
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'high_engagement_feature',
         uses_high_engagement_feature,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`

  UNION ALL
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'high_conversion_feature',
         uses_high_conversion_feature,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`

  UNION ALL
  SELECT activity_date, advertiser_segment_id, platform, industry, country,
         'scaled_campaign_feature',
         uses_scaled_campaign_feature,
         clicks, conversions, ad_spend, revenue
  FROM `your-gcp-project-id.analytics.fact_campaign_activity`
)
SELECT
  activity_date,
  platform,
  industry,
  country,
  feature_name,
  COUNT(DISTINCT advertiser_segment_id) AS total_segments,
  COUNT(DISTINCT CASE WHEN adopted = 1 THEN advertiser_segment_id END) AS adopting_segments,
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN adopted = 1 THEN advertiser_segment_id END),
    COUNT(DISTINCT advertiser_segment_id)
  ) AS adoption_rate,
  SUM(CASE WHEN adopted = 1 THEN clicks ELSE 0 END) AS feature_clicks,
  SUM(CASE WHEN adopted = 1 THEN conversions ELSE 0 END) AS feature_conversions,
  SUM(CASE WHEN adopted = 1 THEN ad_spend ELSE 0 END) AS feature_spend,
  SUM(CASE WHEN adopted = 1 THEN revenue ELSE 0 END) AS feature_revenue
FROM feature_events
GROUP BY 1,2,3,4,5;

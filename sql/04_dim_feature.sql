CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.dim_feature` AS
SELECT 'search_ads_feature' AS feature_name UNION ALL
SELECT 'display_ads_feature' UNION ALL
SELECT 'video_ads_feature' UNION ALL
SELECT 'shopping_ads_feature' UNION ALL
SELECT 'high_engagement_feature' UNION ALL
SELECT 'high_conversion_feature' UNION ALL
SELECT 'scaled_campaign_feature';

CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.dim_advertiser_segment` AS
SELECT DISTINCT
  CONCAT(platform, '_', industry, '_', country) AS advertiser_segment_id,
  platform,
  industry,
  country
FROM `your-gcp-project-id.analytics.cleaned_campaign_activity`;

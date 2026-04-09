CREATE OR REPLACE TABLE `your-gcp-project-id.analytics.dim_date` AS
SELECT DISTINCT
  activity_date,
  EXTRACT(YEAR FROM activity_date) AS year,
  EXTRACT(MONTH FROM activity_date) AS month_num,
  FORMAT_DATE('%Y-%m', activity_date) AS year_month,
  EXTRACT(QUARTER FROM activity_date) AS quarter
FROM `your-gcp-project-id.analytics.cleaned_campaign_activity`;

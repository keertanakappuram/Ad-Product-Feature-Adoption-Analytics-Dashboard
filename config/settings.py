PROJECT_ID = "your-gcp-project-id" #project ID here
RAW_DATASET = "raw"
ANALYTICS_DATASET = "analytics"

RAW_TABLE = f"{PROJECT_ID}.{RAW_DATASET}.global_ads_performance"
CLEANED_TABLE = f"{PROJECT_ID}.{ANALYTICS_DATASET}.cleaned_campaign_activity"

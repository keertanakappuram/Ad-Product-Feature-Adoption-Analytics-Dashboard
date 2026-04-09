from google.cloud import bigquery
from config.settings import PROJECT_ID

SQL_FILES = [
    "sql/01_cleaned_campaign_activity.sql",
    "sql/02_dim_advertiser_segment.sql",
    "sql/03_dim_date.sql",
    "sql/04_dim_feature.sql",
    "sql/05_fact_campaign_activity.sql",
    "sql/06_mart_feature_adoption.sql",
    "sql/07_mart_segment_performance.sql",
    "sql/08_mart_monthly_trends.sql",
    "sql/09_mart_sales_opportunities.sql",
]

def main():
    client = bigquery.Client(project=PROJECT_ID)

    for path in SQL_FILES:
        with open(path, "r") as f:
            query = f.read()
        client.query(query).result()
        print(f"Ran {path}")

if __name__ == "__main__":
    main()

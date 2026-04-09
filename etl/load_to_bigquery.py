import pandas as pd
from google.cloud import bigquery
from config.settings import PROJECT_ID, RAW_DATASET, RAW_TABLE

def main():
    client = bigquery.Client(project=PROJECT_ID)

    df = pd.read_csv("data/global_ads_performance_dataset.csv")

    job_config = bigquery.LoadJobConfig(
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
        source_format=bigquery.SourceFormat.CSV
    )

    job = client.load_table_from_dataframe(
        df,
        RAW_TABLE,
        job_config=job_config
    )
    job.result()

    print(f"Loaded {len(df)} rows into {RAW_TABLE}")

if __name__ == "__main__":
    main()

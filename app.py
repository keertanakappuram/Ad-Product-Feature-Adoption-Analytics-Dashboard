import streamlit as st
import pandas as pd
from google.cloud import bigquery
import plotly.express as px

PROJECT_ID = "your-gcp-project-id"

st.set_page_config(
    page_title="Ad Product Feature Adoption Analytics Dashboard",
    layout="wide"
)

@st.cache_data
def run_query(query: str) -> pd.DataFrame:
    client = bigquery.Client(project=PROJECT_ID)
    return client.query(query).to_dataframe()

st.title("Ad Product Feature Adoption Analytics Dashboard")
st.markdown(
    "BI dashboard for tracking ad product feature adoption, campaign efficiency, and sales prioritization opportunities across advertiser segments."
)

platforms_df = run_query(f"""
SELECT DISTINCT platform
FROM `{PROJECT_ID}.analytics.mart_segment_performance`
ORDER BY platform
""")

industries_df = run_query(f"""
SELECT DISTINCT industry
FROM `{PROJECT_ID}.analytics.mart_segment_performance`
ORDER BY industry
""")

selected_platforms = st.sidebar.multiselect(
    "Platform",
    platforms_df["platform"].tolist(),
    default=platforms_df["platform"].tolist()
)

selected_industries = st.sidebar.multiselect(
    "Industry",
    industries_df["industry"].tolist(),
    default=industries_df["industry"].tolist()
)

platform_filter = ",".join([f"'{x}'" for x in selected_platforms]) if selected_platforms else "''"
industry_filter = ",".join([f"'{x}'" for x in selected_industries]) if selected_industries else "''"

kpi_df = run_query(f"""
SELECT
  SUM(total_spend) AS total_spend,
  SUM(total_revenue) AS total_revenue,
  SUM(conversions) AS total_conversions,
  AVG(roas) AS avg_roas
FROM `{PROJECT_ID}.analytics.mart_segment_performance`
WHERE platform IN ({platform_filter})
  AND industry IN ({industry_filter})
""")

kpis = kpi_df.iloc[0]

c1, c2, c3, c4 = st.columns(4)
c1.metric("Total Spend", f"${kpis['total_spend']:,.0f}")
c2.metric("Total Revenue", f"${kpis['total_revenue']:,.0f}")
c3.metric("Total Conversions", f"{int(kpis['total_conversions']):,}")
c4.metric("Average ROAS", f"{kpis['avg_roas']:.2f}")

tab1, tab2, tab3, tab4 = st.tabs([
    "Feature Adoption",
    "Segment Performance",
    "Monthly Trends",
    "Sales Opportunities"
])

with tab1:
    adoption_df = run_query(f"""
    SELECT
      feature_name,
      AVG(adoption_rate) AS avg_adoption_rate
    FROM `{PROJECT_ID}.analytics.mart_feature_adoption`
    WHERE platform IN ({platform_filter})
      AND industry IN ({industry_filter})
    GROUP BY feature_name
    ORDER BY avg_adoption_rate DESC
    """)

    fig = px.bar(
        adoption_df,
        x="feature_name",
        y="avg_adoption_rate",
        title="Average Feature Adoption Rate"
    )
    st.plotly_chart(fig, use_container_width=True)
    st.dataframe(adoption_df, use_container_width=True)

with tab2:
    segment_df = run_query(f"""
    SELECT
      platform,
      industry,
      AVG(roas) AS avg_roas
    FROM `{PROJECT_ID}.analytics.mart_segment_performance`
    WHERE platform IN ({platform_filter})
      AND industry IN ({industry_filter})
    GROUP BY platform, industry
    """)

    heatmap = segment_df.pivot(index="industry", columns="platform", values="avg_roas").fillna(0)
    fig = px.imshow(
        heatmap,
        text_auto=True,
        aspect="auto",
        title="ROAS by Industry and Platform"
    )
    st.plotly_chart(fig, use_container_width=True)

    campaign_df = run_query(f"""
    SELECT
      campaign_type,
      SUM(total_revenue) AS total_revenue
    FROM `{PROJECT_ID}.analytics.mart_segment_performance`
    WHERE platform IN ({platform_filter})
      AND industry IN ({industry_filter})
    GROUP BY campaign_type
    ORDER BY total_revenue DESC
    """)

    fig2 = px.bar(
        campaign_df,
        x="campaign_type",
        y="total_revenue",
        title="Revenue Contribution by Campaign Type"
    )
    st.plotly_chart(fig2, use_container_width=True)

with tab3:
    trend_df = run_query(f"""
    SELECT
      year_month,
      SUM(total_spend) AS total_spend,
      SUM(total_revenue) AS total_revenue
    FROM `{PROJECT_ID}.analytics.mart_monthly_trends`
    WHERE platform IN ({platform_filter})
    GROUP BY year_month
    ORDER BY year_month
    """)

    fig = px.line(
        trend_df,
        x="year_month",
        y=["total_spend", "total_revenue"],
        title="Monthly Spend vs Revenue"
    )
    st.plotly_chart(fig, use_container_width=True)

with tab4:
    opp_df = run_query(f"""
    SELECT
      platform,
      industry,
      country,
      total_spend,
      total_revenue,
      roas,
      avg_feature_adoption_rate,
      recommendation_bucket
    FROM `{PROJECT_ID}.analytics.mart_sales_opportunities`
    WHERE platform IN ({platform_filter})
      AND industry IN ({industry_filter})
    ORDER BY total_revenue DESC
    LIMIT 25
    """)

    st.dataframe(opp_df, use_container_width=True)

    st.markdown("### Recommended interpretation")
    st.markdown("""
- **High-value, low-adoption** segments suggest advertiser groups with strong spend but underutilization of advanced campaign capabilities.
- **Scale opportunity** segments combine strong efficiency with healthy adoption and are good candidates for budget expansion.
- **Monitor** segments are steady but do not currently stand out as top sales prioritization targets.
""")

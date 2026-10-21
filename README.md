# 🚕 Chicago Rideshare Operations Analysis

An analytics portfolio project using **Python, MySQL and Tableau** to explore **286,434 sampled rideshare records** from Chicago during **June–August 2026**.

The project combines API extraction, data cleaning, SQL analysis and an interactive dashboard to examine pickup patterns, fares, trip speeds and shared-trip authorization.

## 📊 Live Dashboard

[Explore the interactive Tableau dashboard](https://public.tableau.com/app/profile/ayesha.ansari2317/viz/chicagorideshareOperationsAnalysis/ChicagoRideshareOverview?publish=yes)


## 🎥 Dashboard Walkthrough

[▶ Watch the dashboard demonstration](chicago-rideshare-dashboard-demo.mp4)

The recording demonstrates month selection, hour-range adjustment, weekday filtering, chart updates and restoring the default view.

## 📌 Analysis Questions

- Which community areas have the most pickups in the sample?
- How does average trip speed vary by hour and weekday?
- How do fares differ across pickup areas?
- How does shared-trip authorization vary throughout the day?
- How do the metrics change when filters are applied?

## 📈 Key Metrics

| Metric | Result |
|---|---:|
| Sampled trips after cleaning | 286,434 |
| Average fare | $17.89 |
| Average trip speed | 21.71 mph |
| Shared-trip authorization rate | 3.24% |

These results describe the cleaned sample with all dashboard filters reset.

Average trip speed is calculated from trip distance and duration. Shared-trip authorization indicates permission to share a trip; it does not establish that passengers actually shared a vehicle.

## 🖥️ Dashboard Features

- KPI cards for sampled trips, average fare, average trip speed and shared-trip authorization
- Community-area map showing sampled pickup counts
- Top 10 pickup areas ranked by sampled trip count
- Average-speed heatmap by weekday and hour
- Hourly average-speed line chart
- Hourly shared-trip authorization line chart
- Month, pickup area, hour range and day type filters
- Tableau’s built-in **Revert** control to restore the saved default view

The map excludes pickups that cannot be matched to a community area. Overall metrics may therefore include records absent from the map.

## 🗂️ Data Sources

### Trip Data

[City of Chicago Data Portal — Transportation Network Providers: Trips (2025–)](https://data.cityofchicago.org/Transportation/Transportation-Network-Providers-Trips-2025-/6dvr-xwnh)

- **Period analyzed:** June–August 2026
- **Access method:** Socrata Open Data API
- **Fields used:** Trip timestamps, pickup and drop-off community areas, distance, duration, fare, tips, trip total and shared-trip flags

The dataset does not identify individual rideshare providers, so this project cannot compare specific companies.

### Geographic Data

Community-area boundaries from the **City of Chicago Data Portal** are matched to pickup community-area identifiers for the map.

## ⚖️ Sampling Method

The notebook queries hourly time blocks across the three-month period and retrieves a capped number of records from each block.

The cleaned dataset contains **286,434 records**.

This method provides temporal coverage, but it is **not a representative random sample**. Retrieving a similar number of records from each hour does not preserve the relative volumes of busy and quiet periods.

Therefore:

- Counts describe the extracted sample rather than total Chicago rideshare activity.
- Similar sample counts across hours reflect the extraction method, not equal demand.
- The data should not be used to estimate citywide demand, total revenue or market size.
- Geographic, fare, speed and authorization comparisons are exploratory and may be affected by selection bias.

## 🧹 Data Preparation

The Python workflow:

1. Retrieves trip records through the Socrata API.
2. Converts timestamps and numeric fields.
3. Removes duplicate trip identifiers.
4. Removes records with non-positive distance or duration and negative fares.
5. Handles missing pickup and drop-off area identifiers.
6. Derives hour, weekday, day type and trip speed.
7. Exports cleaned data for MySQL analysis and Tableau visualization.

CSV data files are excluded from version control.

## 🔍 Selected Findings

### Pickup Concentration in the Sample

Near North Side has **37,160 sampled pickups**, followed by the Loop with **20,171** and Near West Side with **19,448**.

These rankings describe the sample. Representative trip-volume data would be needed before making driver-allocation decisions.

### Variation in Trip Speed

Average sampled trip speed peaks at approximately **32 mph around 5 AM** and falls to approximately **15 mph in the late afternoon**.

This suggests a useful period for further investigation. Route mix, trip distance and sampling can also affect average speeds, so the analysis does not isolate congestion as the cause.

### Fare Differences Across Areas

Sampled O’Hare pickups have an average fare of approximately **$36.51**, compared with **$17.08** for Near North Side.

Further analysis of distance, duration and fare composition would help explain this difference. Higher fares alone do not establish greater profitability or unmet demand.

### Shared-Trip Authorization

Approximately **3.24%** of sampled trips were authorized to be shared.

Actual pooling outcomes must be analyzed separately before drawing conclusions about shared-ride adoption or sustainability benefits.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Python and Pandas | API extraction, cleaning and feature engineering |
| MySQL and SQL | Data storage, aggregation and analytical queries |
| Tableau Public | Interactive charts, filters and geographic visualization |
| Jupyter Notebook / Google Colab | Analysis workflow |
| Git and GitHub | Version control and documentation |

## 📁 Repository Contents

| File | Purpose |
|---|---|
| `chicago_rideshare_analytics.ipynb` | Data extraction, cleaning and feature engineering |
| `queries.sql` | SQL analysis |
| `requirements.txt` | Python dependencies |
| `dashboard-overview.png` | Dashboard preview |
| `chicago-rideshare-dashboard-demo.mp4` | Dashboard filter demonstration |
| `LICENSE` | Project code license |

## ▶️ How to Reproduce

1. Clone the repository:

   ```bash
   git clone https://github.com/Ayesha-Ansa/chicago-rideshare-analytics.git
   cd chicago-rideshare-analytics
   ```

2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Open `chicago_rideshare_analytics.ipynb` in Jupyter or Google Colab and run the cells in order.

4. Import the exported cleaned CSV into MySQL using the table name and column types required by `queries.sql`.

5. Run `queries.sql` to reproduce the analytical summaries.

6. Connect Tableau to the cleaned trip data and community-area boundaries to rebuild the dashboard, or explore the published dashboard linked above.

The public source may change over time. Rerunning the extraction can produce different results.

## ⚠️ Limitations

- Hourly capped sampling limits conclusions about citywide demand and trip volumes.
- Public records may contain missing values or reporting errors.
- Missing geographic identifiers limit map coverage.
- Trip speed is derived from distance and duration; it is not a direct road-traffic measurement.
- Shared-trip authorization does not confirm completed pooling.
- Fare and trip-total fields do not measure operator profit or driver take-home earnings.
- Observed associations do not establish causal relationships.

## 🔮 Potential Improvements

- Use a documented probability sample or complete extract for demand analysis.
- Compare fares and speeds within distance and duration segments.
- Analyze actual shared-trip outcomes separately from authorization.
- Add automated data-quality checks and preserve extraction metadata.
- Validate operational recommendations with additional data.

## 👩‍💻 Author

**Ayesha Ansari**

[GitHub](https://github.com/Ayesha-Ansa) · [LinkedIn](https://www.linkedin.com/in/ayesha-ansari-285a93209/)

## 📄 License

Project code is licensed under the **MIT License**. The underlying data remains subject to the City of Chicago Data Portal’s applicable terms.

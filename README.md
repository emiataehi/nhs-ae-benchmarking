# NHS A&E Performance Benchmarking: England vs Scotland (2019-2026)

An end-to-end data analysis project investigating 4-hour A&E performance across England and Scotland over seven years. Built to demonstrate business-led analytical thinking using Python, SQL, and Power BI.

---

## Business Questions

Each question is looked at through two lenses: what it means for patients and what it means for NHS planners and commissioners.

1. How has 4-hour A&E performance changed over time in England and Scotland?
2. How do England and Scotland compare on a fair, population-adjusted basis?
3. What drives regional performance differences within England?
4. What does the performance trajectory suggest about where both systems are heading?

---

## Key Findings

**Both countries declined, but at different rates and times**

England fell 13 percentage points over the period. Scotland fell 24 percentage points. The worst months were not during COVID but during post-COVID recovery. Scotland bottomed out in December 2022, England in December 2023, a full year apart. By April 2026 both countries had converged around 64%, well below the 95% national target.

Patient lens: A patient's chance of being seen within 4 hours is significantly worse today than in 2019, regardless of which country they live in.

Organisational lens: The timing gap between Scotland and England's worst months suggests the two systems faced different recovery pressures. A single UK-wide policy response would miss this.

**England has higher breach rates per capita**

On a population-adjusted basis, England recorded 14% more attendances per 100,000 and 39% more breaches per 100,000 than Scotland across the full period. The 12-hour wait comparison was excluded from the headline analysis because England and Scotland measure from different starting points, making direct comparison misleading.

Patient lens: A patient in England faces a statistically higher risk of breaching the 4-hour target than a patient in Scotland.

Organisational lens: The breach rate gap cannot be explained by population size alone. Structural differences between the two systems need further investigation.

**The 95% target has never been met in England across the entire dataset**

Not once across 85 months did England's national average reach the official 95% standard. Regional inequality peaked at around 14 percentage points between best and worst performing regions in 2021-2022, narrowing to 6.3 points by 2025.

Patient lens: Where a patient lives in England determines their A&E experience. The gap between best and worst regions is a real inequality in access to timely care.

Organisational lens: National averages hide a 50+ percentage point spread between individual trusts. Blanket national interventions are unlikely to be efficient. Targeted support for the lowest-performing trusts would deliver better value for money.

**Volume does not fully explain regional performance differences**

The North West is England's worst-performing region but not its busiest. The Midlands has the highest volume and poor performance, where volume partly explains the result. The North West's poor performance is not explained by demand, which points to operational or structural factors specific to that region.

Patient lens: Being in a busy region does not automatically mean poor care.

Organisational lens: Capacity investment alone will not fix the North West. A more targeted investigation into staffing, patient flow, and bed availability would be a better starting point.

**Seasonal patterns are consistent and predictable**

Both countries follow the same seasonal pattern every year. Performance drops from October through January and recovers into spring. January is consistently the worst month. This pattern held across the full 2019-2026 dataset.

---

## Missing Data Finding

During SQL analysis, 14 major England trusts were found missing performance data for an identical consecutive 49-month period (May 2019 to May 2023). This was identified as a systemic issue, likely trust mergers and reporting restructures, rather than random data loss. The gap is documented and accounted for in trust-level analysis.

---

## Technical Stack

| Phase | Tool | Purpose |
|---|---|---|
| Data Engineering | Python, pandas, openpyxl, xlrd | Cleaned 86 NHS England Excel files across 4 formats; pulled Scotland data via PHS API; merged with ONS population estimates |
| Analysis | Python, statsmodels, matplotlib | Answered all 4 business questions; produced SARIMA forecasts; generated charts and narratives |
| Database | PostgreSQL 18, pgAdmin | Loaded 4 analytical tables; wrote SQL queries covering trends, benchmarking, regional drivers, and seasonal validation |
| Dashboard | Power BI Desktop | Built a 4-page interactive dashboard connected live to PostgreSQL |
| Version Control | Git, GitHub | Full project history and portfolio hosting |

---

## Data Sources

- NHS England: Monthly A&E Sitrep files, April 2019 to May 2026 (86 files)
- Public Health Scotland: Monthly A&E performance data via API
- ONS: Mid-year population estimates and 2022-based population projections

---

## Project Structure

```
nhs-ae-benchmarking/
|
|-- data/
|   |-- raw/
|   |   |-- england/          # 86 source Excel files in 4 era folders
|   |   |-- scotland/         # PHS API snapshot
|   |   `-- ons/              # Population estimates
|   `-- processed/            # Cleaned CSVs ready for analysis
|
|-- notebooks/                # Jupyter notebooks (Phase 1 and 2)
|
|-- sql/                      # SQL query files (Phase 3)
|   |-- 01_trend_analysis.sql
|   |-- 02_trust_level_deep_dive.sql
|   `-- 03_country_benchmarking.sql
|
|-- outputs/                  # Charts, summaries, narratives
|
|-- dashboard/                # Power BI .pbix file
|
`-- README.md
```

---

## How to Reproduce

1. Clone the repository
2. Install dependencies: `pip install pandas openpyxl xlrd statsmodels matplotlib`
3. Run the Jupyter notebooks in order (Phase 1 then Phase 2)
4. Set up PostgreSQL, create the database `nhs_project`, and load the processed CSVs
5. Open the SQL files in pgAdmin or VS Code with SQLTools
6. Open the Power BI file and update the PostgreSQL connection to your local server

---

## About

Built by Emi Igein. 
GitHub: https://github.com/emiataehi

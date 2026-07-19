CREATE TABLE region_month_view (
    country TEXT,
    trust_region TEXT,
    period DATE,
    year INTEGER,
    population BIGINT,
    attendances_type1 NUMERIC,
    breaches_4hr_type1 NUMERIC,
    waits_12hr NUMERIC,
    pct_4hr_type1 NUMERIC,
    attendances_per_100k_national NUMERIC,
    breaches_4hr_per_100k_national NUMERIC,
    waits_12hr_per_100k_national NUMERIC
);

COPY region_month_view
FROM 'C:\Users\Administrator\Desktop\nhs_project\nhs-ae-benchmarking\data\processed\region_month_view.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM region_month_view;

CREATE TABLE population_lookup (
    country TEXT,
    year INTEGER,
    population BIGINT
);

COPY population_lookup
FROM 'C:\Users\Administrator\Desktop\nhs_project\nhs-ae-benchmarking\data\processed\population_lookup_2011_to_2026.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM population_lookup;

SELECT 'region_month_view' AS table_name, COUNT(*) FROM region_month_view
UNION ALL
SELECT 'population_lookup', COUNT(*) FROM population_lookup;

CREATE TABLE england_trust_month (
    trust_code TEXT,
    trust_region TEXT,
    trust_name TEXT,
    attendances_type1 NUMERIC,
    breaches_4hr_type1 NUMERIC,
    pct_4hr_type1 NUMERIC,
    waits_12hr NUMERIC,
    admissions_type1 NUMERIC,
    total_admissions NUMERIC,
    period DATE
);

COPY england_trust_month
FROM 'C:\Users\Administrator\Desktop\nhs_project\nhs-ae-benchmarking\data\processed\england_ae_2019_to_2026.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM england_trust_month;



SELECT 
    cmv.country,
    cmv.year,
    cmv.attendances_type1,
	cmv.
    pl.population
FROM country_month_view cmv
JOIN population_lookup pl 
    ON cmv.country = pl.country AND cmv.year = pl.year
ORDER BY cmv.country, cmv.year;

SELECT 
	etm.trust_name,
    etm.period,
    etm.pct_4hr_type1 *100 AS wolverhampton_pct,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN country_month_view cmv 
    ON etm.period = cmv.period AND cmv.country = 'England'
WHERE etm.trust_name = 'The Royal Wolverhampton NHS Trust'
ORDER BY wolverhampton_pct DESC;

SELECT 
	etm.trust_name,
    etm.period,
    etm.pct_4hr_type1 *100 AS wolverhampton_pct,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN country_month_view cmv 
    ON etm.period = cmv.period AND cmv.country = 'England'
WHERE etm.trust_name = 'The Royal Wolverhampton NHS Trust' AND etm.pct_4hr_type1 *100 < cmv.pct_4hr_type1
ORDER BY wolverhampton_pct DESC;


SELECT DISTINCT ON (etm.period)
    etm.period,
    etm.trust_name,
    etm.pct_4hr_type1 * 100 AS trust_pct,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN country_month_view cmv 
    ON etm.period = cmv.period AND cmv.country = 'England'
ORDER BY etm.period, etm.pct_4hr_type1 ASC;

SELECT
    etm.period,
    etm.pct_4hr_type1 * 100 AS bhr_pct,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN country_month_view cmv
    ON etm.period = cmv.period AND cmv.country = 'England'
WHERE etm.trust_name = 'Barking, Havering And Redbridge University Hospitals NHS Trust'
ORDER BY etm.period;

SELECT DISTINCT ON (etm.period)
    etm.period,
    etm.trust_name,
    etm.pct_4hr_type1 * 100 AS trust_pct,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN country_month_view cmv 
    ON etm.period = cmv.period AND cmv.country = 'England'
ORDER BY etm.period, etm.pct_4hr_type1 DESC;

SELECT COUNT(*) AS total_rows,
       COUNT(pct_4hr_type1) AS non_null_rows,
       COUNT(*) - COUNT(pct_4hr_type1) AS null_rows
FROM england_trust_month;

SELECT 
    trust_name,
    COUNT(*) AS missing_months
FROM england_trust_month
WHERE pct_4hr_type1 IS NULL
GROUP BY trust_name
ORDER BY missing_months DESC
LIMIT 15;

SELECT 
    period,
    COUNT(*) AS missing_count
FROM england_trust_month
WHERE pct_4hr_type1 IS NULL
GROUP BY period
ORDER BY period;

SELECT DISTINCT ON (etm.period)
    etm.period,
    etm.trust_name,
    etm.pct_4hr_type1 * 100 AS trust_pct,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN country_month_view cmv 
    ON etm.period = cmv.period AND cmv.country = 'England'
WHERE etm.period >= '2023-06-01'
ORDER BY etm.period, etm.pct_4hr_type1 DESC;

SELECT DISTINCT trust_region
FROM england_trust_month 
ORDER BY trust_region;

SELECT 
    trust_region,
    COUNT(DISTINCT trust_name) AS number_of_trusts
FROM england_trust_month
GROUP BY trust_region
ORDER BY trust_region;

SELECT
    etm.period,
    etm.pct_4hr_type1 * 100 AS wolverhampton_pct,
    rmv.pct_4hr_type1 AS midlands_regional_avg,
    cmv.pct_4hr_type1 AS england_national_avg
FROM england_trust_month etm
JOIN region_month_view rmv
    ON etm.period = rmv.period AND rmv.trust_region = 'NHS England Midlands '
JOIN country_month_view cmv
    ON etm.period = cmv.period AND cmv.country = 'England'
WHERE etm.trust_name = 'The Royal Wolverhampton NHS Trust'
ORDER BY etm.period;

SELECT trust_name, rank, trust_pct
FROM (
    SELECT
        trust_name,
        pct_4hr_type1 * 100 AS trust_pct,
        RANK() OVER (ORDER BY pct_4hr_type1 DESC) AS rank
    FROM england_trust_month
    WHERE period = '2026-04-01' AND pct_4hr_type1 IS NOT NULL
) ranked_trusts
WHERE trust_name = 'The Royal Wolverhampton NHS Trust';

SELECT COUNT(*) 
FROM england_trust_month 
WHERE period = '2026-04-01' AND pct_4hr_type1 IS NOT NULL;



SELECT 
	trust_region,
	trust_name,
	pct_4hr_type1 * 100 AS trust_pct,
	period
FROM england_trust_month 
WHERE pct_4hr_type1 * 100 >= 95 AND EXTRACT(YEAR FROM period) <> 2020
ORDER BY pct_4hr_type1 * 100 DESC;


SELECT 
	period, 
	pct_4hr_type1
FROM country_month_view
WHERE country = 'England' AND pct_4hr_type1 >= 95;


SELECT
    trust_region,
    EXTRACT(YEAR FROM period) AS year,
    AVG(pct_4hr_type1) AS avg_pct
FROM region_month_view
WHERE country = 'England'
GROUP BY trust_region, EXTRACT(YEAR FROM period)
ORDER BY year, avg_pct DESC;


SELECT
    year,
    MAX(avg_pct) AS best_region_pct,
    MIN(avg_pct) AS worst_region_pct,
    MAX(avg_pct) - MIN(avg_pct) AS gap
FROM (
    SELECT
        trust_region,
        EXTRACT(YEAR FROM period) AS year,
        AVG(pct_4hr_type1) AS avg_pct
    FROM region_month_view
    WHERE country = 'England'
    GROUP BY trust_region, EXTRACT(YEAR FROM period)
) yearly_region_avg
GROUP BY year
ORDER BY year;

SELECT DISTINCT ON (year)
    year,
    trust_region AS best_region,
    avg_pct AS best_pct
FROM (
    SELECT
        trust_region,
        EXTRACT(YEAR FROM period) AS year,
        AVG(pct_4hr_type1) AS avg_pct
    FROM region_month_view
    WHERE country = 'England'
    GROUP BY trust_region, EXTRACT(YEAR FROM period)
) yearly_region_avg
ORDER BY year, avg_pct DESC;

SELECT DISTINCT ON (year)
    year,
    trust_region AS best_region,
    avg_pct AS best_pct
FROM (
    SELECT
        trust_region,
        EXTRACT(YEAR FROM period) AS year,
        AVG(pct_4hr_type1) AS avg_pct
    FROM region_month_view
    WHERE country = 'England'
    GROUP BY trust_region, EXTRACT(YEAR FROM period)
) yearly_region_avg
ORDER BY year, avg_pct ASC;

SELECT
    trust_name,
    AVG(pct_4hr_type1) * 100 AS avg_pct,
    STDDEV(pct_4hr_type1) * 100 AS volatility
FROM england_trust_month
WHERE pct_4hr_type1 IS NOT NULL
GROUP BY trust_name
ORDER BY volatility DESC
LIMIT 15;

SELECT
    trust_name,
    COUNT(*) AS months_reported,
    AVG(pct_4hr_type1) * 100 AS avg_pct,
    STDDEV(pct_4hr_type1) * 100 AS volatility
FROM england_trust_month
WHERE pct_4hr_type1 IS NOT NULL
GROUP BY trust_name
HAVING COUNT(*) >= 30
ORDER BY volatility DESC
LIMIT 15;

SELECT
    trust_name,
    COUNT(*) AS months_reported,
    AVG(pct_4hr_type1) * 100 AS avg_pct,
    STDDEV(pct_4hr_type1) * 100 AS volatility
FROM england_trust_month
WHERE pct_4hr_type1 IS NOT NULL AND trust_name = 'The Royal Wolverhampton NHS Trust'
GROUP BY trust_name;

k.SELECT
    trust_region,
    AVG(attendances_type1) AS avg_monthly_attendances,
    AVG(pct_4hr_type1) AS avg_performance
FROM region_month_view
WHERE country = 'England'
GROUP BY trust_region
ORDER BY avg_monthly_attendances DESC;


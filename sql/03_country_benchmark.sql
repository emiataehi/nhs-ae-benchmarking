SELECT
    country,
    SUM(attendances_type1)                              AS total_attendances,
    SUM(breaches_4hr_type1)                             AS total_breaches,
    ROUND(AVG(population)::numeric, 0)                  AS avg_population,
    ROUND(
        (SUM(attendances_type1) / AVG(population)) * 100000
    , 1)                                                AS attendances_per_100k,
    ROUND(
        (SUM(breaches_4hr_type1) / AVG(population)) * 100000
    , 1)                                                AS breaches_per_100k
FROM country_month_view
GROUP BY country
ORDER BY country;

SELECT
    trust_region,
    ROUND(AVG(pct_4hr_type1)::numeric, 1)AS avg_performance,
    ROUND(SUM(attendances_type1)::numeric, 0)AS total_attendances,
    ROUND(AVG(attendances_type1)::numeric, 0)AS avg_monthly_attendances
FROM region_month_view
WHERE country = 'England'
GROUP BY trust_region
ORDER BY avg_performance ASC;

SELECT
    country,
    period,
    ROUND(pct_4hr_type1::numeric, 1)AS pct_4hr
FROM country_month_view
WHERE period >= '2025-05-01'
ORDER BY country, period ASC;








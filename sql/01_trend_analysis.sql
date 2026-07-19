SELECT *
FROM country_month_view;

SELECT 
	country,
	period,
	pct_4hr_type1
FROM country_month_view
ORDER BY period;

SELECT 
    country,
    period,
    pct_4hr_type1
FROM country_month_view
ORDER BY country, period;

SELECT 
    country,
    period,
    pct_4hr_type1
FROM country_month_view
WHERE pct_4hr_type1 <= 70
ORDER BY pct_4hr_type1 ASC;

SELECT 
    country,
    period,
    pct_4hr_type1
FROM country_month_view
ORDER BY pct_4hr_type1 ASC;

SELECT 
    country,
    period,
    pct_4hr_type1
FROM country_month_view
WHERE pct_4hr_type1 <= 59 AND country = 'England'
ORDER BY pct_4hr_type1 ASC;

SELECT 
    country,
    period,
    pct_4hr_type1
FROM country_month_view
WHERE country = 'England'
  AND pct_4hr_type1 <= (
      SELECT MIN(pct_4hr_type1) 
      FROM country_month_view 
      WHERE country = 'Scotland'
  )
ORDER BY pct_4hr_type1 ASC;

SELECT 
    country,
    period,
    pct_4hr_type1,
    (SELECT MIN(pct_4hr_type1) FROM country_month_view WHERE country = 'Scotland') AS scotland_worst
FROM country_month_view
WHERE country = 'England';


SELECT 
    country,
    period,
    pct_4hr_type1
FROM country_month_view
WHERE country = 'England' AND pct_4hr_type1 < (SELECT AVG(pct_4hr_type1) FROM country_month_view WHERE country = 'England' )
ORDER BY pct_4hr_type1 ASC;


SELECT 
    country,
    period,
    pct_4hr_type1,
	(SELECT AVG(pct_4hr_type1) FROM country_month_view WHERE country = 'England' )AS England_avg
FROM country_month_view
WHERE country = 'Scotland'
ORDER BY  pct_4hr_type1;

SELECT 
    country,
    period,
    pct_4hr_type1,
FROM country_month_view
WHERE country = 'Scotland' AND pct_4hr_type1<(SELECT AVG(pct_4hr_type1) FROM country_month_view WHERE country = 'England' )
ORDER BY  pct_4hr_type1;


SELECT
	country,
	 period,
    pct_4hr_type1,
	(SELECT AVG(pct_4hr_type1) FROM country_month_view WHERE country = 'Scotland') AS Scoutland_avg
FROM country_month_view
WHERE country = 'England' AND pct_4hr_type1 < (SELECT AVG(pct_4hr_type1) FROM country_month_view WHERE country = 'Scotland')
ORDER BY pct_4hr_type1 ASC;
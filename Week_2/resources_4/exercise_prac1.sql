SELECT * FROM ev_sales_db.electric_vehicle_sales_by_state;

-- Q4 USE BUILT IN ROUND FUNCTION FIRST THEN CHECK REST 
SELECT ROUND((total_evs_sold * 100)/total_vehicles_sold,2) as penetration_rate
FROM(
SELECT SUM(electric_vehicles_sold) as total_evs_sold,
SUM(total_vehicles_sold) as total_vehicles_sold
FROM electric_vehicle_sales_by_state evs
JOIN dim_date dd
ON evs.date=dd.date
where state='Karnataka' and dd.fiscal_year=2024
) as Subquery;

-- Q5
SELECT state FROM 
(
SELECT state, total_vehicles_sold as total_evs_sold, dd.date, fiscal_year
FROM electric_vehicle_sales_by_state evs
JOIN dim_date dd
ON dd.date=evs.date
WHERE dd.fiscal_year=2023
) AS SUBQUERY
WHERE total_evs_sold=(
SELECT MIN(total_vehicles_sold)
FROM electric_vehicle_sales_by_state evs
JOIN dim_date dd
ON dd.date=evs.date
WHERE dd.fiscal_year=2023
);

-- Q6
SELECT MAX(total_sales), months
FROM(
SELECT group_concat(vehicle_category), 
SUM(electric_vehicles_sold) as total_sales,
EXTRACT(MONTH FROM dd.date) as months
FROM electric_vehicle_sales_by_makers evs
JOIN dim_date dd
ON dd.date=evs.date
where dd.fiscal_year in (2022,2023,2024)
GROUP BY dd.date
ORDER BY total_sales DESC
) AS subquery
WHERE total_sales=MAX(total_sales);

-- Q6 answer
SELECT group_concat(vehicle_category), SUM(electric_vehicles_sold) as total_sales,
EXTRACT(MONTH FROM dd.date) as months
FROM electric_vehicle_sales_by_makers evs
JOIN dim_date dd
ON dd.date=evs.date
where dd.fiscal_year in (2022,2023,2024)
GROUP BY dd.date
ORDER BY total_sales DESC;

-- Q7
SELECT * FROM
electric_vehicle_sales_by_makers evs
JOIN dim_date dd
ON evs.date=dd.date
WHERE dd.fiscal_year BETWEEN 2022 AND 2024 and maker="BAJAJ";

SELECT yearly_sales AS finalsales
FROM (
    SELECT SUM(electric_vehicles_sold) AS yearly_sales, dd.fiscal_year
    FROM electric_vehicle_sales_by_makers evs
    JOIN dim_date dd
    ON evs.date = dd.date
    WHERE dd.fiscal_year BETWEEN 2022 AND 2024 AND maker = "BAJAJ"
    GROUP BY dd.fiscal_year
    ORDER BY dd.fiscal_year ASC
) AS SUBQUERY;
-- 2022 TO 2024 IS a two year period

SELECT 
    ROUND(
        (POW((MAX(yearly_sales) * 1.0 / MIN(yearly_sales)), 1.0 / (MAX(fiscal_year) - MIN(fiscal_year))) - 1) * 100,
        2
    ) AS cagr_percentage
FROM (
    SELECT SUM(electric_vehicles_sold) AS yearly_sales, dd.fiscal_year
    FROM electric_vehicle_sales_by_makers evs
    JOIN dim_date dd
    ON evs.date = dd.date
    WHERE dd.fiscal_year BETWEEN 2022 AND 2024 AND maker = "BAJAJ"
    GROUP BY dd.fiscal_year
) AS subquery;

-- Q8
SELECT (SUM(evs_sold) * 100/SUM(tvs_sold)) as penetration_rate
FROM(
SELECT state, electric_vehicles_sold as evs_sold, 
total_vehicles_sold as tvs_sold FROM 
electric_vehicle_sales_by_state evs
JOIN dim_date dd
ON dd.date=evs.date
WHERE state="Chandigarh" and dd.fiscal_year=2024
) AS subquery;

SELECT 
    ROUND((SUM(evs_sold) * 100 / SUM(tvs_sold)), 2) AS penetration_rate
FROM (
    SELECT state, electric_vehicles_sold AS evs_sold, 
           total_vehicles_sold AS tvs_sold 
    FROM electric_vehicle_sales_by_state
    WHERE LOWER(state) = "chandigarh" AND total_vehicles_sold > 0
) AS subquery;

SELECT 
    	evs.state,
    	SUM(evs.electric_vehicles_sold) AS total_ev_sales,
    	SUM(evs.total_vehicles_sold) AS total_vehicles_sold,
    	SUM(evs.electric_vehicles_sold) / SUM(evs.total_vehicles_sold) * 100 AS penetration_rate,
   	 CASE WHEN (SUM(evs.electric_vehicles_sold) / SUM(evs.total_vehicles_sold)) * 100 > 7 THEN "Above 7%"
WHEN (SUM(evs.electric_vehicles_sold) / SUM(evs.total_vehicles_sold)) * 100 > 5 THEN 'Above 5%'
WHEN (SUM(evs.electric_vehicles_sold) / SUM(evs.total_vehicles_sold)) * 100 > 3 THEN 'Above 3%'
WHEN (SUM(evs.electric_vehicles_sold) / SUM(evs.total_vehicles_sold)) * 100 > 1 THEN 'Above 1%'
        	ELSE 'Below 1%'
    	END AS penetration_category
FROM ev_sales_db.electric_vehicle_sales_by_state evs
JOIN ev_sales_db.dim_date dd ON evs.date = dd.date
WHERE dd.fiscal_year = 2024
GROUP BY evs.state;

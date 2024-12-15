SELECT * FROM ev_sales_db.electric_vehicle_sales_by_makers;

-- Q1
SELECT COUNT(distinct maker) as unique_makers
from electric_vehicle_sales_by_makers
where vehicle_category="2-Wheelers";

-- Q2
SELECT SUM(electric_vehicles_sold) as total_sales
FROM electric_vehicle_sales_by_makers evm
JOIN dim_date dd
ON evm.date=dd.date
WHERE evm.maker='TVS' and dd.fiscal_year in (2023,2024);


-- Q3
SELECT AVG(electric_vehicles_sold) as avg_total_sales
FROM electric_vehicle_sales_by_makers evm
JOIN dim_date dd
ON evm.date=dd.date
WHERE dd.fiscal_year=2024;

-- (SUM(electric_vehicles_sold))/12 as avg_total_sales
-- INTERMEDIATE results
SELECT evm.date,GROUP_CONCAT(vehicle_category), sum(electric_vehicles_sold)
FROM electric_vehicle_sales_by_makers evm
JOIN dim_date dd
ON evm.date=dd.date
WHERE dd.fiscal_year=2024
GROUP BY evm.date;

SELECT avg(SUM(electric_vehicles_sold))
FROM electric_vehicle_sales_by_makers evm
JOIN dim_date dd
ON evm.date=dd.date
WHERE dd.fiscal_year=2024
GROUP BY evm.date;

-- USING SUBQUERY
SELECT AVG(total_sold)
FROM(
SELECT SUM(electric_vehicles_sold) AS total_sold
    FROM electric_vehicle_sales_by_makers evm
    JOIN dim_date dd
    ON evm.date = dd.date
    WHERE dd.fiscal_year = 2024
    GROUP BY evm.date
) as subquery;

SELECT round(AVG(total_vehicle_sales), 0) AS avg_total_sales_per_month
FROM (SELECT EXTRACT(MONTH FROM dd.date) AS months, 
SUM(evs.total_vehicles_sold) AS total_vehicle_sales
    	FROM ev_sales_db.electric_vehicle_sales_by_state evs
   	 JOIN ev_sales_db.dim_date dd ON evs.date = dd.date
    	WHERE dd.fiscal_year = 2024
    	GROUP BY months
) AS monthly_sales;

SELECT EXTRACT(MONTH FROM dd.date) AS months, 
SUM(evs.total_vehicles_sold) AS total_vehicle_sales
    	FROM ev_sales_db.electric_vehicle_sales_by_state evs
   	 JOIN ev_sales_db.dim_date dd ON evs.date = dd.date
    	WHERE dd.fiscal_year = 2024
    	GROUP BY months;
        
-- Q4

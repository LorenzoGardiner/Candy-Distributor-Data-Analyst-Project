-- Check that the Python script imported the data into the tables
select * from "CandySales";
select * from "CandyProducts";

-- How many times is each shipping method used
create view shipping_mode_count as
select "Ship Mode", count(*) from "CandySales"
group by "Ship Mode";

--Changing order date and ship date columns to date type from text type
ALTER TABLE "CandySales"
ALTER COLUMN "Order Date" TYPE DATE USING "Order Date"::DATE,
ALTER COLUMN "Ship Date" TYPE DATE USING "Ship Date"::DATE;

--The total sales per month for each candy type rounded to 2 decimals places
create view month_sales_division as
select round(sum("Sales")::numeric,2) as total_sales, round(sum("Gross Profit")::numeric,2) as profit,
round(sum("Cost")::numeric,2) as costs, year_mon, "Division" 
from (select date_trunc('month', "Order Date") as year_mon, * from "CandySales") as a
group by "Division", year_mon
order by "Division", year_mon;


--Candy sales and profit per state
create view candy_sales_per_state as
select round(sum("Sales")::numeric,2) as total_sales, round(sum("Gross Profit")::numeric,2) as profit,
round(sum("Units")::numeric,2) as Units,  "State/Province" from "CandySales"
group by "State/Province";

--Sales, profit, and cost per factory per month
create view factory_candy_sales as
select round(sum("Sales")::numeric,2) as total_sales, round(sum("Gross Profit")::numeric,2) as profit,
round(sum("Cost")::numeric,2) as costs, "Factory", date_trunc('month', "Order Date") as year_mon from (select "Product ID", "Factory" from "CandyProducts") as a 
join "CandySales" as b
on a."Product ID" = b."Product ID"
group by "Factory", year_mon
order by "Factory", year_mon;

--Finding the top 3 customers
create view top_customers as
select round(sum("Sales")::numeric,2) as total_sales, "Customer ID" from "CandySales"
group by "Customer ID"
order by total_sales desc
limit 3;

--Sales per candy per month
create view month_sales_candy as
select round(sum("Sales")::numeric,2) as total_sales, year_mon, "Product Name" as candy
from (select date_trunc('month', "Order Date") as year_mon, * from "CandySales") as a
group by year_mon, "Product Name"
order by year_mon, "Product Name";

--Regional sales
create view regional_sales as 
select sum("Units") as units, "Region", "Product Name" from "CandySales"
group by "Region", "Product Name"
order by "Region", units desc;

--Top 3 candies per region
create view top3_region as 
select * from (select dense_rank() over (partition by "Region" order by units desc) as rnk, * from regional_sales) as a
where rnk <=3


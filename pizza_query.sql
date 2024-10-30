Select * from pizza_sales


--KPI'S REQUIREMENT
--We need to analyze key indicators for our pizza sales data to gain insights into our business performance.
--Specifically,we want to calculate the following metrics:-

-- 1. Total Revenue
--The sum of the total price of all pizza orders.

Select Sum(total_price) As Total_Revenue From pizza_sales

--2.Average Order Value
-- The average amount spent per order,calculated by dividing the total revenue by the total number of orders
Select Sum(total_price) / count(Distinct order_id) As Avg_order_value From pizza_sales

--3. Total Pizzas Sold
--The sum of Quantity of all pizzas sold
Select sum(quantity) As Total_Pizza_Sold  From pizza_sales

--4. Total Orders
--The total number of Orders placed.
Select Count(Distinct order_id) As Total_Orders from pizza_sales

--5. Average Pizzas Per Order
-- The average number of pizzas sold per order,
-- calculated by dividing the total number of pizzas sold by the total number of orders.
Select Round((sum(quantity) /count(distinct order_id)),2) As Average_Pizzas_per_order from pizza_sales

--CHARTS REQUIREMENT
--We would like to visualize aspects of our pizza sales data to gain insights and understand key trends.
--We have identified the following requirements for creating charts:-

--1. Daily Trend for Total Orders.
--Create a bar chart that displays the daily trend of total orders over a specific time period.
--this chart will help us identify any patterns or fluctuations in order volumes on a daily basis.

Select DATENAME(DW , order_date) as order_day, 
Count(distinct order_id) as Total_Orders
From pizza_sales
Group By DATENAME(DW , order_date); 

--DW extracts the name of the day of the week (e.g., "Monday", "Tuesday", etc.) from the order_date.

--2. Monthly Trend for Total Orders.
--Create a line chart that illustrates the hourly trend of total orders throughout the day.
--This chart will allow us to identify peak hours or periods of high order activity.

Select DATENAME(MONTH, order_date) as Month_Name,
Count(distinct order_id) as Total_Orders
From pizza_sales
Group By DATENAME(MONTH, order_date)
Order By Total_Orders ASC;

--3. Percentage of Sales by Pizza Category.
--Create a pie chart that shows the distribution of sales across different pizza categories.
--This chart will provide insights into the popularity of various pizza categories and their contribution to overall sales.

Select pizza_category,Round(sum(total_price),3) AS Total_Sales, sum(total_price)* 100/
(Select sum(total_price)from pizza_sales Where MONTH(order_date) = 1
) As PCT_Sales
from pizza_sales
Where MONTH(order_date) = 1
Group By pizza_category

--4. Percentage of Sales by Pizza Size
-- Generate a pie chat that represents the percentage of sales attributed to different pizza sizes.
-- This chart will help us understand customer preference for pizza sizes and their impact on sales.

Select pizza_Size,CAST(sum(total_price) AS DECIMAL(10,2)) AS Total_Sales, Round(sum(total_price)* 100/
(Select sum(total_price)from pizza_sales Where DATEPART(quarter, order_date) =1
),2) As PCT_Sales
from pizza_sales
Where DATEPART(quarter, order_date) =1
Group By pizza_Size
order By PCT_Sales DESC


--5. Top 5 best sellers by revenue ,total quanity and total orders.
-- Create a bar chart highlighting the top 5 best selling pizzas based on the revenue,Total Quantity,Total Orders.
--This chart will help us identify the most popular pizza options.

select TOP 5 pizza_name, sum(total_price) As Total_Revenue 
, sum(quantity) As Total_quantity
,count(Distinct order_id) As Total_orders
from pizza_sales
Group by pizza_name
order by Total_Orders DESC

--6. Bottom 5 best sellers by revenue ,total quanity and total orders.
-- Create a bar chart showcasing the bottom 5 worst -selling pizzas based on the Revenue,Total Quantity,TotalOrders.
-- This chart will enable us to identify the least popular pizza options.

select TOP 5 pizza_name, sum(total_price) As Total_Revenue 
, sum(quantity) As Total_quantity
,count(Distinct order_id) As Total_orders
from pizza_sales
Group by pizza_name
order by Total_Orders ASC



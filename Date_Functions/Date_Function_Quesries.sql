Use practise_quest;
drop table if exists sales;
CREATE TABLE sales (
order_id INT PRIMARY KEY AUTO_INCREMENT,
product_id INT,
sale_date DATE,
amount DECIMAL(10, 2)
);
INSERT INTO sales (product_id, sale_date, amount) VALUES 
(1, '2022-01-05', 100.50), 
(2, '2022-01-15', 250.75), 
(3, '2022-02-01', 50.00), 
(1, '2022-02-10', 120.00), 
(2, '2022-03-05', 300.00), 
(3, '2022-03-25', 75.25), 
(1, '2022-04-10', 150.00), 
(2, '2022-04-20', 200.00), 
(3, '2022-05-05', 60.00), 
(1, '2022-06-12', 130.00), 
(2, '2022-06-25', 270.00),
(3, '2022-07-01', 80.00), 
(1, '2022-07-15', 160.00), 
(2, '2022-08-01', 320.00), 
(3, '2022-08-18', 90.00), 
(1, '2022-09-05', 110.00), 
(2, '2022-09-20', 280.00), 
(3, '2022-10-01', 100.00), 
(1, '2022-10-15', 170.00), 
(2, '2022-11-05', 290.00), 
(3, '2022-11-25', 115.00), 
(1, '2022-12-01', 180.00), 
(2, '2022-12-10', 350.00), 
(3, '2022-12-31', 130.00), 
(1, '2023-01-05', 190.00), 
(2, '2023-01-18', 360.00), 
(3, '2023-02-10', 140.00), 
(1, '2023-02-25', 200.00), 
(2, '2023-03-10', 370.00), 
(3, '2023-03-30', 150.00), 
(1, '2023-04-15', 210.00), 
(2, '2023-04-28', 380.00), 
(3, '2023-05-05', 160.00), 
(1, '2023-06-01', 220.00), 
(2, '2023-06-15', 390.00), 
(3, '2023-07-05', 170.00), 
(1, '2023-07-20', 230.00),
(2, '2023-08-01', 400.00), 
(3, '2023-08-15', 180.00), 
(1, '2023-09-01', 240.00), 
(2, '2023-09-18', 410.00), 
(3, '2023-10-05', 190.00), 
(1, '2023-10-25', 250.00), 
(2, '2023-11-10', 420.00), 
(3, '2023-11-20', 200.00), 
(1, '2023-12-01', 260.00), 
(2, '2023-12-15', 430.00), 
(3, '2023-12-29', 210.00); 

-- 1. Calculate the total sales for each month of the year 2023.

Select DATE_FORMAT(sale_date, '%Y-%m') AS sale_month, 
sum(amount) as total_sales from sales 
where year(sale_date) = 2023
group by sale_month
order by sale_month;

-- 2. Find the number of days between the first and last order.
SELECT datediff(max(sale_date), min(sale_date)) as days_between_first_last_order from sales;

-- 3. What were the sales for the last 90 days from the latest order date?
SELECT SUM(amount) AS sales_in_last_90_days FROM sales 
WHERE sale_date >= DATE_SUB((SELECT MAX(sale_date) FROM sales), INTERVAL 90 DAY);

-- 4. Compare the total sales of the year 2023 with the year 2022. 
SELECT sum(case when year(sale_date) =2023 then amount else 0 end) as 2023_sales,
sum(case when year(sale_date) =2022 then amount else 0 end) as 2022_sales
from sales
where year(sale_date) in (2023,2022);

-- 5. Calculate the 6-month moving average of sales for each month in 2023.
SELECT date_format(sale_date,"%Y-%m")as sale_month,
AVG(sum(amount)) OVER(order by date_format(sale_date,"%Y-%m") rows between 5  PRECEDING AND CURRENT ROW) as moving_average_sales 
from sales
where year(sale_date)=2023
group by sale_month
order by sale_month;

-- 6. Find the year-over-year sales growth percentage.
With yearly_sales as
(
SELECT year(sale_date) as sale_year,
		sum(amount) as total_sales
FROM sales
group by sale_year
)
SELECT c.sale_year, c.total_sales as current_year_sale, p.total_sales as previous_year_sale,
		((c.total_sales-p.total_sales)/p.total_sales)*100 as sale_growth_percentage
FROM yearly_sales as c
Inner Join yearly_sales as p ON c.sale_year = p.sale_year+1
ORDER BY c.sale_year


-- 7. List all sales that occurred on a weekend (Saturday or Sunday).
SELECT order_id, product_id,sale_date, amount from sales
where dayofweek(sale_date) in (1,7);

-- 8. Calculate the cumulative sales total for each day in 2023.
SELECT sale_date, SUM(amount), SUM(SUM(amount)) over(ORDER BY sale_date) as cumulative_sale from sales
where sale_date between '2023-01-01' AND '2023-12-31'
group by sale_date;

-- 9. Find the product that had the highest sales in each quarter of 2022. 
With quarterly_product_sales as 
(SELECT product_id, quarter(sale_date) as sale_quarter, sum(amount) as total_sales
FROM sales
WHERE sale_date Between '2022-01-01' AND '2022-12-31'
GROUP BY product_id, sale_quarter),
ranked_product as
(SELECT *, rank() OVER(partition by sale_quarter order by total_sales desc) as rn
from quarterly_product_sales)
SELECT product_id, sale_quarter, total_sales from ranked_product
where rn =1;

-- 10. Determine the number of days since the last sale for each product.
SELECT product_id, max(sale_date) as last_sale_date, datediff((SELECT Max(sale_date) from sales), max(sale_date)) from sales
group by product_id
order by product_id

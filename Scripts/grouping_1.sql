
-- employee, customer, model, inventory, sales


--schema
SELECT sql FROM sqlite_master WHERE type='table' AND name='sales';

-- find the least and most exepensive car sold by each employee
select * from sales where strftime('%Y',soldDate)='2023';
select * from employee limit 5;

select e.employeeId,e.firstName,e.lastName,
min(s.salesAmount) as min_saleamount,
max(s.salesAmount) as max_saleamount
from employee e join sales s 
on e.employeeId=s.employeeId
group by e.employeeId,e.firstName,e.lastName;

-- display employees who have sold more than 5 cars
select e.employeeId, e.firstName, e.lastName, count(*) as total_sales 
from employee e join sales s 
on e.employeeId=s.employeeId 
where s.soldDate>= date('now', 'start of year')
group by e.employeeId, e.firstName, e.lastName
having count(s.employeeId) > 5;

-- summarize sales per year
with cte as (
SELECT strftime('%Y', soldDate) as year, salesAmount
from sales )
select year, sum(salesAmount) as total_sales
from cte
group by year;
--way 2
SELECT strftime('%Y', soldDate) as year, format('$%.2f',sum(salesAmount)) as total_saleamount
from sales 
group by year;


---display number of sales for each employee for year 2021
select e.employeeId, e.firstName, e.lastName,
        strftime('%m',s.soldDate) as month, 
        count(*) as total_sales
from employee e  join sales s
on e.employeeId=s.employeeId
where strftime('%Y',s.soldDate)='2021'
group by e.employeeId, e.firstName, e.lastName, month;

--sales of cars that are electric by using subquery
select m.model, sum(s.salesAmount) as total_sales
from model m join inventory i 
on m.modelId=i.modelId
join sales s on s.inventoryId=i.inventoryId
where m.EngineType='Electric'
group by m.model;

--firstname, lastname, model, numbersold, rank
SELECT e.firstName, e.lastName, m.model, count(*) as total_sold_cars, 
rank() over (partition by e.firstName, e.lastName order by count(*) desc) as rank
from employee e join sales s 
on e.employeeId=s.employeeId
join inventory i on s.inventoryId=i.inventoryId
join model m on m.modelId=i.modelId
group by e.firstName, e.lastName, m.model;

--soldyear, soldmonth, saleamount, annualsales_ruuning total
SELECT strftime('%Y', soldDate) as soldyear, strftime('%m', soldDate) as soldmonth,
sum(salesAmount) as total_saleamount, 
sum(salesAmount) over(partition by strftime('%Y', soldDate) 
                      order by strftime('%Y', soldDate),strftime('%m', soldDate)) as runningtotal
from sales 
group by soldyear, soldmonth;

--monthsold, number_of_cars_sold
SELECT strftime('%Y-%m', soldDate) as month_sold,
count(*) as number_of_cars_sold
from sales 
group by month_sold;
























create database C8;
use C8;

update orders
set orderdate = str_to_date(orderdate, "%d-%m-%Y");
alter table orders
modify column orderdate date;

/* write a SQL query to find top 5 customers with the highest potential Customer Lifetime Value (CLV), representing 
the projected total revenue each customer is expected to generate for the company over their entire engagement?

To estimate CLV, use the formula: Potential CLV = Total Spending * 1.5, where Total Spending is the sum of a customer's spending across completed orders.
Additionally, explore how the frequency of customer orders, indicated by the number of completed orders, reflects their loyalty to the business.

So finally your query will show CustomerName, RegistrationDate, ordercount and PotentialCLV. */
-- CustomerName | RegistrationDate | ordercount | PotentialCLV

select c2.customername, 
count(distinct orderid) as ordercount, 
round((sum(quantity * unitprice) * 1.5),2) as PotentialCLV
from customers c2 inner join orders o using(customerid) inner join order_items oi using(orderid)
where orderstatus = "completed"
group by 1
order by PotentialCLV desc
limit 5;
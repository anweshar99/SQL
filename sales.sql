create database ecom;
use ecom;

/* Write an SQL query to display the cashier_id along with the total discount amount issued by each cashier, 
then add the top department name with the highest refund given by each cashier, then add the total amount of 
discount given by the each cashier in the top department and how many times the cashier gives the discount in 
that top department.*/

-- cashier_id | total_discount_amount | top_department_name | top_department_total_discount | top_department_total_count

with T as
(
	select *
	from
			(select cashier_id, round(sum(discount),2) as total_discount_amount
			from sales
			group by 1) as t1
	inner join
			(select cashier_id, department_name, round(sum(discount),2) as top_department_total_discount, count(discount) as top_department_total_count,
			rank() over (partition by cashier_id order by round(sum(discount),2) desc) as rnk
			from sales
			group by 1,2) as t2
	using(cashier_id)
	order by cashier_id asc
)

select cashier_id, total_discount_amount, department_name as top_department_name, top_department_total_discount, top_department_total_count
from T
where rnk = 1;
create database emp_efficiency;
use emp_efficiency;

select * from projects;

alter table projects
modify column start_date date,
modify column expected_end_date date,
modify column end_date date;

update projects
set start_date = str_to_date(start_date, "%m/%d/%Y");
update projects
set expected_end_date= str_to_date(expected_end_date, "%m/%d/%Y");
update projects
set end_date = str_to_date(end_date, "%m/%d/%Y");

---------------------------------------------------------------------------

/* write an SQL query to identify the most efficient employee within each team, considering their salary, the number of completed projects, 
the total worth of those projects, and the timely completion of projects and project completion bonuses or deductions:

To determine the efficiency of each employee within their respective team, we have formulated an advanced efficiency score that evaluates 
their value contribution to the company, considering various factors. The efficiency score is designed to identify employees who deliver 
optimal value in relation to their salary, while also considering individual project completion performance.

The efficiency score is calculated using the following formula:

Efficiency Score = (Total Worth of Completed Projects * (1 + (Timely Completion Score * 0.2 + Bonus - Deduction))) / Salary

Where:
Total Worth of Completed Projects: This represents the sum of the budgets of all projects completed by the employee.
Timely Completion Score: For each project, this is a binary score (0 or 1) indicating whether the project was completed on or before the expected end date.

Bonus: A value to be added to the efficiency score for projects completed within time. The bonus rewards employees for completing projects earlier than the expected 
end date in this scenario the value is 1.

Deduction: A value to be subtracted from the efficiency score for projects completed over time. The deduction penalizes employees for completing projects after the 
expected end date in this scenario the value is 0.5.

Salary: This refers to the employee's salary.

Your SQL query should display the team, employee_name and efficiency_score */
-- team | employee_name | efficiency_score

with t as 
(
		select *,
		rank() over(partition by team order by efs desc) as rnk
		from
		(select team, employee_name, (twcp * (1+ (tcs * 0.2 + bonus - deduction)))/salary as efs
		from
					(
					select team, employee_name, employee_id, salary, sum(budget) as twcp, sum(tcs) as tcs, sum(bonus) as bonus, sum(deduction) as deduction
						from
							(select *, 
							if(end_date < expected_end_date, 1,0) as tcs,
							if(end_date < expected_end_date, 1,0) as bonus,
							if(end_date > expected_end_date, 0.5,0) as deduction
							from employee e left join projects s using(employee_id)) as temp1
					group by 1,2,3,4
					order by team asc
					) as temp2
		) as temp3
)

select team, employee_name, efs as efficiency_score
from t
where rnk = 1;
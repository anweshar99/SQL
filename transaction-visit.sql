create database c9;
use c9;

create table transaction
(user_id int,
transaction_date varchar(10),
amount int);

create table visit
(user_id int,
visit_date varchar(10));


load data infile "transaction.csv"
into table transaction
fields terminated by ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
ignore 1 lines;

load data infile "visit.csv"
into table visit
fields terminated by ','
enclosed by '"'
LINES TERMINATED BY '\r\n'
ignore 1 lines;

alter table transaction
modify column transaction_date date;

alter table visit
modify column visit_date date;
--------------------------------------------------------------------------------------------------

/* The bank wants to generate a report that displays the daily visits and transactions count for each day within the specified month. 
If there are no visits or transactions on a particular day, the report should still display that day with counts of zero.

Write an SQL query to retrieve the following information for each day:
date: The date of the visit or transaction.
visitors_count: The number of distinct users who visited the bank on that date.
transactions_count: The number of distinct users who made transactions on that date.

The report should be ordered by date. */

select *
from
		(select visit_date as 'date', if(count(distinct user_id)>0, count(distinct user_id), 0) as visitors_count
		from visit
		group by 1
		order by 1 asc) as t1
inner join
		(select transaction_date as 'date', if(count(distinct user_id)>0, count(distinct user_id), 0) as transactions_count
		from transaction
		group by 1
		order by 1 asc) as t2
using(date);

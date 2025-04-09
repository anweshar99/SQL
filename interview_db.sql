/*
Samantha interviews many candidates from different colleges using coding challenges and contests. Write a query to print the contest_id, emp_id, name, and the sums of t_submission, t_accept_submissions, t_views, and t_unique_views for each contest sorted by contest_id. Exclude the contest from the result if all four sums are 0. 
Note: A specific contest can be used to screen candidates at more than one college, but each college only holds 1 screening contest. The DDL Command is given below –
*/

create database interview_db;
use interview_db;
create table contests ( contest_id int, emp_id int, name char(20));

insert into contests (contest_id, emp_id, name)
values (66406, 17973, ‘Pat’),
	  (66556, 79153, ‘Julia’),
	  (94828, 80275, ‘Matt’);

create table colleges ( college_id int, contest_id int);

insert into colleges (college_id, contest_id)
values (11219, 66406),
	  (32473, 66556),
	  (56685, 94828);

create table challenges ( challenge_id int, college_id int);

insert into challenges (challenge_id, college_id)
values (18765, 11219),
	  (47127, 11219),
	  (60292, 32473),
          (72974, 56685);

create table view_stats ( challenge_id int, t_views int, t_unique_views int);

insert into view_stats (challenge_id, t_views, t_unique_views)
values (47127, 26, 19),
	  (47127, 15, 14),
	  (18765, 43, 10),
         (18765, 72, 13),
         (75516, 35, 17),
        (60292, 11, 10),
        (72974, 41, 15),
        (75516, 75, 11);

create table submission_stats ( challenge_id int, t_submissions int, t_accept_submissions int);

insert into submission_stats (challenge_id, t_submissions, t_accept_submissions)
values (75516, 34, 12),
	  (47127, 27, 10),
	  (47127, 56, 18),
          (75516, 74, 12),
          (75516, 83, 8),
          (72974, 68, 24),
          (72974, 82, 14),
          (47127, 28, 11);


with sum_of_total_subs_per_contest as (
select
c.contest_id,
coalesce(sum(ss.t_submissions), 0)
sum_total_submissions,
coalesce(sum(ss.t_accept_submissions), 0)
sum_total_accepted_submissions
from
contests c
left join colleges col
on c.contest_id = col.contest_id
left join challenges ch
on col.college_id = ch.college_id
left join submission_stats ss
on ss.challenge_id = ch.challenge_id
group by
c.contest_id
),
sum_of_total_views_per_contest as (
select
c.contest_id,
coalesce(sum(vs.t_views), 0) sum_total_views,
coalesce(sum(vs.t_unique_views), 0)
sum_total_unique_views
from
contests c left join colleges col
on c.contest_id = col.contest_id
left join challenges ch
on col.college_id = ch.college_id
left join view_stats vs
on vs.challenge_id = ch.challenge_id
group by
c.contest_id
)
select
c.contest_id,
c.emp_id,
c.name,
ts.sum_total_submissions,
ts.sum_total_accepted_submissions,
vs.sum_total_views,
vs.sum_total_unique_views
from
contests c
inner join sum_of_total_subs_per_contest ts
on c.contest_id = ts.contest_id
inner join sum_of_total_views_per_contest vs
on c.contest_id = vs.contest_id
having (
ts.sum_total_submissions
+ ts.sum_total_accepted_submissions
+ vs.sum_total_views
+ vs.sum_total_unique_views
) > 0
Order by
c.contest_id;

/* In other words, a "churned" trade is one where the client has decided to end their relationship or service with the company, 
resulting in the trade being marked as no longer active or relevant.

Identify the top 10 most churned clients based on the number of churned trades. For each of these top churned clients, determine the sales representative(s) involved, 
the total face value, the total actual revenue, and the percentage of face value that is down from revenue for each sales representative. The percentage down from revenue 
is calculated as ((Face Value - Actual Revenue) / Face Value) * 100.

Write a SQL query that accomplishes this. Your query should retrieve the client name, sales representative name(merge first_name and last_name into one column), 
total face value, total actual revenue, and percentage down from revenue for each sales representative. The results should be ordered in descending order based on 
the percentage down from revenue, and only the top 10 results should be displayed. 

client_name | salesrep_name | total_facevalue | total_actual_revenue | percentage_down_from_revenue*/

WITH MostChurnedClient AS (
    SELECT client_id, COUNT(*) AS churn_count
    FROM trades t
    WHERE churn_date!=''
    GROUP BY client_id
    ORDER BY churn_count DESC
    LIMIT 10
)
SELECT
    c.name AS client_name,
    CONCAT(s.first_name," ",s.last_name) AS salesrep_name,
    SUM(t.facevalue) AS salesrep_face_value,
    SUM(t.actual_revenue) AS salesrep_actual_revenue,
    (SUM(t.facevalue) - SUM(t.actual_revenue)) / SUM(t.facevalue) * 100 AS percentage_down
FROM trades t
JOIN MostChurnedClient mcc ON t.client_id = mcc.client_id
JOIN salesreps s ON t.salesperson_id = s.salesrep_id
JOIN clients c ON t.client_id = c.client_id
WHERE t.churn_date!=''
group by client_name,salesrep_name
order by percentage_down desc
limit 10;
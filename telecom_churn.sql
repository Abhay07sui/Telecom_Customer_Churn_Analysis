CREATE DATABASE churn_case;
use churn_case;
select * from customer_churn;
select count(*) from customer_churn;
ALTER TABLE customer_churn
RENAME TO telecom_churn;

-- 
-- 1. What is the total number of customers?
SELECT COUNT(*) AS total_customers
FROM telecom_churn;

-- 2. How many customers have churned vs retained?
SELECT churn,COUNT(*) AS total_customers
FROM telecom_churn
GROUP BY churn;

-- 3. What is the overall churn rate?
SELECT ROUND(COUNT(CASE WHEN Churn = '1' THEN 1 END) * 100.0 / COUNT(*), 2) AS churn_rate_percentage
FROM telecom_churn;

-- 4. Which contract type has the highest churn?
SELECT contract,COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = '1' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN churn = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telecom_churn
GROUP BY contract
ORDER BY churn_rate DESC;

-- 5. Do higher monthly charges lead to churn?
SELECT churn,ROUND(AVG(monthlycharges), 2) AS avg_monthly_charges
FROM telecom_churn
GROUP BY churn;

-- 6. What is the average tenure of churned vs retained customers?
SELECT churn,ROUND(AVG(tenure), 2) AS avg_tenure
FROM telecom_churn
GROUP BY churn;

-- 7. Which internet service has the highest churn?
SELECT internetservice,ROUND(SUM(CASE WHEN churn = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telecom_churn
GROUP BY internetservice
ORDER BY churn_rate DESC;

-- 8. Identify high-risk customers
SELECT * FROM telecom_churn
WHERE contract = 'Month-to-month'
AND monthlycharges > 70
AND tenure < 12;

-- 9. Segment customers based on tenure
SELECT 
    CASE 
        WHEN tenure < 12 THEN 'New Customers'
        WHEN tenure BETWEEN 12 AND 36 THEN 'Mid-term Customers'
        ELSE 'Long-term Customers'
    END AS customer_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = '1' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate
FROM telecom_churn
GROUP BY customer_segment
ORDER BY churn_rate DESC;

-- 10. What is the revenue lost due to churn?
SELECT ROUND(SUM(monthlycharges), 2) AS revenue_lost
FROM telecom_churn
WHERE churn = '1';
DROP TABLE IF EXISTS FRAUD;
CREATE TABLE DETECT
(
transaction_id VARCHAR(10),
transaction_datetime DATE,
customer_id	INT,
account_age_days INT,
num_prev_txns INT,
avg_transaction_amount NUMERIC(10, 2),
amount NUMERIC(10, 2),
merchant VARCHAR(20),
category VARCHAR(20),
location VARCHAR(20),
device_type	VARCHAR(20),
transaction_channel	VARCHAR(20),
ip_risk_score NUMERIC(10, 2),
is_fraud INT
);
SELECT * FROM DETECT;
---Q-1-SHOW FIRST 20 COLUMNS---
SELECT * FROM DETECT
LIMIT 20
---Q-2-COUNT TOTAL TRANSACTIONS---
SELECT 
COUNT(*) FROM DETECT
---Q-3-COUNT FRAUD VS NON-FRAUDS---
SELECT
IS_FRAUD,
COUNT(*) AS NET
FROM DETECT
GROUP BY 1
---Q-4-TOP 5 CUSTOMER BY TRANSACTIONS_COUNT---
SELECT
CUSTOMER_ID,
COUNT(TRANSACTION_ID) AS NET
FROM DETECT
GROUP BY CUSTOMER_ID
ORDER BY NET DESC
LIMIT 5
---Q-5-List transactions where amount > 5000. Show transaction_id, customer_id, amount, merchant, transaction_datetime.---
SELECT
transaction_id, 
customer_id, 
amount, 
merchant, 
transaction_datetime
FROM DETECT
WHERE AMOUNT > 5000
---Q-6-COMPUTE AVERAGE AMOUNT FOR EACH CATEGORY---
SELECT
CATEGORY,
AVG(AMOUNT) AS AVG_AMOUNT
FROM DETECT
GROUP BY 1
---Q-7-Extract hour from transaction_datetime and show how many frauds occur in each hour (0–23). Order by hour.---
SELECT
EXTRACT(HOUR FROM CAST(transaction_datetime AS TIMESTAMP)) AS hours,
COUNT(*) AS fraud_count
FROM DETECT
WHERE is_fraud = 1
GROUP BY hours
ORDER BY hours;
---Q-8-Find transactions where account_age_days < 7 and is_fraud = 1. Show customer_id, transaction_datetime, amount, account_age_days.---
SELECT * FROM DETECT;
SELECT 
customer_id, 
transaction_datetime, 
amount, 
account_age_days
FROM DETECT
WHERE account_age_days < 7 
  AND is_fraud = 1;
---Q-9-For each customer_id, compute total_amount, avg_amount, txn_count, fraud_count. Show top 10 customers by total_amount.---
SELECT
CUSTOMER_ID,
SUM(AMOUNT) AS TOTAL_AMOUNT,
AVG(AMOUNT) AS AVG_AMOUNT,
COUNT(*) AS TXN_AMOUNT,
COUNT(*) FILTER(WHERE IS_FRAUD = 1) AS FRAUD_COUNT
FROM DETECT
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
---Q-10-For each merchant, compute total_txns, fraud_txns, and fraud_rate (fraud_txns/total_txns). Show top 8 merchants by fraud_rate (only include merchants with at least 5 txns).---
SELECT
    merchant,
    COUNT(*) AS total_txns,
    COUNT(*) FILTER (WHERE is_fraud = 1) AS fraud_txns,
    ROUND(
        1.0 * COUNT(*) FILTER (WHERE is_fraud = 1) / COUNT(*),
        2
    ) AS fraud_rate
FROM DETECT
GROUP BY merchant
HAVING COUNT(*) >= 5
ORDER BY fraud_rate DESC
LIMIT 8;
---Q-11-TOP 5 MERCHANT WITH HIGH FRAUD CASES---
SELECT
MERCHANT,
COUNT(*) AS NET
FROM DETECT
WHERE IS_FRAUD = 1
GROUP BY 1
ORDER BY NET DESC
LIMIT 5
---Q-12-INCLUDE THOSE FRAUD CASES WHOSE TRANSACTIONS AMOUNT IS GREATER THAN 5000---
SELECT
CUSTOMER_ID,
IS_FRAUD,
AMOUNT
FROM DETECT
WHERE 
IS_FRAUD = 1
AND
AMOUNT > 5000
---Q-13-WHICH CITY MOST OF THE FRAUD PLACED---
SELECT * FROM DETECT;
SELECT 
LOCATION,
COUNT(*) AS NET
FROM DETECT
WHERE IS_FRAUD = 1
GROUP BY 1
---Q-14-WHICH DEVICE TYPE GET MORE USED IN FRAUDLENT TRANSACTIONS---
SELECT
DEVICE_TYPE,
COUNT(*) AS NET
FROM DETECT
WHERE IS_FRAUD = 1
GROUP BY 1
---Q-15-TOP 3 CUSTOMER WITH HIGH NUMBER OF FRAUD CASES---
SELECT
CUSTOMER_ID,
COUNT(*) AS NET
FROM DETECT
WHERE IS_FRAUD = 1
GROUP BY 1
LIMIT 3
---Q-18-
SELECT
    category,
    COUNT(*) AS fraud_count
FROM DETECT
WHERE is_fraud = 1
GROUP BY category
ORDER BY fraud_count DESC;






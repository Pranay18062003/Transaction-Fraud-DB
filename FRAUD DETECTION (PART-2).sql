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





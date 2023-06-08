/*1 total price for each buy*/
SELECT Customer_Id, name, total_Price,
       SUM(total_Price) OVER (PARTITION BY Customer_Id ORDER BY date) AS running_total
FROM dataset;
/*2 most sellwd items*/
SELECT itemId, item_Name, SUM(amount) AS total_quantity,
       RANK() OVER (ORDER BY SUM(amount) DESC) AS rank
FROM dataset
GROUP BY itemId, item_Name
ORDER BY total_quantity DESC;
/*3 avg spent vs all avg spent*/ 
SELECT Customer_Id, name, AVG(total_Price) AS avg_amount_spent,
       AVG(total_Price) OVER () AS avg_amount_spent_all_customers
FROM dataset
GROUP BY Customer_Id, name;
/*4 customers who spent more than avg*/ 
SELECT Customer_Id, name, total_Price
FROM (
    SELECT Customer_Id, name, total_Price,
           AVG(total_Price) OVER () AS avg_amount_spent
    FROM dataset
    GROUP BY Customer_Id,item_name
) AS subquery
WHERE total_Price > avg_amount_spent;
/*5 customers total spending*/ 
SELECT Customer_Id, name, SUM(total_Price) AS total_spent
FROM dataset
GROUP BY Customer_Id, name;
/*6 ranking costumers in tiers(10)*/ 
SELECT Customer_Id, name, total_spent,
       NTILE(10) OVER (ORDER BY total_spent DESC) AS tier
FROM (
    SELECT Customer_Id, name, SUM(total_Price) AS total_spent
    FROM dataset
    GROUP BY Customer_Id, name
) AS subquery
ORDER BY tier ASC;
/*7 number of unique times they made purchases*/ 
SELECT Customer_Id, name, COUNT(DISTINCT date) AS num_unique_times
FROM dataset
GROUP BY Customer_Id, name
ORDER BY num_unique_times DESC;
/*8*/ 
SELECT Customer_Id, name, total_Price
FROM (
    SELECT Customer_Id, name, total_Price,
           AVG(total_Price) OVER () AS avg_amount_spent
    FROM dataset
    GROUP BY Customer_Id,item_name
) AS subquery
WHERE total_Price > avg_amount_spent;
/*9 items that were purchased by all customers*/ 
SELECT itemId, item_Name
FROM dataset
WHERE itemId IN (
  SELECT itemId
  FROM dataset
  GROUP BY itemId
  HAVING COUNT(DISTINCT Customer_Id) = (
    SELECT COUNT(DISTINCT Customer_Id)
    FROM dataset
  )
);
/*10 customers who spent the most on a single purchase*/ 
SELECT Customer_Id, name, date, total_Price
FROM (
    SELECT Customer_Id, name, date, total_Price,
           RANK() OVER (PARTITION BY Customer_Id ORDER BY total_Price DESC) AS rank
    FROM dataset
) AS subquery
WHERE rank = 1;
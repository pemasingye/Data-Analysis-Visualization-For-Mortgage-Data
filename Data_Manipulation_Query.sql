--1. How many mortgages per month were funded from 2015-11 to 2016-10 ?

SELECT MONTH, COUNT(*) as Mortgages_Per_Month
FROM [SQL Mortgages]..MTG_CUST$
GROUP BY MONTH
--The data is in String format and to split the year and month separately: 
SELECT MONTH, COUNT(*) as Mortgages_Per_Month,
CONCAT(SUBSTRING(CAST(MONTH as varchar), 1, 4), '-', SUBSTRING(CAST(MONTH as varchar), 5, 2)) as MonthYear
FROM [SQL Mortgages]..MTG_CUST$
WHERE MONTH >= 201511 AND MONTH <= 201610
GROUP BY MONTH
ORDER BY MONTH ASC 
-- To remove the MONTH column and replace with MonthYear column
SELECT
CONCAT(SUBSTRING(CAST(MONTH as varchar), 1, 4), '-', SUBSTRING(CAST(MONTH as varchar), 5, 2)) as MONTH,
COUNT(*) as Mortgages_Per_Month
FROM [SQL Mortgages]..MTG_CUST$
WHERE MONTH >= 201511 AND MONTH <= 201610
GROUP BY MONTH
ORDER BY MONTH ASC 


--2. How many mortgages are assigned to Advisor FA500_ON in 201604

SELECT COUNT(*) as Number_of_Mortgages_Assigned_to_Advisor_FA500
FROM [SQL Mortgages]..MTG_CUST$
WHERE Finadvisor = 'FA500_ON' AND DATEPART(yy, MONTH) = 2016 
AND DATEPART(mm, MONTH) = 4

--I have crossed checked with Excel Pivot and still showing zero. 


--3. How many new mortgages in segment “4-Accumulators[45-54]” only in 2016?

SELECT COUNT(*) as Num_of_New_Mortgages 
FROM [SQL Mortgages]..MTG_CUST$
WHERE age_segment = '4-Accumulators[45-54]'
AND MONTH >= 201601 AND MONTH <= 201612

--4. Build one or more queries to retrieve all mortgage clients grouped by region


--1. Number of mortgage clients for each region:

SELECT Region, COUNT(*) as Num_of_Mtg_Clients
FROM [SQL Mortgages]..MTG_CUST$ m
JOIN [SQL Mortgages]..FinAdvMaster$ f 
ON m.Finadvisor = f.FinAdvID
JOIN [SQL Mortgages]..Region$ r 
ON f.Province = r.Province
GROUP BY Region
ORDER BY Num_of_Mtg_Clients DESC 

--2. Dollar value for the mortgages for each region

SELECT Region, SUM(AMT_OF_LOAN) AS Total_Mortgage_Value
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f 
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r 
ON f.Province = r.Province
GROUP BY Region

--To convert into millions & remove the number after the decimals 

SELECT Region, CAST(ROUND(SUM(AMT_OF_LOAN)/1000000, 2) AS INT) AS 'Total Mortgage Value (in millions)'
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY Region
ORDER BY  'Total Mortgage Value (in millions)' DESC 

--3. Number of Advisors under each region


SELECT Region, COUNT(*) AS 'Number of Advisors'
FROM [SQL Mortgages]..FinAdvMaster$ f
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY Region
ORDER BY [Number of Advisors] DESC



--4. Number of delinquent mortgages for each region


SELECT r.Region, COUNT(*) AS 'Number of Delinquent Mortgages'
FROM [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
INNER JOIN [SQL Mortgages]..MTG_CUST$ m
ON d.CUST_Id = m.CUST_Id
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY r.Region
ORDER BY 'Number of Delinquent Mortgages' DESC 

--5. Number of credit card delinquent clients for each region

SELECT r.Region, COUNT(c.CUST_Id) AS 'Number of Credit Card Delinquent Clients'
FROM [SQL Mortgages]..CC_DEL_DEC_2017$ c
INNER JOIN [SQL Mortgages]..MTG_CUST$ m
ON c.CUST_Id = m.CUST_Id
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f 
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r 
ON f.Province = r.Province
GROUP BY r.Region
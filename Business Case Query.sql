--To FInd Total Credit Card Delinquent Mortgage Balance

SELECT ROUND(SUM(balance)/1000000,2) as 'Total Credit Card Delinquent Mortgage Balance'
FROM [SQL Mortgages]..CC_DEL_DEC_2017$

--Number of Delinquent Mortgages by Age Segment

SELECT age_segment, COUNT(*) AS 'Number of Delinquent Mortgages'
FROM [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
INNER JOIN [SQL Mortgages]..MTG_CUST$ c 
ON d.CUST_Id = c.CUST_ID
GROUP BY age_segment
ORDER BY 'Number of Delinquent Mortgages' DESC


--Number of Credit Card Delinquent Mortgages by Age Segment 

SELECT age_segment, COUNT(*) AS 'Number of Delinquent Mortgages'
FROM [SQL Mortgages]..CC_DEL_DEC_2017$ d
INNER JOIN [SQL Mortgages]..MTG_CUST$ c 
ON d.CUST_Id = c.CUST_ID
GROUP BY age_segment
ORDER BY 'Number of Delinquent Mortgages' DESC

--To find the number of delinquent mortgages under each region by age_segment

SELECT r.Region, m.age_segment, COUNT(d.CUST_ID) AS 'Number of Delinquent Mortgages'
FROM [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
INNER JOIN [SQL Mortgages]..MTG_CUST$ m
ON d.CUST_ID = m.CUST_ID
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY r.Region, m.age_segment

--To find the number of delinquent's mortgage by Source

SELECT Source, Count(*) as 'Number of Delinquent Mortgages by Source'
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
ON m.CUST_ID = d.CUST_ID
GROUP BY Source

--To find the number of delinquent credit card mortgages in each region by advisor and also the balance amount
--Advisors delinquent portfolio ($ and number of mortgages)

SELECT r.Region, f.AdvisorFullname, COUNT(c.CUST_ID) AS 'Number of Delinquent Credit Card Mortgages', SUM(c.balance) AS 'Total Balance'
FROM [SQL Mortgages]..CC_DEL_DEC_2017$ c
INNER JOIN [SQL Mortgages]..MTG_CUST$ m
ON c.CUST_ID = m.CUST_ID
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY r.Region, f.AdvisorFullname
ORDER BY r.Region

--To find the comparison percentage of mortgage delinquent between number of clients by advisors with respect to region wise

SELECT r.Region, f.AdvisorFullname, COUNT(m.CUST_ID) AS 'Total Number of Clients', 
COUNT(d.CUST_ID) AS 'Number of Delinquent Mortgages',
ROUND((COUNT(d.CUST_ID) * 100.0) / COUNT(m.CUST_ID), 2) AS 'Delinquency Percentage'
FROM [SQL Mortgages]..MTG_CUST$ m
LEFT JOIN [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
ON m.CUST_ID = d.CUST_ID
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY r.Region, f.AdvisorFullname
ORDER BY r.Region, f.AdvisorFullname


--Following code are done to understand further data but not included in analysis

--Find the average mortgage amount in each province

SELECT f.Province, ROUND(AVG(m.AMT_OF_LOAN),2) AS 'Average Mortgage Size'
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
GROUP BY f.Province
ORDER BY 'Average Mortgage Size'  DESC 

--Number of Advisor by RegionalManager 

SELECT RegionManager, COUNT(AdvisorFullname) AS 'Number of Advisors'
FROM [SQL Mortgages]..FinAdvMaster$ f
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY RegionManager

--Find the total mortgage value in country. 

SELECT ROUND(SUM(AMT_OF_LOAN)/1000000,2) AS 'Total Mortgage Amount (in millions)'
FROM [SQL Mortgages]..MTG_CUST$

-- To find the Total Mortgage Funded Between 2015-11 to 2016-10. 

SELECT
CONCAT(SUBSTRING(CAST(MONTH as varchar), 1, 4), '-', SUBSTRING(CAST(MONTH as varchar), 5, 2)) as MONTH,
ROUND(SUM(AMT_OF_LOAN)/1000000,2) as 'Mortgages_Per_Month(in millions)'
FROM [SQL Mortgages]..MTG_CUST$
WHERE MONTH >= 201511 AND MONTH <= 201610
GROUP BY MONTH
ORDER BY MONTH ASC 



_-- To find the total credit card delinquent balance from 2015-11 to 2016-10.
SELECT
CONCAT(SUBSTRING(CAST(MONTH as varchar), 1, 4), '-', SUBSTRING(CAST(MONTH as varchar), 5, 2)) as MONTH,
SUM(balance) as 'Total_CC_Mortgage_Balance'
FROM [SQL Mortgages]..CC_DEL_DEC_2017$
INNER JOIN [SQL Mortgages]..MTG_CUST$
ON CC_DEL_DEC_2017$.CUST_ID = MTG_CUST$.CUST_ID
WHERE MONTH >= 201511 AND MONTH <= 201610
GROUP BY MONTH
ORDER BY MONTH ASC

--To Find the Total Number of Mortgage Delinquents Between 2015-11 to 2016-10

SELECT
CONCAT(SUBSTRING(CAST(d.MONTH as varchar), 1, 4), '-', SUBSTRING(CAST(d.MONTH as varchar), 5, 2)) as MONTH,
COUNT(d.CUST_ID) as 'Number of Delinquent Mortgages'
FROM [SQL Mortgages]..MTG_CUST$ d
INNER JOIN [SQL Mortgages]..MTG_DELINQ_DEC2017$ m
ON d.CUST_ID = m.CUST_ID
WHERE d.MONTH >= 201511 AND d.MONTH <= 201610
GROUP BY MONTH
ORDER BY MONTH ASC


 
























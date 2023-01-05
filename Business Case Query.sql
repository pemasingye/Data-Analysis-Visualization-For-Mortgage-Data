Number of Delinquent Mortgages by Age Segment

SELECT age_segment, COUNT(*) AS 'Number of Delinquent Mortgages'
FROM [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
INNER JOIN [SQL Mortgages]..MTG_CUST$ c 
ON d.CUST_Id = c.CUST_ID
GROUP BY age_segment
ORDER BY 'Number of Delinquent Mortgages' DESC

Number of Credit Card Delinquent Mortgages by Age Segment 

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


--To find the number of delinquent mortgages in each region by advisor and also with AMT_OF_LOAN(Mortgages)
--Advisors delinquent portfolio ($ and number of mortgages)

SELECT r.Region, f.AdvisorFullname, ROUND(SUM(m.AMT_OF_LOAN)/1000000, 2) AS 'Total Mortgage Value (in millions)'
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
INNER JOIN [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
ON m.CUST_ID = d.CUST_ID
GROUP BY r.Region, f.AdvisorFullname


--To find the number of delinquent's mortgage by Source

SELECT Source, Count(*) as 'Number of Delinquent Mortgages by Source'
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..MTG_DELINQ_DEC2017$ d
ON m.CUST_ID = d.CUST_ID
GROUP BY Source


--Find the average mortgage amount in each province

SELECT f.Province, ROUND(AVG(m.AMT_OF_LOAN),2) AS 'Average Mortgage Size'
FROM [SQL Mortgages]..MTG_CUST$ m
INNER JOIN [SQL Mortgages]..FinAdvMaster$ f
ON m.Finadvisor = f.FinAdvID
GROUP BY f.Province
ORDER BY 'Average Mortgage Size'  DESC 

SELECT RegionManager, COUNT(AdvisorFullname) AS 'Number of Advisors'
FROM [SQL Mortgages]..FinAdvMaster$ f
INNER JOIN [SQL Mortgages]..Region$ r
ON f.Province = r.Province
GROUP BY RegionManager














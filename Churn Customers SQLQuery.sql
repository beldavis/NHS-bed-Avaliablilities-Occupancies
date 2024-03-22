SELECT TOP (1000) [Customer ID]
      ,[Churn Label]
      ,[Account Length (in months)]
      ,[Local Calls]
      ,[Local Mins]
      ,[Intl Calls]
      ,[Intl Mins]
      ,[Intl Active]
      ,[Intl Plan]
      ,[Extra International Charges]
      ,[Customer Service Calls]
      ,[Avg Monthly GB Download]
      ,[Unlimited Data Plan]
      ,[Extra Data Charges]
      ,[State]
      ,[Phone Number]
      ,[Gender]
      ,[Age]
      ,[Under 30]
      ,[Senior]
      ,[Group]
      ,[Number of Customers in Group]
      ,[Device Protection & Online Backup]
      ,[Contract Type]
      ,[Payment Method]
      ,[Monthly Charge]
      ,[Total Charges]
      ,[Churn Category]
      ,[Churn Reason]
  FROM [Chuncustomer].[dbo].['Customer Churn - Data$']


-- The next 2 queries is to see that my data was imported correctly

SELECT TOP 2 *
FROM [dbo].['Customer Churn - Data$']
ORDER by 3,4



-- The next query will select the data I will be using.

SELECT
[Customer ID]
      ,[Churn Label]
      ,[Account Length (in months)] 
      ,[Local Calls]
      ,[Local Mins]
      ,[Intl Calls]
      ,[Intl Mins]
      ,[Intl Active]
      ,[Intl Plan]
      ,[Extra International Charges]
      ,[Customer Service Calls]
      ,[Avg Monthly GB Download]
      ,[Unlimited Data Plan]
      ,[Extra Data Charges]
      ,[State]
      ,[Phone Number]
      ,[Gender]
      ,[Age]
      ,[Under 30]
      ,[Senior]
      ,[Group]
      ,[Number of Customers in Group]
      ,[Device Protection & Online Backup]
      ,[Contract Type]
      ,[Payment Method]
      ,[Monthly Charge]
      ,[Total Charges]
      ,[Churn Category]
      ,[Churn Reason]
  FROM [Chuncustomer].[dbo].['Customer Churn - Data$']
WHERE [Churn Category] IS NOT NULL
AND  [Churn Reason] IS NOT NULL
ORDER BY [Customer ID], [Contract Type]


  --1.NUMBER OF CUSTOMERS
SELECT COUNT ([Customer ID]) AS NO_OF_CUSTOMERS
FROM [dbo].['Customer Churn - Data$']


--2.NUMBER OF CHURN CUSTOMERS
(SELECT COUNT([Churn Label]) AS NO_OF_CHURNED_CUSTOMER
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes')


--4. CHURN LABEL BY STATE AND CONTRACT TYPE
SELECT  State, [Contract Type], [Churn Label]
FROM [dbo].['Customer Churn - Data$']
WHERE  [Churn Label] = 'Yes'

--5. HIGHEST CHURN REASON( FROM HIGHEST TO LOWEST)
SELECT [Churn Reason], COUNT([Churn Reason]) AS CHURN_REASON
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Reason]  IS NOT NULL
GROUP BY  [Churn Reason]
ORDER BY CHURN_REASON DESC

--6.COUNT CHURN BY CATEGORY
SELECT [Churn Category], COUNT([Churn Category]) AS CHURN_CATEGORY
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Category]  IS NOT NULL
GROUP BY  [Churn Category]
ORDER BY CHURN_CATEGORY DESC



--7.CHURN BY STATE
SELECT  State, COUNT ([Churn Label]) AS HIGHESTSTATEBYCHURN
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes'
GROUP BY State
ORDER BY HIGHESTSTATEBYCHURN DESC

SELECT State, [Churn Label],
COUNT([Churn Label]) OVER( PARTITION BY State) AS NOOFChurnbyState
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes'
ORDER BY NOOFChurnbyState DESC

--8.CHURN BY AGE
SELECT  Age, COUNT ([Churn Label]) AS ChurnByAge
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes'
GROUP BY Age
ORDER BY ChurnByAge DESC

--8b 
SELECT MAX(Age) Agemax, MIN(Age) Agemin
FROM [dbo].['Customer Churn - Data$']

--CHURNRATE
SELECT COUNT([Churn Label])as Noofchurn, 
count([Churn Label])/(SELECT COUNT([Churn Label]) 
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes')
 * 100 as ChurnRate
FROM[dbo].['Customer Churn - Data$']

---The above didnt work for Churn rate so i decided to try another method

SELECT [Churn Label],
COUNT([Churn Label]) OVER (PARTITION BY	[Churn Label]) AS A
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes'



--9.AVERAGE MONTHLY CHURN BY NUMBER OFCUSTOMRS IN GROUPS
SELECT  distinct ([Number of Customers in Group]), COUNT([Number of Customers in Group]) NOOFCUSTOMERSINGROUP
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes'
GROUP BY [Number of Customers in Group]
ORDER BY  1 DESC

--10 Churn by Customer

SELECT  Gender, COUNT([Churn Label]) AS ChurnBygENDER
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Label] = 'Yes'
GROUP BY Gender
ORDER BY ChurnBygENDER DESC

--11.Churn by Unlimited plan, International plan, Contract type
SELECT [Churn Label],[Unlimited Data Plan], [Intl Plan], [Contract Type],
COUNT([Churn Label]) OVER (PARTITION BY	[Unlimited Data Plan] ORDER BY  [Contract Type]  ) AS UNLIMITEDDATAPLAN
FROM [dbo].['Customer Churn - Data$']

--12. No of customer by contract types
 SELECT  [Customer ID], [Contract Type],
 COUNT ([Customer ID]) OVER (PARTITION BY [Contract Type] ) AS NOOFBYCONTRACTCUST
 FROM [dbo].['Customer Churn - Data$']


--13. No of customer by accout lenght
SELECT  [Account Length (in months)], COUNT([Customer ID]) AS NoofcusbyAccountlenght
FROM [dbo].['Customer Churn - Data$']
GROUP BY  [Account Length (in months)]
ORDER BY 1 ASC


--14 Making contract type either Monthly/Annually
SELECT [Contract Type]  
	,
	CASE 
		WHEN [Contract Type] = 'Month-to-Month' THEN 'Monthly'
		WHEN [Contract Type] = 'One Year' THEN 'Annually'
		WHEN [Contract Type] = 'Two Year' THEN 'Annually'

		ELSE [Contract Type] 
		END as ContractType
FROM [dbo].['Customer Churn - Data$']

--15 Checking for duplicate Customer ID 
--I decided to use 3 methods in checking for duplicate which includes CTE, Case Statement and Aggregate function

 WITH CTE_SRC AS (
 SELECT *, 
ROW_NUMBER() OVER (PARTITION BY [Customer ID] ORDER BY [Customer ID] ) AS RN
FROM [dbo].['Customer Churn - Data$'])
 SELECT *
 FROM CTE_SRC WHERE RN>1

SELECT [Customer ID], [Phone Number],  COUNT(*) AS A
FROM [dbo].['Customer Churn - Data$']
GROUP BY [Customer ID], [Phone Number]
HAVING COUNT(*)>1

SELECT *,
CASE WHEN [Customer ID] = LAG([Customer ID]) OVER (ORDER BY [Customer ID] ) THEN 'YES'
ELSE 'NO' END AS DP
FROM [dbo].['Customer Churn - Data$']
ORDER BY [Customer ID]
--


--16 Checking for Device protection & Online Backups
SELECT   [Device Protection & Online Backup], COUNT([Device Protection & Online Backup]) AS NOofCustwthDataProandBackup
FROM [dbo].['Customer Churn - Data$']
GROUP BY  [Device Protection & Online Backup]


--17 Payment Method
SELECT [Payment Method], COUNT([Payment Method]) AS CustomerPaymentMthd
FROM [dbo].['Customer Churn - Data$']
GROUP BY [Payment Method]
ORDER BY CustomerPaymentMthd DESC

SELECT [Payment Method],
COUNT([Payment Method]) OVER (PARTITION BY [Payment Method] ORDER BY  [Payment Method]) AS CustomerPaymentMthd
FROM [dbo].['Customer Churn - Data$']
ORDER BY CustomerPaymentMthd DESC


--18 Rolling Monthly Charge by Gender
SELECT [Customer ID],[Gender], [Phone Number],  [Monthly Charge],
SUM([Monthly Charge]) OVER (PARTITION BY [Gender] ORDER BY [Customer ID]) AS [Rolling Monthly Charge]
FROM [dbo].['Customer Churn - Data$']
	

--19 Rolling Total Charge by Gender
SELECT [Customer ID], [Gender], [Phone Number], [Total Charges],
SUM([Total Charges]) OVER (PARTITION BY [Gender] ORDER BY [Customer ID]) AS [Rolling Total Charge]
FROM [dbo].['Customer Churn - Data$']

--20  Moncharge_to_totalcharge %
SELECT [Customer ID],[Payment Method], [Contract Type],[Monthly Charge],[Total Charges],([Monthly Charge]/[Total Charges])*100 AS Moncharge_to_totalcharge
FROM [dbo].['Customer Churn - Data$']


--21 Customers that left with no reason
SELECT COUNT([Churn Reason]) AS CHURN_REASON
FROM [dbo].['Customer Churn - Data$']
WHERE [Churn Reason]  is null
GROUP BY  [Churn Reason]
ORDER BY CHURN_REASON DESC

--22 Under 30
SELECT[Customer ID], [Age], [Under 30]
FROM [dbo].['Customer Churn - Data$']

SELECT [Customer ID], [Age], [Under 30],
COUNT([Under 30]) OVER (PARTITION BY [Under 30] ORDER BY [Customer ID]) AS COUNT_OF_OVER_UNDER30
FROM [dbo].['Customer Churn - Data$']

--23 Replacing empty rows in churn reason and category
  SELECT COALESCE ([Churn Reason], NULL, 'NOREASON') AS RESULT
  FROM [dbo].['Customer Churn - Data$']

  UPDATE [dbo].['Customer Churn - Data$']
  SET [Intl Plan] = 'No'
  WHERE [Intl Plan] = 'no' 

   UPDATE [dbo].['Customer Churn - Data$']
   SET [Intl Plan] = 'Yes'
   WHERE [Intl Plan] = 'yes'


-- 24 Remove duplicates
 WITH CTE_SRC AS (
 SELECT 
ROW_NUMBER() OVER (PARTITION BY [Customer ID] ORDER BY [Customer ID] ) AS RN
FROM [dbo].['Customer Churn - Data$'])
 DELETE  FROM CTE_SRC
 WHERE RN>1

 --25  Changing case to Upper
 UPDATE [dbo].['Customer Churn - Data$']
 SET Gender = UPPER(Gender)



 --26  Joining tables together 
 SELECT DISTINCT [Customer ID], [Phone Number], [Gender] , [Age],A.[State],  B.[Account Length (in months)], [Contract Type], [Payment Method], [Monthly Charge], [Total Charges]
 FROM [dbo].['Customer Churn - Data$'] A LEFT JOIN [dbo].[CHURN_CUSTOMER_OVER_15months] B
 ON A.[Account Length (in months)] = B.[Account Length (in months)]
 ORDER BY [Customer ID]  ASC





SELECT TOP (1000) [Year]
      ,[PeriodEnd]
      ,[RegionCode]
      ,[OrgCode]
      ,[OrgName]
      ,[F6]
      ,[Total ]
      ,[General&Acute]
      ,[LearningDisabilities]
      ,[Maternity]
      ,[Mental_Illness]
      ,[F12]
  FROM [NHSBedOccupancies].[dbo].[Occupancy$]

  SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH AS MAX_LENGTH, 
    CHARACTER_OCTET_LENGTH AS OCTET_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'avaliablebed$'

SELECT *
FROM dbo.avaliablebed$


SELECT Max(LearningDisabilities) as MaxLD
FROM dbo.avaliablebed$

SELECT Min(LearningDisabilities) as MaxLD
FROM dbo.avaliablebed$

SELECT RegionCode, count(LearningDisabilities) as noOfLDbyRegcode
FROM dbo.avaliablebed$
GROUP BY RegionCode
ORDER BY noOfLDbyRegcode DESC

SELECT Year, PeriodEnd, RegionCode, OrgCode, [Total ], [General&Acute], LearningDisabilities, Maternity, Mental_Illness
FROM [NHSBedOccupancies].[dbo].[Occupancy$]
WHERE RegionCode = 'Y56'
order by 4

SELECT *
FROM dbo.avaliablebed$ INNER JOIN dbo.Occupancy$
ON  dbo.avaliablebed$.RegionCode = dbo.Occupancy$.RegionCode


SELECT *
FROM dbo.avaliablebed$ INNER JOIN dbo.Occupancy$
ON  dbo.avaliablebed$.OrgName = dbo.Occupancy$.OrgName

SELECT Year, PeriodEnd, OrgCode, OrgName, Total, LearningDisabilities, Maternity, Mental_Illness
FROM dbo.avaliablebed$
UNION ALL
SELECT Year, PeriodEnd, OrgCode, OrgName, Total, LearningDisabilities, Maternity, Mental_Illness
FROM dbo.Occupancy$


SELECT DISTINCT RegionCode,
              ( CASE
               WHEN RegionCode = 'Y56' THEN 'SOUTH'
               WHEN RegionCode = 'Y58' THEN 'MIDLANDS'
               WHEN RegionCode = 'Y59' THEN 'SOUTHMIDLANDS'
               WHEN RegionCode = 'Y60' THEN 'BIRMINGHAM'
               WHEN RegionCode = 'Y61' THEN 'ESSEXANDSUFFORK'
               WHEN RegionCode = 'Y62' THEN 'NORTHWEST'
               WHEN RegionCode = 'Y63' THEN 'NORTHEAST'
ELSE NULL
END ) AS REGIONS
FROM dbo.Occupancy$
UNION ALL
SELECT DISTINCT RegionCode, 
              ( CASE
               WHEN RegionCode = 'Y56' THEN 'SOUTH'
               WHEN RegionCode = 'Y58' THEN 'MIDLANDS'
               WHEN RegionCode = 'Y59' THEN 'SOUTHMIDLANDS'
               WHEN RegionCode = 'Y60' THEN 'BIRMINGHAM'
               WHEN RegionCode = 'Y61' THEN 'ESSEXANDSUFFORK'
               WHEN RegionCode = 'Y62' THEN 'NORTHWEST'
               WHEN RegionCode = 'Y63' THEN 'NORTHEAST'
ELSE NULL
END ) AS REGIONSColomn
FROM dbo.avaliablebed$

SELECT RegionCode, 
              ( CASE
               WHEN RegionCode = 'Y56' THEN 'SOUTH'
               WHEN RegionCode = 'Y58' THEN 'MIDLANDS'
               WHEN RegionCode = 'Y59' THEN 'SOUTHMIDLANDS'
               WHEN RegionCode = 'Y60' THEN 'BIRMINGHAM'
               WHEN RegionCode = 'Y61' THEN 'ESSEXANDSUFFORK'
               WHEN RegionCode = 'Y62' THEN 'NORTHWEST'
               WHEN RegionCode = 'Y63' THEN 'NORTHEAST'
ELSE NULL
END ) AS REGIONSColomn
FROM dbo.Occupancy$

SELECT COUNT(RegionCode) as newR
FROM dbo.avaliablebed$


SELECT distinct RegionCode, OrgName, Maternity
FROM dbo.avaliablebed$
WHERE Maternity between 1 and 1000
order by 3

SELECT Maternity, RegionCode, OrgName,
                 (CASE
				WHEN Maternity between '0' AND '10' THEN 'avaliable<10'
				WHEN Maternity between '11' AND '20' THEN 'avaliable<20'
				WHEN Maternity between '21' AND '40' THEN 'avaliable<40'
				WHEN Maternity between '41' AND '60' THEN 'avaliable<60'
				WHEN Maternity between '61' AND '100' THEN 'avaliable<100'
				WHEN Maternity between '100' AND '1000' THEN 'avaliable<300'
				ELSE NULL
				END) AS BED_SPACE
FROM dbo.avaliablebed$
WHERE RegionCode = 'Y56'
order by 1


UPDATE avaliablebed$
SET Maternity = '20'
WHERE LearningDisabilities = '0'

UPDATE avaliablebed$
SET LearningDisabilities  = '20'
WHERE Maternity = '20'

UPDATE avaliablebed$
SET F11 = '20'
WHERE Maternity = '20'


SELECT OrgName,
              (CASE 
			  WHEN OrgName LIKE '%LONDON%' THEN 'SOUTH'
			  WHEN OrgName LIKE '%MIDDLESEX%' THEN 'MIDLANDS'
			  WHEN OrgName LIKE '%KING%' THEN 'SOUTH'
			  WHEN OrgName LIKE '%OXFORD%' THEN 'SOUTH'
              WHEN OrgName LIKE '%CORNWALL%' THEN 'SOUTH'
			   ELSE NULL
			  END) AS NEW_REGION
			  FROM avaliablebed$ 
			  ORDER BY 2
SELECT *
FROM dbo.avaliablebed$  inner JOIN dbo.Occupancy$
ON  dbo.avaliablebed$.RegionCode = dbo.Occupancy$.RegionCode

SELECT INITCAP(OrgName)
FROM avaliablebed$

SELECT LearningDisabilities, Maternity, (LearningDisabilities / Total)*100 as LDpercent
from dbo.avaliablebed$
where total  between  '1' and '1000000'
order by 3

SELECT MAX(LearningDisabilities) AS LDMAX
from dbo.avaliablebed$


SELECT Maternity, (Maternity / Total)*100 as MATpercent
from dbo.avaliablebed$
where total  between  '1' and '1000000'


SELECT MAX(LearningDisabilities) as maxLd, MAX(Maternity) as maxmat, COUNT(Maternity) as ct, AVG(LearningDisabilities) as ldavg, min(Maternity) as Minmat
from dbo.avaliablebed$

SELECT (CONCAT OrgName '' RegionCode)
from dbo.avaliablebed$


SELECT LearningDisabilities, (LearningDisabilities / Total)*100 as percenttotalLD
from dbo.avaliablebed$
where total  between  '1' and '1000000'

SELECT *
from dbo.avaliablebed$

SELECT OrgCode, MAX(LearningDisabilities) as Highlearning, MAX((LearningDisabilities  / Total))*100 as PercenttotalLD
from dbo.avaliablebed$
where Total  between  '1' and '1000000'
GROUP BY LearningDisabilities, OrgCode
order by 3 desc


SELECT Year, SUM(Total) as TotalSum, SUM(Mental_illness) as TotalMiLness, (SUM(Mental_illness)/SUM(Total))*100  as Mentalillnesspercent
from dbo.avaliablebed$
GROUP BY Year


SELECT Year, SUM(Total) as TotalSum, SUM(Mental_illness) as TotalMiLness, (SUM(Mental_illness)/SUM(Total))*100  as Mentalillnesspercent
from dbo.Occupancy$
GROUP BY Year

SELECT OrgCode, MAX(LearningDisabilities) as Highlearning, MAX((LearningDisabilities  / Total))*100 as PercenttotalLD
from dbo.Occupancy$
where Total  between  '1' and '1000000'
GROUP BY LearningDisabilities, OrgCode
order by 3 desc

SELECT OrgName,
              (CASE 
			  WHEN OrgName LIKE '%LONDON%' THEN 'SOUTH'
			  WHEN OrgName LIKE '%MIDDLESEX%' THEN 'MIDLANDS'
			  WHEN OrgName LIKE '%KING%' THEN 'SOUTH'
			  WHEN OrgName LIKE '%OXFORD%' THEN 'SOUTH'
              WHEN OrgName LIKE '%CORNWALL%' THEN 'SOUTH'
		
			  WHEN OrgName LIKE '%HS%' THEN 'SOUTH'
			   ELSE NULL
			  END) AS NEW_REGION
			  FROM Occupancy$
			  ORDER BY 2




























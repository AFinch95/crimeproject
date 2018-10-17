use crimeproject;

-- Cleaning population data by changing data types
-- Checking lengths of columns with string data and minimum, maximum values of population data
SELECT 
	 MIN(LEN([F1])) as minlengthBoroughCode
	,MAX(LEN([F1])) as maxlengthBoroughCode
	,MIN(LEN([F2])) as minlengthBoroughName
	,MAX(LEN([F2]))	as maxlengthBoroughName
	,MIN(LEN([F3])) as minlengthGeoType
	,MAX(LEN([F3]))	as maxlengthGeoType
	,MIN([F4])		as minTotalPop
	,MAX([F4])		as maxTotalPop
FROM [raw].[pop17]

SELECT 
	 CAST([F1] as char(9)) as [BoroughCode]
	,CAST([F2] as varchar(22)) as [BoroughName]
	,CAST([F3] as char(14)) as [GeoType]
	,CAST([F4] as int) as [TotalPopulation]
	,CAST('2017-01-01' as date) as [Year]
--INTO [clean].[population]  
FROM [raw].[pop17]

-- Find only London LSOAs
SELECT
 p.[Area Codes]
,p.[F3]
,p.[All Ages]
,sum(p.[All Ages]) over (partition by p2.[F2])
--,CASE 
--	WHEN p.[Area Codes] is not null THEN '2016'
--	WHEN p2.[F2] is not null THEN '2017'
--END
,p2.[F2]
,p2.[F4]
FROM [raw].[pop16] p
INNER JOIN [raw].[LondonLSOA] l
ON P.[F3] = l.LSOAName
LEFT JOIN [raw].[pop17] p2
ON p2.[F2]=left(p.[F3],len(p.[F3])-5)
use crimeproject;
-- Cleaning population data by changing data types, unpivotting and aggregating
-- Choosing only population data for the boroughs in London
if object_id('[raw].[LondonPops]') is not null
drop table [raw].[LondonPops]

SELECT DISTINCT
	p.*
INTO [raw].[LondonPops]
FROM [raw].[populationfull] p
-- Choosing only the Boroughs in London by inner joining with London borough names
INNER JOIN [raw].[LondonLSOA] l
ON p.[lad2014_name] = LEFT(l.[LSOAName], LEN(l.[LSOAName]) - 5)

--Unpivot years of population data
if object_id('[raw].[LondonPopUnpivot]') is not null
drop table [raw].[LondonPopUnpivot]

SELECT
	 [Year]
	,popcount
	,[lad2014_code] as [BoroughCode]
	,[lad2014_name] as [BoroughName]
	,[sex]
	,[Age]
INTO [raw].[LondonPopUnpivot]
FROM (SELECT * FROM [raw].[LondonPops]) lp
unpivot(
popcount for [Year] in ([population_2001], [population_2002], [population_2003], [population_2004], [population_2005], [population_2006], [population_2007], [population_2008], [population_2009], [population_2010], [population_2011], [population_2012], [population_2013], [population_2014], [population_2015], [population_2016], [population_2017])
) unpiv

-- Finding min and max values to aid choosing data types for each column
SELECT
	 min(len([BoroughCode])) as minlengthboroughcode
	,max(len([BoroughCode])) as maxlengthboroughcode
	,min(len(BoroughName)) as minlengthboroughname
	,max(len(BoroughName)) as maxlengthboroughname
	,min(cast([popcount] as int)) as minpopcount
	,max(cast([popcount] as int)) as maxpopcount
FROM [raw].[LondonPopUnpivot]

--Find Populations for Under18s and Total for each Borough and Year
SELECT DISTINCT
	 cast([BoroughCode] as char(9)) as [BoroughCode]
	,cast([BoroughName] as varchar(22)) as [BoroughName]
	,cast(RIGHT([Year], 4) + '-01-01' as date) as [Year]
	,CASE WHEN cast([Age] as smallint) < 18 THEN 'UNDER18' ELSE '18OROLDER' END as Under18
	,sum(cast([popcount] as int)) over (partition by [BoroughCode], [Year]) as [TotalPop]
	,sum(cast([popcount] as int)) over (partition by [BoroughCode], [Year], CASE WHEN cast([Age] as smallint) < 18 THEN 'UNDER18' ELSE '18OROLDER' END) as [PopUnder18]
INTO [raw].[LondonPopUnpivotUnder18s]
FROM [raw].[LondonPopUnpivot]

--Put into clean population table
SELECT 
	 [BoroughCode]
	,[BoroughName]
	,[Year]
	,[PopUnder18]
	,[TotalPop]
INTO [clean].[LondonPop]
FROM [raw].[LondonPopUnpivotUnder18s]
WHERE [Under18] = 'UNDER18'
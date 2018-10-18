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

--Put into clean population table for years there is crime data for
if object_id('[clean].[LondonPop]') is not null
drop table [clean].[LondonPop]

SELECT 
	 [BoroughCode]
	,[BoroughName]
	,left([Year],4) as [Year]
	,[PopUnder18]
	,[TotalPop]
INTO [clean].[LondonPop]
FROM [raw].[LondonPopUnpivotUnder18s]
WHERE [Under18] = 'UNDER18' AND [YEAR] between '2010-01-01' AND '2018-01-01' 

-- Create Dimension for the model which includes population data
CREATE TABLE [Geography].[DimBorough]
(BoroughID int identity primary key
,BoroughName varchar(50))

-- Populate new table with Borough Names
INSERT INTO [Geography].[DimBorough]
	SELECT DISTINCT [Borough] FROM [Geography].[DimGeo]

ALTER TABLE [Geography].[DimGeo]
	ADD BoroughID int foreign key
	references [Geography].[DimBorough] (BoroughID)

----------------------------------------------------------------

-- Not 100% sure what happened here -> joined dim geo to dim borough to pick up boroughID then recreate key constraints

ALTER TABLE [Geography].[DimGeo]
	SET BoroughID = SELECT 

SELECT * FROM [Geography].[DimGeo]
SELECT * FROM [Geography].[DimBorough]


SELECT 
 dg.*
,db.[BoroughID]
INTO [Geography].[DimGeo2]
FROM [Geography].[DimBorough] db
inner join [Geography].[DimGeo] dg on db.[BoroughName] = dg.[Borough]

Alter schema trash
	TRANSFER [Geography].[DimGeo]

alter table [Geography].[DimGeo] drop column [Borough]

select 264*4832/33

alter table [Geography].[DimGeo]
add constraint pk_GeoID primary key ([GeoID])

alter table [Geography].[DimBorough]
add constraint pk_BoroughID primary key ([BoroughID])

alter table [Fact].[FactTable]
add constraint fk_GeoID foreign key ([GeoID])
references [Geography].[DimGeo] ([GeoID])

alter table [Geography].[DimGeo]
add constraint fk_BoroughID foreign key ([BoroughID])
references [Geography].[DimBorough] ([BoroughID])
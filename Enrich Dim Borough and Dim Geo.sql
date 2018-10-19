-- Enrich Dim Geography table
-- Add spatial object column to geography dimension

ALTER TABLE [Geography].[DimGeo]
ADD [SpatialObject] geography

-- Insert spatial column from raw spatial column table

UPDATE [Geography].[DimGeo] 
SET [SpatialObject] = LL.[SpatialObj]
FROM [Geography].[DimGeo] DG
INNER JOIN [raw].[LondonLSOABoundaries] LL
ON DG.[LSOACode] = LL.[LSOA11CD]

-- Add Number of House Holds column to geography dimension
ALTER TABLE [Geography].[DimGeo]
ADD [NoHouseHolds] int

-- Insert Number of House Holds column from raw spatial column table

UPDATE [Geography].[DimGeo] 
SET [NoHouseHolds] = LL.[HHOLDS]
FROM [Geography].[DimGeo] DG
INNER JOIN [raw].[LondonLSOABoundaries] LL
ON DG.[LSOACode] = LL.[LSOA11CD]

-- Add Number of residents column to geography dimension

ALTER TABLE [Geography].[DimGeo]
ADD [NoResidents] int

-- Insert Number of residents column from raw spatial column table

UPDATE [Geography].[DimGeo] 
SET [NoResidents] = LL.[USUALRES]
FROM [Geography].[DimGeo] DG
INNER JOIN [raw].[LondonLSOABoundaries] LL
ON DG.[LSOACode] = LL.[LSOA11CD]

-- Add spatial object column to borough dimension

ALTER TABLE [Geography].[DimBorough]
ADD [SpatialObject] geography

-- Insert Spatial Object column from raw spatial column table

UPDATE [Geography].[DimBorough]
SET [SpatialObject] = LB.[SpatialObj]
FROM [Geography].[DimBorough] DB
INNER JOIN [raw].[LondonBoundaries] LB
ON LB.[NAME] = DB.[BoroughName]

-- Add Hectares column to borough dimension

ALTER TABLE [Geography].[DimBorough]
ADD [Hectares] float

-- Insert Spatial Object column from raw spatial column table

UPDATE [Geography].[DimBorough]
SET [Hectares] = LB.[HECTARES]
FROM [Geography].[DimBorough] DB
INNER JOIN [raw].[LondonBoundaries] LB
ON LB.[NAME] = DB.[BoroughName]

-- Join budget and staff number data to clean and put into Geo dimension
if object_id('[Clean].[BudgetAndStaffNos]') is not null
drop table [Clean].[BudgetAndStaffNos]

SELECT
	  CAST(COALESCE(LTRIM(RTRIM(B.[borough])), LTRIM(RTRIM(S.[borough]))) as varchar(60)) as [Borough]
	 ,CAST(COALESCE(LTRIM(RTRIM(B.[financialyear])), LTRIM(RTRIM(S.[financialyear]))) as char(7)) as [FY]
	 ,ISNULL(CAST(ROUND(B.[budget], 0) as int), -99) as [FYbudget]
	 ,ISNULL(CAST(ROUND(S.[staffnos], 0) as int), -99) as [FYstaffnos]
	 ,DB.[BoroughID]
INTO [Clean].[BudgetAndStaffNos]
FROM [raw].[YCbudgetunpivot] B
FULL OUTER JOIN [raw].[YCstaffnosunpivot] S
ON B.[borough] = S.[borough] AND B.[financialyear] = S.[financialyear]
LEFT JOIN [Geography].[DimBorough] DB
 ON DB.[BoroughName] = CAST(COALESCE(LTRIM(RTRIM(B.[borough])), LTRIM(RTRIM(S.[borough]))) as varchar(60))

SELECT BS.* FROM [clean].[BudgetAndStaffNos] BS 
SELECT * FROM [Geography].[Population]
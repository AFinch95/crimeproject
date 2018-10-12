--Creating Views for histogram analysis in Excel

-- Create view for outcomes of London crimes
alter view [vw_countofoutcome] as (
SELECT DISTINCT
	 [Last outcome category]
	,COUNT(*) over (partition by [Last outcome category]) as [OutcomeCount]
FROM
	[raw].[LondonCrimes]
);

-- Create view for months of London crimes
go
alter view [vw_countofmonths] as (
SELECT DISTINCT
	 [Month]
	,COUNT(*) over (partition by [Month]) as [MonthCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Create view for Reported By of London crimes
go
create view [vw_countofReportedBy] as (
SELECT DISTINCT
	 [Reported by]
	,COUNT(*) over (partition by [Reported by]) as [ReportedByCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Create view for FallsWithin of London crimes
go
create view [vw_countofFallsWithin] as (
SELECT DISTINCT
	 [Falls within]
	,COUNT(*) over (partition by [Falls within]) as [FallsWithinCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Insert statistical analysis values for Longitude into new table to create view from
;WITH CTE AS(
SELECT DISTINCT
	 avg(cast([Longitude] as float)) as [MeanLong]
	,MIN(cast([Longitude] as float)) as [MinLong]
	,MAX(cast([Longitude] as float)) as [MaxLong]
FROM
	[raw].[LondonCrimes])
SELECT DISTINCT
	C.*
	,PERCENTILE_DISC(0.5) within group (order by cast(L.[Longitude] as float) asc) over ()  as [MedianLong]
	,PERCENTILE_DISC(0.25) within group (order by cast(L.[Longitude] as float) asc) over()  as [1QLong]
	,PERCENTILE_DISC(0.75) within group (order by cast(L.[Longitude] as float) asc) over()  as [3QLong]
INTO [raw].[longanalysis]
FROM 
	CTE AS C
CROSS JOIN [raw].[LondonCrimes] AS L
go
-- Create view for Longitude of London crimes
go
create view [vw_longstatanalysis] as
SELECT * FROM [raw].[longanalysis]
go

-- Insert statistical analysis values for Latitude into new table to create view from
;WITH CTE AS(
SELECT DISTINCT
	 avg(cast([Latitude] as float)) as [MeanLat]
	,MIN(cast([Latitude] as float)) as [MinLat]
	,MAX(cast([Latitude] as float)) as [MaxLat]
FROM
	[raw].[LondonCrimes])
SELECT DISTINCT
	C.*
	,PERCENTILE_DISC(0.5) within group (order by cast(L.[Latitude] as float) asc) over ()  as [MedianLat]
	,PERCENTILE_DISC(0.25) within group (order by cast(L.[Latitude] as float) asc) over()  as [1QLat]
	,PERCENTILE_DISC(0.75) within group (order by cast(L.[Latitude] as float) asc) over()  as [3QLat]
INTO [raw].[latanalysis]
FROM 
	CTE AS C
CROSS JOIN [raw].[LondonCrimes] AS L
go
-- Create view for Latitude of London crimes
go
create view [vw_latstatanalysis] as
SELECT * FROM [raw].[latanalysis]
go

-- Create view for Crime IDs of London crimes **THIS DOESN'T RUN IN EXCEL NOR WILL LOCATION
go
create view [vw_countofcrimeids] as (
SELECT DISTINCT
	 [Crime ID]
	,COUNT(*) over (partition by [Crime ID]) as [CrimeIDCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Create view for LSOA codes of London crimes 
go
create view [vw_countofLSOAcodes] as (
SELECT DISTINCT
	 [LSOA code]
	,COUNT(*) over (partition by [LSOA code]) as [LSOAcodeCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Create view for LSOA names of London crimes 
go
create view [vw_countofLSOAnames] as (
SELECT DISTINCT
	 [LSOA name]
	,COUNT(*) over (partition by [LSOA name]) as [LSOAnameCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Create view for Crime types of London crimes 
go
create view [vw_countofcrimetypes] as (
SELECT DISTINCT
	 [Crime type]
	,COUNT(*) over (partition by [Crime type]) as [CrimeTypeCount]
FROM
	[raw].[LondonCrimes]
)
go

-- Create view for Context of London crimes 
go
create view [vw_countofcontext] as (
SELECT DISTINCT
	 [Context]
	,COUNT(*) over (partition by [Context]) as [ContextCount]
FROM
	[raw].[LondonCrimes]
)
go


--SELECT distinct
--	 [LSOA name]
--	--,[Latitude]
--	--,[Longitude]
--FROM
--	[trash].[crimedataraw]
--WHERE 
--		CAST([Longitude] as float) BETWEEN -0.49 AND 0.31
--	AND cast([Latitude] as float) BETWEEN 51.28 AND 51.69

--EXCEPT

--SELECT
--[LSOA name]--,[Latitude],[Longitude]
--FROM [raw].[LondonCrimes]
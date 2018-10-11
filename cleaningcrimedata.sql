use crimeproject
go

-- Cleaning the original crime data

select
	   [Crime ID]
	  ,[Month]
	  ,[Reported by]
	  ,[Falls within]
	  ,[Longitude]
	  ,[Latitude]
	  ,[Location]
	  ,[LSOA code]
	  ,[LSOA name]
	  ,[Crime type]
	  ,[Last outcome category]
	  ,[Context]
-- Adding columns for Month, Year and Season based on date of crime
	--,datepart(mm, cast([Month]+'-01' as date)) as [month]
	--,datepart(yyyy, cast([Month]+'-01' as date)) as [year]
	--,CASE
	--	WHEN datepart(mm, cast([Month]+'-01' as date)) IN (12, 1, 2) THEN 'Winter'
	--	WHEN datepart(mm, cast([Month]+'-01' as date)) IN (3, 4, 5) THEN 'Spring'
	--	WHEN datepart(mm, cast([Month]+'-01' as date)) IN (6, 7, 8) THEN 'Summer'
	--	WHEN datepart(mm, cast([Month]+'-01' as date)) IN (9, 10, 11) THEN 'Autumn'
	-- END as [season]
	--,left([LSOA name], len([LSOA name]) - 5) as [Borough]
from [raw].[crimedataraw]

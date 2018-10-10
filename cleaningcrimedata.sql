use crimeproject
go

select top 500
	 *
	,datepart(mm, cast([Month]+'-01' as date)) as [month]
	,datepart(yyyy, cast([Month]+'-01' as date)) as [year]
	,CASE
		WHEN datepart(mm, cast([Month]+'-01' as date)) IN (12, 1, 2) THEN 'Winter'
		WHEN datepart(mm, cast([Month]+'-01' as date)) IN (3, 4, 5) THEN 'Spring'
		WHEN datepart(mm, cast([Month]+'-01' as date)) IN (6, 7, 8) THEN 'Summer'
		WHEN datepart(mm, cast([Month]+'-01' as date)) IN (9, 10, 11) THEN 'Autumn'
	 END as [season]
	,[LSOA code]
	,left([LSOA name], len([LSOA name]) - 5) as [Borough]
--    ,geography::STPointFromText('POINT(' + [Longitude] + ' ' + [Latitude] + ')',4326) [location point]
--into [dbo].[cleancrime]
from [dbo].[crimedataraw]
--where cast([Longitude] as float) not between -0.4945 and 0.2692
--    or cast([Latitude] as float) not between 51.264 and 51.7145
where 
	 [LSOA NAME] like('%London%')
or [LSOA NAME] like('%City of Westminster%')
or [LSOA NAME] like('%Kensington and Chelsea%')
or [LSOA NAME] like('%Hammersmith and Fulham%')
or [LSOA NAME] like('%Wandsworth%')
or [LSOA NAME] like('%Lambeth%')
or [LSOA NAME] like('%Southwark%')
or [LSOA NAME] like('%Tower Hamlets%')
or [LSOA NAME] like('%Hackney%')
or [LSOA NAME] like('%Islington%')
or [LSOA NAME] like('%Camden%')
or [LSOA NAME] like('%Brent%')
or [LSOA NAME] like('%Ealing%')
or [LSOA NAME] like('%Hounslow%')
or [LSOA NAME] like('%Richmond upon Thames%')
or [LSOA NAME] like('%Kingston upon Thames%')
or [LSOA NAME] like('%Merton%')
or [LSOA NAME] like('%Sutton%')
or [LSOA NAME] like('%Croydon%')
or [LSOA NAME] like('%Bromley%')
or [LSOA NAME] like('%Lewisham%')
or [LSOA NAME] like('%Greenwich%')
or [LSOA NAME] like('%Bexley%')
or [LSOA NAME] like('%Havering%')
or [LSOA NAME] like('%Barking and Dagenham%')
or [LSOA NAME] like('%Redbridge%')
or [LSOA NAME] like('%Newham%')
or [LSOA NAME] like('%Waltham Forest%')
or [LSOA NAME] like('%Haringey%')
or [LSOA NAME] like('%Enfield%')
or [LSOA NAME] like('%Barnet%')
or [LSOA NAME] like('%Harrow%')
or [LSOA NAME] like('%Hillingdon%')


go
ALTER view vw_dirtycrimeid as 
SELECT [Crime ID]
FROM [dbo].[crimedataraw]
WHERE  [LSOA NAME] like('%London%')
	or [LSOA NAME] like('%City of Westminster%')
	or [LSOA NAME] like('%Kensington and Chelsea%')
	or [LSOA NAME] like('%Hammersmith and Fulham%')
	or [LSOA NAME] like('%Wandsworth%')
	or [LSOA NAME] like('%Lambeth%')
	or [LSOA NAME] like('%Southwark%')
	or [LSOA NAME] like('%Tower Hamlets%')
	or [LSOA NAME] like('%Hackney%')
	or [LSOA NAME] like('%Islington%')
	or [LSOA NAME] like('%Camden%')
	or [LSOA NAME] like('%Brent%')
	or [LSOA NAME] like('%Ealing%')
	or [LSOA NAME] like('%Hounslow%')
	or [LSOA NAME] like('%Richmond upon Thames%')
	or [LSOA NAME] like('%Kingston upon Thames%')
	or [LSOA NAME] like('%Merton%')
	or [LSOA NAME] like('%Sutton%')
	or [LSOA NAME] like('%Croydon%')
	or [LSOA NAME] like('%Bromley%')
	or [LSOA NAME] like('%Lewisham%')
	or [LSOA NAME] like('%Greenwich%')
	or [LSOA NAME] like('%Bexley%')
	or [LSOA NAME] like('%Havering%')
	or [LSOA NAME] like('%Barking and Dagenham%')
	or [LSOA NAME] like('%Redbridge%')
	or [LSOA NAME] like('%Newham%')
	or [LSOA NAME] like('%Waltham Forest%')
	or [LSOA NAME] like('%Haringey%')
	or [LSOA NAME] like('%Enfield%')
	or [LSOA NAME] like('%Barnet%')
	or [LSOA NAME] like('%Harrow%')
	or [LSOA NAME] like('%Hillingdon%')
go
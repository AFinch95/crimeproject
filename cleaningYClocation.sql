-- Cleaning YC location data
delete 
FROM [raw].[yclocationsraw]
WHERE [Name] = 'XXX'

-- After running the code on http://postcodes.io/ these postcodes did not return Lat, Long data although personal search of the web did so update them

UPDATE [raw].[YCLatLong]
SET [Latitude] = '51.56069', [Longitude] = '0.1503'
WHERE [Query] = 'RM10 7AY'

UPDATE [raw].[YCLatLong]
SET [Latitude] = '51.48964', [Longitude] = '0.06795'
WHERE [Query] = 'SE18 6EW'

UPDATE [raw].[YCLatLong]
SET [Latitude] = '51.5056', [Longitude] = '-0.09235'
WHERE [Query] = 'SE1 9EL'

-- Clean the YC location data and insert it into a new table

if object_id('[clean].[yclocations]') is not null
drop table [clean].[yclocations]

;with CTE as(
SELECT
	 CAST(REPLACE(REPLACE(LTRIM(RTRIM([Borough ])), CHAR(13), ''), CHAR(10), '') AS varchar(22)) as [BoroughName] -- There was data with trailing and leading whitespace including line breaks which the replace takes account for
	,CASE
		WHEN UPPER(REPLACE(REPLACE(LTRIM(RTRIM([Funded 2017/18 ])), CHAR(13), ''), CHAR(10), '')) = 'Y'
		THEN 0
		WHEN UPPER(REPLACE(REPLACE(LTRIM(RTRIM([Cut since 2011 ])), CHAR(13), ''), CHAR(10), '')) = 'Y'
		THEN 1
		ELSE -99
	 END as cutsince2011flag
	,CAST(REPLACE(REPLACE(LTRIM(RTRIM([Name])), CHAR(13), ''), CHAR(10), '') as varchar(100)) as YCName
	,CAST(REPLACE(REPLACE(LTRIM(RTRIM([Address])), CHAR(13), ''), CHAR(10), '') as varchar(48)) as YCAddress
	,CAST(REPLACE(REPLACE(LTRIM(RTRIM([Postcode ])), CHAR(13), ''), CHAR(10), '') as varchar(10)) as YCPostCode
	,CASE
	WHEN UPPER(REPLACE(REPLACE(LTRIM(RTRIM([VCS run but supported by the council ])), CHAR(13), ''), CHAR(10), '')) = 'Y'
	THEN 1
	ELSE 0
	END as VolunteerYCSupportedByCouncilFlag
FROM [raw].[yclocationsraw]
)
-- Cross join with table created from http://postcodes.io/ with Lat, Long data for YCs
SELECT DISTINCT
	 yc.[BoroughName]
	,yc.YCName
	,yc.YCAddress
	,yc.YCPostCode
	,ll.[Latitude] as [Latitude]
	,ll.[Longitude] as [Longitude]
	,ll.[Lsoa]
	,ll.[Parliamentary Constituency]
	,yc.VolunteerYCSupportedByCouncilFlag
INTO [clean].[yclocations]
FROM CTE as yc
INNER JOIN [raw].[YCLatLong] ll ON yc.YCPostCode = ll.[Query]
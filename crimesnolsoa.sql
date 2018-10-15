use crimeproject;
if OBJECT_ID('[raw].[crimesnolsoa]') is not null
drop table [raw].[crimesnolsoa]

-- Finding crimes which were filtered out by the original cull
SELECT *
INTO [raw].[crimesnolsoa]
FROM [trash].[crimedataraw]
WHERE 1=1
-- All crimes which did not have LSOA data were culled
	AND nullif([LSOA name], '') is null
-- Ignore the crime if there is no long, lat data (as could not analyse anyway)
	AND nullif([Longitude], '') is not null
	AND nullif([Latitude], '') is not null
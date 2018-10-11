--Creating Views for histogram analysis in Excel


create view [vw_countofoutcome] as (
SELECT DISTINCT
	[Last outcome category]
	,COUNT(*) over (partition by [Last outcome category]) as [Count]
FROM
[raw].[crimedataraw]
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
)
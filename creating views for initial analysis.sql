--Creating Views for histogram analysis in Excel


create view [vw_countofoutcome] as (
SELECT DISTINCT
	[Last outcome category]
	,COUNT(*) over (partition by [Last outcome category]) as [Count]
FROM
	[raw].[LondonCrimes]
)
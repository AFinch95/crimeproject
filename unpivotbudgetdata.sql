SELECT
	 F1 as Borough
	,[Financial Year]
	,Budget
FROM 
(SELECT
	*
FROM
	[raw].[youthservicesbudgetsraw]
) r
unpivot(
Budget for [Financial Year] in ([2011/12], [2012/13], [2013/14], [2014/15], [2016/17], [2018/19])
) budget
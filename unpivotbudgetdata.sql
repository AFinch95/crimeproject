SELECT
	 F1 as borough
	,[financialyear]
	,budget
FROM 
(SELECT
	*
FROM
	[raw].[youthservicesbudgetsraw]
) r
unpivot(
Budget for [financialyear] in ([2011/12], [2012/13], [2013/14], [2014/15], [2015/16], [2016/17], [2017/18], [2018/19])
) budget

SELECT
	 F1 as borough
	,[financialyear]
	,staffnos
FROM 
(SELECT
	*
FROM
	[raw].[noofstaffraw]
) r
unpivot(
staffnos for [financialyear] in ([2011/12], [2012/13], [2013/14], [2014/15], [2015/16], [2016/17], [2017/18], [2018/19])
) staff
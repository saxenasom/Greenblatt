select pva.symbol, pva.record_date, pva.day_open , pva.high, pva.low, pva.day_close ,splits.ex_date
from pva join splits
on pva.symbol=splits.symbol
where pva.record_date - splits.ex_date between -15 and 15
order by symbol asc,record_date asc


select *
from pva 
where symbol in
	(
		select distinct(symbol) 
 		from eps
	)




	SELECT 
		pva.symbol,
		pva.proxy,
		turnover,
		price,
		report_date,
		interest,
		pbt,
		np,
		eps,
		assets,
		CASE WHEN eps>0 THEN price/eps
		ELSE 10000
		END AS pe,
		CASE WHEN assets>0 THEN (pbt+interest)/assets
		ELSE 0
		END AS roa,
		CASE WHEN assets>0 THEN np/assets 
		ELSE 0
		END AS nroa	
	FROM pva left join 
	(
		SELECT 
			t1.symbol,
			t1.proxy,
			report_date,
			interest,
			pbt,
			np,
			eps,
			assets
		FROM 
		(
			SELECT 
				pva.symbol,
				pva.proxy,
				max(report_date) AS last_report
			FROM pva join reports
			ON pva.symbol=reports.symbol
			AND pva.proxy BETWEEN report_date+CAST('3 Months' AS interval) AND report_date+CAST('14 Months' AS interval)
			GROUP BY pva.symbol,pva.proxy
		)t1 JOIN reports
		ON t1.symbol=reports.symbol
		AND t1.last_report=reports.report_date
	)t2
	ON pva.symbol=t2.symbol
	AND pva.proxy=t2.proxy
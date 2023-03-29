--Calculate metrics
CREATE TABLE final AS(
SELECT 
	pva.symbol,
	pva.proxy,
	pva.price,
	pe,
	roa,
	nroa
FROM pva LEFT JOIN
(
	SELECT 
		t1.symbol,
		t1.proxy,
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
	FROM 
	(
		SELECT 
			pva.symbol,
			pva.proxy,
			pva.price,
			max(report_date) AS last_report
		FROM pva join reports
		ON pva.symbol=reports.symbol
		AND pva.proxy BETWEEN report_date+CAST('3 Months' AS interval) AND report_date+CAST('14 Months' AS interval)
		GROUP BY pva.symbol,pva.proxy,pva.price
	)t1 JOIN reports
	ON t1.symbol=reports.symbol
	AND t1.last_report=reports.report_date
)t2
ON pva.symbol=t2.symbol
AND pva.proxy=t2.proxy
AND pe>5
WHERE pva.symbol in
(
	SELECT DISTINCT(symbol)
	FROM reports
)
);

--Generate ranks
SELECT symbol,
	proxy,
	price,
	ROW_Number() over (partition by proxy order by finrank asc),
	finrank
from
(
	SELECT 
		symbol,
		proxy,
		price,
		rank() OVER (PARTITION BY proxy ORDER BY pe ASC) + rank() OVER (PARTITION BY proxy ORDER BY roa DESC NULLS LAST) AS finrank 	
	FROM final
)t1


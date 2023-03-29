select symbol, record_date, day_open, high, low, day_close
from pva
where 
symbol='CUB' 
and 
record_date < '2018-09-13'
order by record_date desc
limit 90;


select *
from pva_daily
where symbol='ABMINTLTD' 
and date_part('month',record_date)=5
and date_part('year',record_date)=2020;



select *
from pva t1 join pva t2
on t1.symbol=t2.symbol
and make_date(t1.yr,t1.mnth,1) = make_date(t2.yr,t2.mnth,1)+ CAST('1 month' as interval)


SELECT 
	t3.symbol,
	t3.yr,
	t3.mnth,
	t3.turnover,
	pva.turnover AS turnover_prev,
	t3.price,
	t3.proxy,
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
		pva.yr,
		pva.mnth,
		turnover,
		price,
		proxy,
		report_date,
		interest,
		pbt,
		np,
		eps,
		assets
	FROM pva left join 
	(
		SELECT 
			t1.symbol,
			yr,
			mnth,
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
				yr,
				mnth,
				max(report_date) AS last_report
			FROM pva join reports
			ON pva.symbol=reports.symbol
			AND pva.proxy BETWEEN report_date+CAST('3 Months' AS interval) AND report_date+CAST('14 Months' AS interval)
			GROUP BY pva.symbol,yr,mnth
		)t1 JOIN reports
		ON t1.symbol=reports.symbol
		AND t1.last_report=reports.report_date
	)t2
	ON pva.symbol=t2.symbol
	AND pva.yr=t2.yr
	AND pva.mnth=t2.mnth
)t3 left join pva 
on t3.symbol=pva.symbol
and t3.proxy=pva.proxy+CAST('1 Month' AS interval)
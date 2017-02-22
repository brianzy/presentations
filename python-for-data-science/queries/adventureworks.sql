SELECT   TO_CHAR(th.transactiondate, 'YYYY-MM') AS month
       , p.name
       , COUNT(*) AS total
FROM production.transactionhistory th
INNER JOIN production.product p
  ON th.productid = p.productid
WHERE DATE_PART('year', transactiondate) = '2014'
GROUP BY TO_CHAR(th.transactiondate, 'YYYY-MM'), p.name
;
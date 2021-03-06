create table #temptbl
(
    date datetime,
    category varchar(3),
    amount money
)

insert into #temptbl values 
  ('1/1/2012', 'ABC', 1000.00)
, ('2/1/2012', 'DEF', 500.00)
, ('2/1/2012', 'GHI', 800.00)
, ('2/10/2012', 'DEF', 700.00)
, ('3/1/2012', 'ABC', 1100.00)


DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

SET @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.category) 
            FROM #temptbl c
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

set @query = 'SELECT date, ' + @cols + ' from 
            (
                select date
                    , amount
                    , category
                from #temptbl
           ) x
            pivot 
            (
                 max(amount)
                for category in (' + @cols + ')
            ) p '


execute(@query)

drop table #temptbl

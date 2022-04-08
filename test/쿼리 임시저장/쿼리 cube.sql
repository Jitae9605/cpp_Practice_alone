create table cubeTbl(prodName nchar(3), color nchar(2), amount int);
go
insert into cubeTbl values('컴퓨터','검정',11);
insert into cubeTbl values('컴퓨터','파랑',22);
insert into cubeTbl values('모니터','검정',33);
insert into cubeTbl values('모니터','파랑',44);
go
select prodName, color, sum(amount) as[수량합계]
from cubeTbl
group by cube(color, prodName);
-- 다차원 소합계외 합계를 내준다
-- 즉, 여기서 모니터/컴퓨터의 소합계를 내고 이둘을 합한 총합계를 낸다음
-- 색깔별로 다시 합계를 내준다.
use tempdb
-- 문제 1
-- 구구단을 출력하는 프로시저를 작성하세요.
-- 단, 로컬 임시 테이블을 사용하고,
-- 프로시저 실행 후 구구단 전체가 출력이 되도록 하세요.
drop table gugudanTbl
drop procedure proc_gugudan
create table gugudanTbl(i int,j int, res int)
go

create procedure proc_gugudan
as
	declare @i int
	declare @j int
	
	set @i = 0
	set @j = 1

	while(@i < 9) 
	begin
		set @i += 1
		while(@j <= 9) 
		begin
			insert into gugudanTbl values(@i,@j,@i*@j)
			set @j += 1
		end
		set @j = 1
	end
go

exec proc_gugudan;
go

select i as [단], j as [반복], res as [결과] from gugudanTbl
go

-- 문제 2
-- 부서별 매출 순위를 출력하는 프로시저를 작성하세요.
-- 단, 로컬 임시 테이블을 사용해서 부서별 매출 정보를 저장하세요.
-- 부서별 매출 정보는 부서 코드, 매출 수량 입니다.
-- 프로시저 실행 후 부서별 매출 순위가 출력이 되도록 하세요.
drop table sell
drop procedure proc_sell
create table sell(code varchar(1), amount int)
go
insert into sell values('A',100);
insert into sell values('B',70);
insert into sell values('C',50);
insert into sell values('D',70);
insert into sell values('E',85);
go

create procedure proc_sell
as
	declare @i int
	set @i = 1

	while(@i <= 5)
	begin
		select amount from sell order by amount
	 

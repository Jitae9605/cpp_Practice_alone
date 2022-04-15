use tempdb
-- ���� 1
-- �������� ����ϴ� ���ν����� �ۼ��ϼ���.
-- ��, ���� �ӽ� ���̺��� ����ϰ�,
-- ���ν��� ���� �� ������ ��ü�� ����� �ǵ��� �ϼ���.
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

select i as [��], j as [�ݺ�], res as [���] from gugudanTbl
go

-- ���� 2
-- �μ��� ���� ������ ����ϴ� ���ν����� �ۼ��ϼ���.
-- ��, ���� �ӽ� ���̺��� ����ؼ� �μ��� ���� ������ �����ϼ���.
-- �μ��� ���� ������ �μ� �ڵ�, ���� ���� �Դϴ�.
-- ���ν��� ���� �� �μ��� ���� ������ ����� �ǵ��� �ϼ���.
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
	 

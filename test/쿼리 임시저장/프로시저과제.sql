use tempdb
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

	while(@i <= 9) 
	begin
		set @i += 1
		while(@j <= 9) 
		begin
			insert into gugudanTbl values(@i,@j,@i*@j)
			set @j += 1
		end
		
	end
go

exec proc_gugudan;
go

select i as [단], j as [반복], res as [결과] from gugudanTbl

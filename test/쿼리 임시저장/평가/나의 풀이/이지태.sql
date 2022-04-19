
<------------------------------------------- 문제1
use maseter;
go
create database MESDB;
go
create database ERPDB;
go
--------------------------------------------->


use MESDB

<------------------------------------------- 문제3
-- MES 시스템의 생산실적 테이블
create table TB_MES_OQC (
	ProductionDate date,					-- 생산일
	LotNo nvarchar(10) not null unique,		-- 로트넘버
	ModelCd nvarchar(10),					-- 모델코드
	LineCD nvarchar(6),						-- 생산라인코드
	Quantity int,							-- 생산수량
	OqcDate date,							-- 판정일
	OqcResult nvarchar(10)					-- 판정결과
);
go

-- MES 시스템의 생산실적에 대한 ERP 시스템 연계(I/F) 테이블
create table TB_MES_ERP_IF_OQC (
	CreateDate date,					-- 데이터 생성일
	ProductionDate date,				-- 생산일
	LotNo nvarchar(10) not null unique ,			-- 로트넘버
	ModelCd nvarchar(10),				-- 모델코드
	LineCD nvarchar(6),					-- 생산라인코드
	Quantity int,						-- 생산수량
	OqcDate date,						-- 판정일
	OqcResult int,						-- 판정결과
	ErpUpload nchar(1)					-- ERP업로드유무
);
go
--------------------------------------------->


-------------------------------------------- 문제4
use ERPDB
go
-- ERP 시스템의 생산실적 테이블
create table TB_ERP_OQC (
	ProductionDate date,					-- 생산일
	LotNo nvarchar(10) not null,		-- 로트넘버
	ModelCd nvarchar(10),					-- 모델코드
	FactoryCD nvarchar(10) not null,	-- 생산공장코드
	LineCD nvarchar(6),						-- 생산라인코드
	Quantity int,							-- 생산수량
	OqcDate date,							-- 판정일
	OqcResult nvarchar(10),					-- 판정결과
	unique (LotNo,FactoryCD)
);
go

---------------------------------------------


-------------------------------------------- 문제7, 8
use MESDB
go

-- 트리거
-- insert
create trigger trg_OqcResult_insert
on TB_MES_OQC
after insert
as
	declare @inserted_OqcResult varchar(10)
	set @inserted_OqcResult = (select OqcResult from inserted)

	declare @inserted_date date
	set @inserted_date = (select ProductionDate from inserted)

	declare @inserted_LotNo nvarchar(10)
	set @inserted_LotNo = (select LotNo from inserted)

	if (@inserted_OqcResult = 'OK' or @inserted_OqcResult = 'Special OK')
	begin
		insert into TB_MES_ERP_IF_OQC(CreateDate, ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult) 
		select (SELECT CONVERT(date,GETDATE())), ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate,
			case
			when @inserted_OqcResult = 'OK' then 1
			when @inserted_OqcResult = 'Special OK' then 2
			when @inserted_OqcResult = 'NG' then 3
			when @inserted_OqcResult = 'HD' then 4
			when @inserted_OqcResult = 'Reject' then 5
			else 0
			end
		from inserted
		where ProductionDate = @inserted_date and LotNo = @inserted_LotNo

		update TB_MES_ERP_IF_OQC set ERPUpload = 'Y' where @inserted_OqcResult = 'OK' or @inserted_OqcResult = 'Special OK'

		exec proc_uploadERP @inserted_date, @inserted_LotNo
	end
go	

-- update
create trigger trg_OqcResult_update
on TB_MES_OQC
after update
as
	declare @inserted_OqcResult varchar(10)
	set @inserted_OqcResult = (select OqcResult from inserted)

	declare @inserted_date date
	set @inserted_date = (select ProductionDate from inserted)

	declare @inserted_LotNo nvarchar(10)
	set @inserted_LotNo = (select LotNo from inserted)

	declare @deleted_OqcResult varchar(10)
	set @deleted_OqcResult = (select OqcResult from deleted)

	if(@inserted_OqcResult in('OK','Special OK') and @deleted_OqcResult in('NG', 'HD', 'Reject'))
		begin
			insert into TB_MES_ERP_IF_OQC(CreateDate, ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate) 
			select (SELECT CONVERT(date,GETDATE())), ProductionDate, LotNo,ModelCd, LineCD, Quantity,OqcDate 
			from TB_MES_OQC
			where ProductionDate = @inserted_date and LotNo = @inserted_LotNo

		update TB_MES_ERP_IF_OQC set OqcResult = 
		case 
			when @inserted_OqcResult = 'OK' then 1
			when @inserted_OqcResult = 'Special OK' then 2
			else 0
		end
		where LotNo = @inserted_LotNo

		update TB_MES_ERP_IF_OQC set ERPUpload = 'Y' where @inserted_OqcResult = 'OK' or @inserted_OqcResult = 'Special OK'

		exec proc_uploadERP @inserted_date, @inserted_LotNo
		end
		

	
go

-- 프로시저
-- I/F -> ERP
create procedure dbo.proc_uploadERP
	@ProductionDate date,
	@LotNo nvarchar(10)
as
begin
	insert into ERPDB.dbo.TB_ERP_OQC (ProductionDate,LotNo,ModelCd,FactoryCD, LineCD,Quantity,OqcDate,OqcResult)
	select ProductionDate, LotNo, ModelCd,'PUSAN', LineCD,Quantity,OqcDate,OqcResult 
		from MESDB.dbo.TB_MES_ERP_IF_OQC 
		where ProductionDate = @ProductionDate and LotNo = @LotNo;

end
go
---------------------------------------------


-------------------------------------------- 문제9, 10

-- insert 실행
insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A1','Model A1','A1',100,'2022-04-19','OK')

insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A2','Model A2','A2',300,'2022-04-19','Special OK')

insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A7','Model A7','A7',700,'2022-04-19','NG')

insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A4','Model A4','A4',700,'2022-04-19','Reject')

-- update 실행
update TB_MES_OQC set OqcResult = 'OK' where LotNo = '20220419A7'
update TB_MES_OQC set OqcResult = 'Special OK' where LotNo = '20220419A4'

-- 결과조회
select * from TB_MES_OQC
select * from TB_MES_ERP_IF_OQC
select * from ERPDB.dbo.TB_ERP_OQC

---------------------------------------------
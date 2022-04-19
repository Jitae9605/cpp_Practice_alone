use MESDB

-- MES �ý����� ������� ���̺�
create table TB_MES_OQC (
	ProductionDate date,					-- ������
	LotNo nvarchar(10) not null unique,		-- ��Ʈ�ѹ�
	ModelCd nvarchar(10),					-- ���ڵ�
	LineCD nvarchar(6),						-- ��������ڵ�
	Quantity int,							-- �������
	OqcDate date,							-- ������
	OqcResult nvarchar(10)					-- �������
);
go

-- MES �ý����� ��������� ���� ERP �ý��� ����(I/F) ���̺�
create table TB_MES_ERP_IF_OQC (
	CreateDate date,					-- ������ ������
	ProductionDate date,				-- ������
	LotNo nvarchar(10) not null unique ,			-- ��Ʈ�ѹ�
	ModelCd nvarchar(10),				-- ���ڵ�
	LineCD nvarchar(6),					-- ��������ڵ�
	Quantity int,						-- �������
	OqcDate date,						-- ������
	OqcResult int,						-- �������
	ErpUpload nchar(1)					-- ERP���ε�����
);
go

use ERPDB
go

-- ERP �ý����� ������� ���̺�
create table TB_ERP_OQC (
	ProductionDate date,					-- ������
	LotNo nvarchar(10) not null,		-- ��Ʈ�ѹ�
	ModelCd nvarchar(10),					-- ���ڵ�
	FactoryCD nvarchar(10) not null,	-- ��������ڵ�
	LineCD nvarchar(6),						-- ��������ڵ�
	Quantity int,							-- �������
	OqcDate date,							-- ������
	OqcResult nvarchar(10),					-- �������
	unique (LotNo,FactoryCD)
);
go
 
use MESDB
go

-- Ʈ����
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

-- ���ν���
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

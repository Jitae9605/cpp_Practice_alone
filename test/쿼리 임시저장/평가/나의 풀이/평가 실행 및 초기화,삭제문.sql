-- insert ����
insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A1','Model A1','A1',100,'2022-04-19','OK')

insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A2','Model A2','A2',300,'2022-04-19','Special OK')

insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A7','Model A7','A7',700,'2022-04-19','NG')

insert into MESDB.dbo.TB_MES_OQC(ProductionDate,LotNo,ModelCd,LineCD,Quantity,OqcDate,OqcResult)
values('2022-04-19','20220419A4','Model A4','A4',700,'2022-04-19','Reject')

-- update ����
update TB_MES_OQC set OqcResult = 'OK' where LotNo = '20220419A7'
update TB_MES_OQC set OqcResult = 'Special OK' where LotNo = '20220419A4'

-- �����ȸ
select * from TB_MES_OQC
select * from TB_MES_ERP_IF_OQC
select * from ERPDB.dbo.TB_ERP_OQC


-- ��� ���� ����(�� ������ ����/����� ���� �ʿ��Ҷ� �̰� �ѹ� ����)
-- ���̺�/Ʈ����/���ν��� ���� ���(�ʱ�ȭ �� ����)
 drop procedure proc_uploadERP
 drop trigger trg_OqcResult_insert
 drop trigger trg_OqcResult_update
 drop table ERPDB.dbo.TB_ERP_OQC
 drop table TB_MES_ERP_IF_OQC
 drop table TB_MES_OQC


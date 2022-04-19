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


-- 얘는 따로 실행(다 끝나고 수정/재실행 등이 필요할때 이거 한번 실행)
-- 테이블/트리거/프로시저 전부 드랍(초기화 및 삭제)
 drop procedure proc_uploadERP
 drop trigger trg_OqcResult_insert
 drop trigger trg_OqcResult_update
 drop table ERPDB.dbo.TB_ERP_OQC
 drop table TB_MES_ERP_IF_OQC
 drop table TB_MES_OQC


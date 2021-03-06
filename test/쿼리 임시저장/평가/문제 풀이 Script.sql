
use maseter;
go
create database MES;
go
create database ERP;
go




use MES;
go
create schema OQC;
go
use ERP;
go
create schema OQC;
go






use MES;
go
create table OQC.TB_MES_OQC 
( ProductionDate date, LotNo varchar(10),  
ModelCd varchar(10), LineCD varchar(6), 
Quantity int, OqcDate date, 
OqcResult varchar(10), 
primary key(LotNo));
go
create table OQC.TB_MES_ERP_IF_OQC 
( ProductionDate date, LotNo varchar(10),  
ModelCd varchar(10), LineCD varchar(6), 
Quantity int, OqcDate date, OqcResult int,
ErpUpload char(1),
primary key(LotNo));
go

use ERP;
go
create table OQC.TB_ERP_OQC 
( ProductionDate date, LotNo varchar(10),  
ModelCd varchar(10), FactoryCD varchar(10), 
LineCD varchar(6), 
Quantity int, OqcDate date, 
OqcResult int, 
primary key(LotNo, FactoryCD));
go





use MES;
go
create synonym TB_MES_OQC
FOR MES.OQC.TB_MES_OQC;
create synonym TB_MES_ERP_IF_OQC
FOR MES.OQC.TB_MES_ERP_IF_OQC;
create synonym TB_ERP_OQC
FOR ERP.OQC.TB_ERP_OQC;






use MES;
go
CREATE FUNCTION OQC.ufn_getOqcResultCode(
    @oqcResult varchar(10)
)
return int
as
    BEGIN
       declare @oqcResultCd INT

       set @oqcResultCd =
          CASE
	     WHEN ( @oqcResult = 'OK' ) THEN 1
	     WHEN ( @oqcResult = 'Special OK' ) THEN 2
	     WHEN ( @oqcResult = 'NG' ) THEN 3
	     WHEN ( @oqcResult = 'HD' ) THEN 4
	     WHEN ( @oqcResult = 'Reject' ) THEN 5
	     ELSE 0
          END;

       return (@oqcResultCd); 
    END
go






use MES;
go
create TRIGGER TRG_TB_MES_OQC_INSERT_UPDATE
on OQC.TB_MES_OQC
AFTER INSERT, UPDATE
as
BEGIN
    declare @oqcResult varchar(10)

    set @oqcResult = ( select OqcResult from inserted )

    if OQC.ufn_getOqcResultCode(@oqcResult) < 3
        begin
           INSERT INTO TB_MES_ERP_IF_OQC
              (ProductionDate, LotNo, ModelCd, 
               LineCD, Quantity, OqcDate, OqcResult)
	   select ProductionDate, LotNo, ModelCd, 
               LineCD, Quantity, OqcDate, 
			   OQC.ufn_getOqcResultCode( OqcResult )
             from inserted;
        end

END





use MES;
go
insert into TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
values ( getdate(), '20220419A1', 'Model A1', 'A1', 100, getdate(), 'OK');
go
insert into TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
values ( getdate(), '20220419A2', 'Model A2', 'A2', 300, getdate(), 'Special OK');
go
insert into TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
values ( getdate(), '20220419A7', 'Model A7', 'A7', 700, getdate(), 'NG');
go
insert into TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
values ( getdate(), '20220419B1', 'Model B1', 'A3', 100, getdate(), 'HD');
go
insert into TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
values ( getdate(), '20220419B2', 'Model B2', 'A3', 100, getdate(), 'Reject');
go
insert into TB_MES_OQC 
       ( ProductionDate, LotNo, ModelCd, LineCD, Quantity, OqcDate, OqcResult )
values ( getdate(), '20220419F1', 'Model F1', 'A4', 450, getdate(), 'Reject');
go






update TB_MES_OQC
   set OqcResult = 'OK'
 where LotNo = '20220419F1';
 go






create procedure OQC.sp_oqcUpload
    @p_in_lotNo varchar(10), 
    @p_in_proDate varchar(10)
as
begin

    declare @v_processResult int
    set @v_processResult = 1

    declare @v_prodResultCnt int
    set @v_prodResultCnt = 0

    set @v_prodResultCnt = 
       (
           select count(*)
             from TB_MES_ERP_IF_OQC
            where LotNo = @p_in_lotNo
              and CONVERT(NVARCHAR, ProductionDate, 23) = @p_in_proDate
              and erpupload is null
              and oqcresult in (1, 2)
       );
    
    if @v_prodResultCnt = 0
       begin
          print(concat(N'???????? ?????? ????????.','( Lot No : ',@p_in_lotNo,' )'));
	  return
       end
    
    begin tran
       insert into TB_ERP_OQC
                   (ProductionDate, LotNo, ModelCd, FactoryCD,
                     LineCD, Quantity, OqcDate, OqcResult
                    )
       select ProductionDate, LotNo, ModelCd, 'PUSAN', LineCD, 
	      Quantity, OqcDate, OqcResult
         from TB_MES_ERP_IF_OQC
	where LotNo = @p_in_lotNo
          and CONVERT(NVARCHAR, ProductionDate, 23) = @p_in_proDate
          and erpupload is null
          and oqcresult in (1, 2);
  

       if @@ERROR <> 0 or @@ROWCOUNT <> 1  
          begin
             set @v_processResult = 0
	  end
       
       if @v_processResult = 1
          begin
            update TB_MES_ERP_IF_OQC
               set ErpUpload = 'Y'
             where LotNo = @p_in_lotNo;
	  end

       if @@ERROR <> 0 or @@ROWCOUNT <> 1  
          begin
             set @v_processResult = 0
	  end


       if @v_processResult = 1
	  begin
             commit tran
             print(concat(N'MES ?????????? ERP?? ?????????? ????????????????.','( Lot No : ',@p_in_lotNo,' )'));
          end
       else
	  begin
             rollback tran
             print(concat(N'MES ?????????? ERP?? ?????????? ?????? ????????????.','( Lot No : ',@p_in_lotNo,' )'));
          end
end




exec OQC.oqc_upload @p_in_lotNo ='20220419A1', @p_in_proDate = '2022-04-19';


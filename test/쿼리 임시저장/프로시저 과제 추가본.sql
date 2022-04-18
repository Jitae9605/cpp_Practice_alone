-- 추가문제 1
-- 문제의 요구사항을 확인 후, 프로시저를 작성하세요.
-- 문제에서 사용할 테이블은 아래와 같습니다.

-- create table T매출 (
-- 일자 nvarchar(8),
-- 제품 nvarchar(30),
-- 수량 int default 0,
-- primary key (일자, 제품)
-- )
-- go

-- insert into T매출(일자, 제품, 수량)
-- values ('20200101', 'A1', 10), ('20200102', 'A2', 20)
-- go

-- 아래는 요구사항입니다.
-- 1. update, delete 를 하나의 트랜잭션으로 관리합니다.
-- 2. 각 DML 문장의 성공 결과는 시스템 변수를 확인합니다.
-- 3. 참조할 시스템 변수는 @@ERROR, @@ROWCOUNT
--		이고, 트랜잭션의 완료와 취소는 아래를 참고하세요.
--  1) @@ERROR <> 0 또는 @@ROWCOUNT <> 1 아니면
--		모두 취소이고, 그외는 모두 완료가 되도록 합니다.
--  2) 트랜잭션이 완료 또는 취소 후의 데이터를 출력합니다.
--  3) T매출 테이블에 대한 update 문장의 실행 조건입니다.
--		조건의 일자, 제품은 각각 '20200101', 'A1' 입니다.
--  4) T매출 테이블에 대한 delete 문장의 실행 조건입니다.
--		조건의 일자, 제품은 각각 '20200105', 'A5' 입니다.

create table T매출 (
일자 nvarchar(8),
제품 nvarchar(30),
수량 int default 0,
primary key (일자, 제품)
)
go

insert into T매출(일자, 제품, 수량)
values ('20200101', 'A1', 10), ('20200102', 'A2', 20)
go

select * from T매출 
go
drop procedure hr.proc_assign
go
create procedure hr.proc_assign
as
	begin transaction
	update T매출 set 제품 = 'A1' where 일자 = '20200101'
	delete from T매출 where 일자 = '20200105' and 제품 = 'A5'

	if (@@error <> 0 or @@ROWCOUNT <> 1)
	begin
		print('모두 취소')
		rollback tran
		select * from T매출
	end
	else
	begin
		print('모두 완료')
		commit transaction
		select * from T매출
	end
	commit transaction
go


exec hr.proc_assign
go

-- 추가문제 2

-- 문제의 요구사항을 확인 후, 프로시저를 작성하세요.
-- 문제에서 사용할 임시 로컬 테이블은 아래와 같습니다.

CREATE TABLE #T제품 (
제품코드 NVARCHAR(30)
,제품명 NVARCHAR(30)
)

INSERT INTO #T제품 (제품코드, 제품명)
VALUES ('A2', '당근') , ('A1', '사과'), ('A4', '레몬'),
('A3', '포도'), ('A5', '양파'), ('A9', '상추'),
('A7', '감자'), ('A6', '고추') ,('A8', '버섯')

select * from #T제품
go

create procedure proc_product
as
	delete from #T제품 where 제품코드 in ('A2','A1','A3')
	select * from #T제품 order by 제품코드
	select * from #T제품 where 제품코드 in ('A4','A5')
go

exec proc_product
go

-- 추가문제 3
-- 문제의 요구사항을 확인 후, 프로시저를 작성하세요.
-- 아래의 프로시저는 커서를 사용하고 있습니다.
-- 아래의 코드에서 커서를 사용하지 않고 동일하게 실행이 되도록
-- 새로은 프로시저를 작성하세요.
CREATE PROCEDURE SP_CURSOR
AS
	BEGIN
		CREATE TABLE #T작업1 (
			코드 NVARCHAR(10),
			수량 NUMERIC(18,0)
		)
		
		INSERT INTO #T작업1 (코드, 수량)
			VALUES ('A1', 10), ('A2', 20), ('A3', 30)
		
		DECLARE 커서1 CURSOR FOR	-- 커서정의
			SELECT A.코드, A.수량		
				FROM #T작업1 A
				WHERE A.코드 < 'A3'
				ORDER BY 수량 DESC
		
		OPEN 커서1;
		
		DECLARE @커서1_코드 NVARCHAR(10)
			,@커서1_수량 NUMERIC(18,0)
		
		WHILE (1 = 1) BEGIN
			FETCH NEXT FROM 커서1 INTO @커서1_코드, @커서1_수량
			
			IF @@FETCH_STATUS <> 0 BREAK
			
			SELECT 코드 = @커서1_코드,수량 = @커서1_수량
		
		END;
		
		CLOSE 커서1
		
		DEALLOCATE 커서1
		
		DROP TABLE #T작업1
	END
go

exec SP_CURSOR

-- 추가문제 4
-- 문제의 요구사항을 확인 후, 프로시저를 작성하세요.
-- 문제에서 사용할 임시 로컬 테이블은 아래와 같습니다.

CREATE TABLE #제품 (
제품코드 NVARCHAR(20),
제품명 NVARCHAR(20)
)

INSERT INTO #제품 (제품코드, 제품명)
VALUES ('A','사과'), ('B','포도'), ('C','딸기'),
('D','수박'), ('E','참외')
go

CREATE TABLE #매입 (
제품코드 NVARCHAR(20),
매입일자 NVARCHAR(20),
매입수량 NUMERIC(18,0) default 0
)

INSERT INTO #매입 (제품코드, 매입일자, 매입수량)
VALUES ('A', '20191201', 100), ('A', '20200103', 200),
('B', '20200201', 300), ('C', '20200105', 400),
('D', '20200107', 500)
go

CREATE TABLE #매출 (
제품코드 NVARCHAR(20),
매출일자 NVARCHAR(20),
매출수량 NUMERIC(18,0) default 0
)

INSERT INTO #매출 (제품코드, 매출일자, 매출수량)
VALUES ('A', '20191220', 10), ('A', '20200103', 20),
('B', '20200305', 30), ('B', '20200217', 40),
('C', '20200220', 50)
-- 아래는 프로시저를 실행하여 특정 기간의 재고 수불 정보를 조회
-- 한 결과입니다. 재고수불 조회 검색 조건은 다음과 같습니다.
--	수불 검색 시작일 : 20200101
--	수불 검색 종료일 : 20200131
go
-- select * from #매입
go

create procedure proc_jago 
	@start_date NVARCHAR(20),
	@end_date NVARCHAR(20)
as
	declare @기초수량 table
	(
	제품코드 NVARCHAR(20),
	기초수량 NUMERIC(18,0) default 0
	)

	insert into @기초수량
		select P.제품코드,isnull(sum(I.매입수량)- sum(O.매출수량),0)
		from #제품 P
		left outer join #매입 I
			on P.제품코드 = I.제품코드 and @start_date > I.매입일자
		left outer join #매출 O
			on P.제품코드 = O.제품코드 and @start_date > O.매출일자
		group by P.제품코드

	declare @매입수량 table
		(
	제품코드 NVARCHAR(20),
	매입수량 NUMERIC(18,0) default 0
	)

	insert into @매입수량
		select P.제품코드,isnull(sum(I.매입수량),0)
		from #제품 P
		left outer join #매입 I
			on P.제품코드 = I.제품코드 and @start_date < I.매입일자 and @end_date > I.매입일자
		group by P.제품코드
	
	declare @매출수량 table
	(
	제품코드 NVARCHAR(20),
	매출수량 NUMERIC(18,0) default 0
	)

	insert into @매출수량
		select P.제품코드,isnull(sum(O.매출수량),0)
		from #제품 P
		left outer join #매출 O
			on P.제품코드 = O.제품코드 and @start_date < O.매출일자 and @end_date > O.매출일자
		group by P.제품코드
	
	select P.제품코드, P.제품명,
	isnull(T1.기초수량,0) as [기초수량],
	isnull(T2.매입수량,0) as [매입수량],
	isnull(T3.매출수량,0) as [매출수량],
	기초수량 + 매입수량 - 매출수량 as [기말수량]
	from #제품 P
	inner join @기초수량 T1
	on P.제품코드 = T1.제품코드
	inner join @매입수량 T2
	on P.제품코드 = T2.제품코드
	inner join @매출수량 T3
	on P.제품코드 = T3.제품코드
go

exec proc_jago '20200101','20200131'
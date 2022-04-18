
-- 추가문제 4
-- 문제의 요구사항을 확인 후, 프로시저를 작성하세요.
-- 문제에서 사용할 임시 로컬 테이블은 아래와 같습니다.
drop table #매입
drop table #매출
drop table #제품

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
-- select * from #제품
-- select * from #매입
-- select * from #매출
-- go

--create procedure proc_jago 
--	@start_date NVARCHAR(20),
--	@end_date NVARCHAR(20)
--as	

	declare @start_date NVARCHAR(20)
	set @start_date = '20200101'
	declare @end_date NVARCHAR(20)
	set @end_date = '20200131'
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

	 
	 
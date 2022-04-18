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
drop procedure proc_assign
create procedure proc_assign
as
	
	if (@@error <> 0 or @@ROWCOUNT<>1)
	begin
		print('모두 취소')
		rollback tran
		select * from T매출
	end
	else
	begin
		print('모두 완료')
		select * from T매출
	end
go










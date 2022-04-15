-- 테이블 생성
create table orderTbl	-- 구매테이블
(
orderNo int identity,	-- 구매일련번호
userID nvarchar(5),		-- 구매회원아이디
prodName nvarchar(5),	-- 구매한 물건
orderAmount int			-- 구매한 갯수
);
go

create table prodTbl	-- 물품테이블
(
prodName nvarchar(5),	-- 물건 이름
account int				-- 물건 갯수
);
go

create table deliverTbl	-- 배송테이블
(
deliverNo int identity,	-- 배송일련번호
prodName nvarchar(5),	-- 배송할 물건
amount int				-- 배송할 물건갯수
);
go

-- 물품테이블에 생플삽입
insert into prodTbl values(N'사과',100);
insert into prodTbl values(N'배',100);
insert into prodTbl values(N'귤',100);

-- 재귀트리거 실습용 테이블 생성
create table recuA (id int identity, txt nvarchar(10));	-- 간접 재귀 트리거용 테이블A
go
create table recuB (id int identity, txt nvarchar(10));	-- 간접 재귀 트리거용 테이블B
go
create table recuC (id int identity, txt nvarchar(10));	-- 간접 재귀 트리거용 테이블C
go

-- 물품테이블에서 갯수를 감소시키는 트리거
create trigger trg_order
on orderTbl
after insert
as
	print N'1. trg_order를 실행합니다.'
	declare @orderAmount int
	declare @prodName nvarchar(5)

	select @orderAmount = orderAmount from inserted
	select @prodName = prodName from inserted
	
	update prodTbl set account -= @orderAmount
		where prodName = @prodName;
go

-- 배송테이블에 새 배송건을 입력하는 트리거
create trigger trg_prod
on prodTbl
after update
as
	print N'2. trg_prod를 실행합니다.'
	declare @prodName varchar(5)
	declare @amount int

	select @prodName = prodName from inserted
	select @amount =D.account - I.account		-- 변경전의 개수 - 변경후의 개수 = 주문 개수 
		from inserted I, deleted D

	 insert into deliverTbl(prodName,amount) values(@prodName,@amount);
go

-- 고객이 물품을 구매
insert into orderTbl values('JOHN',N'배',5);
go

select * from orderTbl;
select * from prodTbl;
select * from deliverTbl;
go



-- 1.1 after 트리거
-- 임시 실습테이블 생성
use tempdb
create table testTbl (id int, txt nvarchar(5));
go

-- 임시데이터 입력
insert into testTbl values(1, N'원더걸스');
insert into testTbl values(2, N'애프터스쿨');
insert into testTbl values(3, N'에이오에이');
go

-- 트리거 생성
create trigger testTrg -- 트리거이름
on testTbl	-- 트리거를 부착할 테이블
after delete, update -- 삭제/수정후에 작동
as
	print(N'트리거가 작동했습니다.');	-- 트리거 발동시 실행될 sql문

go

-- 트리거 발동
insert into testTbl values(4,N'나인뮤지스');
update testTbl set txt = N'에[이핑크'where id = 3;	-- 트리거 발동
delete testTbl where id = 4;		-- 트리거 발동
go

-- 기존의 테이블을 삭제하고 새로운 테이블(백업테이블)을 정의
use sqldb;
drop table buyTbl;
go

create table backup_userTbl
(
userID char (8) not null primary key,
name nvarchar(10) not null,
birthYear int not null,
addr nchar(2) not null,
mobile1 char(3),
mobile2 char(8),
height smallint,
mDate date,
modType nchar(2),	-- 변경된 타입.(수정 or 삭제)
modDate date,		--  변경한 날짜
modUser nvarchar(256) -- 변경한 사용자
)
go

-- 트리거 생성
create trigger trg_BackupUserTbl -- 트리거이름
on userTbl						 -- 트리거 부착할 테이블 지정
after update,delete				-- 트리거 발동 시기(after)와 조건(update,delete)
as
	declare @modType nchar(2) -- 변경타입

	if	(COLUMNS_UPDATED() > 0 ) -- 업데이트 되었다면
		begin
			set @modType = N'수정'
		end
	else						-- 삭제되었다면
		begin
			set @modType = N'삭제'
		end
	-- delete테이블의 내용(변경전 내용을 백업테이블에 삽입)
	insert into backup_userTbl	
		select userID, name,birthday, addr, mobile1, mobile2, height, mdate,@modType,getdate(),USER_NAME() from deleted; -- deleted 는 삭제/변경될때 데이터가 잠시 보관되는 임시 테이블이다
go

update userTbl set addr = N'몽고' where userId = 'JKW';
delete userTbl where height >=177;

select * from backup_userTbl;
go


-- turncate table 테이블명 = 모든 행테이터 전체삭제 = delete from 테이블명와 같은 결과
truncate table userTbl;
select * from backup_userTbl;
-- truncate 로 삭제하면 delete가 아니니까 trigger는 당연히 작동하지 않는다
go


create trigger trg_insertUserTbl
on userTbl
after insert
as
	raiserror(N'데이터의 입력을 시도했습니다.',10,1)			-- 오류 강제발생 함수
	raiserror(N'귀하의 정보가 서버에 기록되었습니다.',10,1)
	raiserror(N'입력하신 데이터는 반영되지 않았습니다..',10,1)

	rollback tran;	-- 증명되지 않은 테이터의 insert를 방지(rollback을 통한 보호)

insert into userTbl values(N'ABC',N'에비씨',1977,N'서울',N'011',N'11111111',181,'2019-12-25');

--1.2 instead of 트리거
-- instead of트리거가 작동하면 그 트리거의 대상이 되는 sql문장(insert, update, delete)는 무시된다.
create view uv_deliver -- 배송정보를 위한 뷰
as
select b.userid, u.name, b.prodName, b.price, b.amount, u.addr
from buyTbl b
	inner join userTbl u
	on b.userid = u.userid;
go

select * from uv_deliver;
go

-- 복합 view에 insert를 할수 없다.
insert into uv_deliver values ('JBI',N'존밴이',N'구두',50,1,N'인천');
go

-- 이를 해결하기 위해 instead of 트리거를 사용
create trigger trg_insert
on uv_deliver
instead of insert
as
begin 
	insert into userTbl(userid, name, birthYear, addr, mdate)
		select userid, name, 1900, addr, getdate() from inserted

	insert into buyTbl(userid, prodName, price,amount)
		select userid,prodName, price, amount from inserted
end;

-- insert 실행
insert into uv_deliver values ('JBI',N'존밴이',N'구두',50,1,N'인천');

-- insert되었는지 확인
select * from userTbl where userid = 'JBI';
select * from buyTbl where userid = 'JBI';

-- 트리거 수정(arter trigger)
-- * 트리거 이름수정
exec sp_rename 'dbo.trg_insert', 'dbo.trg_uvInsert';
-- 이렇게 되면 카탈로그뷰의 내용은 바뀌지 않아 삭제가 이름바꾸기 전의 것으로 수정/삭제가 가능
-- 즉, 비효율적
-- 그냥 아예 삭제하고 다시 만들것! 


	 
-- primary key, unique로 선언되면 인텍스가 자동으로 생성된다.
-- index에는 클러스터형과 비클러스터형이 있고 자동생성되는것은 기본적으로 클러스터형이다
-- 테이블 하나당 클러스터형 인덱스는 1개이하로 존재가능

use tempdb;
create table tbl1
(
a int primary key,
b int,
c int
);
go

create table tbl2
(
a int primary key,
b int unique,
c int unique,
d int
);
go

-- 인덱스 생성확인
exec sp_helpindex tbl1;
exec sp_helpindex tbl2;
go

-- primary key 인덱스를 비클러스터형 인덱스로 되게 선언해보자
create table tbl3
(
a int primary key nonclustered,
b int unique,
c int unique,
d int
);
go

exec sp_helpindex tbl3;
go

-- unique로 지정된 열에 clustered를 지정할수도 있다.
-- 다른 unique가 clustered로 지정되면 primaey key는 자동으로 nonclustered로 지정된다.
create table tbl4
(
a int primary key nonclustered,
b int unique clustered,
c int unique,
d int
);
go

exec sp_helpindex tbl4;
go

use sqldb
select * from userTbl;
go

-- 인덱스 만들기
create index idx_userTbl_addr
	on userTbl(addr);
go

-- 인덱스만들기2
create unique index idx_userTbl_name
	on userTbl(name);
go

-- 2개의 열을 합쳐서 인덱스생성
-- (birthday는 겹치는 값이 있어서 원래 인덱스가 불가능하지만 name과 합쳐서는 겹치는게 없어 가능)
create nonclustered index idx_userTbl_name_birthYear
	on userTbl (name,birthday);
go

-- 인덱스 삭제
-- (단, 제약조건(primary key, unique 등으로인해 생성된 인덱스는 제거불가)
--    -> (제약조건을 삭제하면 자동 삭제된다)
drop index userTbl.idx_userTbl_addr;
drop index userTbl.idx_userTbl_name;
drop index userTbl.idx_userTbl_name_birthYear;
go



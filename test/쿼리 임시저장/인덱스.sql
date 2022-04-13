-- primary key, unique�� ����Ǹ� ���ؽ��� �ڵ����� �����ȴ�.
-- index���� Ŭ���������� ��Ŭ���������� �ְ� �ڵ������Ǵ°��� �⺻������ Ŭ���������̴�
-- ���̺� �ϳ��� Ŭ�������� �ε����� 1�����Ϸ� ���簡��

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

-- �ε��� ����Ȯ��
exec sp_helpindex tbl1;
exec sp_helpindex tbl2;
go

-- primary key �ε����� ��Ŭ�������� �ε����� �ǰ� �����غ���
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

-- unique�� ������ ���� clustered�� �����Ҽ��� �ִ�.
-- �ٸ� unique�� clustered�� �����Ǹ� primaey key�� �ڵ����� nonclustered�� �����ȴ�.
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

-- �ε��� �����
create index idx_userTbl_addr
	on userTbl(addr);
go

-- �ε��������2
create unique index idx_userTbl_name
	on userTbl(name);
go

-- 2���� ���� ���ļ� �ε�������
-- (birthday�� ��ġ�� ���� �־ ���� �ε����� �Ұ��������� name�� ���ļ��� ��ġ�°� ���� ����)
create nonclustered index idx_userTbl_name_birthYear
	on userTbl (name,birthday);
go

-- �ε��� ����
-- (��, ��������(primary key, unique ���������� ������ �ε����� ���źҰ�)
--    -> (���������� �����ϸ� �ڵ� �����ȴ�)
drop index userTbl.idx_userTbl_addr;
drop index userTbl.idx_userTbl_name;
drop index userTbl.idx_userTbl_name_birthYear;
go



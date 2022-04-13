-- �� ����
create view v_userbuyTbl
as
	select U.userid as [USER ID],U.name as [USER NAME], B.prodName as [PRODUCT NAME], U.addr, U.mobile1+U.mobile2 as [MOBILE PHONE]
	from userTbl U
		inner join buyTbl B
		on U.userid = B.userid;
go

-- �信�� ��� ����Ʈ
select [USER ID],[USER NAME] from v_userbuyTbl;
go

-- ������� alter view������ �Ѵ�
alter view v_userbuyTbl
as
	select U.userid as [����� ���̵�], U.name as [�̸�], B.prodName as [��ǰ�̸�], U.addr,U.mobile1+U.mobile2 as [��ȭ ��ȣ]
	from userTbl U
		inner join buyTbl B
			on U.userID = B.userID;
go
-- ��, �����Լ�, join���� ����� ��� distinct/ group by ���� �� �׷�ȭ�� �ܼ� ������ �ƴ� ���ļӼ��� �� ����� ��� ������ �Ұ����ϴ�.

select [�̸�],[��ȭ ��ȣ] from v_userbuyTbl;
go

-- �����
drop view v_userbuyTbl;
go
-- �䰡 �����ϰ��ִ� ���̺��� �����Ǹ� �䵵 �����ȴ�

create view v_userTbl
as
select userid, name,addr from userTbl;
go

-- ���� �ҽ� Ȯ��
-- �信���� ������ īŻ�α� ��(sys.sql_modules)���ִ�
select * from sys.sql_modules;
select object_name(1221579390) as v_userTbl, definition from sys.sql_modules;
select * from sys.sql_modules;
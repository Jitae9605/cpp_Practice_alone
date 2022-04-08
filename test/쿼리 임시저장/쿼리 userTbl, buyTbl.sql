create table userTbl		-- ȸ�����̺� ����
(
userID char(8) not null primary key,	-- ����� ���̵�(�⺻Ű)
name nchar(10) not null,				-- �̸�
birthday int not null,					-- ����⵵
addr nchar(2) not null,					-- ����(����,��� ��)
mobile1 char(3),						-- �޴��ȣ ����(011,010...)
mobile2 char(8),						-- �޴��ȣ ������(������ ����)
height smallint,						-- Ű
mDate date								-- ȸ��������
);
go
create table buyTbl			-- �������̺� ����
(
num int identity not null primary key,								-- ����(�⺻Ű)
userID char(8) not null foreign key references userTbl(userID),		-- ������ ���̵�(�ܷ�Ű - ȸ�����̺�(����ھ��̵�))
prodName nchar(6) not null,											-- ��ǰ��
groupName nchar(4),													-- �з�
price int not null,													-- �ܰ�
amount smallint not null											-- ����
);
go

insert into userTbl values('LSG','�̽±�',1987,'����','011','11111111',182,'2008-8-8');
insert into userTbl values('KBS','�����',1979,'�泲','011','22222222',173,'2012-4-4');
insert into userTbl values('KKH','���ȣ',1971,'����','019','33333333',177,'2007-7-7');
insert into userTbl values('JYP','������',1950,'���','011','44444441',166,'2009-4-4');
insert into userTbl values('SSK','���ð�',1979,'����', NULL,      NULL,186,'2013-12-12');
insert into userTbl values('LJB','�����',1969,'����','016','66666666',182,'2009-9-9');
insert into userTbl values('YJS','������',1969,'�泲', NULL,      NULL,170,'2005-5-5');
insert into userTbl values('EJW','������',1972,'���','011','88888888',174,'2014-3-3');
insert into userTbl values('JKW','������',1965,'���','018','99999999',172,'2010-10-10');
insert into userTbl values('BBK','�ٺ�Ŵ',1973,'����','010','00000000',176,'2013-5-5');
GO

insert into buyTbl values('KBS','�ȭ',NULL  ,30   ,2);
insert into buyTbl values('KBS','��Ʈ��','����',1000 ,1);
insert into buyTbl values('JYP','�����','����',200  ,1);
insert into buyTbl values('BBK','�����','����',200  ,5);
insert into buyTbl values('KBS','û����','�Ƿ�',50,   3);
insert into buyTbl values('BBK','�޸�','����',80,  10);
insert into buyTbl values('SSK','å',    '����',15,   5);
insert into buyTbl values('EJW','å',    '����',15,   2);
insert into buyTbl values('EJW','û����','�Ƿ�',50,   1);
insert into buyTbl values('BBK','�ȭ',NULL,  30,   2);
insert into buyTbl values('EJW','å',    '����',15,   1);
insert into buyTbl values('BBK','�µ�ȭ',NULL,  30,   2);
GO

select * from userTbl;
select * from buyTbl;

backup database sqldb to disk = 'D:\sql_backup����\sqldb.bak' with init;
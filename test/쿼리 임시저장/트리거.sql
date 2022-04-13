-- 1.1 after Ʈ����
-- �ӽ� �ǽ����̺� ����
use tempdb
create table testTbl (id int, txt nvarchar(5));
go

-- �ӽõ����� �Է�
insert into testTbl values(1, N'�����ɽ�');
insert into testTbl values(2, N'�����ͽ���');
insert into testTbl values(3, N'���̿�����');
go

-- Ʈ���� ����
create trigger testTrg -- Ʈ�����̸�
on testTbl	-- Ʈ���Ÿ� ������ ���̺�
after delete, update -- ����/�����Ŀ� �۵�
as
	print(N'Ʈ���Ű� �۵��߽��ϴ�.');	-- Ʈ���� �ߵ��� ����� sql��

go

-- Ʈ���� �ߵ�
insert into testTbl values(4,N'���ι�����');
update testTbl set txt = N'��[����ũ'where id = 3;	-- Ʈ���� �ߵ�
delete testTbl where id = 4;		-- Ʈ���� �ߵ�
go

-- ������ ���̺��� �����ϰ� ���ο� ���̺�(������̺�)�� ����
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
modType nchar(2),	-- ����� Ÿ��.(���� or ����)
modDate date,		--  ������ ��¥
modUser nvarchar(256) -- ������ �����
)
go

-- Ʈ���� ����
create trigger trg_BackupUserTbl -- Ʈ�����̸�
on userTbl						 -- Ʈ���� ������ ���̺� ����
after update,delete				-- Ʈ���� �ߵ� �ñ�(after)�� ����(update,delete)
as
	declare @modType nchar(2) -- ����Ÿ��

	if	(COLUMNS_UPDATED() > 0 ) -- ������Ʈ �Ǿ��ٸ�
		begin
			set @modType = N'����'
		end
	else						-- �����Ǿ��ٸ�
		begin
			set @modType = N'����'
		end
	-- delete���̺��� ����(������ ������ ������̺� ����)
	insert into backup_userTbl	
		select userID, name,birthday, addr, mobile1, mobile2, height, mdate,@modType,getdate(),USER_NAME() from deleted; -- deleted �� ����/����ɶ� �����Ͱ� ��� �����Ǵ� �ӽ� ���̺��̴�
go

update userTbl set addr = N'����' where userId = 'JKW';
delete userTbl where height >=177;

select * from backup_userTbl;
go


-- turncate table ���̺�� = ��� �������� ��ü���� = delete from ���̺��� ���� ���
truncate table userTbl;
select * from backup_userTbl;
-- truncate �� �����ϸ� delete�� �ƴϴϱ� trigger�� �翬�� �۵����� �ʴ´�
go


create trigger trg_insertUserTbl
on userTbl
after insert
as
	raiserror(N'�������� �Է��� �õ��߽��ϴ�.',10,1)			-- ���� �����߻� �Լ�
	raiserror(N'������ ������ ������ ��ϵǾ����ϴ�.',10,1)
	raiserror(N'�Է��Ͻ� �����ʹ� �ݿ����� �ʾҽ��ϴ�..',10,1)

	rollback tran;	-- ������� ���� �������� insert�� ����(rollback�� ���� ��ȣ)

insert into userTbl values(N'ABC',N'����',1977,N'����',N'011',N'11111111',181,'2019-12-25');

--1.2 instead of Ʈ����
-- instead ofƮ���Ű� �۵��ϸ� �� Ʈ������ ����� �Ǵ� sql����(insert, update, delete)�� ���õȴ�.
create view uv_deliver -- ��������� ���� ��
as
select b.userid, u.name, b.prodName, b.price, b.amount, u.addr
from buyTbl b
	inner join userTbl u
	on b.userid = u.userid;
go

select * from uv_deliver;
go

-- ���� view�� insert�� �Ҽ� ����.
insert into uv_deliver values ('JBI',N'������',N'����',50,1,N'��õ');
go

-- �̸� �ذ��ϱ� ���� instead of Ʈ���Ÿ� ���
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

-- insert ����
insert into uv_deliver values ('JBI',N'������',N'����',50,1,N'��õ');

-- insert�Ǿ����� Ȯ��
select * from userTbl where userid = 'JBI';
select * from buyTbl where userid = 'JBI';

-- Ʈ���� ����(arter trigger)
-- * Ʈ���� �̸�����
exec sp_rename 'dbo.trg_insert', 'dbo.trg_uvInsert';
-- �̷��� �Ǹ� īŻ�α׺��� ������ �ٲ��� �ʾ� ������ �̸��ٲٱ� ���� ������ ����/������ ����
-- ��, ��ȿ����
-- �׳� �ƿ� �����ϰ� �ٽ� �����! 


	 
-- �߰����� 1
-- ������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
-- �������� ����� ���̺��� �Ʒ��� �����ϴ�.

-- create table T���� (
-- ���� nvarchar(8),
-- ��ǰ nvarchar(30),
-- ���� int default 0,
-- primary key (����, ��ǰ)
-- )
-- go

-- insert into T����(����, ��ǰ, ����)
-- values ('20200101', 'A1', 10), ('20200102', 'A2', 20)
-- go

-- �Ʒ��� �䱸�����Դϴ�.
-- 1. update, delete �� �ϳ��� Ʈ��������� �����մϴ�.
-- 2. �� DML ������ ���� ����� �ý��� ������ Ȯ���մϴ�.
-- 3. ������ �ý��� ������ @@ERROR, @@ROWCOUNT
--		�̰�, Ʈ������� �Ϸ�� ��Ҵ� �Ʒ��� �����ϼ���.
--  1) @@ERROR <> 0 �Ǵ� @@ROWCOUNT <> 1 �ƴϸ�
--		��� ����̰�, �׿ܴ� ��� �Ϸᰡ �ǵ��� �մϴ�.
--  2) Ʈ������� �Ϸ� �Ǵ� ��� ���� �����͸� ����մϴ�.
--  3) T���� ���̺� ���� update ������ ���� �����Դϴ�.
--		������ ����, ��ǰ�� ���� '20200101', 'A1' �Դϴ�.
--  4) T���� ���̺� ���� delete ������ ���� �����Դϴ�.
--		������ ����, ��ǰ�� ���� '20200105', 'A5' �Դϴ�.

create table T���� (
���� nvarchar(8),
��ǰ nvarchar(30),
���� int default 0,
primary key (����, ��ǰ)
)
go

insert into T����(����, ��ǰ, ����)
values ('20200101', 'A1', 10), ('20200102', 'A2', 20)
go

select * from T���� 
go
drop procedure proc_assign
create procedure proc_assign
as
	
	if (@@error <> 0 or @@ROWCOUNT<>1)
	begin
		print('��� ���')
		rollback tran
		select * from T����
	end
	else
	begin
		print('��� �Ϸ�')
		select * from T����
	end
go










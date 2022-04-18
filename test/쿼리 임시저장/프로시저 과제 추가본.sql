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
drop procedure hr.proc_assign
go
create procedure hr.proc_assign
as
	begin transaction
	update T���� set ��ǰ = 'A1' where ���� = '20200101'
	delete from T���� where ���� = '20200105' and ��ǰ = 'A5'

	if (@@error <> 0 or @@ROWCOUNT <> 1)
	begin
		print('��� ���')
		rollback tran
		select * from T����
	end
	else
	begin
		print('��� �Ϸ�')
		commit transaction
		select * from T����
	end
	commit transaction
go


exec hr.proc_assign
go

-- �߰����� 2

-- ������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
-- �������� ����� �ӽ� ���� ���̺��� �Ʒ��� �����ϴ�.

CREATE TABLE #T��ǰ (
��ǰ�ڵ� NVARCHAR(30)
,��ǰ�� NVARCHAR(30)
)

INSERT INTO #T��ǰ (��ǰ�ڵ�, ��ǰ��)
VALUES ('A2', '���') , ('A1', '���'), ('A4', '����'),
('A3', '����'), ('A5', '����'), ('A9', '����'),
('A7', '����'), ('A6', '����') ,('A8', '����')

select * from #T��ǰ
go

create procedure proc_product
as
	delete from #T��ǰ where ��ǰ�ڵ� in ('A2','A1','A3')
	select * from #T��ǰ order by ��ǰ�ڵ�
	select * from #T��ǰ where ��ǰ�ڵ� in ('A4','A5')
go

exec proc_product
go

-- �߰����� 3
-- ������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
-- �Ʒ��� ���ν����� Ŀ���� ����ϰ� �ֽ��ϴ�.
-- �Ʒ��� �ڵ忡�� Ŀ���� ������� �ʰ� �����ϰ� ������ �ǵ���
-- ������ ���ν����� �ۼ��ϼ���.
CREATE PROCEDURE SP_CURSOR
AS
	BEGIN
		CREATE TABLE #T�۾�1 (
			�ڵ� NVARCHAR(10),
			���� NUMERIC(18,0)
		)
		
		INSERT INTO #T�۾�1 (�ڵ�, ����)
			VALUES ('A1', 10), ('A2', 20), ('A3', 30)
		
		DECLARE Ŀ��1 CURSOR FOR	-- Ŀ������
			SELECT A.�ڵ�, A.����		
				FROM #T�۾�1 A
				WHERE A.�ڵ� < 'A3'
				ORDER BY ���� DESC
		
		OPEN Ŀ��1;
		
		DECLARE @Ŀ��1_�ڵ� NVARCHAR(10)
			,@Ŀ��1_���� NUMERIC(18,0)
		
		WHILE (1 = 1) BEGIN
			FETCH NEXT FROM Ŀ��1 INTO @Ŀ��1_�ڵ�, @Ŀ��1_����
			
			IF @@FETCH_STATUS <> 0 BREAK
			
			SELECT �ڵ� = @Ŀ��1_�ڵ�,���� = @Ŀ��1_����
		
		END;
		
		CLOSE Ŀ��1
		
		DEALLOCATE Ŀ��1
		
		DROP TABLE #T�۾�1
	END
go

exec SP_CURSOR

-- �߰����� 4
-- ������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
-- �������� ����� �ӽ� ���� ���̺��� �Ʒ��� �����ϴ�.

CREATE TABLE #��ǰ (
��ǰ�ڵ� NVARCHAR(20),
��ǰ�� NVARCHAR(20)
)

INSERT INTO #��ǰ (��ǰ�ڵ�, ��ǰ��)
VALUES ('A','���'), ('B','����'), ('C','����'),
('D','����'), ('E','����')
go

CREATE TABLE #���� (
��ǰ�ڵ� NVARCHAR(20),
�������� NVARCHAR(20),
���Լ��� NUMERIC(18,0) default 0
)

INSERT INTO #���� (��ǰ�ڵ�, ��������, ���Լ���)
VALUES ('A', '20191201', 100), ('A', '20200103', 200),
('B', '20200201', 300), ('C', '20200105', 400),
('D', '20200107', 500)
go

CREATE TABLE #���� (
��ǰ�ڵ� NVARCHAR(20),
�������� NVARCHAR(20),
������� NUMERIC(18,0) default 0
)

INSERT INTO #���� (��ǰ�ڵ�, ��������, �������)
VALUES ('A', '20191220', 10), ('A', '20200103', 20),
('B', '20200305', 30), ('B', '20200217', 40),
('C', '20200220', 50)
-- �Ʒ��� ���ν����� �����Ͽ� Ư�� �Ⱓ�� ��� ���� ������ ��ȸ
-- �� ����Դϴ�. ������ ��ȸ �˻� ������ ������ �����ϴ�.
--	���� �˻� ������ : 20200101
--	���� �˻� ������ : 20200131
go
-- select * from #����
go

create procedure proc_jago 
	@start_date NVARCHAR(20),
	@end_date NVARCHAR(20)
as
	declare @���ʼ��� table
	(
	��ǰ�ڵ� NVARCHAR(20),
	���ʼ��� NUMERIC(18,0) default 0
	)

	insert into @���ʼ���
		select P.��ǰ�ڵ�,isnull(sum(I.���Լ���)- sum(O.�������),0)
		from #��ǰ P
		left outer join #���� I
			on P.��ǰ�ڵ� = I.��ǰ�ڵ� and @start_date > I.��������
		left outer join #���� O
			on P.��ǰ�ڵ� = O.��ǰ�ڵ� and @start_date > O.��������
		group by P.��ǰ�ڵ�

	declare @���Լ��� table
		(
	��ǰ�ڵ� NVARCHAR(20),
	���Լ��� NUMERIC(18,0) default 0
	)

	insert into @���Լ���
		select P.��ǰ�ڵ�,isnull(sum(I.���Լ���),0)
		from #��ǰ P
		left outer join #���� I
			on P.��ǰ�ڵ� = I.��ǰ�ڵ� and @start_date < I.�������� and @end_date > I.��������
		group by P.��ǰ�ڵ�
	
	declare @������� table
	(
	��ǰ�ڵ� NVARCHAR(20),
	������� NUMERIC(18,0) default 0
	)

	insert into @�������
		select P.��ǰ�ڵ�,isnull(sum(O.�������),0)
		from #��ǰ P
		left outer join #���� O
			on P.��ǰ�ڵ� = O.��ǰ�ڵ� and @start_date < O.�������� and @end_date > O.��������
		group by P.��ǰ�ڵ�
	
	select P.��ǰ�ڵ�, P.��ǰ��,
	isnull(T1.���ʼ���,0) as [���ʼ���],
	isnull(T2.���Լ���,0) as [���Լ���],
	isnull(T3.�������,0) as [�������],
	���ʼ��� + ���Լ��� - ������� as [�⸻����]
	from #��ǰ P
	inner join @���ʼ��� T1
	on P.��ǰ�ڵ� = T1.��ǰ�ڵ�
	inner join @���Լ��� T2
	on P.��ǰ�ڵ� = T2.��ǰ�ڵ�
	inner join @������� T3
	on P.��ǰ�ڵ� = T3.��ǰ�ڵ�
go

exec proc_jago '20200101','20200131'
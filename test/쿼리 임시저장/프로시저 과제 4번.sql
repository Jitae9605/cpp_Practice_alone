
-- �߰����� 4
-- ������ �䱸������ Ȯ�� ��, ���ν����� �ۼ��ϼ���.
-- �������� ����� �ӽ� ���� ���̺��� �Ʒ��� �����ϴ�.
drop table #����
drop table #����
drop table #��ǰ

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
-- select * from #��ǰ
-- select * from #����
-- select * from #����
-- go

--create procedure proc_jago 
--	@start_date NVARCHAR(20),
--	@end_date NVARCHAR(20)
--as	

	declare @start_date NVARCHAR(20)
	set @start_date = '20200101'
	declare @end_date NVARCHAR(20)
	set @end_date = '20200131'
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

	 
	 
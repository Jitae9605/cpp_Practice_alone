-- ����������Լ� ���� �� ���
create function ufn_getAge(@byear int)	-- �Ű������� ������ ����
	returns int			-- ���ϰ��� ���������� ����
as
	begin
		declare @age int
		set @age = year(getdate()) - @byear
		return(@age)
	end
go

-- �Լ�ȣ��
select dbo.ufn_getAge(1979);	-- ȣ��� ��Ű���� �ʼ�
go

-- execute������ ȣ�⵵ ���������� �����ϰ� �Ⱦ���
declare @retVal int;
exec @retVal = dbo.ufn_getAge 1979;
print @retVal;
go

-- ���̺� ��ȸ�� �Լ������ ����
select userID, name, dbo.ufn_getAge(birthday) as [�� ����] from userTbl;
go

-- �Լ������� alter��
alter function ufn_getAge(@byear int)
	returns int
as
	begin
		declare @age int
		set @age = year(getdate()) - @byear + 1
		return(@age)
	end
go

-- ������ drop�����
drop function ufn_getAge;
go

-- ���̺��Լ� ���� �� ���
create function ufn_getUser(@ht int)
	returns table
as
	return
	(
	select userId as [���̵�], name as [�̸�], height as [Ű]
	from userTbl
	where height > @ht
	)
go

-- ȣ�� �� ���
select * from dbo.ufn_getUser(177);	-- Ű�� 177�̻��� ��� select
go


-- �������� �Ű������� �ް� �Ű��������� ���Ŀ� �¾ ���鸸 ����� �з��ϴ� �Լ�.
-- ��, ���Ŀ� �¾ ���� ������ '����'�� ��ȯ
create function ufn_userGrade(@byear int)
	-- ������ ���̺� ����(@retTable �� begin...end���� ���� ���̺� ����)
	returns @retTable table
			(
			userID char(8),
			name nchar(10),
			grade nchar(5)
			)
as
begin
	declare @rowCnt int; -- ���� ���� ī��Ʈ
	select @rowCnt = count(*) from userTbl where birthday >= @byear;

	if @rowCnt <=0 -- ���� �ϳ��� ������ '����'���
	begin
		insert into @retTable Values('����','����','����');
		return;
	end;

	-- ���� ������ ���İ� �����
	insert into @retTable
		select U.userid, U.name,
			 case
				when (sum(price*amount) >= 1500) then '�ֿ����'
				when (sum(price*amount) >= 1000) then '�����'
				when (sum(price*amount) >= 1) then '�Ϲݰ�'
				else '���ɰ�'
			end
		from buyTbl B
			right outer join userTbl U
				on B.userID = U.userID
		where birthday >= @byear
		group by U.userID, U.name;
	return;
end; 




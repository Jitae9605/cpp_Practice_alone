-- �پ��� sql���α׷��� �����

-- if...else�� ���
create proc usp_ifElse
	@userName nvarchar(10)
as
	declare @bYear int -- ����⵵ ������ ����
	select @bYear = birthday from userTbl
			where name = @userName;
	if (@bYear >=1980)
		begin
			print '���� ����';
		end
	else
		begin
			print'���� ����'
		end
go

exec usp_ifElse '������';
go

-- case�� ���
create proc usp_case
	@userName nvarchar(10)
as
	declare @bYear int
	declare @tti nvarchar(3)	-- ��
	select @byear = birthday from userTbl
			where name = @userName;
	set @tti =
		case
			when (@bYear % 12 = 0) then '������'
			when (@bYear % 12 = 1) then '��'
			when (@bYear % 12 = 2) then '��'
			when (@bYear % 12 = 3) then '����'
			when (@bYear % 12 = 4) then '��'
			when (@bYear % 12 = 5) then '��'
			when (@bYear % 12 = 6) then 'ȣ����'
			when (@bYear % 12 = 7) then '�䳢'
			when (@bYear % 12 = 8) then '��'
			when (@bYear % 12 = 9) then '��'
			when (@bYear % 12 = 10) then '��'
			else '��'
		end;
	print @userName + '�� �� ==> ' + @tti;
go

exec usp_case '���ð�';
go

alter table userTbl
	add grade nvarchar(5);	-- ����� �� �߰�
go

-- ���� Ȯ���Ͽ� ���忡�� ���ɸ��� ������ ���ν��� �� where���� ���
-- ���� ����� ���� Ŀ���� ������ ����!
create procedure usp_while
as
	declare userCur cursor for		-- Ŀ������
		select U.userid, sum(price*amount)
		from buyTbl B
			right outer join userTbl U
			on B.userID = U.userID
		group by U.userID, U.name

	open userCur		-- Ŀ������

	declare @id nvarchar(10)	-- ����ھ��̵� ������ ����
	declare @sum bigint			-- �� ���ž��� ������ ����
	declare @userGrade nchar(5) -- ����� ����
	
	fetch next from userCur into @id, @sum	-- ù�ప�� ����
	
	while(@@FETCH_STATUS=0)	-- ���̾����� ���� �ݺ�(=��� �� ó��)
	begin
		set @userGrade = 
			case
				when (@sum >= 1500) then '�ֿ����'
				when (@sum >= 1000) then '�����'
				when (@sum >= 1) then '�Ϲݰ�'
				else '���ɰ�'
			end
		update userTbl set grade = @usergrade where userID = @id
		fetch next from userCur into @id, @sum -- ���� �� ���� ����
	end
	
	close userCur	-- Ŀ���ݱ�
	deallocate userCur -- Ŀ������
go

select * from userTbl;
go

exec usp_while;
select * from userTbl;
go

-- return ���� �̿��� �������ν��� �������� Ȯ��
create proc usp_return 
	@userName nvarchar(10)
as
	declare @userID char(8);
	select @userID = userID from userTbl
			where name = @userName;
	if (@userID<>'')
		return 0;	-- ������ ���, �׳� ���ϸ� �ᵵ ����Ʈ�� 0�̶� 0�� ��ȯ��
	else
		return -1;	-- ������ ���(��, �ش��̸��� ID�� �������)
go

-- ����
declare @retVal int;
exec @retVal=usp_return '������';
select @retval;
go

declare @retVal int;
exec @retVal=usp_return '������';
select @retVal;
go

-- ����ó��(@@error)
create proc usp_error
	@userid char(8),
	@name nvarchar(10),
	@birthYear int = 1900,
	@addr nchar(2) = '����',
	@mobile1 char(3) = null,
	@mobile2 char(8) = null,
	@height smallint = 170,
	@mdate date = '2019-11-11'
as

	declare @err int;
	insert into userTbl (userID, name, birthday, addr, mobile1, mobile2, height, mDate)
		values(@userid,@name,@birthYear,@addr,@mobile1,@mobile2,@height,@mdate);

	select @err = @@error;
	if @err !=0
	begin
		print '###' + @name + '��(��) insert�� �����߽��ϴ�. ###'
	end;

	return @err;	-- ������ȣ ��ȯ
go

-- ����
declare @errNum int;
exec @errNum = usp_error 'WDT', '�����';
if (@errNum != 0)
	select @errNum;
go

-- try...catch �������� �����ؼ� �غ���
create proc usp_tryCatch
	@userid char(8),
	@name nvarchar(10),
	@birthYear int = 1900,
	@addr nchar(2) = '����',
	@mobile1 char(3) = null,
	@mobile2 char(8) = null,
	@height smallint = 170,
	@mdate date = '2019-11-11'
as
	declare @err int;
	begin try
		insert into userTbl (userID, name, birthday, addr, mobile1, mobile2, height, mDate)
		 values(@userid,@name,@birthYear,@addr,@mobile1,@mobile2,@height,@mdate);
	end try

	begin catch
		select ERROR_NUMBER()
		select ERROR_MESSAGE()
	end catch
go

-- ����
exec usp_tryCatch 'SYJ','�տ���';
go

-- ���ν��� ������ȸ
-- ��� 1
select o.name,m.definition
from sys.sql_modules m
	join sys.objects o
	on m.object_id = o.object_id and o.type = 'P';
go
-- ����������ִ� ���ν��� �̸��� ���Ǹ� �����´�.

-- ���2
execute sp_helptext usp_error;
go
-- Ư�� ���ν����� ���� ������ �ؽ�Ʈ�� ���

-- ���ν��� ��ȣȭ
-- ���ν��� ������ �ڿ� with encryption�� ���̸� ���ν����� ��ȣȭ�Ǿ� �ڵ�� ������ ��������.
-- �Ѥ��� ��ȣȭ �ϸ� ��ȣȭ�� �ȵǹǷ� �������� �ݵ�� �ؾ��Ѵ�.
create proc usp_encryption with encryption
as
	select substring(name,1,1)+'00' as [�̸�], birthday as '����⵵', height as 'Ű'
		from userTbl;
go


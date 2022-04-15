-- ���̺� ����
create table orderTbl	-- �������̺�
(
orderNo int identity,	-- �����Ϸù�ȣ
userID nvarchar(5),		-- ����ȸ�����̵�
prodName nvarchar(5),	-- ������ ����
orderAmount int			-- ������ ����
);
go

create table prodTbl	-- ��ǰ���̺�
(
prodName nvarchar(5),	-- ���� �̸�
account int				-- ���� ����
);
go

create table deliverTbl	-- ������̺�
(
deliverNo int identity,	-- ����Ϸù�ȣ
prodName nvarchar(5),	-- ����� ����
amount int				-- ����� ���ǰ���
);
go

-- ��ǰ���̺� ���û���
insert into prodTbl values(N'���',100);
insert into prodTbl values(N'��',100);
insert into prodTbl values(N'��',100);

-- ���Ʈ���� �ǽ��� ���̺� ����
create table recuA (id int identity, txt nvarchar(10));	-- ���� ��� Ʈ���ſ� ���̺�A
go
create table recuB (id int identity, txt nvarchar(10));	-- ���� ��� Ʈ���ſ� ���̺�B
go
create table recuC (id int identity, txt nvarchar(10));	-- ���� ��� Ʈ���ſ� ���̺�C
go

-- ��ǰ���̺��� ������ ���ҽ�Ű�� Ʈ����
create trigger trg_order
on orderTbl
after insert
as
	print N'1. trg_order�� �����մϴ�.'
	declare @orderAmount int
	declare @prodName nvarchar(5)

	select @orderAmount = orderAmount from inserted
	select @prodName = prodName from inserted
	
	update prodTbl set account -= @orderAmount
		where prodName = @prodName;
go

-- ������̺� �� ��۰��� �Է��ϴ� Ʈ����
create trigger trg_prod
on prodTbl
after update
as
	print N'2. trg_prod�� �����մϴ�.'
	declare @prodName varchar(5)
	declare @amount int

	select @prodName = prodName from inserted
	select @amount =D.account - I.account		-- �������� ���� - �������� ���� = �ֹ� ���� 
		from inserted I, deleted D

	 insert into deliverTbl(prodName,amount) values(@prodName,@amount);
go

-- ���� ��ǰ�� ����
insert into orderTbl values('JOHN',N'��',5);
go

select * from orderTbl;
select * from prodTbl;
select * from deliverTbl;
go



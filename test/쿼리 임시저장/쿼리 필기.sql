


select Name, addr from userTbl where addr = '�泲' or addr = '����' or addr = '���'
select Name, addr from userTbl where addr in('�泲', '����', '���');

select Name, height from userTbl where name like '��%'; -- '��'���� �����ϴ� ���� �˻�
select Name, height from userTbl where name like '_��%'; -- �ƹ� �ѱ��� �ڿ� '��'�� ���� ���� �˻� ex) '���ö', '�̿�', '�ڿ���', '������ ���' ��
select Name, height from userTbl where name like '_����%'; -- �ƹ� �ѱ��� �ڿ� '����'�� ���� ���� �˻� ex) '������', '������' ��

select Name, height from userTbl where height > (select height from userTbl where Name = '���ȣ');
	-- ���⼭  (select height from userTbl where Name = '���ȣ') �� ��������

select Name, height from userTbl where height >= any (select height from userTbl where addr = ���泲��);
	-- or�� ����� ����. ���ǽĿ� ������ ������ �ְ� �̸� �ϳ��� �����ϸ� ��

select Name, mdate from userTbl order by mdate desc;

select Name, height  from userTbl order by height desc, Name asc;
-- Ű�� �������� �������� ������ �����ϵ� Ű�� ������� �̸��� �������� �������� ����



select distinct addr from userTbl; -- ������߿� �ߺ��Ǵ� �� ����


select top(0.1) percent height from userTbl; -- ���� n�� �� ���(10��)

select * from userTbl tablesample(50 percent);
	-- Ư�� ���̺��� ������ ������ŭ �����ϰ� ���� �̾Ƽ� ���

select top(5000) * from userTbl tablesample(50 percent);
-- ��ü�� 50%�� �ش��ϴ� �ڷḦ �������� �����ϵ� �ִ� 5000�Ǹ� ����ϰ�ʹٸ�
select * into buyTbl1 from buyTbl2;
-- buyTbl2�� ��� ��(*)�� buyTbl1�� ����ٿ��ֱ� �Ѵ�.,

select userID, sum(amount) from buyTbl group by userID;
-- userID�� �������� �����ͳ��� �׷�ȭ �Ѵ��� amout�� �׷캰�� ��� ���ѵ� �� ����� userID�� ��� 

select userID as[����ھ��̵�],sum(amount) as[�� ���� ����] from buyTbl group by userID;

avg()			-- ���
min()			-- �ּҰ�
max()			-- �ִ밪
count()			-- �హ��
count_big()		-- ������ ���µ� ������� bigint��
stdev()			-- ǥ������
var()			-- �л�
sum()


select userID as[�����],sum(price*amount) as[�� ���ž�] from buyTbl group by userID
having sum(price*amount) > 1000;

select num ,groupName, sum(price*amount)as[���] from buyTbl
group by rollup(groupName, num);
-- �׷캰 ���հ踦 �����ش�.
grouping_id(groupName) -- ������� 1�̸� �հ踦 ���� �߰��ȿ� �ƴϸ� ���� �����
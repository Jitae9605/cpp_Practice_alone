create table cubeTbl(prodName nchar(3), color nchar(2), amount int);
go
insert into cubeTbl values('��ǻ��','����',11);
insert into cubeTbl values('��ǻ��','�Ķ�',22);
insert into cubeTbl values('�����','����',33);
insert into cubeTbl values('�����','�Ķ�',44);
go
select prodName, color, sum(amount) as[�����հ�]
from cubeTbl
group by cube(color, prodName);
-- ������ ���հ�� �հ踦 ���ش�
-- ��, ���⼭ �����/��ǻ���� ���հ踦 ���� �̵��� ���� ���հ踦 ������
-- ���򺰷� �ٽ� �հ踦 ���ش�.
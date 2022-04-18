-- ����1
-- ��Ī�� ����Ͽ� ����� ���� �� ������ ����ϼ���
select ename as [ENAME], sal as [SAL], ((sal*12)+comm) as [ANNSAL], comm as [COMM] from hr.emp
go

-- ����2
-- ��� ������ �μ� ��ȣ(���� ����), �޿�(��������)���� �����Ͽ� ����ϼ���
select * from hr.emp order by deptno asc, sal desc;
go

-- ���� 3
-- �μ� ��ȣ�� 30 �̰�, ��� ������ SALESMAN �� ����� ������ ����ϼ���.
select * from hr.emp where deptno = 30 and job = 'SALESMAN';
go

-- ���� 4
-- ��� ������ MANAGER, SALESMAN, CLERK �߿� ���ϴ� ����� ������ ����ϼ���.
select * from hr.emp where job = 'MANAGER' or job = 'SALESMAN' or job = 'CLERK';
go

-- ���� 5
-- �޿��� 2000 ���� ����, 3000 ���� ���� ����� ������ ����ϼ���.
select * from hr.emp where sal < 2000 or sal > 3000;
go

-- ���� 6
-- ��� �̸��� �� ��° ���ڰ� L�� ����� ������ ����ϼ���.
select * from hr.emp where ename like '_L%';
go

-- ���� 7
-- ����� 'AM'�� ���ԵǾ� ���� ���� ����� ������ ����ϼ���.
select * from hr.emp
except
select * from hr.emp where ename like '%AM%'  or ename like 'AM%' or ename like '%AM';
go

-- ���� 8
-- ���� ����� �ִ� ����� ������ ����ϼ���.
select * from hr.emp where mgr is not null;
go

-- ���� 9
-- 10 �� �Ǵ� 20 �� �μ��� �Ҽӵ� ����� ������ ����ϼ���.
select * from hr.emp where deptno in(10,20);

-- ���� 10
-- �Ի� 10�ֳ��� �Ǵ� ����� ������ ������� �Ի� 10�ֳ��� �Ǵ� ��¥�� ����ϼ���.
select empno,ename, hiredate, (dateadd(yy,10,(hiredate))) as [work10year] from hr.emp
go 

-- ���� 11
-- ��� �������� �λ�� �޿� ������ ����ϼ���.
-- ��, ��� ������ MANAGER �̸�, �޿��� 10% �λ��ϰ�, SALESMAN �̸�, �޿��� 5% �λ��ϰ�, ANALYST �̸�, �޿� �λ��� ����, �� �ܴ� �޿��� 3% �λ��� �ǵ��� �ϼ���.
select empno, ename, job, sal,
	case
		when(job = 'MANAGER') then sal * 1.1
		when(job = 'SALESMAN') then sal*1.05
		when(job = 'ANALYST') then sal
		else sal*(1.03)
	end as [UPSAL]
from hr.emp
go

-- ���� 12
-- ��� ����� �����Ͽ�, ����� ���� ������ ����ϼ���.
select empno, ename, comm,
	case
		when (comm is null) then '�ش����'
		when (comm = 0) then '�������'
		else '���� = ' + cast(comm as varchar)
	end as [comm_text] 
from hr.emp
go

-- ���� 13
-- 10��, 20��, 30�� �μ��� ��� �޿��� ����ϼ���.
-- ��, group by �� ������� �ʰ� ��µǵ��� �ϼ���.
select avg(sal) as [AVG_SAL], 10 as [deptno] from hr.emp where deptno = 10
	union all
select avg(sal) as [AVG_SAL], 20 as [deptno] from hr.emp where deptno = 20
	union all
select avg(sal) as [AVG_SAL], 30 as [deptno] from hr.emp where deptno = 30
go

-- ���� 14
-- �޿��� 3000 �̸��� ����� �ٹ��ϰ� �ִ� �μ��� �μ���, ��� ������ ��� �޿� ������ ����ϼ���.
with abc(deptno, job, sal)
as
(
select deptno,job, sal from hr.emp where sal < 3000
)
select deptno, job, avg(sal) as [AVG_SAL] from abc group by deptno, job
go

-- ���� 15
-- �� ����� ������ �ڽ��� ��� ������ �Բ� ��µǵ��� �ϰ�,
-- ���� ��簡 ���� ����� ������ �Բ� ��µǵ��� �ϼ���.
-- ��, ���� ������ ���� ��� ������ ��µ��� �ʵ��� �ϼ���.
select E.empno, E.ename, E.mgr, U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME]
	from hr.emp E
		left outer join hr.emp U
				on E.mgr = U.empno
go

-- ���� 16
-- ��簡 �ִ� �� ����� ������ �ڽ��� ��� ������ �Բ� ��µǵ��� �ϰ�,
-- ���� ��簡 ���� ����� ��¿��� �����ϰ�,
-- ���� ������ ���� ��� ������ ��µǵ��� �ϼ���.
select null as [EMPNO], null as [ENAME], U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME]  from hr.emp U
except
select null as [EMPNO], null as [ENAME], U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME] 
	from hr.emp U
		inner join hr.emp E
			on U.empno = E.mgr
	union all
select E.empno, E.ename, U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME]
	from hr.emp E
		inner join hr.emp U
				on E.mgr = U.empno
go

-- ���� 17
-- ��簡 �ִ� �� ����� ������ �ڽ��� ��� ������ �Բ� ��µǵ��� �ϰ�,
-- ���� ��簡 ���� ��� �� ���� ������ ���� ��絵 ��� ��µǵ��� �ϼ���.
select null as [EMPNO], null as [ENAME], U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME]  from hr.emp U
except
select null as [EMPNO], null as [ENAME], U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME] 
	from hr.emp U
		inner join hr.emp E
			on U.empno = E.mgr
	union all
select E.empno, E.ename, U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME]
	from hr.emp E
		left outer join hr.emp U
				on E.mgr = U.empno
go

-- ���� 18
-- JONES ����� �޿� �̻����� �޴� ��� ������ ����ϼ���.
declare @a int;
set @a = (select sal from hr.emp where ename = 'JONES')
select * from hr.emp where sal > @a
go

-- ���� 19
-- SCOTT ��� ���� ���� �ٹ��� ��� ������ ����ϼ���.
declare @b date;
set @b = (select hiredate from hr.emp where ename = 'SCOTT')
select * from hr.emp where hiredate < @b
go

-- ���� 20
-- 20 �� �μ��� �ٹ��ϰ� �ִ� ����߿��� ��� ��ü ��� �޿����� ���� �޿��� �޴� ��� ������ ����ϼ���.
-- ��, �μ� ������ �Բ� ��µǵ��� �ϼ���.
declare @c int
set @c = (select avg(sal) from hr.emp) 
select E.empno, E.ename, E.job, E.sal, U.deptno,U.dname,U.loc
	from hr.emp E
		inner join hr.dept U
			on E.deptno = U.deptno
	where E.deptno = 20 and E.sal > @c
go

-- ���� 21
-- �μ��� �ְ� �޿��� �޴� ����� ������ ����ϼ���.
declare @d1 varchar(10)
set @d1 = (select top(1)ename from hr.emp where deptno = 10 order by sal desc)

declare @d2 varchar(10)
set @d2 = (select top(1)ename from hr.emp where deptno = 20 order by sal desc)

declare @d3 varchar(10)
set @d3 = (select top(1)ename from hr.emp where deptno = 30 order by sal desc)
select * from hr.emp where ename in(@d1,@d2,@d3)
go

-- ���� 22
-- 10 �� �μ��� �Ҽӵ� ����� ������ ����ϼ���. ��, with ���� ����ϼ���.
with e1(empo, ename, job, mgr, hiredat, sal, comm, deptno)
as
(
	select * from hr.emp where deptno = 10
)
select * from e1
go

-- ���� 23
-- ��� ������ ����ϵ�, �޿� ���, �μ� ������ �Բ� ��µǵ��� �ϼ���.
select E.empno, E.ename,E.job,E.sal,S.grade,E.deptno, D.dname
	from hr.emp E
		inner join hr.salgrade S
			on E.sal >= S.losal and E.sal <= S.hisal

		inner join hr.dept D
			on E.deptno = D.deptno
go
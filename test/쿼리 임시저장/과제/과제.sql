-- 문제1
-- 별칭을 사용하여 사원의 연간 총 수입을 출력하세요
select ename as [ENAME], sal as [SAL], ((sal*12)+comm) as [ANNSAL], comm as [COMM] from hr.emp
go

-- 문제2
-- 사원 정보를 부서 번호(오름 차순), 급여(내림차순)으로 정렬하여 출력하세요
select * from hr.emp order by deptno asc, sal desc;
go

-- 문제 3
-- 부서 번호가 30 이고, 담당 업무가 SALESMAN 인 사원의 정보를 출력하세요.
select * from hr.emp where deptno = 30 and job = 'SALESMAN';
go

-- 문제 4
-- 담당 업무가 MANAGER, SALESMAN, CLERK 중에 속하는 사원의 정보를 출력하세요.
select * from hr.emp where job = 'MANAGER' or job = 'SALESMAN' or job = 'CLERK';
go

-- 문제 5
-- 급여가 2000 보다 낮고, 3000 보다 높은 사원의 정보를 출력하세요.
select * from hr.emp where sal < 2000 or sal > 3000;
go

-- 문제 6
-- 사원 이름의 두 번째 글자가 L인 사원의 정보를 출력하세요.
select * from hr.emp where ename like '_L%';
go

-- 문제 7
-- 사원명에 'AM'이 포함되어 있지 않은 사원의 정보를 출력하세요.
select * from hr.emp
except
select * from hr.emp where ename like '%AM%'  or ename like 'AM%' or ename like '%AM';
go

-- 문제 8
-- 직속 상관이 있는 사원의 정보를 출력하세요.
select * from hr.emp where mgr is not null;
go

-- 문제 9
-- 10 번 또는 20 번 부서에 소속된 사원의 정보를 출력하세요.
select * from hr.emp where deptno in(10,20);

-- 문제 10
-- 입사 10주년이 되는 사원의 정보와 사원별로 입사 10주년이 되는 날짜를 출력하세요.
select empno,ename, hiredate, (dateadd(yy,10,(hiredate))) as [work10year] from hr.emp
go 

-- 문제 11
-- 담당 직무별로 인상된 급여 정보를 출력하세요.
-- 단, 담당 직무가 MANAGER 이면, 급여를 10% 인상하고, SALESMAN 이면, 급여를 5% 인상하고, ANALYST 이면, 급여 인상이 없고, 그 외는 급여를 3% 인상이 되도록 하세요.
select empno, ename, job, sal,
	case
		when(job = 'MANAGER') then sal * 1.1
		when(job = 'SALESMAN') then sal*1.05
		when(job = 'ANALYST') then sal
		else sal*(1.03)
	end as [UPSAL]
from hr.emp
go

-- 문제 12
-- 출력 결과를 참고하여, 사원별 수당 정보를 출력하세요.
select empno, ename, comm,
	case
		when (comm is null) then '해당없음'
		when (comm = 0) then '수당없음'
		else '수당 = ' + cast(comm as varchar)
	end as [comm_text] 
from hr.emp
go

-- 문제 13
-- 10번, 20번, 30번 부서별 평균 급여를 출력하세요.
-- 단, group by 를 사용하지 않고 출력되도록 하세요.
select avg(sal) as [AVG_SAL], 10 as [deptno] from hr.emp where deptno = 10
	union all
select avg(sal) as [AVG_SAL], 20 as [deptno] from hr.emp where deptno = 20
	union all
select avg(sal) as [AVG_SAL], 30 as [deptno] from hr.emp where deptno = 30
go

-- 문제 14
-- 급여가 3000 미만인 사원이 근무하고 있는 부서의 부서별, 담당 업무별 평균 급여 정보를 출력하세요.
with abc(deptno, job, sal)
as
(
select deptno,job, sal from hr.emp where sal < 3000
)
select deptno, job, avg(sal) as [AVG_SAL] from abc group by deptno, job
go

-- 문제 15
-- 각 사원의 정보를 자신의 상사 정보와 함께 출력되도록 하고,
-- 직속 상사가 없는 사원의 정보도 함께 출력되도록 하세요.
-- 단, 부하 직원이 없는 상사 정보는 출력되지 않도록 하세요.
select E.empno, E.ename, E.mgr, U.empno as [MGR_EMPNO], U.ename as [MGR_ENAME]
	from hr.emp E
		left outer join hr.emp U
				on E.mgr = U.empno
go

-- 문제 16
-- 상사가 있는 각 사원의 정보는 자신의 상사 정보와 함께 출력되도록 하고,
-- 직속 상사가 없는 사원은 출력에서 제외하고,
-- 부하 직원이 없는 상사 정보는 출력되도록 하세요.
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

-- 문제 17
-- 상사가 있는 각 사원의 정보는 자신의 상사 정보와 함께 출력되도록 하고,
-- 직속 상사가 없는 사원 및 부하 직원이 없는 상사도 모두 출력되도록 하세요.
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

-- 문제 18
-- JONES 사원의 급여 이상으로 받는 사원 정보를 출력하세요.
declare @a int;
set @a = (select sal from hr.emp where ename = 'JONES')
select * from hr.emp where sal > @a
go

-- 문제 19
-- SCOTT 사원 보다 오래 근무한 사원 정보를 출력하세요.
declare @b date;
set @b = (select hiredate from hr.emp where ename = 'SCOTT')
select * from hr.emp where hiredate < @b
go

-- 문제 20
-- 20 번 부서에 근무하고 있는 사원중에서 사원 전체 평균 급여보다 높은 급여를 받는 사원 정보를 출력하세요.
-- 단, 부서 정보도 함께 출력되도록 하세요.
declare @c int
set @c = (select avg(sal) from hr.emp) 
select E.empno, E.ename, E.job, E.sal, U.deptno,U.dname,U.loc
	from hr.emp E
		inner join hr.dept U
			on E.deptno = U.deptno
	where E.deptno = 20 and E.sal > @c
go

-- 문제 21
-- 부서별 최고 급여를 받는 사원의 정보를 출력하세요.
declare @d1 varchar(10)
set @d1 = (select top(1)ename from hr.emp where deptno = 10 order by sal desc)

declare @d2 varchar(10)
set @d2 = (select top(1)ename from hr.emp where deptno = 20 order by sal desc)

declare @d3 varchar(10)
set @d3 = (select top(1)ename from hr.emp where deptno = 30 order by sal desc)
select * from hr.emp where ename in(@d1,@d2,@d3)
go

-- 문제 22
-- 10 번 부서에 소속된 사원의 정보를 출력하세요. 단, with 절을 사용하세요.
with e1(empo, ename, job, mgr, hiredat, sal, comm, deptno)
as
(
	select * from hr.emp where deptno = 10
)
select * from e1
go

-- 문제 23
-- 사원 정보를 출력하되, 급여 등급, 부서 정보가 함께 출력되도록 하세요.
select E.empno, E.ename,E.job,E.sal,S.grade,E.deptno, D.dname
	from hr.emp E
		inner join hr.salgrade S
			on E.sal >= S.losal and E.sal <= S.hisal

		inner join hr.dept D
			on E.deptno = D.deptno
go
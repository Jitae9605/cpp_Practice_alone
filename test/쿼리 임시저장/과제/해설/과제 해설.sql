--1
select eName as 사원이름, sum(sal) as 급여합, sum(comm) as 보너스합
	from hr.emp
	group by ename;

--2
select *from hr.emp
	order by deptno asc, sal desc;

--3
select *from hr.emp
where deptno=30 and job='SALESMAN';

--4
select *from hr.emp
where job='MANAGER' or job='SALESMAN' or job='CLERK';

--5
select *from hr.emp
where sal<2000 or sal>3000;

--6
select *from hr.emp
where ename like '_L%';

--7
select *from hr.emp
where not ename like '%AM%';

--8
select *from hr.emp
where mgr is not null;

--9
select EMPNO,ENAME,SAL,DEPTNO 
	from hr.emp
		where deptno=10 or deptno=20
		order by deptno;

--10
select empno,ename,hiredate,dateadd(year,10,hiredate) as WORK10YEAR
	from hr.emp;

--11
select EMPNO, ENAME, JOB, SAL,
	CASE 
		WHEN JOB='MANAGER' THEN SAL*1.1
		WHEN JOB='SALESMAN' THEN SAL*1.05
		WHEN JOB = 'ANALYST' THEN SAL*1.0
		ELSE SAL*1.03
	END AS[UPSAL]
FROM HR.EMP

--12
SELECT EMPNO, ENAME, COMM,
	CASE
		WHEN COMM > 0.00 THEN '수당 : ' + CAST(COMM AS VARCHAR(10))
		WHEN COMM=0.00 THEN '수당없음'
		WHEN COMM IS NULL THEN '해당사항 없음'
	END AS [COMM_TEXT]
FROM HR.EMP;

--13
SELECT AVG(SAL),DEPTNO
FROM HR.EMP
GROUP BY DEPTNO;

--14
SELECT DEPTNO,JOB,AVG(SAL) AS AVG_SAL
FROM HR.EMP
GROUP BY DEPTNO,job
having avg(sal)<3000;

--15
select A.empno as EMPNO, A.ename AS ENAME,A.mgr AS MGR,
		B.EMPNO AS MGR_EMPNO,B.ENAME AS MGR_ENAME
FROM HR.EMP A LEFT JOIN HR.EMP B
ON A.MGR = B.EMPNO; 

--16
SELECT A.EMPNO AS EMPNO, A.ENAME AS ENAME, B.EMPNO AS MGR_EMPNO, B.ENAME AS MGR_ENAME
FROM HR.EMP A
RIGHT JOIN HR.EMP B
ON A.MGR = B.EMPNO
ORDER BY A.EMPNO;

--17
SELECT A.EMPNO AS EMPNO, A.ENAME AS ENAME, A.MGR AS MGR,B.EMPNO AS MGR_EMPNO, B.ENAME AS MGR_ENAME
FROM HR.EMP A
FULL JOIN HR.EMP B
ON A.MGR = B.EMPNO
ORDER BY A.EMPNO;

--18
SELECT * from hr.emp
where sal > (select sal from hr.emp
				where ename = 'JONES');

--19
select * from hr.emp
where hiredate < (select hiredate from hr.emp
					where ename = 'SCOTT');

--20
select A.EMPNO as 사원번호, A.ENAME AS 사원이름, A.JOB AS 담당업무, A.SAL AS 급여, A.DEPTNO AS 부서코드,
	B.DNAME AS 부서명, B.LOC AS 부서위치
FROM HR.EMP A
INNER JOIN HR.DEPT B
ON A.DEPTNO = B.DEPTNO
WHERE A.DEPTNO=20 AND A.SAL>(SELECT AVG(SAL) FROM HR.EMP);

--21
SELECT * FROM HR.EMP
GROUP BY DEPTNO
HAVING MAX(SAL);
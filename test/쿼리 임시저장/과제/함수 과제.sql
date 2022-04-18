-- 문제 1
-- hr.dept 테이블 기반으로 hr.dept_temp 테이블을 생성하세요.
-- 그리고, hr.dept_temp 데이터를 대상으로 OPERATIONS 부서의
-- 위치를 SEOUL 로 변경하세요.
-- 단, 변경시 Sub Query 를 사용하세요.
drop table hr.dept_temp
select * into hr.dept_temp from hr.dept
update  hr.dept_temp set loc = 'SEOUL' where loc = (select loc from hr.dept_temp where dname = 'OPERATIONS')
select * from hr.dept_temp

-- 문제 2
-- hr.emp 테이블 기반으로 hr.emp_temp 테이블을 생성하세요.
-- 그리고, 급여가 1등급인 사원 정보만 입력되도록 하세요.
-- hr.emp_temp 데이터를 대상으로 급여 등급이 1등급이며,
-- 부서 번호가 30번인 사원 정보를 삭제하도록 하세요.
-- 단, 삭제시 Sub Query 를 사용하세요.
drop table hr.emp_temp

select E.empno, E.ename,E.job,E.sal,S.grade,E.deptno, D.dname into hr.emp_temp
	from hr.emp E
		inner join hr.salgrade S
			on E.sal >= S.losal and E.sal <= S.hisal

		inner join hr.dept D
			on E.deptno = D.deptno
	where S.grade = 1
go
delete hr.emp_temp where deptno = 30
select*from hr.emp_temp
go
-- 문제 3
-- 세후 급여를 계산하는 함수를 hr 스키마에 생성하세요.
-- 세금은 일괄적으로 5% 로 계산하세요.
-- 그리고, 생성된 함수를 사용하여 전 사원의 세전 과 세후를
-- 확인할 수 있도록 출력하세요.
-- drop function cal_tax

create function hr.cal_tax()
	returns table
as
	return
	(
	select empno, ename, sal, sal*0.95 as [after_tax] from hr.emp
	)
go

select * from hr.cal_tax();
go

-- 문제 4
-- hr.emp_temp 에 트리거를 추가하세요.
-- 트리거의 기능은 토, 일 요일에 insert, update, delete 에 대한
-- DML 이벤트가 발생할 경우
-- 주말에서 등록, 수정, 삭제 할 수 없습니다.' 메시지를 출력하며,
-- 트랜잭션이 취소가 되도록 하세요.
drop trigger hr.trg_checkWeek
create trigger trg_checkWeek
on hr.emp_temp
after insert, update, delete
as
	if(datepart(weekday,getdate()) = 7 or datepart(weekday,getdate()) = 2) --
	begin
		print('주말에 등록, 수정, 삭제 불가능')
		ROLLBACK TRAN
	end
go

select * from hr.emp_temp
insert into hr.emp_temp values(1,'test','test',1,1,1,'test')





		
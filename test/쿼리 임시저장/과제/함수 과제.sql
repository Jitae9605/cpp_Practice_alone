-- ���� 1
-- hr.dept ���̺� ������� hr.dept_temp ���̺��� �����ϼ���.
-- �׸���, hr.dept_temp �����͸� ������� OPERATIONS �μ���
-- ��ġ�� SEOUL �� �����ϼ���.
-- ��, ����� Sub Query �� ����ϼ���.
drop table hr.dept_temp
select * into hr.dept_temp from hr.dept
update  hr.dept_temp set loc = 'SEOUL' where loc = (select loc from hr.dept_temp where dname = 'OPERATIONS')
select * from hr.dept_temp

-- ���� 2
-- hr.emp ���̺� ������� hr.emp_temp ���̺��� �����ϼ���.
-- �׸���, �޿��� 1����� ��� ������ �Էµǵ��� �ϼ���.
-- hr.emp_temp �����͸� ������� �޿� ����� 1����̸�,
-- �μ� ��ȣ�� 30���� ��� ������ �����ϵ��� �ϼ���.
-- ��, ������ Sub Query �� ����ϼ���.
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
-- ���� 3
-- ���� �޿��� ����ϴ� �Լ��� hr ��Ű���� �����ϼ���.
-- ������ �ϰ������� 5% �� ����ϼ���.
-- �׸���, ������ �Լ��� ����Ͽ� �� ����� ���� �� ���ĸ�
-- Ȯ���� �� �ֵ��� ����ϼ���.
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

-- ���� 4
-- hr.emp_temp �� Ʈ���Ÿ� �߰��ϼ���.
-- Ʈ������ ����� ��, �� ���Ͽ� insert, update, delete �� ����
-- DML �̺�Ʈ�� �߻��� ���
-- �ָ����� ���, ����, ���� �� �� �����ϴ�.' �޽����� ����ϸ�,
-- Ʈ������� ��Ұ� �ǵ��� �ϼ���.
drop trigger hr.trg_checkWeek
create trigger trg_checkWeek
on hr.emp_temp
after insert, update, delete
as
	if(datepart(weekday,getdate()) = 7 or datepart(weekday,getdate()) = 2) --
	begin
		print('�ָ��� ���, ����, ���� �Ұ���')
		ROLLBACK TRAN
	end
go

select * from hr.emp_temp
insert into hr.emp_temp values(1,'test','test',1,1,1,'test')





		
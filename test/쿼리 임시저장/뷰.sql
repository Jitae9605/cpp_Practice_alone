-- 뷰 생성
create view v_userbuyTbl
as
	select U.userid as [USER ID],U.name as [USER NAME], B.prodName as [PRODUCT NAME], U.addr, U.mobile1+U.mobile2 as [MOBILE PHONE]
	from userTbl U
		inner join buyTbl B
		on U.userid = B.userid;
go

-- 뷰에서 결과 셀렉트
select [USER ID],[USER NAME] from v_userbuyTbl;
go

-- 뷰수정은 alter view문으로 한다
alter view v_userbuyTbl
as
	select U.userid as [사용자 아이디], U.name as [이름], B.prodName as [제품이름], U.addr,U.mobile1+U.mobile2 as [전화 번호]
	from userTbl U
		inner join buyTbl B
			on U.userID = B.userID;
go
-- 단, 집계함수, join등을 사용한 뷰와 distinct/ group by 등의 함 그룹화와 단순 정렬이 아닌 정렬속성이 들어간 경우의 뷰는 수정이 불가능하다.

select [이름],[전화 번호] from v_userbuyTbl;
go

-- 뷰삭제
drop view v_userbuyTbl;
go
-- 뷰가 참조하고있는 테이블이 삭제되면 뷰도 삭제된다

create view v_userTbl
as
select userid, name,addr from userTbl;
go

-- 뷰의 소스 확인
-- 뷰에대한 정보는 카탈로그 뷰(sys.sql_modules)에있다
select * from sys.sql_modules;
select object_name(1221579390) as v_userTbl, definition from sys.sql_modules;
select * from sys.sql_modules;
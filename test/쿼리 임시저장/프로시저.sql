-- 다양한 sql프로그래밍 방법들

-- if...else문 사용
create proc usp_ifElse
	@userName nvarchar(10)
as
	declare @bYear int -- 출생년도 저장할 변수
	select @bYear = birthday from userTbl
			where name = @userName;
	if (@bYear >=1980)
		begin
			print '아직 젊음';
		end
	else
		begin
			print'나이 많음'
		end
go

exec usp_ifElse '조용필';
go

-- case문 사용
create proc usp_case
	@userName nvarchar(10)
as
	declare @bYear int
	declare @tti nvarchar(3)	-- 띠
	select @byear = birthday from userTbl
			where name = @userName;
	set @tti =
		case
			when (@bYear % 12 = 0) then '원숭이'
			when (@bYear % 12 = 1) then '닭'
			when (@bYear % 12 = 2) then '개'
			when (@bYear % 12 = 3) then '돼지'
			when (@bYear % 12 = 4) then '쥐'
			when (@bYear % 12 = 5) then '소'
			when (@bYear % 12 = 6) then '호랑이'
			when (@bYear % 12 = 7) then '토끼'
			when (@bYear % 12 = 8) then '용'
			when (@bYear % 12 = 9) then '뱀'
			when (@bYear % 12 = 10) then '말'
			else '양'
		end;
	print @userName + '의 띠 ==> ' + @tti;
go

exec usp_case '성시경';
go

alter table userTbl
	add grade nvarchar(5);	-- 고객등급 열 추가
go

-- 조금 확장하여 현장에서 사용될만한 복잡한 프로시저 및 where문의 사용
-- 아직 배우지 못한 커서가 있으니 주의!
create procedure usp_while
as
	declare userCur cursor for		-- 커서선언
		select U.userid, sum(price*amount)
		from buyTbl B
			right outer join userTbl U
			on B.userID = U.userID
		group by U.userID, U.name

	open userCur		-- 커서열기

	declare @id nvarchar(10)	-- 사용자아이디 저장할 변수
	declare @sum bigint			-- 총 구매액을 저장할 변수
	declare @userGrade nchar(5) -- 고객등급 변수
	
	fetch next from userCur into @id, @sum	-- 첫행값을 대입
	
	while(@@FETCH_STATUS=0)	-- 행이없을때 까지 반복(=모든 행 처리)
	begin
		set @userGrade = 
			case
				when (@sum >= 1500) then '최우수고객'
				when (@sum >= 1000) then '우수고객'
				when (@sum >= 1) then '일반고객'
				else '유령고객'
			end
		update userTbl set grade = @usergrade where userID = @id
		fetch next from userCur into @id, @sum -- 다음 행 값을 대입
	end
	
	close userCur	-- 커서닫기
	deallocate userCur -- 커서헤제
go

select * from userTbl;
go

exec usp_while;
select * from userTbl;
go

-- return 문을 이용해 저장프로시저 성공여부 확인
create proc usp_return 
	@userName nvarchar(10)
as
	declare @userID char(8);
	select @userID = userID from userTbl
			where name = @userName;
	if (@userID<>'')
		return 0;	-- 성공일 경우, 그냥 리턴만 써도 디폴트가 0이라 0을 반환함
	else
		return -1;	-- 실패일 경우(즉, 해당이름의 ID가 없을경우)
go

-- 실행
declare @retVal int;
exec @retVal=usp_return '은지원';
select @retval;
go

declare @retVal int;
exec @retVal=usp_return '나몰라';
select @retVal;
go

-- 오류처리(@@error)
create proc usp_error
	@userid char(8),
	@name nvarchar(10),
	@birthYear int = 1900,
	@addr nchar(2) = '서울',
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
		print '###' + @name + '을(를) insert에 실패했습니다. ###'
	end;

	return @err;	-- 오류번호 반환
go

-- 실행
declare @errNum int;
exec @errNum = usp_error 'WDT', '우당탕';
if (@errNum != 0)
	select @errNum;
go

-- try...catch 구문으로 변경해서 해보자
create proc usp_tryCatch
	@userid char(8),
	@name nvarchar(10),
	@birthYear int = 1900,
	@addr nchar(2) = '서울',
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

-- 실행
exec usp_tryCatch 'SYJ','손연재';
go

-- 프로시저 정보조회
-- 방법 1
select o.name,m.definition
from sys.sql_modules m
	join sys.objects o
	on m.object_id = o.object_id and o.type = 'P';
go
-- 현재생성되있는 프로시저 이름과 정의를 가져온다.

-- 방법2
execute sp_helptext usp_error;
go
-- 특정 프로시저의 정의 전문을 텍스트로 출력

-- 프로시저 암호화
-- 프로시저 생성시 뒤에 with encryption을 붙이면 프로시저가 암호화되어 코드와 정보를 볼수없다.
-- 한ㅂ너 암호화 하면 복호화가 안되므로 별도저장 반드시 해야한다.
create proc usp_encryption with encryption
as
	select substring(name,1,1)+'00' as [이름], birthday as '출생년도', height as '키'
		from userTbl;
go


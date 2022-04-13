-- 사용자정의함수 정의 및 사용
create function ufn_getAge(@byear int)	-- 매개변수로 정수를 받음
	returns int			-- 리턴값은 정수형임을 선언
as
	begin
		declare @age int
		set @age = year(getdate()) - @byear
		return(@age)
	end
go

-- 함수호출
select dbo.ufn_getAge(1979);	-- 호출시 스키마명 필수
go

-- execute문으로 호출도 가능하지만 불편하고 안쓴다
declare @retVal int;
exec @retVal = dbo.ufn_getAge 1979;
print @retVal;
go

-- 테이블 조회때 함수사용은 유용
select userID, name, dbo.ufn_getAge(birthday) as [만 나이] from userTbl;
go

-- 함수수정은 alter문
alter function ufn_getAge(@byear int)
	returns int
as
	begin
		declare @age int
		set @age = year(getdate()) - @byear + 1
		return(@age)
	end
go

-- 삭제는 drop문사용
drop function ufn_getAge;
go

-- 테이블함수 정의 및 사용
create function ufn_getUser(@ht int)
	returns table
as
	return
	(
	select userId as [아이디], name as [이름], height as [키]
	from userTbl
	where height > @ht
	)
go

-- 호출 및 사용
select * from dbo.ufn_getUser(177);	-- 키가 177이상인 사람 select
go


-- 정수값을 매개변수로 받고 매개변수보다 이후에 태어난 고객들만 등급을 분류하는 함수.
-- 단, 이후에 태어난 고객이 없으면 '없다'를 반환
create function ufn_userGrade(@byear int)
	-- 리턴할 테이블 정의(@retTable 은 begin...end에서 사용될 테이블 변수)
	returns @retTable table
			(
			userID char(8),
			name nchar(10),
			grade nchar(5)
			)
as
begin
	declare @rowCnt int; -- 행의 갯수 카운트
	select @rowCnt = count(*) from userTbl where birthday >= @byear;

	if @rowCnt <=0 -- 행이 하나도 없으면 '없음'출력
	begin
		insert into @retTable Values('없음','없음','없음');
		return;
	end;

	-- 행이 있으면 이후가 실행됨
	insert into @retTable
		select U.userid, U.name,
			 case
				when (sum(price*amount) >= 1500) then '최우수고객'
				when (sum(price*amount) >= 1000) then '우수고객'
				when (sum(price*amount) >= 1) then '일반고객'
				else '유령고객'
			end
		from buyTbl B
			right outer join userTbl U
				on B.userID = U.userID
		where birthday >= @byear
		group by U.userID, U.name;
	return;
end; 




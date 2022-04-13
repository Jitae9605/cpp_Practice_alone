-- 커서선언
-- 회원테이블(userTbl)에서 키(height)의 행집합을 가져오는 커서
declare userTbl_cursor cursor global
	for select height from userTbl;


open userTbl_cursor;


-- 커서에서 데이터를 가져오고 이를 처리하는 것을 반복
-- 먼저, 사용할 변수 서언
declare @height int -- 고객의 키
declare @cnt int = 0 -- 고객의 인원수(=읽은 행의 갯수)
declare @totalheight int = 0 -- 키의 합계

fetch next from userTbl_cursor into @height -- 첫행을 읽어 키를 @height에 넣는다.

-- 성공적으로 읽으면 @@fetch_status 함수는 0을 반환 ==> 계속처리함
-- 즉, 더이상 읽은 행이없다면(=EOF되면) while 문 종료
while @@FETCH_STATUS = 0
begin
	set @cnt += 1	-- 읽은 갯수 증가시킴
	set @totalheight += @height	-- 키를 계속누적함
	fetch next from userTbl_cursor into @height -- 다음행 읽음
end

-- 고객키의 평균 계산
print '고객 키의 평균 ==> ' + cast(@totalheight/@cnt as char(10))

close userTbl_cursor; -- 커서닫음

deallocate userTbl_cursor; -- 커서할당헤제


-- global = 전역
-- local = 지역

-- forward_only = 시작 행부터 끝 행까지 단방향으로만 커서가 움직임
-- scroll = 커서가 자유롭게 이동 ( fetch next/first/last/prior... )

-- static = 커서가 테이블을 복사해서 가져옴(커서 open이후의 update/insert 반영X) 
-- keyset = 커서가 대상의 키값들만 다져옴(커서 open이후의 update는 반영O, insert는 반영X)
-- dynamic = 커서가 테이블의 키값을 가져옴(커서open이후의 모든 변경사항 반영O), (디폴트 설정)
-- fast_forward = 커서에서 행데이터 수정없으면 가장 뛰어난 성능
-- 성능 = fast_forward > static > keyset > dynamic

-- read_only = 읽기전용
-- scroll_locks = 위치지정 업데이트/삭제 허용
-- optimistic = 커서open이후 원본의 수정이 커서의 데이터에 반영되지 않게 설정
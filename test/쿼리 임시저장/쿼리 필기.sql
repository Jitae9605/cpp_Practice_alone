


select Name, addr from userTbl where addr = '경남' or addr = '전남' or addr = '경북'
select Name, addr from userTbl where addr in('경남', '전남', '경북');

select Name, height from userTbl where name like '김%'; -- '김'으로 시작하는 것을 검색
select Name, height from userTbl where name like '_용%'; -- 아무 한글자 뒤에 '용'이 오는 것을 검색 ex) '김용철', '이용', '박용현', '조용한 사람' 등
select Name, height from userTbl where name like '_종신%'; -- 아무 한글자 뒤에 '종신'이 오는 것을 검색 ex) '윤종신', '김종신' 등

select Name, height from userTbl where height > (select height from userTbl where Name = '김경호');
	-- 여기서  (select height from userTbl where Name = '김경호') 가 서브쿼리

select Name, height from userTbl where height >= any (select height from userTbl where addr = ‘경남’);
	-- or의 개념과 같다. 조건식에 각각의 값들을 넣고 이를 하나라도 만족하면 참

select Name, mdate from userTbl order by mdate desc;

select Name, height  from userTbl order by height desc, Name asc;
-- 키를 기준으로 내림차순 정렬을 수행하되 키가 같을경우 이름을 기준으로 오름차순 정렬



select distinct addr from userTbl; -- 결과값중에 중복되는 값 제거


select top(0.1) percent height from userTbl; -- 상위 n개 만 출력(10개)

select * from userTbl tablesample(50 percent);
	-- 특정 테이블에서 지정한 비율만큼 랜더하게 열을 뽑아서 출력

select top(5000) * from userTbl tablesample(50 percent);
-- 전체의 50%에 해당하는 자료를 무작위로 추출하되 최대 5000건만 출력하고싶다면
select * into buyTbl1 from buyTbl2;
-- buyTbl2의 모든 열(*)을 buyTbl1에 복사붙여넣기 한다.,

select userID, sum(amount) from buyTbl group by userID;
-- userID를 기준으로 같은것끼리 그룹화 한다음 amout를 그룹별로 모두 더한뒤 그 결과와 userID를 출력 

select userID as[사용자아이디],sum(amount) as[총 구매 개수] from buyTbl group by userID;

avg()			-- 평균
min()			-- 최소값
max()			-- 최대값
count()			-- 행갯수
count_big()		-- 갯수를 세는데 결과값이 bigint임
stdev()			-- 표준편차
var()			-- 분산
sum()


select userID as[사용자],sum(price*amount) as[총 구매액] from buyTbl group by userID
having sum(price*amount) > 1000;

select num ,groupName, sum(price*amount)as[비용] from buyTbl
group by rollup(groupName, num);
-- 그룹별 총합계를 구해준다.
grouping_id(groupName) -- 결과값이 1이면 합계를 위해 추가된열 아니면 본래 결과열
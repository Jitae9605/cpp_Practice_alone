create table userTbl		-- 회원테이블 생성
(
userID char(8) not null primary key,	-- 사용자 아이디(기본키)
name nchar(10) not null,				-- 이름
birthday int not null,					-- 출생년도
addr nchar(2) not null,					-- 지역(서울,경기 등)
mobile1 char(3),						-- 휴대번호 국번(011,010...)
mobile2 char(8),						-- 휴대번호 나머지(하이픈 제외)
height smallint,						-- 키
mDate date								-- 회원가입일
);
go
create table buyTbl			-- 구매테이블 생성
(
num int identity not null primary key,								-- 순번(기본키)
userID char(8) not null foreign key references userTbl(userID),		-- 구매자 아이디(외래키 - 회원테이블(사용자아이디))
prodName nchar(6) not null,											-- 물품명
groupName nchar(4),													-- 분류
price int not null,													-- 단가
amount smallint not null											-- 수량
);
go

insert into userTbl values('LSG','이승기',1987,'서울','011','11111111',182,'2008-8-8');
insert into userTbl values('KBS','김범수',1979,'경남','011','22222222',173,'2012-4-4');
insert into userTbl values('KKH','김경호',1971,'전남','019','33333333',177,'2007-7-7');
insert into userTbl values('JYP','조용필',1950,'경기','011','44444441',166,'2009-4-4');
insert into userTbl values('SSK','성시경',1979,'서울', NULL,      NULL,186,'2013-12-12');
insert into userTbl values('LJB','임재범',1969,'서울','016','66666666',182,'2009-9-9');
insert into userTbl values('YJS','윤종신',1969,'경남', NULL,      NULL,170,'2005-5-5');
insert into userTbl values('EJW','은지원',1972,'경북','011','88888888',174,'2014-3-3');
insert into userTbl values('JKW','조관우',1965,'경기','018','99999999',172,'2010-10-10');
insert into userTbl values('BBK','바비킴',1973,'서울','010','00000000',176,'2013-5-5');
GO

insert into buyTbl values('KBS','운동화',NULL  ,30   ,2);
insert into buyTbl values('KBS','노트북','전자',1000 ,1);
insert into buyTbl values('JYP','모니터','전자',200  ,1);
insert into buyTbl values('BBK','모니터','전자',200  ,5);
insert into buyTbl values('KBS','청바지','의류',50,   3);
insert into buyTbl values('BBK','메모리','전자',80,  10);
insert into buyTbl values('SSK','책',    '서적',15,   5);
insert into buyTbl values('EJW','책',    '서적',15,   2);
insert into buyTbl values('EJW','청바지','의류',50,   1);
insert into buyTbl values('BBK','운동화',NULL,  30,   2);
insert into buyTbl values('EJW','책',    '서적',15,   1);
insert into buyTbl values('BBK','온동화',NULL,  30,   2);
GO

select * from userTbl;
select * from buyTbl;

backup database sqldb to disk = 'D:\sql_backup폴더\sqldb.bak' with init;
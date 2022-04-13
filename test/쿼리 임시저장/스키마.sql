use tempdb
create database schemaDB;	-- 실습용 데이터베이스 생성
go

use schemaDB;
go
create schema userSchema;	-- 회원스키마 생성
go
create schema buySchema;	-- 구매스키마 생성
go

-- 스키마에 테이블 생성
create table userSchema.userTBL(id int);
create table buySchema.buyTBL(num int);
create table buySchema.prodTBL(pid int);

-- 이제 스키마이름.테이블이름.멤버변수 로 접근이 가능하다.

use tempdb
create database schemaDB;	-- �ǽ��� �����ͺ��̽� ����
go

use schemaDB;
go
create schema userSchema;	-- ȸ����Ű�� ����
go
create schema buySchema;	-- ���Ž�Ű�� ����
go

-- ��Ű���� ���̺� ����
create table userSchema.userTBL(id int);
create table buySchema.buyTBL(num int);
create table buySchema.prodTBL(pid int);

-- ���� ��Ű���̸�.���̺��̸�.������� �� ������ �����ϴ�.

-- Ŀ������
-- ȸ�����̺�(userTbl)���� Ű(height)�� �������� �������� Ŀ��
declare userTbl_cursor cursor global
	for select height from userTbl;


open userTbl_cursor;


-- Ŀ������ �����͸� �������� �̸� ó���ϴ� ���� �ݺ�
-- ����, ����� ���� ����
declare @height int -- ���� Ű
declare @cnt int = 0 -- ���� �ο���(=���� ���� ����)
declare @totalheight int = 0 -- Ű�� �հ�

fetch next from userTbl_cursor into @height -- ù���� �о� Ű�� @height�� �ִ´�.

-- ���������� ������ @@fetch_status �Լ��� 0�� ��ȯ ==> ���ó����
-- ��, ���̻� ���� ���̾��ٸ�(=EOF�Ǹ�) while �� ����
while @@FETCH_STATUS = 0
begin
	set @cnt += 1	-- ���� ���� ������Ŵ
	set @totalheight += @height	-- Ű�� ��Ӵ�����
	fetch next from userTbl_cursor into @height -- ������ ����
end

-- ��Ű�� ��� ���
print '�� Ű�� ��� ==> ' + cast(@totalheight/@cnt as char(10))

close userTbl_cursor; -- Ŀ������

deallocate userTbl_cursor; -- Ŀ���Ҵ�����

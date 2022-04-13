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


-- global = ����
-- local = ����

-- forward_only = ���� ����� �� ����� �ܹ������θ� Ŀ���� ������
-- scroll = Ŀ���� �����Ӱ� �̵� ( fetch next/first/last/prior... )

-- static = Ŀ���� ���̺��� �����ؼ� ������(Ŀ�� open������ update/insert �ݿ�X) 
-- keyset = Ŀ���� ����� Ű���鸸 ������(Ŀ�� open������ update�� �ݿ�O, insert�� �ݿ�X)
-- dynamic = Ŀ���� ���̺��� Ű���� ������(Ŀ��open������ ��� ������� �ݿ�O), (����Ʈ ����)
-- fast_forward = Ŀ������ �൥���� ���������� ���� �پ ����
-- ���� = fast_forward > static > keyset > dynamic

-- read_only = �б�����
-- scroll_locks = ��ġ���� ������Ʈ/���� ���
-- optimistic = Ŀ��open���� ������ ������ Ŀ���� �����Ϳ� �ݿ����� �ʰ� ����
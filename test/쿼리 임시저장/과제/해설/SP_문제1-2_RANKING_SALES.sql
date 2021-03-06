USE [ShopDB_TEST]
GO

/****** Object:  StoredProcedure [hr].[RANKING_SALES]    Script Date: 2022-04-18 오후 3:35:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [hr].[RANKING_SALES] 
AS
BEGIN
    ----------------------------------------------------------------------
    -- 실습을 위한 테이블 생성 및 자료 입력 
    -- 임시적 사용을 위해 임시테이블로 생성함 
    ----------------------------------------------------------------------
    CREATE TABLE #salesTbl (
        deptCode        NVARCHAR(20),
        numberOfSales        int
    )
    INSERT INTO #salesTbl (deptCode, numberOfSales) 
         VALUES ('A', 100), ('B', 70), ('C', 50),
                ('D',  70), ('E', 85)
                                
    ----------------------------------------------------------------------
    -- 결과 출력 
    ----------------------------------------------------------------------
    SELECT A.deptCode [부서 코드], A.numberOfSales [매출 수량],
           RANK() OVER(ORDER BY A.numberOfSales DESC)[매출 순위]
      FROM #salesTbl A 
END

GO



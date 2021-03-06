USE [ShopDB_TEST]
GO

/****** Object:  StoredProcedure [hr].[GUGUDAN_WHILE]    Script Date: 2022-04-18 오후 3:37:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [hr].[GUGUDAN_WHILE]
AS
BEGIN
    -- gugudanTbl 저장을 위해 임시테이블을 생성한다 
    CREATE TABLE #gugudanTbl (
        numberOfDan        INT,
        numberOfIteration        INT 
    )

    DECLARE @numberOfDan      INT = 2,
            @numberOfIteration      INT = 1

    WHILE (@numberOfDan <= 9) BEGIN 

        SET @numberOfIteration = 1 

        WHILE (@numberOfIteration <= 9) BEGIN 

            INSERT INTO #gugudanTbl (numberOfDan, numberOfIteration) VALUES (@numberOfDan, @numberOfIteration) 

            SET @numberOfIteration = @numberOfIteration + 1 

        END 

        SET @numberOfDan = @numberOfDan + 1 
    END 

    SELECT A.numberOfDan [단], A.numberOfIteration [반복수], 
           A.numberOfDan * A.numberOfIteration [결과]
      FROM #gugudanTbl A 
     ORDER BY A.numberOfDan, A.numberOfIteration 
END

GO



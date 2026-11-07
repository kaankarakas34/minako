CREATE PROCEDURE [dbo].[UPDATE_SHERIFF_REPORTS]
@Type tinyint,
@strCharID varchar(21),
@Yes tinyint,
@No tinyint,
@Sheriff varchar(21)
AS

   DECLARE @EvetA varchar(21), @EvetB varchar(21), @NoA varchar(21), @NoB varchar(21), @NoC varchar(21)
      IF (@Type = 1)
         BEGIN
            SELECT @EvetA = SheriffYesB, @EvetB = SheriffYesC FROM SHERIFF_REPORTS WHERE ReportedName = @strCharID	
               IF(@EvetA IS NULL)
                  UPDATE SHERIFF_REPORTS SET Yes = @Yes, SheriffYesB = @Sheriff WHERE ReportedName = @strCharID
                     ELSE IF(@EvetB IS NULL)
                        UPDATE SHERIFF_REPORTS SET Yes = @Yes, SheriffYesC = @Sheriff WHERE ReportedName = @strCharID
                           END
   ELSE IF (@Type = 2)
      BEGIN 
         SELECT @NoA = SheriffNoA, @NoB = SheriffNoB, @NoC = SheriffNoC FROM SHERIFF_REPORTS WHERE ReportedName = @strCharID
            IF(@NoA IS NULL)
               UPDATE SHERIFF_REPORTS SET [No] = @No, SheriffNoA = @Sheriff WHERE ReportedName = @strCharID
                  ELSE IF(@NoB IS NULL)
                     UPDATE SHERIFF_REPORTS SET [No] = @No, SheriffNoB = @Sheriff WHERE ReportedName = @strCharID
                        ELSE IF(@NoC IS NULL)
                           UPDATE SHERIFF_REPORTS SET [No] = @No, SheriffNoC = @Sheriff WHERE ReportedName = @strCharID
                              END
IF (@yes > 2 or @No >= 2)
BEGIN
      DELETE FROM SHERIFF_REPORTS WHERE ReportedName = @strCharID
END

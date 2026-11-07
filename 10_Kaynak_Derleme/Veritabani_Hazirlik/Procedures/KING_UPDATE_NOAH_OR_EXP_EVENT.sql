CREATE PROC [dbo].[KING_UPDATE_NOAH_OR_EXP_EVENT]
@byType tinyint,
@byNation tinyint,
@byAmount tinyint,
@byDay tinyint,
@byHour tinyint,
@byMinute tinyint,
@sDuration	smallint,
@nCoins int
AS

  IF @byType = 1
    BEGIN
      UPDATE KING_SYSTEM SET byNoahEvent = @byAmount, byNoahEvent_Day = @byDay, byNoahEvent_Hour = @byHour, byNoahEvent_Minute = @byMinute, sNoahEvent_Duration = @sDuration, nNationalTreasury = @nCoins WHERE byNation = @byNation
		END
		  ELSE IF @byType = 2
		    BEGIN
		      UPDATE KING_SYSTEM SET byExpEvent = @byAmount, byExpEvent_Day = @byDay, byExpEvent_Hour = @byHour, byExpEvent_Minute = @byMinute, sExpEvent_Duration = @sDuration,nNationalTreasury = @nCoins WHERE byNation = @byNation
		        END

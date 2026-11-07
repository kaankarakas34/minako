CREATE PROCEDURE [dbo].[UPDATE_DRAKI_TOWER_DATA]
@strCharID char(21),
@DrakiTime int,
@DrakiStage tinyint
AS

DECLARE @tempStage tinyint, @tempTime int

DECLARE @FinalStage tinyint = 41

SELECT @TempTime = iDrakiTime, @TempStage = bDrakiStage  FROM USER_DRAKI_TOWER_DATA where strUserID = @strCharID

/*IF (@DrakiStage >= @TempStage AND @DrakiTime <= @TempTime/* AND @DrakiStage != @FinalStage*/)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END

IF (@DrakiTime <= @TempTime AND @DrakiStage = @FinalStage)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END*/

IF (@DrakiStage > @TempStage AND @DrakiStage != @FinalStage)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END
ELSE IF (@DrakiStage = @TempStage AND @DrakiTime <= @TempTime AND @DrakiStage != @FinalStage)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END
ELSE IF (@DrakiStage >= @TempStage AND @DrakiTime <= @TempTime)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END

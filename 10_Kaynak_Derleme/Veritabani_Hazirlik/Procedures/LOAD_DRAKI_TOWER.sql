CREATE PROCEDURE [dbo].[LOAD_DRAKI_TOWER]
@strCharID char(21)
AS

BEGIN
	SELECT iDrakiTime,bDrakiStage,bDrakiEnteranceLimit FROM USER_DRAKI_TOWER_DATA WHERE strUserID = @strCharID
END

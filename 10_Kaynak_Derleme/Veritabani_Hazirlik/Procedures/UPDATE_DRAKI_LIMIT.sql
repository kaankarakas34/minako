CREATE PROCEDURE [dbo].[UPDATE_DRAKI_LIMIT]
@strCharID char(21),
@DrakiEnteranceLimit tinyint
AS

BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET bDrakiEnteranceLimit = @DrakiEnteranceLimit WHERE strUserID = @strCharID
END

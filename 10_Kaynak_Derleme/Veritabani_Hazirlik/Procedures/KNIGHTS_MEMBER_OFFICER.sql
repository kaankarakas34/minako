CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_OFFICER]
@strCharID char(21),
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE USERDATA SET Fame = 4 WHERE strUserID = @strCharID AND Knights = @sClanID
	UPDATE USER_KNIGHTDATA SET Fame = 4 WHERE strUserID = @strCharID AND sClanID = @sClanID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_ADMIT]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE USERDATA SET Fame = 3 WHERE strUserID = @strCharID AND Knights = @sClanID
	UPDATE USER_KNIGHTDATA SET Fame = 3 WHERE strUserID = @strCharID AND sClanID = @sClanID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_USERMEMO]
@strUserID char(21),
@strMemo char(20)
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE USER_KNIGHTDATA SET strMemo = @strMemo WHERE strUserID = @strUserID
	END

	RETURN 1
-------------------------------------------------------------------------------------------------------
--TheThyke

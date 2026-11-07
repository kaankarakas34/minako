CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_REFUNDNP]
@strUserID char(21),
@nRefundNP int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE USERDATA SET Loyalty += @nRefundNP WHERE strUserID = @strUserID
		UPDATE USER_KNIGHTDATA SET loyalty += @nRefundNP WHERE strUserID = @strUserID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

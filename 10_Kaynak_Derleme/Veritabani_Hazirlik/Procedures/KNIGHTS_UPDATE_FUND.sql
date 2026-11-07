CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_FUND]
@sClanID smallint,
@nClanPointFund int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET ClanPointFund = @nClanPointFund WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

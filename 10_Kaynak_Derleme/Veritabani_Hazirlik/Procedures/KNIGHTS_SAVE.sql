CREATE PROCEDURE [dbo].[KNIGHTS_SAVE]
@sClanID smallint,
@bFlag tinyint,
@nClanFund int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET Flag = @bFlag,ClanPointFund = @nClanFund WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--YNG

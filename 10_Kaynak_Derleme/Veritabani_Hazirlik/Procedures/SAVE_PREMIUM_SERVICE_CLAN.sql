CREATE PROCEDURE [dbo].[SAVE_PREMIUM_SERVICE_CLAN]
@sClanID smallint,
@sPremiumInUse tinyint,
@sPremiumTime int
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE KNIGHTS SET sPremiumInUse = @sPremiumInUse, sPremiumTime = @sPremiumTime WHERE IDNum = @sClanID
END
-------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SAVE_PREMIUM_SERVICE_USER_V2]
@strAccountID char(20),
@strPremium binary(30),
@Counter int,
@bPremiumInUse tinyint,
@time int
AS

BEGIN
	UPDATE ACCOUNT_PREMIUM_DATA SET strPremium = @strPremium, sPremiumCount = @Counter,sPremiumInUse = @bPremiumInUse,sPremiumTime = @time WHERE strAccountID = @strAccountID
END

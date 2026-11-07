CREATE PROCEDURE [dbo].[LOAD_PREMIUM_SERVICE_USER_V2]
@strAccountID char(20)
AS

BEGIN
	SELECT sPremiumInUse,sPremiumCount,strPremium FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
END

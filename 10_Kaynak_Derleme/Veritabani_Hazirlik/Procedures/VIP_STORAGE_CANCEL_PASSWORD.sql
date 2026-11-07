CREATE PROCEDURE [dbo].[VIP_STORAGE_CANCEL_PASSWORD]
@strAccountID char(21),
@key tinyint
AS

DECLARE @bCount tinyint
SELECT @bCount = COUNT(strAccountID) FROM VIP_WAREHOUSE WHERE strAccountID = @strAccountID

IF (@bCount = 0)
    RETURN 2
ELSE
	UPDATE VIP_WAREHOUSE SET WipPasswordRequest = @key WHERE strAccountID = @strAccountID

RETURN 1

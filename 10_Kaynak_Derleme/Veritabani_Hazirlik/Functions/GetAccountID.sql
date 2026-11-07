CREATE FUNCTION [dbo].[GetAccountID]
(
	@strCharID char(20)
)
RETURNS char(20)
-- =============================================
-- Author:		Terry
-- Create date: 2016-28-03
-- =============================================
BEGIN
	DECLARE @strAccountID char(20)

	SELECT @strAccountID = strAccountID FROM ACCOUNT_CHAR WHERE @strCharID IN(strCharID1, strCharID2, strCharID3,strCharID4)

	RETURN @strAccountID
END

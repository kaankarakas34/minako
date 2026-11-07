CREATE PROCEDURE [dbo].[GET_ALL_CHARID]
@strAccountID varchar(21)
AS

-------------------------------------------------------------------------------------------------------
   SELECT strCharID1,strCharID2,strCharID3,strCharID4 FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
-------------------------------------------------------------------------------------------------------
--TheThyke

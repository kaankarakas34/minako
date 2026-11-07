CREATE PROCEDURE [dbo].[UPDATE_ALL_CHAR_ID]
@strAccountID varchar(21),
@strCharID1 char(21),
@strCharID2 char(21),
@strCharID3 char(21),
@strCharID4 char(21)
AS

BEGIN
	UPDATE ACCOUNT_CHAR SET strCharID1 = @strCharID1,strCharID2 = @strCharID2, strCharID3 = @strCharID3,strCharID4 = @strCharID4 WHERE strAccountID = @strAccountID
END

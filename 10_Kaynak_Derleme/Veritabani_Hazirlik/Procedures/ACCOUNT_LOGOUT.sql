CREATE PROCEDURE [dbo].[ACCOUNT_LOGOUT]
@strAccountID varchar(21)
AS

BEGIN
	DELETE FROM CURRENTUSER WHERE strAccountID = @strAccountID
END
/*
DECLARE @FirstCharacterLastExit datetime, @TwoCharacterLastExit datetime,@ThreeCharacterLastExit datetime
DECLARE @strCharID1 Char(21),@strCharID2 Char(21),@strCharID3 Char(21)
SELECT @FirstCharacterLastExit = FirstCharacterLastExit, @TwoCharacterLastExit = TwoCharacterLastExit , @ThreeCharacterLastExit = ThreeCharacterLastExit FROM KOHSTR_OLD_CHARACTER_LETTER_SYSTEM WHERE AccountID = @strAccountID
SELECT @strCharID1 = FirstCharName ,@strCharID2 = TwoCharName, @strCharID3 = ThreeCharName FROM KOHSTR_OLD_CHARACTER_LETTER_SYSTEM WHERE AccountID = @strAccountID
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET FirstCharacterLastExit = GETDATE() WHERE FirstCharName = @strCharID1
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET TwoCharacterLastExit = GETDATE() WHERE TwoCharName = @strCharID2
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET ThreeCharacterLastExit = GETDATE() WHERE ThreeCharName = @strCharID3
*/

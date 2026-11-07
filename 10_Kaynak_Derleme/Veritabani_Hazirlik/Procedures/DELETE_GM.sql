CREATE PROCEDURE [dbo].[DELETE_GM]
@strUserID varchar(21)
AS
BEGIN
DECLARE @strAccountID varchar(21)
SELECT @strAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID1 = @strUserID or strCharID2 = @strUserID or strCharID3 = @strUserID  or strCharID4 = @strUserID 
END
BEGIN
UPDATE USERDATA SET Authority = 1 WHERE strUserID = @strUserID

DELETE FROM [KNIGHT_TEMU_2239].dbo.GAME_MASTER_SETTINGS WHERE strCharID = @strUserID

print 'Felicidades, El usuario ha sido eliminado correctamente como GM'

END

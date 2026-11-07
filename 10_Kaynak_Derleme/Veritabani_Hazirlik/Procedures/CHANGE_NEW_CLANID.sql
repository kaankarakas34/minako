CREATE PROCEDURE [dbo].[CHANGE_NEW_CLANID]
@strClanID		varchar(30),
@strNewClanID	varchar(30)
AS

DECLARE @AccountID varchar(20),@UserID varchar(20)

SELECT @UserID = Chief from KNIGHTS where IDName = @strClanID

SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID1 = @UserID
SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID2 = @UserID
SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID3 = @UserID
SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID4 = @UserID

DECLARE @Count tinyint
SELECT @Count = COUNT(IDName) FROM KNIGHTS WHERE IDName = @strNewClanID
IF (@Count > 0)
	RETURN 2

IF (@Count = 0)
BEGIN
	DECLARE @IDNum smallint
	SELECT @IDNum = IDNum FROM KNIGHTS WHERE IDName = @strClanID

	UPDATE KNIGHTS SET IDName = @strNewClanID WHERE IDNum = @IDNum
	--UPDATE KNIGHTS_SIEGE_WARFARE_REGISTER SET sBaseClanNum = @strNewClanID WHERE sBaseClanNum = @strClanID
	--UPDATE KNIGHTS_SIEGE_WARFARE_BARRACK SET BaseClanID = @strNewClanID WHERE BaseClanID = @strClanID
	--UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sBaseClanNum = @strNewClanID WHERE sBaseClanNum = @strClanID
	--UPDATE KNIGHTS_SIEGE_WARFARE_RANK_RESULT SET sBaseClanNum = @strNewClanID WHERE sBaseClanNum = @strClanID
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.CLAN_NAME_CHANGE_LOG (AccountID,UserID,  ClanID, ClanName, NewClanName,LogTime) VALUES (@AccountID,@UserID, @IDNum, @strClanID, @strNewClanID, GETDATE())
END
IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 1
	END
COMMIT TRAN

RETURN 3

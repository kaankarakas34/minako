CREATE PROCEDURE [dbo].[CHARACTER_UNSEAL_PROCEED]
@strAccountID varchar(21),
@Index tinyint,
@nItemSerial bigint
AS

DECLARE @AccountNation tinyint, @CharNum tinyint
DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20), @CharID4 varchar(20)

SELECT @AccountNation = bNation, @CharNum = bCharNum, @CharID1 = strCharID1, @CharID2 = strCharID2, @CharID3 = strCharID3, @CharID4 = strCharID4 FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0 OR @CharNum = 4)
	RETURN 2

DECLARE @strUserID char(21)
SELECT @strUserID = strUserID FROM USER_CHARACTER_SEAL_ITEMS WHERE strAccountID = @strAccountID AND nItemSerial = @nItemSerial
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	RETURN 2

DECLARE @Nation tinyint, @CypherRingSerial bigint
SELECT @Nation = Nation FROM USERDATA WHERE strUserID = @strUserID
SELECT @CypherRingSerial = nItemSerial FROM USER_CHARACTER_SEAL_ITEMS WHERE strUserID = @strUserID
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0 OR @CypherRingSerial = 0 OR @AccountNation != @Nation)
	RETURN 2

BEGIN TRANSACTION
	IF (@Index = 0 AND @CharID1 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID1 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@Index = 1 AND @CharID2 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID2 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@Index = 2 AND @CharID3 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID3 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@Index = 3 AND @CharID4 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID4 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	DELETE FROM USER_CHARACTER_SEAL_ITEMS WHERE strAccountID = @strAccountID AND nItemSerial = @nItemSerial AND strUserID = @strUserID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.CHARACTER_SEAL_LOG (strAccountID, strUserID, nSerialNum, SeatType,SealTypeDescription) VALUES (@strAccountID, @strUserID, @nItemSerial,3,'Character Use Ring (UnSeal)')

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END
COMMIT TRANSACTION

RETURN 1

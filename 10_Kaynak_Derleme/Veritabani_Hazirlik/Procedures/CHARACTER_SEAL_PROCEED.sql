CREATE PROCEDURE [dbo].[CHARACTER_SEAL_PROCEED]
@strAccountID varchar(21),
@strUserID char(21),
@nItemSerial bigint
AS

DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20), @CharID4 varchar(20)

SELECT @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''), @CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	RETURN 2

BEGIN TRANSACTION
	IF (@CharID1 <> '' AND @strUserID = @CharID1)
		UPDATE ACCOUNT_CHAR SET strCharID1 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID
	ELSE IF (@CharID2 <> '' AND @strUserID = @CharID2)
		UPDATE ACCOUNT_CHAR SET strCharID2 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID
	ELSE IF (@CharID3 <> '' AND @strUserID = @CharID3)
		UPDATE ACCOUNT_CHAR SET strCharID3 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID
	ELSE IF (@CharID4 <> '' AND @strUserID = @CharID4)
		UPDATE ACCOUNT_CHAR SET strCharID4 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	INSERT INTO USER_CHARACTER_SEAL_ITEMS (strUserID,strAccountID,nItemSerial) VALUES (@strUserID,@strAccountID,@nItemSerial)

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.CHARACTER_SEAL_LOG (strAccountID, strUserID, nSerialNum, SeatType,SealTypeDescription) VALUES (@strAccountID, @strUserID, @nItemSerial,2,'Character Seal')

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

COMMIT TRANSACTION

RETURN 1

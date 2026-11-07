CREATE PROCEDURE [dbo].[CHARACTER_SELECT_NAME_CHANGE]
@AccountID char(21),
@OldCharID char(21),
@NewCharID char(21)
AS

DECLARE @AlreadyCharName int

BEGIN TRAN
IF (dbo.IsValidCharacters(@NewCharID) = 1)
	RETURN 0

SELECT @AlreadyCharName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @NewCharID
IF(@AlreadyCharName != 0)
	RETURN 0

SELECT @AlreadyCharName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @NewCharID
IF(@AlreadyCharName = 0)
BEGIN
	UPDATE ACCOUNT_CHAR SET strCharID1 = @NewCharID WHERE strCharID1 = @OldCharID AND strCharID1 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID2 = @NewCharID WHERE strCharID2 = @OldCharID AND strCharID2 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID3 = @NewCharID WHERE strCharID3 = @OldCharID AND strCharID3 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID4 = @NewCharID WHERE strCharID4 = @OldCharID AND strCharID4 IS NOT NULL
	UPDATE USERDATA SET strUserId = @NewCharID WHERE strUserId = @OldCharID AND strUserId IS NOT NULL
	UPDATE KNIGHTS SET Chief = @NewCharID WHERE Chief = @OldCharID AND Chief IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_1 = @NewCharID WHERE ViceChief_1 = @OldCharID AND ViceChief_1 IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_2 = @NewCharID WHERE ViceChief_2 = @OldCharID AND ViceChief_2 IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_3 = @NewCharID WHERE ViceChief_3 = @OldCharID AND ViceChief_3 IS NOT NULL
	UPDATE FRIEND_LIST SET strUserID = @NewCharID where strUserID = @OldCharID
	UPDATE RENTAL_ITEM SET strLenderCharID = @NewCharID WHERE strLenderCharID = @OldCharID AND strLenderCharID IS NOT NULL
	UPDATE RENTAL_ITEM SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE RENTAL_ITEM_LIST SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @OldCharID
	UPDATE CURRENTUSER SET strCharID = @NewCharID WHERE strAccountID = @AccountID AND strCharID = @OldCharID
	UPDATE USERDATA_SKILLSHORTCUT SET strCharID = @NewCharID WHERE strCharID = @OldCharID AND strCharID IS NOT NULL
	UPDATE BATTLE SET strUserName = @NewCharID WHERE strUserName = @OldCharID AND strUserName IS NOT NULL
	UPDATE USER_DAILY_OP SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE MAIL_BOX SET strSenderID = @NewCharID WHERE strSenderID = @OldCharID AND strSenderID IS NOT NULL
	UPDATE MAIL_BOX SET strRecipientID = @NewCharID WHERE strRecipientID = @OldCharID AND strRecipientID IS NOT NULL
	UPDATE USER_ACHIEVE_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE RENTAL_ITEM SET strLenderCharID = @NewCharID WHERE strLenderCharID = @OldCharID AND strLenderCharID IS NOT NULL
	UPDATE RENTAL_ITEM SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE RENTAL_ITEM_LIST SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE SEALED_ITEMS SET strUserID = @NewCharID WHERE strUserID = @OldCharID  AND strUserID IS NOT NULL
	UPDATE USER_SEAL_EXP SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE USER_DRAKI_TOWER_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE DRAKI_TOWER_RIFT_RANK SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE WEB_ITEMMALL SET strCharID = @NewCharID WHERE strAccountID = @AccountID AND strCharID = @OldCharID
	UPDATE USER_GENIE_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE SHERIFF_REPORTS SET ReportedName = @NewCharID WHERE ReportedName = @OldCharID AND ReportedName IS NOT NULL
	UPDATE SHERIFF_REPORTS SET ReportedSheriffName = @NewCharID WHERE ReportedSheriffName = @OldCharID AND ReportedSheriffName IS NOT NULL
	UPDATE USER_RENTAL_ITEM SET strUserID = @NewCharID WHERE strAccountID = @AccountID AND strUserID = @OldCharID
	UPDATE USER_KNIGHTDATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sBaseClanCommander = @NewCharID WHERE sBaseClanCommander = @OldCharID AND sBaseClanCommander IS NOT NULL
	UPDATE KNIGHTS_SIEGE_WARFARE_REGISTER SET sBaseClanCommander = @NewCharID WHERE sBaseClanCommander = @OldCharID AND sBaseClanCommander IS NOT NULL
	UPDATE USER_RETURN_DATA SET strCharID = @NewCharID WHERE strCharID = @OldCharID AND strCharID IS NOT NULL
	UPDATE USER_QUEST_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.NAME_CHANGE_LOG (AccountID, OldCharID, NewCharID, LogTime) VALUES (@AccountID, @OldCharID, @NewCharID, GETDATE())
END
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 0
	END
COMMIT TRAN

RETURN 1

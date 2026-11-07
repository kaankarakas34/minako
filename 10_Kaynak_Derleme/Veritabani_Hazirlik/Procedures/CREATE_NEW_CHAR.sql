CREATE PROCEDURE [dbo].[CREATE_NEW_CHAR]
@strAccountID varchar(21),
@index tinyint,
@strCharID varchar(21),
@bRace tinyint,
@sClass smallint,
@nHair int,
@bFace tinyint,
@bStr tinyint,
@bSta tinyint,
@bDex tinyint,
@bIntel tinyint,
@bCha tinyint
AS

------------------------------------------------------------------------------------------------------------
DECLARE @bNation tinyint,@bCharCount tinyint,@bCount tinyint

--===================KURIAN CANCELACION==================
--IF @bRace = 6 OR @bRace = 14
--RETURN 4
--===================================================

SELECT @bNation = bNation, @bCharCount = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
	
	IF (@bNation = 1 AND @bRace > 10)
		RETURN 2
	ELSE IF (@bNation = 2 AND @bRace < 10)
		RETURN 2
	ELSE IF (@bNation <> 1 AND @bNation <> 2)
		RETURN 2
	
	IF (dbo.IsValidCharacters(@strCharID) = 1)
		RETURN 5

SELECT @bCount = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strCharID
	IF (@bCount > 0)
		RETURN 3
------------------------------------------------------------------------------------------------------------
BEGIN TRAN
	IF (@index = 0)
		UPDATE ACCOUNT_CHAR SET strCharID1 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID 
	ELSE IF (@index = 1)
		UPDATE ACCOUNT_CHAR SET strCharID2 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@index = 2)
		UPDATE ACCOUNT_CHAR SET strCharID3 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@index = 3)
		UPDATE ACCOUNT_CHAR SET strCharID4 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 4
	END

	BEGIN
		/* Character Creation */
		INSERT INTO USERDATA (strUserID, Nation, Race, Class, HairRGB, Face, Strong, Sta, Dex, Intel, Cha,
            Rank, Title, [Level], bRebirthLevel, City, Fame, bRebStr, bRebSta, bRebDex, bRebIntel, bRebCha,
            Authority, Zone, Loyalty, LoyaltyMonthly, strItem, strDeletedItem, strSerial, strItemTime, dtCreateTime)
        VALUES (@strCharID, @bNation, @bRace, @sClass, @nHair, @bFace, @bStr, @bSta, @bDex, @bIntel, @bCha,
            0,0,1,0,0,0,0,0,0,0,0,1,21,0,0,
            CAST(0x00 AS BINARY(600)),CAST(0x00 AS BINARY(480)),CAST(0x00 AS BINARY(600)),CAST(0x00 AS BINARY(300)),GETDATE())
		--VALUES (@strCharID, @bNation, @bRace, @sClass, @nHair, @bFace, 255, 255, 255, 255, 255)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
    		
		/* Creating Character Skill Data */
		INSERT INTO USERDATA_SKILLSHORTCUT (strCharID, nCount, strSkillData) VALUES (@strCharID, 0, 0x00)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Creating a Character Skill Bar */
		INSERT INTO USER_SAVED_MAGIC (strCharID, nSkill1, nDuring1, nSkill2, nDuring2, nSkill3, nDuring3, nSkill4, nDuring4, nSkill5, nDuring5, nSkill6, nDuring6, nSkill7, nDuring7, nSkill8, nDuring8, nSkill9, nDuring9, nSkill10, nDuring10 )
		VALUES (@strCharID, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Creating User Clan Information */
		INSERT INTO USER_KNIGHTDATA (sClanID,strUserID,nDonatedNP,strMemo,fame,sClass,[level],lastLogin,Loyalty) VALUES (0,@strCharID,0,'',0,@sClass,1,0,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Boosted-profile gifts must not enter normal level-one progression. */
        IF EXISTS(SELECT 1 FROM BEGINNER_SETTINGS WHERE ServerNo=1 AND BeginnerType<>0)
        BEGIN
        /* Sending a Character Starter Gift */
		INSERT INTO MAIL_BOX (dtSendDate, bStatus, strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability)
		SELECT GETDATE(), 1, SenderID, @strCharID, ItemName, ItemDescription, LetterType, ItemID, ItemCount, ItemDuration FROM LETTER_GIFT WHERE SendingStatus = 1
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		END;
        /* Character Achieve Initial Creation */
		--Status 1: Let All Tasks Begin Unfinished.
		--Status 2: Let All Tasks Begin Done.
		INSERT INTO USER_ACHIEVE_DATA(strUserID,sCoverID,sSkillID,sAchieveCount,strAchieve) SELECT @strCharID,sCoverID,sSkillID,sAchieveCount,strAchieve FROM USER_ACHIEVE_LOAD_DATA WHERE sStatus = 1

		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Creating a Character Genie */
		INSERT INTO USER_GENIE_DATA (strUserID,sGenieTime,strGenieOptions,sFirstUsingGenie) VALUES (@strCharID,0,0x00,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Creating User Seal Exp */
		INSERT INTO USER_SEAL_EXP (strUserID,sSealedExp) VALUES (@strCharID,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Return Data */
		INSERT INTO USER_RETURN_DATA (strCharID,ReturnSymbolisOK,ReturnisLogOutTime,ReturnSymbolTime) VALUES (@strCharID,0,0,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_RETURN_DATA WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Quest Data */
		INSERT INTO USER_QUEST_DATA (strUserID,sQuestCount,strQuest) VALUES (@strCharID,0,0x00)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_RETURN_DATA WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_QUEST_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Quest Closed Skill Data */
		INSERT INTO QUEST_SKILLS_CLOSED_DATA (strUserID,strQuestSkill,strQuestSkillCount,strCheck) VALUES (@strCharID,0x00,0,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_RETURN_DATA WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_QUEST_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM QUEST_SKILLS_CLOSED_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Character Start */
		EXEC LOAD_NEW_CHAR_VALUE @StrCharID , @sClass;
        IF EXISTS(SELECT 1 FROM BEGINNER_SETTINGS WHERE ServerNo=1 AND BeginnerType<>0)
        BEGIN
          UPDATE TB_USER SET CashPoint=50000,BonusCashPoint=55000 WHERE strAccountID=@strAccountID;
        END;
    	EXEC DELETE_GM @StrUserID = @strCharID;
	END

   IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 4
	END

COMMIT TRAN
RETURN 0

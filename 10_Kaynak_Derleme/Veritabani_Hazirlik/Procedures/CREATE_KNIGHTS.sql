CREATE PROCEDURE [dbo].[CREATE_KNIGHTS]
@sClanID smallint,
@bNation tinyint,
@bFlag tinyint,
@strKnightsName char(21),
@strChief char(21)
AS

     DECLARE @bCount tinyint,@ServerNo smallint
       SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID OR IDName = @strKnightsName
         IF (@bCount > 0)
           RETURN 3
		SELECT @ServerNo = nServerNo FROM CURRENTUSER where strCharID = @strChief
			IF (@ServerNo > 15001)
				RETURN 8
			     IF (@sClanID = 0)
	                RETURN 6
             BEGIN TRAN
               INSERT INTO KNIGHTS (IDNum, Nation, Flag, IDName, Chief) VALUES (@sClanID, @bNation, @bFlag, @strKnightsName, @strChief)
			     UPDATE USER_KNIGHTDATA SET sClanID = @sClanID,Fame = 1 WHERE strUserID = @strChief
			       UPDATE USERDATA SET Knights = @sClanID, Fame = 1 WHERE strUserID = @strChief
                   --INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.KOHSTR_CREATE_CLAN_LOG (UserID,ClanName,CreatedLogTime) VALUES (@strChief,@strKnightsName,GETDATE())
   IF (@@ERROR <> 0)
     BEGIN
       ROLLBACK TRAN
         RETURN 6
           END
             COMMIT TRAN
               RETURN 0

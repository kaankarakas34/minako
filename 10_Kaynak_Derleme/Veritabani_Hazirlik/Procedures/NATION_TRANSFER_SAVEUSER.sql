CREATE PROCEDURE [dbo].[NATION_TRANSFER_SAVEUSER]
@strAccountID varchar(21),
@strCharID varchar(21),
@nNum int,
@bnewRace tinyint,
@bNewClass smallint,
@bNewNation tinyint,
@bNewFace tinyint,
@iNewHair int
AS

BEGIN
	UPDATE USERDATA SET Nation = @bNewNation, Race = @bnewRace, Class = @bNewClass,HairRGB = @iNewHair,Face = @bNewFace WHERE strUserID = @strCharID
	UPDATE ACCOUNT_CHAR SET bNation = @bNewNation,bCharNum = @nNum WHERE strAccountID = @strAccountID
	UPDATE USER_KNIGHTDATA SET sClass = @bNewClass WHERE strUserID = @strCharID
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.NATION_TRANSFER_LOG(AccountID, UserID, Race,NewClass,Face,NewNation,LogTime) VALUES (@strAccountID, @strCharID, @bnewRace,@bNewClass,@bNewFace,@bNewNation,GETDATE())
END

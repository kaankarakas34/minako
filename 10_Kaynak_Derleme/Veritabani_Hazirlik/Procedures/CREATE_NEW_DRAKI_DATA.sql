CREATE PROCEDURE [dbo].[CREATE_NEW_DRAKI_DATA]
@strCharID char(21),
@Class tinyint
AS

DECLARE @CharCount tinyint,@ClassName varchar(20)
SELECT @CharCount = COUNT(strUserID) FROM USER_DRAKI_TOWER_DATA WHERE strUserID = @strCharID

IF (@Class = 1)
	SET @ClassName = 'Warrior'
ELSE IF (@Class = 2)
	SET @ClassName = 'Rogue'
ELSE IF (@Class = 3)
	SET @ClassName = 'Mage'
ELSE IF (@Class = 4)
	SET @ClassName = 'Priest'
ELSE IF (@Class = 13)
	SET @ClassName = 'Kurian'

IF (@CharCount = 0)
BEGIN
	INSERT INTO USER_DRAKI_TOWER_DATA (strUserID,Class,ClassName,iDrakiTime,bDrakiStage,bDrakiEnteranceLimit) VALUES (@strCharID,@Class,@ClassName,3600,1,3)
END

RETURN 1

CREATE PROCEDURE [dbo].[LOAD_USER_QUEST_DATA]
@strCharID varchar(21)
AS

BEGIN
	SELECT sQuestCount,strQuest FROM USER_QUEST_DATA WHERE strUserID = @strCharID
END

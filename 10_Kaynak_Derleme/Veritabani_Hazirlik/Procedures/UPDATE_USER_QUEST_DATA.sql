CREATE PROCEDURE [dbo].[UPDATE_USER_QUEST_DATA]
@strCharID char(21),
@strQuest binary(3888),
@sQuestCount smallint
AS

BEGIN
	UPDATE USER_QUEST_DATA SET sQuestCount = @sQuestCount, strQuest = @strQuest WHERE strUserID = @strCharID
END

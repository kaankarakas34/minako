CREATE PROCEDURE [dbo].[LOAD_GENIE_DATA]
@strUserID char(21)
AS

DECLARE @Count smallint
SELECT @Count = COUNT(strUserID) FROM USER_GENIE_DATA WHERE strUserID = @strUserID

IF (@Count = 0)
BEGIN
	INSERT INTO USER_GENIE_DATA (strUserID,sGenieTime,strGenieOptions,sFirstUsingGenie) VALUES (@strUserID,0,0x00,0)
	SELECT sGenieTime,strGenieOptions,sFirstUsingGenie FROM USER_GENIE_DATA WHERE strUserID = @strUserID
END
ELSE
BEGIN
	SELECT sGenieTime,strGenieOptions,sFirstUsingGenie FROM USER_GENIE_DATA WHERE strUserID = @strUserID
END

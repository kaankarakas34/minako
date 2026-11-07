CREATE PROCEDURE [dbo].[UPDATE_GENIE_DATA]
@strUserID char(21),
@strGenieOptions binary(100),
@sGenieTime	smallint,
@First tinyint
AS

BEGIN
	UPDATE USER_GENIE_DATA SET sGenieTime = @sGenieTime , strGenieOptions = @strGenieOptions, sFirstUsingGenie = @First WHERE strUserID = @strUserID
END

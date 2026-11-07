CREATE PROCEDURE [dbo].[LOAD_USER_RETURN_DATA]
@CharID char(21)
AS

BEGIN
	SELECT ReturnSymbolisOK,ReturnisLogOutTime,ReturnSymbolTime FROM USER_RETURN_DATA WHERE strCharID = @CharID
END

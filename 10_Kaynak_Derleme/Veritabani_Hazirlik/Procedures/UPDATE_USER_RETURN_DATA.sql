CREATE PROCEDURE [dbo].[UPDATE_USER_RETURN_DATA]
@CharID char(21),
@isOK int,
@loqtime bigint,
@symboltime bigint
AS

BEGIN
	UPDATE USER_RETURN_DATA SET ReturnSymbolisOK = @isOK,ReturnisLogOutTime = @loqtime,ReturnSymbolTime = @symboltime WHERE strCharID = @CharID
END

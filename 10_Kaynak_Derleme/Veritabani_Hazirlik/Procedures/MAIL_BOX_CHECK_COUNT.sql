CREATE PROCEDURE [dbo].[MAIL_BOX_CHECK_COUNT]
@strRecipientID varchar(21)
AS

DECLARE @bCount tinyint

SELECT TOP(20) @bCount = COUNT(*) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0

RETURN @bCount

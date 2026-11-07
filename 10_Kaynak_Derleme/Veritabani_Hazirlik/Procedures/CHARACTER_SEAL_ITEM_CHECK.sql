CREATE PROCEDURE [dbo].[CHARACTER_SEAL_ITEM_CHECK]
@CharID varchar(20)
AS

DECLARE @binaryLoop int = 1
DECLARE @ItemID int

WHILE (@binaryLoop < 600)
BEGIN
	SELECT 
	@ItemID = /*ItemID*/CAST(CAST(REVERSE(SUBSTRING(strItem, @binaryLoop, 4)) AS VARBINARY) AS INT)
	FROM [KNIGHT_TEMU_2239].dbo.USERDATA WHERE (CAST(CAST(REVERSE(SUBSTRING(strItem, @binaryLoop, 4)) AS VARBINARY) AS INT)) <> 0 AND strUserID = @CharID

	SET @binaryLoop += 8

	IF (@ItemID != 0)
		RETURN 0
END

SET @binaryLoop = 1

RETURN 1

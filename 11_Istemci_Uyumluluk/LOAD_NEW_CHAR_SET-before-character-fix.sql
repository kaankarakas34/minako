CREATE PROCEDURE [dbo].[LOAD_NEW_CHAR_SET]
@CharID varchar(20),
@Class smallint
AS

DECLARE @SlotID tinyint = 0, @binaryLoop int = 0, @binaryLoopEx int = 0
DECLARE @ItemID int, @ItemDuration smallint, @ItemCount smallint, @ItemFlag tinyint, @ItemExpireTime int
DECLARE @binaryItemID varbinary(4), @binaryItemDuration varbinary(2), @binaryItemCount varbinary(2), @binaryItemFlag varbinary(1), @binaryItemExpireTime varbinary(4)
DECLARE @binaryItemData binary(600) = 0x00, @binaryItemDataEx binary(370) = 0x00

WHILE (@SlotID < 75)
BEGIN
	SELECT @ItemID = ItemID, @ItemDuration = ItemDuration, @ItemCount = ItemCount, @ItemFlag = ItemFlag, @ItemExpireTime = ItemExpireTime FROM CREATE_NEW_CHAR_SET WHERE ClassType = @Class % 100 AND SlotID = @SlotID

	IF (@@ROWCOUNT = 0)
		RETURN

	SET @binaryItemID = SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 4, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 3, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 2, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 1, 1)
	SET @binaryItemDuration = SUBSTRING(CAST(@ItemDuration AS VARBINARY(2)), 2, 1) + SUBSTRING(CAST(@ItemDuration AS VARBINARY(2)), 1, 1)
	SET @binaryItemCount = SUBSTRING(CAST(@ItemCount AS VARBINARY(2)), 2, 1) + SUBSTRING(CAST(@ItemCount AS VARBINARY(2)), 1, 1)
	SET @binaryItemFlag = SUBSTRING(CAST(@ItemFlag AS VARBINARY(1)), 1, 1)
	SET @binaryItemExpireTime = SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 4, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 3, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 2, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 1, 1)

	SET @binaryItemData = CAST(SUBSTRING(@binaryItemData, 1, @binaryLoop) + CAST(CAST(@binaryItemID AS VARBINARY(4)) + @binaryItemDuration +  @binaryItemCount AS VARBINARY(8)) + SUBSTRING(@binaryItemData, @binaryLoop + 8, 593 - @binaryLoop) AS BINARY(592))
	SET @binaryItemDataEx = CAST(SUBSTRING(@binaryItemDataEx, 1, @binaryLoopEx) + CAST(CAST(@binaryItemFlag AS VARBINARY(1)) + @binaryItemExpireTime AS VARBINARY(5)) + SUBSTRING(@binaryItemDataEx, @binaryLoopEx + 5, 371 - @binaryLoopEx) AS BINARY(370))

	SET @SlotID += 1
	SET @binaryLoop += 8
	SET @binaryLoopEx += 5
END
/* codigo para inicializar items segun BEGINNER_ITEMS */

SELECT @binaryItemData = strItem FROM BEGINNER_ITEMS WHERE iClass = @Class % 100
    
UPDATE USERDATA SET strItem = @binaryItemData, strItemTime = @binaryItemDataEx WHERE strUserID = @CharID

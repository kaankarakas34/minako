CREATE PROCEDURE [dbo].[LOAD_NEW_CHAR_SET]
@CharID varchar(20),
@Class smallint
AS

-- Normal level-one progression uses a separate basic preset. Keep the supplied
-- high-level PvP templates for explicitly selected boosted profiles only.
IF EXISTS(SELECT 1 FROM BEGINNER_SETTINGS WHERE ServerNo=1 AND BeginnerType=0)
BEGIN
 DECLARE @normalSlot int=0,@normalID int,@normalDuration smallint,@normalCount smallint,@normalItems varbinary(max)=0x;
 IF NOT EXISTS(SELECT 1 FROM dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS WHERE ClassType=@Class%100)
  THROW 51102,'Normal starter preset missing for class',1;
 WHILE @normalSlot<75
 BEGIN
  SELECT @normalID=0,@normalDuration=0,@normalCount=0;
  SELECT @normalID=s.ItemID,@normalDuration=i.Duration,@normalCount=1
   FROM dbo.KNIGHTLAB_NORMAL_STARTER_ITEMS s JOIN ITEM i ON i.num=s.ItemID
   WHERE s.ClassType=@Class%100 AND s.SlotID=@normalSlot;
  SET @normalItems+=CONVERT(binary(4),REVERSE(CONVERT(binary(4),@normalID)))+CONVERT(binary(2),REVERSE(CONVERT(binary(2),@normalDuration)))+CONVERT(binary(2),REVERSE(CONVERT(binary(2),@normalCount)));
  SET @normalSlot+=1;
 END;
 UPDATE USERDATA SET strItem=@normalItems,strItemTime=CONVERT(binary(300),0x00) WHERE strUserID=@CharID;
 RETURN;
END;

DECLARE @SlotID tinyint = 0
DECLARE @ItemID int, @ItemDuration smallint, @ItemCount smallint, @ItemFlag tinyint, @ItemExpireTime int
DECLARE @binaryItemID varbinary(4), @binaryItemDuration varbinary(2), @binaryItemCount varbinary(2), @binaryItemFlag varbinary(1), @binaryItemExpireTime varbinary(4)
DECLARE @binaryItemData varbinary(max) = 0x, @binaryItemDataEx varbinary(max) = 0x

WHILE (@SlotID < 75)
BEGIN
	SELECT @ItemID = ItemID, @ItemDuration = ItemDuration, @ItemCount = ItemCount, @ItemFlag = ItemFlag, @ItemExpireTime = ItemExpireTime FROM CREATE_NEW_CHAR_SET WHERE ClassType = @Class % 100 AND SlotID = @SlotID

	IF (@@ROWCOUNT = 0)
		THROW 51011, 'Missing starter equipment slot', 1;

	SET @binaryItemID = SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 4, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 3, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 2, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 1, 1)
	SET @binaryItemDuration = SUBSTRING(CAST(@ItemDuration AS VARBINARY(2)), 2, 1) + SUBSTRING(CAST(@ItemDuration AS VARBINARY(2)), 1, 1)
	SET @binaryItemCount = SUBSTRING(CAST(@ItemCount AS VARBINARY(2)), 2, 1) + SUBSTRING(CAST(@ItemCount AS VARBINARY(2)), 1, 1)
	SET @binaryItemFlag = SUBSTRING(CAST(@ItemFlag AS VARBINARY(1)), 1, 1)
	SET @binaryItemExpireTime = SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 4, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 3, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 2, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 1, 1)

	SET @binaryItemData += @binaryItemID + @binaryItemDuration + @binaryItemCount
	-- The compiled server reads one little-endian uint32 expiry per slot (no flag byte).
	SET @binaryItemDataEx += @binaryItemExpireTime

	SET @SlotID += 1
END
/* codigo para inicializar items segun BEGINNER_ITEMS */

IF NOT EXISTS(SELECT 1 FROM BEGINNER_ITEMS WHERE iClass=@Class % 100 AND DATALENGTH(strItem)=600)
    THROW 51010, 'Invalid starter inventory binary format', 1;
SELECT @binaryItemData = strItem FROM BEGINNER_ITEMS WHERE iClass = @Class % 100
    
UPDATE USERDATA SET strItem = @binaryItemData, strItemTime = @binaryItemDataEx WHERE strUserID = @CharID

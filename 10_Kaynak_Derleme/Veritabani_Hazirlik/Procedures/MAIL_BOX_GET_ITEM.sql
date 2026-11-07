CREATE PROCEDURE [dbo].[MAIL_BOX_GET_ITEM]
@strRecipientID	varchar(21),
@nLetterID int
AS

SELECT nItemID, sCount, sDurability, nCoins, nSerialNum, nItemTime FROM MAIL_BOX WHERE nLetterID = @nLetterID AND bStatus = 1 AND strRecipientID = @strRecipientID

IF (@@ROWCOUNT = 0)
	RETURN -1

UPDATE MAIL_BOX SET bStatus = 2 WHERE nLetterID = @nLetterID AND strRecipientID = @strRecipientID 
RETURN 1

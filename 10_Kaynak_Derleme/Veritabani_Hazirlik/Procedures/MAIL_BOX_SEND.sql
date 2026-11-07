CREATE PROCEDURE [dbo].[MAIL_BOX_SEND]
@strSenderID varchar(21),
@strRecipientID varchar(21),
@strSubject varchar(31),
@strMessage varchar(128),
@bType tinyint,
@nItemID int,
@sCount smallint,
@sDurability smallint,
@nSerialNum bigint,
@nCoins int
AS

DECLARE @strRecvAccountID char(20)
DECLARE @bPremiumType tinyint
DECLARE @sLimitLine smallint
DECLARE @nCount int

SET @strRecvAccountID = dbo.GetAccountID(@strRecipientID)

IF (@strRecvAccountID IS NULL)
	RETURN -1

IF (NOT EXISTS(SELECT strUserID FROM USERDATA WHERE strUserID = @strRecipientID))
     RETURN -1

SELECT @bPremiumType = bPremiumType FROM [KNIGHT_TEMU_2239].dbo.TB_USER WHERE strAccountID = @strRecvAccountID

IF (@bPremiumType >= 5)
	SET @sLimitLine = 20
ELSE
	SET @sLimitLine = 10

SELECT @nCount = COUNT(strRecipientID) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0

IF (@nCount >= @sLimitLine)
	RETURN -2

	INSERT INTO MAIL_BOX (strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability, nSerialNum, nCoins) VALUES (@strSenderID, @strRecipientID, @strSubject, @strMessage, @bType, @nItemID, @sCount, @sDurability, @nSerialNum, @nCoins)
		
RETURN 1

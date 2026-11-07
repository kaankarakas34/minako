CREATE PROCEDURE [dbo].[NATION_SELECT]
@strAccountID varchar(21),
@bNation tinyint
AS
      
DECLARE @aCount tinyint,@bCount tinyint,@cCount tinyint,@dCount tinyint,@eCount tinyint,@fCount tinyint

IF @bNation NOT IN (1,2)
    RETURN 0

BEGIN TRAN
	SELECT @aCount = COUNT(strAccountID) FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
	IF (@aCount = 0)
	BEGIN
		INSERT INTO ACCOUNT_CHAR (strAccountID, bNation) VALUES (@strAccountID, @bNation)
	END
	ELSE
	BEGIN
		-- Account setup creates this empty row before the player chooses a nation.
		UPDATE ACCOUNT_CHAR SET bNation=@bNation
		WHERE strAccountID=@strAccountID AND bNation=0 AND bCharNum=0
		  AND ISNULL(strCharID1,'')='' AND ISNULL(strCharID2,'')=''
		  AND ISNULL(strCharID3,'')='' AND ISNULL(strCharID4,'')=''
		IF NOT EXISTS(SELECT 1 FROM ACCOUNT_CHAR WHERE strAccountID=@strAccountID AND bNation=@bNation)
		BEGIN
			COMMIT TRAN
			RETURN 0
		END
	END
                  
	SELECT @bCount = COUNT(strAccountID) FROM WAREHOUSE WHERE strAccountID = @strAccountID
	IF (@bCount = 0)
	BEGIN
		INSERT INTO WAREHOUSE (strAccountID, nMoney, dwTime, WarehouseData, strSerial, WarehouseDataTime) VALUES (@strAccountID, 0, 0, 0x00, 0x00, 0x00)	
	END
                      
	SELECT @cCount = COUNT(strAccountID) FROM VIP_WAREHOUSE WHERE strAccountID = @strAccountID
	IF (@cCount = 0)
	BEGIN
		INSERT INTO VIP_WAREHOUSE (strAccountID, strPassword,WipPasswordRequest, strExpirationDate, VIPWarehouseData, strSerial, VIPWarehouseDataTime) VALUES (@strAccountID, 1234,0, 0, 0x00, 0x00, 0x00)											
	END

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 0
	END
COMMIT TRAN

RETURN @bNation

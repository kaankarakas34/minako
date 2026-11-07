CREATE PROCEDURE [dbo].[NATION_SELECT]
@strAccountID varchar(21),
@bNation tinyint
AS
      
DECLARE @aCount tinyint,@bCount tinyint,@cCount tinyint,@dCount tinyint,@eCount tinyint,@fCount tinyint

BEGIN TRAN
	SELECT @aCount = COUNT(strAccountID) FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
	IF (@aCount = 0)
	BEGIN
		INSERT INTO ACCOUNT_CHAR (strAccountID, bNation) VALUES (@strAccountID, @bNation)
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

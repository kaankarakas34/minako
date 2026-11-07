CREATE PROCEDURE [dbo].[LOAD_RENTAL_DATA]
@strAccountID	char(21)
AS




DECLARE @CurrentTime smalldatetime
SET @CurrentTime = getdate()

SELECT 
	strUserID, 
	byRentalType, 
	byRegType, 
	nRentalIndex,
	nItemIndex, 
	sDurability, 
	nSerialNumber, 
	nRentalMoney, 
	sRentalTime, 
	sDuringTime=datediff( n, timeRental, @CurrentTime ), 
	timeRental FROM USER_RENTAL_ITEM WHERE strAccountID = @strAccountID

DELETE FROM USER_RENTAL_ITEM WHERE strAccountID = @strAccountID and (byRentalType=2 or byRentalType=3) and sRentalTime< datediff( n, timeRental, @CurrentTime ) 

UPDATE USER_RENTAL_ITEM SET nRentalMoney = 0 WHERE strAccountID = @strAccountID and byRentalType=2 and nRentalMoney>0

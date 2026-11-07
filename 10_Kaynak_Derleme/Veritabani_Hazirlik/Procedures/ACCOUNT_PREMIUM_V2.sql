CREATE PROCEDURE [dbo].[ACCOUNT_PREMIUM_V2]
@strAccountID char(20)
AS

DECLARE @AccountPremium tinyint,@PremiumOkey tinyint, @sHours int,@HoursSetting int

BEGIN TRAN
	SELECT @AccountPremium = COUNT(strAccountID) FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
	IF (@AccountPremium = 0)
	BEGIN
		INSERT INTO ACCOUNT_PREMIUM_DATA (strAccountID,strPremium,sPremiumCount,sPremiumInUse,sPremiumTime) VALUES (@strAccountID,0x00,0,0,0)
	END

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
COMMIT TRAN

DECLARE @BinaryLoopType int = 1,@BinaryLoopTime int = 2,@Dongu int = 1,@test int = 0
DECLARE @SorguPremiumType int = 0,@PremiumType1 int = 0,@PremiumType2 int = 0,@PremiumType3 int = 0,@PremiumType4 int = 0,@PremiumType5 int = 0
DECLARE @SorguPremiumTime int  = 0,@PremiumTime1 int  = 0,@PremiumTime2  int = 0,@PremiumTime3 int  = 0,@PremiumTime4 int  = 0,@PremiumTime5 int  = 0, @CurrentUnixTime int = 0, @OnlyPremiumTime int = 0, @ShowPremiumTime int = 0
DECLARE @PremiumInUse tinyint
DECLARE @Premium binary(30)

SELECT @PremiumInUse = sPremiumInUse,@PremiumOkey = sPremiumCount,@Premium = strPremium FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
IF (@PremiumOkey = 0)
	RETURN -1

WHILE (@Dongu < 6)
BEGIN
	SET @SorguPremiumType = CAST(CAST(REVERSE(SUBSTRING(@Premium, @BinaryLoopType, 1)) AS varbinary) AS int)
	SET @SorguPremiumTime = CAST(CAST(REVERSE(SUBSTRING(@Premium, @BinaryLoopTime, 4)) AS varbinary) AS int)

	IF (@Dongu = 6)
		BREAK

	IF (@SorguPremiumType > 0 AND @Dongu = 1)
	BEGIN
		SET @PremiumType1 = @SorguPremiumType
		SET @PremiumTime1 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 2)
	BEGIN
		SET @PremiumType2 = @SorguPremiumType
		SET @PremiumTime2 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 3)
	BEGIN
		SET @PremiumType3 = @SorguPremiumType
		SET @PremiumTime3 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 4)
	BEGIN
		SET @PremiumType4 = @SorguPremiumType
		SET @PremiumTime4 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 5)
	BEGIN
		SET @PremiumType5 = @SorguPremiumType
		SET @PremiumTime5 = @SorguPremiumTime
		SET @test = 1
	END

	SET @BinaryLoopType += 5
	SET @BinaryLoopTime += 5
	SET @Dongu += 1
END

IF (@test = 0)
	RETURN -1

SET @CurrentUnixTime = DATEDIFF(s, '1970-01-01', GETUTCDATE())
IF (@CurrentUnixTime = 0)
	RETURN -1

IF (@PremiumInUse = @PremiumType1 AND @PremiumTime1 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime1 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType2 AND @PremiumTime2 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime2 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType3 AND @PremiumTime3 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime3 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType4 AND @PremiumTime4 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime4 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType5 AND @PremiumTime5 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime5 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE
	RETURN -1

IF (@ShowPremiumTime <= 0)
	RETURN -1
	
IF (@OnlyPremiumTime >= 1 AND @OnlyPremiumTime <= 3600)
	SET @ShowPremiumTime = 1

RETURN @ShowPremiumTime

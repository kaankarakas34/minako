CREATE PROCEDURE [dbo].[UPDATE_USER_KNIGHTS_RANK]
AS

DECLARE @strUserID char(21),@Loyalty int,@Knights int,@KnightName char(50)
DECLARE @IsValidKnight int,@Index smallint,@IsValidCount tinyint,@nMoney int
DECLARE @RankName varchar(30)

SELECT @IsValidCount = Count(*) FROM USER_KNIGHTS_RANK
	IF @IsValidCount < 200
	BEGIN
		SET @Index = 1
	WHILE @Index < 201
	BEGIN
	IF @Index = 1
	BEGIN
		SET @RankName = 'Gold Knight' 
		SET @nMoney = 1000000
	END
	IF @Index > 1 AND @Index <= 4
	BEGIN
		SET @RankName = 'Silver Knight'
		SET @nMoney = 700000
	END
	IF @Index > 4 AND @Index <= 10
	BEGIN
		SET @RankName = 'Mirage Knight'
		SET @nMoney = 500000 
	END
	IF @Index > 10 AND @Index <= 40
	BEGIN
		SET @RankName = 'Shadow Knight'
		SET @nMoney = 300000 
	END
	IF @Index > 40 AND @Index <= 100
	BEGIN
		SET @RankName = 'Mist Knight'
		SET @nMoney = 200000 
	END
	IF @Index > 100 AND @Index <= 200
	BEGIN
		SET @RankName = 'Training Knight'
		SET @nMoney = 100000 
	END
  
		INSERT INTO USER_KNIGHTS_RANK (shIndex,strName,strElmoUserID,strElmoKnightsName,nElmoLoyalty,strKarusUserID,strKarusKnightsName,nKarusLoyalty,nMoney,sKarusKnights,sElmoKnights) VALUES (@Index,@RankName,NULL,NULL,0,NULL,NULL,0,@nMoney,0,0)
		SET @Index = @Index + 1
	END
	END

	SET @Index = 1
	SET @strUserID = NULL
	SET @Loyalty = 0
	SET @Knights = 0
  
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserID,Loyalty,Knights FROM USERDATA WHERE Nation = 1 AND Authority = 1 ORDER BY Loyalty DESC
OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @KnightName = NULL
		SET @IsValidKnight = 0
	IF @Knights <> 0
	BEGIN
	SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights
	IF @IsValidKnight <> 0
	BEGIN
	SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
	END
	END
   
	UPDATE USER_KNIGHTS_RANK SET sKarusKnights = @Knights, strKarusUserID = @strUserID, strKarusKnightsName = @KnightName, nKarusLoyalty = @Loyalty WHERE shIndex = @Index
	SET @Index = @Index + 1           
	FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
	END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS
	SET @Index = 1
	SET @strUserID = NULL
	SET @Loyalty = 0
	SET @Knights = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserID,Loyalty,Knights FROM USERDATA WHERE Nation = 2 AND Authority = 1 ORDER BY Loyalty DESC
OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
WHILE @@FETCH_STATUS = 0 
	BEGIN
	SET @KnightName = NULL
	SET @IsValidKnight = 0
	IF @Knights <> 0
	BEGIN
	SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights 
	IF @IsValidKnight <> 0
	BEGIN
	SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
	END
	END
		UPDATE USER_KNIGHTS_RANK SET sElmoKnights = @Knights, strElmoUserID = @strUserID, strElmoKnightsName = @KnightName, nElmoLoyalty = @Loyalty WHERE shIndex = @Index
		SET @Index = @Index + 1           
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
	END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS

CREATE PROCEDURE [dbo].[KING_INSERT_PRIZE_EVENT] 
@byType tinyint,
@byNation  tinyint,
@nCoins int,
@strCharID varchar(21)
AS

  DECLARE @nType tinyint
    IF @byType IN(3, 5)
      BEGIN
        SET @nType = @nType + 2
          END
  UPDATE KING_SYSTEM SET nNationalTreasury = @nCoins WHERE byNation = @byNation AND strKingName = @strCharID

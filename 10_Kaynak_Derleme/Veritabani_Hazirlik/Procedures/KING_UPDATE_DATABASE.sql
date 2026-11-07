CREATE PROC [dbo].[KING_UPDATE_DATABASE]
@byNation           tinyint,
@nNationalTreasury  int,
@KingTax	        int
AS

   UPDATE KING_SYSTEM SET nNationalTreasury = @nNationalTreasury,nTerritoryTax = @KingTax WHERE byNation = @byNation

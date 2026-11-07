CREATE PROC [dbo].[KING_CHANGE_TAX]
@opcode             tinyint,
@Nation             tinyint,
@TerritoryTariff	int, 
@TerritoryTax	    int
AS

  IF @opcode = 4
    BEGIN
      UPDATE KING_SYSTEM SET byTerritoryTariff = @TerritoryTariff WHERE byNation = @Nation
        END
  IF @opcode = 2
    BEGIN
      UPDATE KING_SYSTEM SET nTerritoryTax = @TerritoryTax WHERE byNation = @Nation
        END

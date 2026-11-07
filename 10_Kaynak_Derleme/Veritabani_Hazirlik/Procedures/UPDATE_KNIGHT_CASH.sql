CREATE PROCEDURE [dbo].[UPDATE_KNIGHT_CASH]
@strAccountID char(21),
@KnightCash int
AS

BEGIN
   UPDATE TB_USER SET CashPoint += @KnightCash WHERE strAccountID = @strAccountID
END

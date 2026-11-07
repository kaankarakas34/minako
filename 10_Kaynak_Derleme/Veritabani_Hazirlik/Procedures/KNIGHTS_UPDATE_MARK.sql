CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_MARK]
@sClanID smallint,
@clanSymbol binary(2400),
@sSymbolSize smallint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET Mark = @clanSymbol,sMarkLen = @sSymbolSize,sMarkVersion +=1 WHERE IDNum = @sClanID
	END

	RETURN 0
-------------------------------------------------------------------------------------------------------
--TheThyke

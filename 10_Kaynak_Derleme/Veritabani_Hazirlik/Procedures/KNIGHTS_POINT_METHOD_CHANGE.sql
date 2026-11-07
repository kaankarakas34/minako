CREATE PROCEDURE [dbo].[KNIGHTS_POINT_METHOD_CHANGE]
@sClanID smallint,
@bDomination tinyint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET ClanPointMethod = @bDomination WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

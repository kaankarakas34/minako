CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_DESTROY]
@sAllianceID smallint
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	DELETE FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sAllianceID
	UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sAllianceID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

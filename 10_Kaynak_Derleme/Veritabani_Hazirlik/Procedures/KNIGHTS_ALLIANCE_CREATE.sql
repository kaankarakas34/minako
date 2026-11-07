CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_CREATE]
@sMainClanID smallint,
@sSubClanID smallint,
@byEmptyIndex tinyint
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	INSERT INTO KNIGHTS_ALLIANCE (sMainAllianceKnights,sSubAllianceKnights,sMercenaryClan_1,sMercenaryClan_2) VALUES (@sMainClanID,@sSubClanID,0,0)
	UPDATE KNIGHTS SET sAllianceKnights = @sMainClanID WHERE IDNum = @sSubClanID
	UPDATE KNIGHTS SET sAllianceKnights = @sMainClanID WHERE IDNum = @sMainClanID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

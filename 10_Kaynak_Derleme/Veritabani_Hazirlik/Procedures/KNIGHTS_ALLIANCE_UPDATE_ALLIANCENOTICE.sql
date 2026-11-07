CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_UPDATE_ALLIANCENOTICE]
@sClanID smallint,
@strClanNotice char(128)
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS_ALLIANCE SET strAllianceNotice = @strClanNotice WHERE sMainAllianceKnights = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

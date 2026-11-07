CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_PUNISH]
@sMainClanID smallint,
@sSubClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @SubAlly smallint,@MercenaryClan1 smallint,@MercenaryClan2 smallint
	  SELECT @SubAlly = sSubAllianceKnights,@MercenaryClan1 = sMercenaryClan_1,@MercenaryClan2 = sMercenaryClan_2 FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sMainClanID
	      IF @sSubClanID = @SubAlly
	        BEGIN
	          UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = 0 WHERE sMainAllianceKnights = @sMainClanID
	            END
	              IF @sSubClanID = @MercenaryClan1
	                BEGIN
	                  UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = 0 WHERE sMainAllianceKnights = @sMainClanID	
	                    END
	                      IF @sSubClanID = @MercenaryClan2
	                        BEGIN
	                          UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = 0 WHERE sMainAllianceKnights = @sMainClanID	
	                            END
							  	 UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sSubClanID	
-------------------------------------------------------------------------------------------------------
--TheThyke

CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_INSERT]
@sMainClanID smallint,
@sSubClanID smallint,
@byEmptyIndex tinyint
AS
-------------------------------------------------------------------------------------------------------
	  IF @byEmptyIndex = 1
	    BEGIN
	      UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = @sSubClanID WHERE sMainAllianceKnights = @sMainClanID	
	        END
	          IF @byEmptyIndex = 2
	            BEGIN
	              UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = @sSubClanID WHERE sMainAllianceKnights = @sMainClanID	
	                END
	                  IF @byEmptyIndex = 3
	                    BEGIN
	                      UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = @sSubClanID WHERE sMainAllianceKnights = @sMainClanID	
	                        END
							 UPDATE KNIGHTS SET sAllianceKnights = @sMainClanID WHERE IDNum = @sSubClanID
-------------------------------------------------------------------------------------------------------
--TheThyke

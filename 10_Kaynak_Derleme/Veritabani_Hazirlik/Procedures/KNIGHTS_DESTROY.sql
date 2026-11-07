CREATE PROCEDURE [dbo].[KNIGHTS_DESTROY]
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @bCount tinyint
	  SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID
	    IF (@bCount = 0)
	      RETURN 7
	        BEGIN TRAN
	          DELETE FROM KNIGHTS WHERE IDNum = @sClanID
	            DELETE FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sClanID
	              UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sClanID
	                UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = 0 WHERE sSubAllianceKnights = @sClanID
	                  UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = 0 WHERE sMercenaryClan_1 = @sClanID
	                    UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = 0 WHERE sMercenaryClan_2 = @sClanID
						  UPDATE USERDATA SET Knights = 0, Fame = 0 WHERE Knights = @sClanID
						   UPDATE USER_KNIGHTDATA SET sClanID = 0,Fame = 0,strMemo='' WHERE sClanID = @sClanID
						     DELETE FROM KNIGHTS_CASTELLAN WHERE IDNum = @sClanID
	IF (@@ERROR <> 0)
	  BEGIN
	    ROLLBACK TRAN
	      RETURN 7
	        END
	  COMMIT TRAN
	    RETURN 0
-------------------------------------------------------------------------------------------------------
--YNG

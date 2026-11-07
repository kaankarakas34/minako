CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_CHIEF]
@strCharID char(21),
@sClanID smallint
AS

DECLARE @strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @strViceChief1 = ViceChief_1,@strViceChief2 = ViceChief_2,@strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	    UPDATE KNIGHTS SET Chief = @strCharID WHERE IDNum = @sClanID
	      IF (@strViceChief1 = @strCharID)
	        BEGIN
	          UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	            END
	              IF (@strViceChief2 = @strCharID)
	                BEGIN
	                  UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	                    END
	                      IF (@strViceChief3 = @strCharID)
	                        BEGIN
	                          UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                            END
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE USERDATA SET Fame = 1 WHERE strUserID = @strCharID AND Knights = @sClanID
	UPDATE USER_KNIGHTDATA SET Fame = 1 WHERE strUserID = @strCharID AND sClanID = @sClanID
END
-------------------------------------------------------------------------------------------------------
RETURN 1
--TheThyke

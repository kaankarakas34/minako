CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_VICECHIEF]
@strCharID char(21),
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------
	DECLARE @strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	    IF (@strViceChief1 IS NOT NULL AND @strViceChief2 IS NOT NULL AND @strViceChief3 IS NOT NULL)
	        RETURN 8
 
	IF (@strViceChief1 IS NULL)
	  BEGIN
	    UPDATE KNIGHTS SET ViceChief_1 = @strCharID WHERE IDNum = @sClanID
	      END
	        ELSE IF (@strViceChief2 IS NULL)
	          BEGIN
	            UPDATE KNIGHTS SET ViceChief_2 = @strCharID WHERE IDNum = @sClanID
	              END
	                ELSE IF (@strViceChief3 IS NULL)
	                  BEGIN
	                    UPDATE KNIGHTS SET ViceChief_3 = @strCharID WHERE IDNum = @sClanID
	                      END
-------------------------------------------------------------------------------------------------------
--TheThyke

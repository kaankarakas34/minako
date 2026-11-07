CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_REMOVE]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @ClanNumber tinyint,@strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @ClanNumber = Members, @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	BEGIN
	  UPDATE USERDATA SET Knights = 0 WHERE strUserID = @strCharID
	  UPDATE USER_KNIGHTDATA SET sClanID = 0, strMemo = '' WHERE strUserID = @strCharID
	    END
	IF (@ClanNumber <= 1)
	  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @sClanID
	    ELSE
	      UPDATE KNIGHTS SET Members -= 1 WHERE IDNum = @sClanID
	IF (@strViceChief1 = @strCharID)
	  BEGIN
	    UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	      END
	        ELSE IF (@strViceChief2 = @strCharID)
	          BEGIN
	            UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	              END
	                ELSE IF (@strViceChief3 = @strCharID)
	                  BEGIN
	                    UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                      END
	BEGIN
	  DELETE FROM [EN.KOHSTR_KO_MAIN_LOG].dbo.KOHSTR_DONATED_NP_LOG WHERE UserID = @strCharID
	    END
-------------------------------------------------------------------------------------------------------
--TheThyke

CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_JOIN]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @bMembers tinyint,@bUserMembers tinyint,@bCount tinyint
	  SELECT @bMembers = Members FROM KNIGHTS WHERE IDNum = @sClanID
	    SELECT @bUserMembers = COUNT(*) FROM USERDATA WHERE Knights = @sClanID	
	      IF (@bMembers >= 50 OR @bUserMembers >= 50)
	        RETURN 8
	SELECT @bCount = COUNT(*) FROM USERDATA WHERE strUserID = @strCharID
	  IF (@bCount = 0)
	    RETURN 2
	BEGIN TRAN
	  BEGIN
	    UPDATE KNIGHTS SET Members += 1 WHERE IDNum = @sClanID
	      UPDATE USERDATA SET Knights = @sClanID WHERE strUserID = @strCharID
		   UPDATE USER_KNIGHTDATA SET sClanID = @sClanID WHERE strUserID = @strCharID
	        END
	IF (@@ERROR <> 0)
	  BEGIN	 
	    ROLLBACK TRAN
	      RETURN 2
	        END
	          COMMIT TRAN
	            RETURN 0
-------------------------------------------------------------------------------------------------------
--TheThyke

CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_DONATE]
@strUserID char(21),
@sClanID smallint,
@amountNP int,
@UserAmountNP int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
	  UPDATE KNIGHTS SET ClanPointFund = @amountNP WHERE IDNum = @sClanID
	    UPDATE USERDATA SET nDonatedNP += @UserAmountNP WHERE strUserID = @strUserID AND Knights = @sClanID
		 UPDATE USER_KNIGHTDATA SET nDonatedNP += @UserAmountNP WHERE strUserID = @strUserID AND sClanID = @sClanID
	      END
	DECLARE @Count tinyint
	  SELECT @Count = COUNT(UserID) FROM [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG WHERE UserID = @strUserID
	    IF (@Count > 0)
	      BEGIN
	        UPDATE [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG SET DonatedNP += @UserAmountNP WHERE UserID = @strUserID
	          END
	            ELSE
	              BEGIN
	                INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG VALUES (@strUserID, @sClanID, @amountNP)
	                  END
-------------------------------------------------------------------------------------------------------
--TheThyke

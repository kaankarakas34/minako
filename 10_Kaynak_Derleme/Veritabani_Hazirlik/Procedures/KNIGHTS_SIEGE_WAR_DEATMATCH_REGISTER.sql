CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER]
@ClanID smallint,
@strUserID char(21)
AS

DECLARE @Count tinyint
SELECT @Count = COUNT(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID --AND sBaseClanCommander = @strUserID

IF (@Count = 0)
BEGIN
	INSERT INTO KNIGHTS_SIEGE_WARFARE_REGISTER (sBaseClanNum,sBaseClanCommander) VALUES (@ClanID,@strUserID)
END

RETURN 1

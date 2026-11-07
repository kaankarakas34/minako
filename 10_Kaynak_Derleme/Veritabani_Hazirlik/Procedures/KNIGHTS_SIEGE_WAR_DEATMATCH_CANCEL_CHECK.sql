CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_CANCEL_CHECK]
@ClanID smallint,
@strUserID char(21)
AS

DECLARE @Count tinyint,@Count2 tinyint,@Count3 tinyint
SELECT @Count = count(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID AND sBaseClanCommander = @strUserID
IF (@Count = 0)
	RETURN 3

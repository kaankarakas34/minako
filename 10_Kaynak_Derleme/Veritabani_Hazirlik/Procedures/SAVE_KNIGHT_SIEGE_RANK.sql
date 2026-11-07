CREATE PROCEDURE [dbo].[SAVE_KNIGHT_SIEGE_RANK]
@ClanID smallint,
@TotalKil smallint,
@BarrackKil tinyint,
@RemainBarrack tinyint
AS

BEGIN
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sWarKillCount = @TotalKil, sWarBaseKillCount = @BarrackKil, sWarClanBaseRemainCount = @RemainBarrack WHERE sBaseClanNum = @ClanID
END

RETURN 1

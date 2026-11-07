CREATE PROCEDURE [dbo].[LOAD_GAMEMASTER_SETTINGS]
@strAccountID char(21),
@strCharID char(21),
@ServerNo smallint
AS

DECLARE @Count smallint,@Count2 smallint

SELECT @Count = COUNT(*) FROM [KNIGHT_TEMU_2239].dbo.GAME_MASTER_SETTINGS WHERE strCharID = @strCharID AND sServerNo = @ServerNo AND strAccountID = @strAccountID
IF (@Count = 0)
BEGIN
	INSERT INTO [KNIGHT_TEMU_2239].dbo.GAME_MASTER_SETTINGS (strAccountID,strCharID,sServerNo) VALUES (@strAccountID,@strCharID,@ServerNo)
END

BEGIN
	SELECT 
	sMute,
	sUnMute,
	sUnBan,
	sBanPermit,
	sAllowAttack,
	sDisabledAttack,
	sNpAdd,
	sExpAdd,
	sMoneyAdd,
	sLoyaltyChange,
	sExpChange,
	sMoneyChange,
	sGiveItem,
	sGiveItemSelf,
	sSummonUser,
	sTpOnUser,
	sZoneChange,
	sLocationChange,
	sMonsterSummon,
	sNpcSummon,
	sMonKilled,
	sTeleportAllUser,
	sClanSummon,
	sResetPlayerRanking,
	sChangeEventRoom,
	sWarOpen1,
	sWarOpen2,
	sWarOpen3,
	sWarOpen4,
	sWarOpen5,
	sWarOpen6,
	sWarOpen9,
	sWarSiegeOpen,
	sWarClose,
	sCaptainElection,
	sWarSiegeClose,
	sSendPrsion
	FROM [KNIGHT_TEMU_2239].dbo.GAME_MASTER_SETTINGS WHERE strAccountID = @strAccountID AND strCharID = @strCharID AND sServerNo = @ServerNo
END

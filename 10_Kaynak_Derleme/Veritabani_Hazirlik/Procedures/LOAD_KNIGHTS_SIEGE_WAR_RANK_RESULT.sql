CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_SIEGE_WAR_RANK_RESULT]
AS

DECLARE @sBaseClanNum smallint ,@sWarKillCount smallint,@sWarBaseKillCount tinyint,@sWarClanBaseRemainCount tinyint
DECLARE @nRank int = 1

TRUNCATE TABLE KNIGHTS_SIEGE_WARFARE_RANK_RESULT

DECLARE CswRank CURSOR FOR
SELECT sBaseClanNum, sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount FROM KNIGHTS_SIEGE_WARFARE_RANK ORDER BY sWarBaseKillCount DESC, sWarKillCount DESC

OPEN CswRank

FETCH NEXT FROM CswRank INTO @sBaseClanNum, @sWarKillCount,@sWarBaseKillCount,@sWarClanBaseRemainCount
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT KNIGHTS_SIEGE_WARFARE_RANK_RESULT (sRankNumber, sBaseClanNum, sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount) VALUES (@nRank, @sBaseClanNum, @sWarKillCount,@sWarBaseKillCount,@sWarClanBaseRemainCount)

	SET @nRank += 1

FETCH NEXT FROM CswRank INTO @sBaseClanNum, @sWarKillCount,@sWarBaseKillCount,@sWarClanBaseRemainCount
END

CLOSE CswRank
DEALLOCATE CswRank

SELECT TOP(10)sBaseClanNum,sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount FROM KNIGHTS_SIEGE_WARFARE_RANK_RESULT

CREATE PROCEDURE [dbo].[KNIGHTS_LOAD]
AS

BEGIN
-------------------------------------------------------------------------------------------------------
--SELECT * FROM KNIGHTS 
SELECT IDNum, Flag, Nation, Ranking, IDName, Gold, Domination, Mark, sMarkVersion, sMarkLen, sCape, bCapeR, bCapeG, bCapeB, sAllianceKnights, ClanPointFund, strClanNotice, ClanPointMethod, bySiegeFlag, nLose, nVictory, sPremiumInUse, sPremiumTime, nMoney, WarehouseData, strSerial, WarehouseDataTime FROM KNIGHTS
-------------------------------------------------------------------------------------------------------
END
--YNG

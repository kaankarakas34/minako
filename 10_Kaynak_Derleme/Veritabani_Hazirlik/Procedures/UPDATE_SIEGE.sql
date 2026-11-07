CREATE PROCEDURE [dbo].[UPDATE_SIEGE]
@m_sCastleIndex     smallint,
@m_sMasterKnights   smallint,
@m_bySiegeType		smallint,
@m_byWarDay			smallint,
@m_byWarTime	    smallint,
@m_byWarMinute      smallint 
AS

BEGIN
	    UPDATE KNIGHTS_SIEGE_WARFARE SET bySiegeType = @m_bySiegeType, 
		byWarDay = @m_byWarDay, byWarTime = @m_byWarTime, byWarMinute = @m_byWarMinute,
        sChallengeList_1 = sMasterKnights, sMasterKnights = @m_sMasterKnights, sChallengeList_3 = 0,
        sChallengeList_4 = 0, sChallengeList_5 = 0, sChallengeList_6 = 0,
        sChallengeList_7 = 0, sChallengeList_8 = 0, sChallengeList_9 = 0, sChallengeList_10 = 0
		WHERE sCastleIndex = @m_sCastleIndex
END

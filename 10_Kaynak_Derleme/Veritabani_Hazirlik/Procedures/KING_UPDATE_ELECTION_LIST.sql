CREATE PROC [dbo].[KING_UPDATE_ELECTION_LIST]
@byDBType tinyint,
@byType tinyint,
@byNation tinyint,
@sKnights smallint,
@nAmount int,
@strNominee char(21)
AS

  IF (@byDBType = 1)
    BEGIN
      INSERT INTO KING_ELECTION_LIST (byType, byNation, nKnights, nMoney,strName) VALUES (@byType, @byNation, @sKnights,@nAmount, @strNominee)
        END
  IF (@byDBType = 2)
    BEGIN
		DELETE FROM KING_ELECTION_LIST WHERE strName = @strNominee and byType = @byType
		DELETE FROM KING_NOMINATION_LIST WHERE strNominee = @strNominee
        END
  IF @byType = 1
    BEGIN
      UPDATE KING_SYSTEM SET strKingName = @strNominee WHERE byNation = @byNation
        UPDATE USERDATA SET Rank = 1 WHERE strUserID = @strNominee
          END

CREATE PROCEDURE [dbo].[KING_ELECTION_PROC]
@strVoterAccountID	char(21),
@strVoterUserID	    char(21),
@byNation	        tinyint,
@strNominee     	char(21)
AS

  DECLARE @Check smallint
    SELECT @Check = COUNT(strAccountID) FROM KING_BALLOT_BOX WHERE  strAccountID = @strVoterAccountID
      IF @Check > 0
        BEGIN
          RETURN -3
            END
  DECLARE @CheckLevel tinyint
    SELECT @CheckLevel = Level FROM USERDATA WHERE strUserID = @strVoterUserID
      IF (@CheckLevel < 50)
        BEGIN
          RETURN -4
            END
  UPDATE KING_ELECTION_LIST SET nMoney = nMoney +1 WHERE byType = 4 and strName = @strNominee and byNation = @byNation
    INSERT INTO KING_BALLOT_BOX (strAccountID,strUserID,Nation,strCandidateName,LogTime) VALUES (@strVoterAccountID,@strVoterUserID,@byNation,@strNominee,GETDATE())
      RETURN 1

CREATE PROCEDURE [dbo].[KING_ELECTION_RESULTS]
@byNation	tinyint
AS

DECLARE @strUserID char(20),@bRank tinyint,@sClanID smallint,@bMonth tinyint,@sYear smallint,@kingvotes int,@totalvotes int,@perc int

SELECT @totalvotes = sum(nMoney) FROM KING_ELECTION_LIST WHERE byNation = @byNation

SELECT @strUserID = strName,@sClanID = nKnights FROM KING_ELECTION_LIST WHERE byNation = @byNation ORDER BY nMoney

SELECT @kingvotes = nMoney FROM KING_ELECTION_LIST WHERE strName = @strUserID and byNation = @byNation

SET @perc = (@kingvotes * 100) / @totalvotes

BEGIN
	INSERT INTO KING_NOMINATION_RESULT (byNation,strUserID,bRank,sClanID,bMonth,sYear,kingvotes,totalvotes) 
	SELECT @byNation,@strUserID,1,@sClanID,MONTH(GETDATE()),YEAR(GETDATE()),nMoney,@totalvotes FROM KING_ELECTION_LIST WHERE strName = @strUserID and byNation = @byNation
END

BEGIN
	DELETE FROM KING_ELECTION_LIST WHERE strName = @strUserID and byNation = @byNation
END

BEGIN
	INSERT INTO KING_NOMINATION_RESULT (byNation,strUserID,bRank,sClanID,bMonth,sYear,kingvotes,totalvotes) 
	SELECT @byNation,strName,2,nKnights,MONTH(GETDATE()),YEAR(GETDATE()),nMoney,@totalvotes FROM KING_ELECTION_LIST WHERE byNation = @byNation
END

SELECT @bMonth = byMonth FROM KING_SYSTEM WHERE byNation = @byNation

IF (@bMonth = 12)
	BEGIN
		UPDATE KING_SYSTEM SET strKingName = @strUserID,sKingClanID = @sClanID,byMonth = 1 ,sYear = YEAR(GETDATE()) WHERE byNation = @byNation
	END
ELSE
	BEGIN
		UPDATE KING_SYSTEM SET strKingName = @strUserID,sKingClanID = @sClanID,byMonth = MONTH(GETDATE()) +1 ,sYear = YEAR(GETDATE()) WHERE byNation = @byNation
	END

IF @strUserID IS NULL
	BEGIN
		RETURN 
	END

SELECT strUserID,bRank,sClanID,bMonth,sYear,kingvotes,totalvotes FROM KING_NOMINATION_RESULT WHERE byNation = @byNation

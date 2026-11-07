CREATE PROCEDURE [dbo].[AUTHORITY_CHANGE]
@strUserID char(21),
@GameMaster char(21),
@reason varchar(50),
@nAuthority smallint,
@iPeriod int,
@banType tinyint
AS

DECLARE @sRet tinyint 
DECLARE @strAccountID char(21)
SELECT @strAccountID = strAccountID from ACCOUNT_CHAR where strCharID1 = @strUserID or strCharID2 = @strUserID or strCharID3 = @strUserID or strCharID4 = @strUserID

DECLARE @KarakterName char(21),@KarakterAuthority smallint
SELECT @KarakterName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strUserID

DECLARE @R smallint
SELECT @R = isAuthority FROM [KNIGHT_TEMU_2239].dbo.ACCOUNT_LOGIN_CONTROL where strAccountID = @strAccountID

DECLARE @R2 smallint

SELECT @R2 = Authority FROM USERDATA WHERE strUserID = @strUserID

SELECT @KarakterAuthority = Authority FROM USERDATA WHERE strUserID = @strUserID

IF (@KarakterName = 0)
BEGIN
	SELECT sRet = 1, strRealUserID = @strUserID,strAccountID = @strAccountID
	RETURN
END

IF (@KarakterAuthority = 0)
BEGIN
	SELECT sRet = 2, strRealUserID = @strUserID,strAccountID = @strAccountID
	RETURN
END

IF (@banType = 0 or @banType = 1)
BEGIN
	IF (@R = @nAuthority)
	BEGIN
		SELECT sRet = 3, strRealUserID = @strUserID,strAccountID = @strAccountID
		RETURN
	END
END

IF (@banType = 5 or @banType = 6 or @banType = 7 or @banType = 8)
BEGIN
	IF (@R2 = @nAuthority)
	BEGIN
		SELECT sRet = 3, strRealUserID = @strUserID,strAccountID = @strAccountID
		RETURN
	END
END

IF (@banType = 5 or @banType = 6 or @banType = 7 or @banType = 8)
BEGIN
	UPDATE USERDATA SET Authority = @nAuthority,TimePunishment = @iPeriod WHERE strUserID = @strUserID
END

IF (@banType = 0 or @banType = 1)
BEGIN
	EXEC AUTHORITY_CHANGE_UPDATE @strAccountID , @GameMaster,@nAuthority, @reason, @strUserID
END	

SELECT sRet = 0, strRealUserID = @strUserID,strAccountID = @strAccountID

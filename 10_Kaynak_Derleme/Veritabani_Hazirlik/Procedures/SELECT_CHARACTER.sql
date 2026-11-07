CREATE PROCEDURE [dbo].[SELECT_CHARACTER]
@strAccountID varchar(20),
@strUserID varchar(20)
AS

DECLARE @CharID1 char(21), @CharID2 char(21), @CharID3 char(21),@CharID4 char(21), @strAuthorıty tinyint, @Authority tinyint, @MaintenanceMode tinyint,@AccountID smallint,@Zone1 tinyint,@Zone2 tinyint,@Zone3 tinyint,@Zone4 tinyint,@CharNameCount smallint,@CharacterSelectLogin smallint
DECLARE @ZONE_PRISON tinyint = 92

SELECT @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''), @CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
SELECT @Zone1 = [Zone] FROM USERDATA WHERE strUserID = @CharID1 AND strUserID IS NOT NULL
SELECT @Zone2 = [Zone] FROM USERDATA WHERE strUserID = @CharID2 AND strUserID IS NOT NULL
SELECT @Zone3 = [Zone] FROM USERDATA WHERE strUserID = @CharID3 AND strUserID IS NOT NULL
SELECT @Zone4 = [Zone] FROM USERDATA WHERE strUserID = @CharID4 AND strUserID IS NOT NULL
	
IF (@strUserID NOT IN(@CharID1, @CharID2, @CharID3,@CharID4))
BEGIN
	RETURN 0
END

SELECT @MaintenanceMode = MaintenanceMode FROM [KNIGHT_TEMU_2239].dbo.GAME_OPTIONS
IF (@MaintenanceMode = 1)
BEGIN
	SELECT @AccountID = COUNT(GmLoginID) FROM [KNIGHT_TEMU_2239].dbo.GM_MAINTENANCE_LOGIN WHERE GmLoginID = @strAccountID  
	IF (@AccountID = 0)
	BEGIN
		RETURN 5
	END
END

SELECT @CharacterSelectLogin = CharacterSelectLogin FROM [KNIGHT_TEMU_2239].dbo.GAME_OPTIONS
IF (@CharacterSelectLogin = 1)
BEGIN
	IF (@AccountID = 0)
	BEGIN
		RETURN 6
	END
END

SELECT @strAuthorıty = strAuthority FROM TB_USER WHERE strAccountID = @strAccountID
IF (@strAuthorıty = 255)
BEGIN
	RETURN 2
END

SELECT @Authority = Authority FROM USERDATA WHERE strUserID = @strUserID
IF (@Authority = 255)
BEGIN
	RETURN 2
END

SELECT @CharNameCount = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strUserID
IF (@CharNameCount >= 2)
BEGIN
	RETURN 3
END

IF (@Zone1 = @ZONE_PRISON  or @Zone2 = @ZONE_PRISON  or @Zone3 = @ZONE_PRISON  or @Zone4 = @ZONE_PRISON)
BEGIN
	IF (@CharID1 <> '')
	BEGIN
		SELECT @Zone1 = [Zone] FROM USERDATA WHERE strUserID = @CharID1
		IF (@Zone1 != @ZONE_PRISON AND @CharID1 = @strUserID)
			RETURN 4
	END

	IF (@CharID2 <> '')
	BEGIN
		SELECT @Zone2 = [Zone] FROM USERDATA WHERE strUserID = @CharID2
		IF (@Zone2 != @ZONE_PRISON AND @CharID2 = @strUserID)
			RETURN 4
	END

	IF (@CharID3 <> '')
	BEGIN
		SELECT @Zone3 = [Zone] FROM USERDATA WHERE strUserID = @CharID3
		IF (@Zone3 != @ZONE_PRISON AND @CharID3 = @strUserID)
			RETURN 4
	END

	IF (@CharID4 <> '')
	BEGIN
		SELECT @Zone4 = [Zone] FROM USERDATA WHERE strUserID = @CharID4
		IF (@Zone4 != @ZONE_PRISON AND @CharID4 = @strUserID)
			RETURN 4
		END
END

RETURN 1

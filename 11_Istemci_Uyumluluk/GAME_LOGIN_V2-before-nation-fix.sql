CREATE PROCEDURE [dbo].[GAME_LOGIN_V2]
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

    DECLARE @bNation tinyint
         DECLARE @strHashPassword varchar(28)
              DECLARE @strAuthority tinyint
                   DECLARE @Premium smallint
    SELECT @strHashPassword = strPasswd, @strAuthority = strAuthority FROM TB_USER WHERE strAccountID = @strAccountID
             IF (@@ROWCOUNT = 0 OR @strHashPassword != @strPasswd OR @strAuthority = 9)
                     RETURN -1
    DECLARE @FreeLimit smallint, @TotalUser smallint
           DECLARE @ServerIPAddress varchar(15) 
                 DECLARE @MaintenanceMode tinyint
                       DECLARE @AccountID smallint
                              DECLARE @GmLoginID smallint
    SELECT @FreeLimit = FreeLimit, @TotalUser = TotalUserLimit, @ServerIPAddress = ServerIPAddress, @MaintenanceMode = MaintenanceMode FROM [KNIGHT_TEMU_2239].dbo.GAME_OPTIONS
        IF (@MaintenanceMode = 1 AND @strAuthority != 0)
             BEGIN
                  SELECT @AccountID = COUNT(GmLoginID) FROM [KNIGHT_TEMU_2239].dbo.GM_MAINTENANCE_LOGIN WHERE GmLoginID = @strAccountID  
                           IF (@AccountID = 0)
                                   BEGIN
                                       RETURN 4
                                          END
                                             END
    DECLARE @TotalUserCount smallint
         SELECT @TotalUserCount = COUNT(strServerIP) FROM CURRENTUSER WHERE strServerIP = @ServerIPAddress
			SELECT @Premium = sPremiumCount FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
                IF (@Premium = 0 AND @TotalUserCount >= @FreeLimit)
                      RETURN 21
				IF (@TotalUserCount >= @TotalUser)
					  RETURN 21

DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20),@CharID4 varchar(20)
DECLARE @AccountNation tinyint, @CharNum tinyint
DECLARE @Nation tinyint, @Class smallint, @Race tinyint

SELECT @AccountNation = bNation, @CharNum = bCharNum, @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''),@CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@AccountNation != 1 AND @AccountNation != 2)
	RETURN 30

DECLARE @ValidCharacters tinyint

IF (@CharID1 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID1

	IF (@Nation != @AccountNation)
		RETURN 31
	
	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID2 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID2

	IF (@Nation != @AccountNation)
		RETURN 31
	
	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID3 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID3

	IF (@Nation != @AccountNation)
		RETURN 31

	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID4 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID4

	IF (@Nation != @AccountNation)
		RETURN 31

	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

RETURN @AccountNation

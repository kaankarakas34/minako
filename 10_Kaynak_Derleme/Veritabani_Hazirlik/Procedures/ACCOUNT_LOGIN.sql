CREATE PROCEDURE [dbo].[ACCOUNT_LOGIN]
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

DECLARE @strHashPassword varchar(28)
SELECT @strHashPassword = strPasswd FROM TB_USER WHERE strAccountID = @strAccountID
	IF (@strHashPassword != @strPasswd)
		RETURN 3
 
DECLARE @BanControl tinyint, @ısnull tinyint
SELECT @ısnull = count(*) FROM [KNIGHT_TEMU_2239].dbo.ACCOUNT_LOGIN_CONTROL WHERE strAccountID = @strAccountID
SELECT @BanControl = isAuthority FROM [KNIGHT_TEMU_2239].dbo.ACCOUNT_LOGIN_CONTROL WHERE strAccountID = @strAccountID
	IF(@ısnull > 0)
	BEGIN
		IF(@BanControl != 1)
			RETURN 4 
	END

DECLARE @isInGame tinyint
SELECT @isInGame = count(*) FROM CURRENTUSER WHERE strAccountID = @strAccountID
	IF(@isInGame > 0)
	BEGIN
		DELETE FROM CURRENTUSER WHERE strAccountID = @strAccountID
		RETURN 5
	END
 
DECLARE @AutoRegister tinyint
SELECT @AutoRegister = [AutoRegister] FROM [KNIGHT_TEMU_2239].dbo.GAME_OPTIONS
SELECT @strAccountID = strAccountID FROM TB_USER WHERE strAccountID = @strAccountID
	IF (@@ROWCOUNT = 0 AND @AutoRegister = 1)
	BEGIN
		INSERT INTO TB_USER (strAccountID, strPasswd) VALUES (@strAccountID, @strPasswd)
		INSERT INTO [KNIGHT_TEMU_2239].dbo.ACCOUNT_LOGIN_CONTROL(strAccountID,BanGameMasterName,isAuthority,BanReason,BanCount,OpenCount, UpdateTime) VALUES (@strAccountID,'',1,'',0,0,GETDATE()) 
		RETURN 1
	END
                
DECLARE @AccountControl smallint,@AccountOTP smallint
SELECT @AccountControl = COUNT(strAccountID) FROM TB_USER WHERE strAccountID = @strAccountID  
	IF (@AccountControl > 0)
	BEGIN
		SELECT @AccountOTP = OpenOTP FROM [KNIGHT_TEMU_2239].dbo.GAME_OPTIONS 
		IF (@AccountOTP = 1)
			RETURN 16
		RETURN 1
	END

RETURN 2

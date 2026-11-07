CREATE PROCEDURE [dbo].[INSERT_USER_HDD_BANS]
@StrUserID varchar(21),
@HddKey varchar(32),
@MacKey int
AS


IF dbo.IsValidCharacters(@StrUserID) = 1
BEGIN
RETURN 9
END

DECLARE @ListedeVarmiyiz tinyint
DECLARE @BanStatus tinyint
DECLARE @BanStatusv2 int
DECLARE @BanStatusv3 int
DECLARE @BanStatusv4 int

SELECT @BanStatusv4 = LEN(@HddKey)
SELECT @ListedeVarmiyiz = COUNT(*) FROM USER_HDD_BAN_LIST WHERE UserID = @StrUserID

IF (@BanStatusv4 < 5)
RETURN 7

IF (@ListedeVarmiyiz = 0)
INSERT INTO USER_HDD_BAN_LIST (UserID, HwidKey, MacKey) VALUES (@StrUserID, @HddKey, @MacKey)

SELECT TOP 1 @BanStatusv2 = Banned
FROM USER_HDD_BAN_LIST where MacKey = @MacKey
ORDER BY Banned DESC

IF (@BanStatusv2 = 1)
RETURN 6

SELECT TOP 1 @BanStatusv3 = Banned
FROM USER_HDD_BAN_LIST where HwidKey = @HddKey
ORDER BY Banned DESC

IF (@BanStatusv3 = 1)
RETURN 6

SELECT @BanStatus = Banned FROM USER_HDD_BAN_LIST
WHERE UserID = @StrUserID

IF (@BanStatus = 1)
RETURN 3
BEGIN
RETURN 2
END

IF (@@ERROR <> 0)
BEGIN	
ROLLBACK TRAN
RETURN 4
END

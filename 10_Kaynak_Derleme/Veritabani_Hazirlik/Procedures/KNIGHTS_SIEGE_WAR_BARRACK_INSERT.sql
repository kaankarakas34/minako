CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_BARRACK_INSERT]
@Type tinyint,
@ClanID smallint,
@X int,
@Z int
AS

DECLARE @Sign tinyint

IF (@Type = 1)
BEGIN

SELECT @Sign = count(*) FROM KNIGHTS_SIEGE_WARFARE_BARRACK WHERE BaseClanID = @ClanID

IF (@Sign > 0)
	RETURN 2

INSERT INTO KNIGHTS_SIEGE_WARFARE_BARRACK(BaseClanID, BasePosX, BasePosZ) VALUES (@ClanID, @X, @Z)
END

IF (@Type = 2)
BEGIN
	DELETE KNIGHTS_SIEGE_WARFARE_BARRACK WHERE BaseClanID = @ClanID
END

IF (@Type = 3)
BEGIN
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sWarClanBaseRemainCount = 1 WHERE sBaseClanNum = @ClanID
END

RETURN 1

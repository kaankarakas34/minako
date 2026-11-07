CREATE PROCEDURE dbo.CASTLE_SIEGE_WAR_CONTROL @ClanID int
AS
BEGIN
 SET NOCOUNT ON;
 -- CastleSiegeWarGameStartController clears ownership only when this returns 1.
 -- A valid clan must retain the castle; a deleted/imported orphan cannot own it.
 IF EXISTS(SELECT 1 FROM dbo.KNIGHTS WHERE IDNum=@ClanID) RETURN 0;
 RETURN 1;
END

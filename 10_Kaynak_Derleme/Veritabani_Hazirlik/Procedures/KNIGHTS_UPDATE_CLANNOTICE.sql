CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_CLANNOTICE]
@sClanID smallint,
@strClanNotice varchar(128)
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE KNIGHTS SET strClanNotice = @strClanNotice WHERE IDNum = @sClanID
END

-------------------------------------------------------------------------------------------------------
--TheThyke

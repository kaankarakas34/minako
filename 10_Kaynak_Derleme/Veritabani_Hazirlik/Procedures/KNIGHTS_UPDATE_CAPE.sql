CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_CAPE]
@sClanID smallint,
@sCapeID smallint,
@r tinyint,
@g tinyint,
@b tinyint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS Set sCape= @sCapeID, bCapeR = @r, bCapeG = @g, bCapeB = @b Where IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

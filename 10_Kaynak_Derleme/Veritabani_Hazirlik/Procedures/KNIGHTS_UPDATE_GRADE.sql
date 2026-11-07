CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_GRADE]
@sClanID smallint,
@sCapeID smallint,
@byFlag tinyint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET Flag = @byFlag,sCape = @sCapeID WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

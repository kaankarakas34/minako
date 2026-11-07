CREATE PROCEDURE [dbo].[UPDATE_USER_SEAL_EXP]
@strCharID char(21),
@SealExp int
AS

BEGIN
	UPDATE USER_SEAL_EXP SET sSealedExp = @SealExp WHERE strUserID = @strCharID
END

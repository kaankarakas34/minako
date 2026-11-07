CREATE PROCEDURE [dbo].[USER_ITEM_SEAL_PASSWORD]
@strAccountID varchar(21),
@strPasswd char(8)
AS

DECLARE @strSealPasswd char(8)
SELECT @strSealPasswd = strSealPasswd FROM TB_USER WHERE strAccountID = @strAccountID
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	RETURN 2

IF (@strSealPasswd <> @strPasswd)
	RETURN 2

RETURN 0

CREATE PROCEDURE [dbo].[UPDATE_USER_PET]
@nSerialID bigint,
@strPetName varchar(50),
@bLevel tinyint,
@sHP smallint,
@sMP smallint,
@sSatisfaction smallint,
@nExp int,
@sPid smallint,
@sSize smallint,
@sItems binary(81)
AS

UPDATE PET_USER_DATA
SET
sPetName = @strPetName,
bLevel = @bLevel,
sHP = @sHP,
sMP = @sMP,
sSatisfaction = @sSatisfaction,
nExp = @nExp,
sPid = @sPid,
sSize = @sSize,
sItems = @sItems
WHERE nSerialID = @nSerialID

CREATE PROCEDURE [dbo].[CREATE_NEW_PET]
@nSerialID bigint,
@bStartLevel tinyint,
@strPetName varchar(50)
AS

DECLARE @nIndex int,@PetName varchar(15)
SELECT @PetName = count(*) FROM PET_USER_DATA WHERE sPetName = @strPetName

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		RETURN 4

	IF (@PetName > 0)
		RETURN 2

BEGIN
	SET NOCOUNT ON;

	SELECT @nIndex = count(*) from PET_USER_DATA
	SET @nIndex = @nIndex + 10
END

DECLARE @sMaxHP int, @sMaxMP int, @sAttack int, @sDefense int, @bRes tinyint, @nExp int
SELECT @sMaxHP = PetMaxHp, @sMaxMP = PetMaxSp, @sAttack = PetAttack, @sDefense = PetDefence, @bRes = PetRes, @nExp = PetExp FROM PET_STATS_INFO WHERE PetLevel = @bStartLevel	

BEGIN TRANSACTION
	INSERT INTO PET_USER_DATA VALUES (@nSerialID, @strPetName, @bStartLevel, @sMaxHP, @sMaxMP, 0x00, @nIndex, 9000, @nExp, 25500, 100)

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END
COMMIT TRANSACTION

RETURN @nIndex

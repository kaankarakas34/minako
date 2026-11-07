CREATE PROCEDURE [dbo].[LOAD_NEW_CHAR_VALUE]
@CharID varchar(20),
@Class smallint,
@ServerNo smallint = 1
AS

DECLARE @JobType tinyint, @Level tinyint, @Exp bigint
DECLARE @Strength tinyint, @Health tinyint, @Dexterity tinyint, @Intelligence tinyint, @MagicPower tinyint, @FreePoints smallint
DECLARE @SkillPointFree tinyint, @SkillPointCat1 tinyint, @SkillPointCat2 tinyint, @SkillPointCat3 tinyint, @SkillPointMaster tinyint
DECLARE @binarySkill binary(10),@Gold int,@BeginnerType tinyint


SELECT @BeginnerType = BeginnerType FROM [KNIGHT_TEMU_2239].dbo.BEGINNER_SETTINGS WHERE ServerNo = @ServerNo
IF (@@ROWCOUNT = 0)
	RETURN

SELECT @JobType = JobType, @Level = [Level], @Exp = [Exp], @Strength = Strength, @Health = Health, @Dexterity = Dexterity, @Intelligence = Intelligence, @MagicPower = MagicPower, @FreePoints = FreePoints, @SkillPointFree = SkillPointFree, @SkillPointCat1 = SkillPointCat1, @SkillPointCat2 = SkillPointCat2, @SkillPointCat3 = SkillPointCat3, @SkillPointMaster = SkillPointMaster, @Gold = Gold FROM CREATE_NEW_CHAR_VALUE WHERE ClassType = @Class % 100 AND JobType = @BeginnerType
IF (@@ROWCOUNT = 0)
	RETURN

IF (@JobType = 1) -- Skilled
BEGIN
	IF (@Class % 100 = 1) -- Warrior
		SET @Class += 4
	ELSE IF (@Class % 100 = 2) -- Rogue
		SET @Class += 5
	ELSE IF (@Class % 100 = 3) -- Magician
		SET @Class += 6
	ELSE IF (@Class % 100 = 4) -- Priest
		SET @Class += 7
	ELSE IF (@Class % 100 = 13) -- Kurian
		SET @Class += 1
END
ELSE IF (@JobType = 2 or @JobType = 3) -- Mastered
BEGIN
	IF (@Class % 100 = 1) -- Warrior
		SET @Class += 5
	ELSE IF (@Class % 100 = 2) -- Rogue
		SET @Class += 6
	ELSE IF (@Class % 100 = 3) -- Magician
		SET @Class += 7
	ELSE IF (@Class % 100 = 4) -- Priest
		SET @Class += 8
	ELSE IF (@Class % 100 = 13) -- Kurian
		SET @Class += 2
END

IF (@Gold > 0)
	UPDATE USERDATA SET Gold = @Gold WHERE strUserID = @CharID

IF (@Level > 0)
	UPDATE USERDATA SET [Level] = @Level WHERE strUserID = @CharID

IF (@Exp > 0)
	UPDATE USERDATA SET [Exp] = @Exp WHERE strUserID = @CharID

IF (@Strength > 0)
	UPDATE USERDATA SET Strong = @Strength WHERE strUserID = @CharID

IF (@Health > 0)
	UPDATE USERDATA SET Sta = @Health WHERE strUserID = @CharID

IF (@Dexterity > 0)
	UPDATE USERDATA SET Dex = @Dexterity WHERE strUserID = @CharID

IF (@Intelligence > 0)
	UPDATE USERDATA SET Intel = @Intelligence WHERE strUserID = @CharID

IF (@MagicPower > 0)
	UPDATE USERDATA SET Cha = @MagicPower WHERE strUserID = @CharID

IF (@FreePoints > 0)
	UPDATE USERDATA SET Points = @FreePoints WHERE strUserID = @CharID

SET @binarySkill = CONVERT(VARBINARY(1), @SkillPointFree) -- Free points
SET @binarySkill += CONVERT(VARBINARY(4), 0) -- Command, Politics, Language, Siege weapon
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat1) -- Skill 1
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat2) -- Skill 2
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat3) -- Skill 3
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointMaster) -- Master
SET @binarySkill += CONVERT(VARBINARY(1), 0) -- Padding

UPDATE USERDATA SET Class = @Class, strSkill = @binarySkill WHERE strUserID = @CharID

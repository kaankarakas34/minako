CREATE PROCEDURE [dbo].[SKILLSHORTCUT_SAVE]
@strCharID 	varchar(21),
@nCount	smallint,
@strSkillData binary(320)
AS

   SELECT strCharID FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID
      IF(@@rowcount = 0)
        BEGIN
          INSERT USERDATA_SKILLSHORTCUT VALUES(@strCharID, 0,0x00)
            END
              UPDATE USERDATA_SKILLSHORTCUT SET nCount = @nCount, strSkillData = @strSkillData WHERE strCharID = @strCharID

CREATE PROCEDURE [dbo].[LOAD_CHAR_INFO]
@strCharID	char(21)
AS

-------------------------------------------------------------------------------------------------------
   SELECT Race, Class, HairRGB, [Level], Face, [Zone], strItem, strItemTime FROM USERDATA WHERE strUserID = @strCharID
-------------------------------------------------------------------------------------------------------
--TheThyke

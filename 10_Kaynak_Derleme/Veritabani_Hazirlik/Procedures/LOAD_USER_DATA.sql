CREATE PROCEDURE [dbo].[LOAD_USER_DATA]
@strAccountID varchar(21),
@strCharID varchar(21)
AS

DECLARE @strCharID1 varchar(21), @strCharID2 varchar(21), @strCharID3 varchar(21),@strCharID4 varchar(21)
SELECT @strCharID1 = ISNULL(strCharID1, ''),  @strCharID2 = ISNULL(strCharID2, ''), @strCharID3 = ISNULL(strCharID3, ''),@strCharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

	IF (@strCharID NOT IN(@strCharID1, @strCharID2, @strCharID3,@strCharID4))
		RETURN

	UPDATE USERDATA SET Zone='21' WHERE strUserID = @strCharID and Zone='22' or Zone='23' or Zone='24' or Zone='25'
	UPDATE USERDATA SET Zone='1'  WHERE strUserID = @strCharID and Zone='5'  or Zone='6'
	UPDATE USERDATA SET Zone='2'  WHERE strUserID = @strCharID and Zone='7'  or Zone='8'
	-- UPDATE USERDATA SET PX='81570',PZ='44600',PY='469' WHERE strUserID = @strCharID and Zone='21' or Zone='22' or Zone='23' or Zone='24' or Zone='25'	
	UPDATE USERDATA SET Zone='11'  WHERE strUserID = @strCharID and Zone='13'  or Zone='14'	 
	UPDATE USERDATA SET Zone='12'  WHERE strUserID = @strCharID and Zone='15'  or Zone='16'	
  
SELECT Nation, Race, Class, HairRGB, [Rank], Title, [Level],bRebirthLevel, [Exp], Loyalty, Face, City, Knights, Fame, Hp, Mp, Sp, Strong, Sta, Dex, Intel, Cha,bRebStr,bRebSta,bRebDex,bRebIntel,bRebCha, Authority, Points, Gold, Zone, Bind, PX, PZ, PY, dwTime, strSkill, strItem,strDeletedItem, strSerial, strItemTime, MannerPoint, LoyaltyMonthly,TimePunishment FROM USERDATA WHERE strUserID = @strCharID

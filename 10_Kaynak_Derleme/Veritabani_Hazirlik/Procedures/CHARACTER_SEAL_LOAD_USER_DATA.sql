CREATE PROCEDURE [dbo].[CHARACTER_SEAL_LOAD_USER_DATA]
@strAccountID varchar(21),
@strUserID char(21)
AS

SELECT Race,Class,HairRGB,[Rank],Title,[Level],bRebirthLevel,[Exp],Loyalty,Face,City,Knights,Fame,Hp,Mp,Sp,Strong,Sta,Dex,Intel,Cha,bRebStr,bRebSta,bRebDex,bRebIntel,bRebCha,Authority,Points,Gold,[Zone],strSkill,strItem,strSerial,strItemTime,MannerPoint,LoyaltyMonthly FROM USERDATA WHERE strUserID = @strUserID

--SELECT strUserID,strAccountID,nItemSerial FROM USER_CHARACTER_SEAL_ITEMS WHERE strUserID = @strUserID AND strAccountID = @strAccountID

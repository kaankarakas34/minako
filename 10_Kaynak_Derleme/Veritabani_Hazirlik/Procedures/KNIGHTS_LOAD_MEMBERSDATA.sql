CREATE PROCEDURE [dbo].[KNIGHTS_LOAD_MEMBERSDATA]
AS

-----------------------------------------------------------------------------------------------------------------
SELECT sClanID,strUserID,nDonatedNP,strMemo,Fame,sClass,[Level],lastlogin,Loyalty FROM USER_KNIGHTDATA WHERE sClanID > 0
-----------------------------------------------------------------------------------------------------------------
--TheThyke

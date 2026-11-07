CREATE PROCEDURE [dbo].[KNIGHTS_LOAD_MEMBERS]
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------
SELECT strUserID, fame, [Level], sClass FROM USER_KNIGHTDATA WHERE sClanID = @sClanID
-------------------------------------------------------------------------------------------------------
--TheThyke

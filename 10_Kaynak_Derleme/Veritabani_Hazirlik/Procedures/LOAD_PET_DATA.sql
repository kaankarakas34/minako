CREATE PROCEDURE [dbo].[LOAD_PET_DATA]
@nSerialID bigint
AS

SELECT sPetName, bLevel, sHP, sMP,nIndex, sSatisfaction, nExp, sPid, sSize, sItems FROM PET_USER_DATA where nSerialID = @nSerialID

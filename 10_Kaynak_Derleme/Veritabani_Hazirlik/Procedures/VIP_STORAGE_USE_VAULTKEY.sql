CREATE PROCEDURE [dbo].[VIP_STORAGE_USE_VAULTKEY]
@strAccountID char(21),
@strExpirationDate int
AS

   DECLARE @bCount tinyint
     SELECT @bCount = COUNT(strAccountID) FROM VIP_WAREHOUSE WHERE strAccountID = @strAccountID
       IF (@bCount = 0)
         RETURN 2
           ELSE
             UPDATE VIP_WAREHOUSE SET strExpirationDate = @strExpirationDate WHERE strAccountID = @strAccountID
               RETURN 1

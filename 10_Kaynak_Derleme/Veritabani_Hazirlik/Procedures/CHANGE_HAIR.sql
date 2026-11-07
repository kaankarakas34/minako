CREATE PROCEDURE [dbo].[CHANGE_HAIR]
@strAccountID varchar(21),
@strCharID varchar(21),
@bOpcode tinyint,
@bFace tinyint,
@nHair int
AS

   DECLARE @Count tinyint
     SELECT @Count = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strCharID
       IF (@Count = 0)
         RETURN 1
           UPDATE USERDATA SET HairRGB = @nHair, Face = @bFace WHERE strUserID = @strCharID 
             RETURN 0

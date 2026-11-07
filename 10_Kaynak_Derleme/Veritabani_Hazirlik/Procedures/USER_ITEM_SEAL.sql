CREATE PROCEDURE [dbo].[USER_ITEM_SEAL]
@strAccountID char(21),
@strCharID char(21),
@strPasswd char(8),
@nItemSerial bigint,
@nItemID int,
@bSealType tinyint
AS

   DECLARE @strSealPasswd char(8)
     SELECT @strSealPasswd = strSealPasswd FROM TB_USER WHERE strAccountID = @strAccountID
       IF (@bSealType < 3 AND @strSealPasswd <> @strPasswd)
         BEGIN
           RETURN 4
             END
               ELSE
                 BEGIN
                   IF (@bSealType = 1 OR @bSealType = 3)
                     BEGIN
                       DELETE FROM SEALED_ITEMS WHERE strAccountID = @strAccountID AND strUserID = @strCharID AND nItemSerial = @nItemSerial AND nItemID = @nItemID
                         INSERT INTO SEALED_ITEMS (strAccountID, strUserID, nItemSerial, nItemID, bSealType) VALUES (@strAccountID, @strCharID, @nItemSerial, @nItemID, @bSealType)
                           RETURN 1
                             END
                               IF (@bSealType = 2)
                                 BEGIN
                                   DELETE FROM SEALED_ITEMS WHERE strAccountID = @strAccountID AND strUserID = @strCharID AND nItemSerial = @nItemSerial AND nItemID = @nItemID
                                     RETURN 1
                                       END
                                         IF (@bSealType = 4)
                                           BEGIN
                                             UPDATE SEALED_ITEMS SET bSealType = @bSealType WHERE strAccountID = @strAccountID AND strUserID = @strCharID AND nItemSerial = @nItemSerial AND nItemID = @nItemID
                                               RETURN 1
                                                 END
                                                   END

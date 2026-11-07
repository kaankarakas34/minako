CREATE PROCEDURE [dbo].[KING_CANDIDACY_NOTICE_BOARD_PROC]
@strCharID char(21),
@byNation tinyint, 
@strNotice varchar(500)
AS

  DECLARE @bCount tinyint
    SELECT @bCount = COUNT(*) FROM KING_CANDIDACY_NOTICE_BOARD WHERE strUserID = @strCharID
      IF (@bCount = 0)
        INSERT INTO KING_CANDIDACY_NOTICE_BOARD (strUserID, byNation, strNotice) VALUES (@strCharID, @byNation, @strNotice)
          ELSE
            UPDATE KING_CANDIDACY_NOTICE_BOARD SET strNotice = @strNotice WHERE strUserID = @strCharID

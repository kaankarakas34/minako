CREATE PROCEDURE [dbo].[KING_UPDATE_ELECTION_STATUS]
@byType tinyint,
@byNation tinyint
AS

  --Aşama Seviye Atlatıyoruz.
  UPDATE KING_SYSTEM SET byType = @byType WHERE byNation = @byNation
  IF (@byType = 1)
    BEGIN
      /* Aday Atama Başlayacağı İçin Tabloları Boşaltıyoruz */
        DELETE FROM KING_ELECTION_LIST WHERE byNation = @byNation
          DELETE FROM KING_CANDIDACY_NOTICE_BOARD WHERE byNation = @byNation
            DELETE FROM KING_NOMINATION_LIST WHERE Nation = @byNation
              DELETE FROM KING_BALLOT_BOX WHERE Nation = @byNation
                DELETE FROM KING_NOMINATION_RESULT WHERE byNation = @byNation
                  END
  ELSE IF (@byType = 2)
    BEGIN
      /* Aday Atama bittiği İçin Senatörleri Siliyoruz. */
	  /* Aday Atama bittiği için aday göstermeyenleri aday yapıyoruz. */
        --DELETE FROM KING_ELECTION_LIST WHERE byType = 3 and byNation = @byNation
			UPDATE KING_ELECTION_LIST SET byType = 4 WHERE byNation = @byNation
          END
  ELSE IF (@byType = 7)
    BEGIN
      /* Aday Olanları Senatör Olarak Ekliyoruz. */
        INSERT INTO KING_ELECTION_LIST (byType,byNation, strName, nKnights, nMoney)
          SELECT 3,byNation,strName, nKnights, nMoney FROM KING_ELECTION_LIST WHERE byNation = @byNation AND byType = 4
            -- Aday Listesini Temizliyoruz.
              DELETE FROM KING_ELECTION_LIST WHERE byType = 4 AND byNation = @byNation
                END
  ELSE IF (@byType = 0)
    BEGIN
  /* Senatörler Eklendikten Sonra Nomination Tablosunu, Notice Board Tablosunu ve Oy Tablosunu Sıfırlıyoruz.*/
      DELETE FROM KING_NOMINATION_LIST WHERE Nation = @byNation
        DELETE FROM KING_CANDIDACY_NOTICE_BOARD WHERE byNation = @byNation
          DELETE FROM KING_BALLOT_BOX WHERE Nation = @byNation
            END

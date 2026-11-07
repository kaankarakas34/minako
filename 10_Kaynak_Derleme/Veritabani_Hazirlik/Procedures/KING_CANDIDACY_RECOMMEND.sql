CREATE PROCEDURE [dbo].[KING_CANDIDACY_RECOMMEND]
@strNominator char(21),
@strNominee	char(21),
@byNation	tinyint
AS

  DECLARE @UserNation tinyint
    SELECT @UserNation = Nation FROM USERDATA WHERE strUserID = @strNominee
      IF (@UserNation != @byNation)
        RETURN -4
        -- You can only nominate a user from the same nation :
        -- Aynı ulustan yalnızca bir kullanıcı aday gösterilebilir.
  DECLARE @strNominatorClanID smallint,@strNomineeClanID Smallint
    SELECT @strNominatorClanID = Knights FROM USERDATA WHERE strUserID = @strNominator
      SELECT @strNomineeClanID = Knights FROM USERDATA WHERE strUserID = @strNominee
        IF (@strNomineeClanID != @strNominatorClanID)
          RETURN -1 
          -- ID does ot exits :
          -- Aday Gösterilecek Oyuncu Kendi Klanında Olmalıdır.Karakter Bulunamadı.
  DECLARE @User char(21)
    SELECT @User = strUserID FROM USERDATA WHERE strUserID = @strNominee
      IF (@@ROWCOUNT = 0)
        RETURN -1
		-- ID does ot exits :
        -- Karakter Bulunamadı.
  DECLARE @Aday tinyint
    SELECT @Aday = COUNT(strNominator)FROM  KING_NOMINATION_LIST WHERE strNominator = @strNominator
      IF (@Aday > 0)
        RETURN -3
	    -- You do not have the authory to nominate :
        -- Aday gösterme yetkisine sahip değilsin Nedeni ise daha önce bir oyunucuyu aday göstermişşiniz ve o oyuncu hala aday.
  DECLARE @Aday2 tinyint
    SELECT @Aday2 = COUNT (strName) FROM KING_ELECTION_LIST WHERE strName = @strNominee AND byType = 4
      IF (@Aday2 > 0)
	  BEGIN
        RETURN -5 
		END
		-- This person has already been nominated :
        -- Bu kişi zaten aday olmuş.
		BEGIN
  DECLARE @ClanID smallint
    SELECT  @ClanID = Knights FROM USERDATA WHERE strUserID = @strNominee
      INSERT INTO KING_NOMINATION_LIST (Nation,strNominator,strNominee) VALUES (@byNation,@strNominator,@strNominee)
        INSERT INTO KING_ELECTION_LIST (byNation,byType,strName, nKnights,nMoney) VALUES (@byNation,4 ,@strNominee,@ClanID, 0)
		 DELETE FROM KING_ELECTION_LIST WHERE  strName = @strNominator and byNation = @byNation and byType = 3
          RETURN 1
		  END
          -- Succes :
          -- Aday başarıyla oluşturuldu.

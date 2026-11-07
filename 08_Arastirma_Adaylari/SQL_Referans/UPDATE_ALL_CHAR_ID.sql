-- Reference only: extracted from an alternative TemuKO database script.
-- Source: https://github.com/luisfelipe18/temuko-posix/blob/af34b1131c21b42d1949d2a63d689165b812103d/Database/KO_DATABASE_SERVER_001_SPs.sql
-- Retrieved: 2026-11-04. Not installed in KNIGHT_24XX_TEST.
-- Author metadata in upstream file: TheThyke, 2017-10-13 / 2017-12-29.
CREATE PROCEDURE [dbo].[UPDATE_ALL_CHAR_ID]
@strAccountID varchar(21),
@strCharID1 char(21),
@strCharID2 char(21),
@strCharID3 char(21),
@strCharID4 char(21)
AS

BEGIN
	UPDATE ACCOUNT_CHAR SET strCharID1 = @strCharID1,strCharID2 = @strCharID2, strCharID3 = @strCharID3,strCharID4 = @strCharID4 WHERE strAccountID = @strAccountID
END


CREATE PROCEDURE [dbo].[SET_LOGIN_INFO]
@strAccountID varchar(20),
@strCharID varchar(20),
@nServerno smallint,
@strServerIP varchar(50),
@strClientIP varchar(50),
@bInit tinyint
AS


   DECLARE @IpAdressOld char(15)
     SELECT @IpAdressOld = strClientIP FROM TB_USER WHERE strAccountID = @strAccountID
       IF (@bInit = 1)
         BEGIN
           INSERT INTO CURRENTUSER (strAccountID, strCharID, nServerNo, strServerIP, strClientIP) VALUES (@strAccountID, @strCharID, @nServerno, @strServerIP, @strClientIP)
               END
                 ELSE	
                   UPDATE CURRENTUSER SET nServerNo = @nServerno, strServerIP = @strServerIP WHERE strAccountID = @strAccountID
                     UPDATE TB_USER SET strClientIP = @strClientIP WHERE strAccountID = @strAccountID
					   RETURN 1

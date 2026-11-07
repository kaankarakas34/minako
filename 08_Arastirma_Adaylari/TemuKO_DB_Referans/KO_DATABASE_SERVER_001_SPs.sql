-- =============================================
-- Procedure: dt_dropuserobjectbyid
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Drop an object from the dbo.dtproperties table
*/
create procedure dbo.dt_dropuserobjectbyid
	@id int
as
	set nocount on
	delete from dbo.dtproperties where objectid=@id


GO

-- =============================================
-- Procedure: dt_droppropertiesbyid
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Drop one or all the associated properties of an object or an attribute 
**
**	dt_dropproperties objid, null or '' -- drop all properties of the object itself
**	dt_dropproperties objid, property -- drop the property
*/
create procedure dbo.dt_droppropertiesbyid
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		delete from dbo.dtproperties where objectid=@id
	else
		delete from dbo.dtproperties 
			where objectid=@id and property=@property



GO

-- =============================================
-- Procedure: LOAD_HACKTOOL_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 17.08.2018
-- Update date: 17.08.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_HACKTOOL_LIST]
AS

BEGIN
	SELECT* FROM HACKTOOL_CHECK_LIST
END

GO

-- =============================================
-- Procedure: dt_verstamp006
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	This procedure returns the version number of the stored
**    procedures used by the Microsoft Visual Database Tools.
**    Current version is 7.0.00.
*/
create procedure dbo.dt_verstamp006
as
	select 7000


GO

-- =============================================
-- Procedure: dt_getpropertiesbyid_vcs
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create procedure dbo.dt_getpropertiesbyid_vcs
    @id       int,
    @property varchar(64),
    @value    varchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select value
                from dbo.dtproperties
                where @id=objectid and @property=property
                )



GO

-- =============================================
-- Procedure: dt_displayoaerror
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE dbo.dt_displayoaerror
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      varchar(255)
declare @hr             int
declare @vchSource      varchar(255)
declare @vchDescription varchar(255)

    exec @hr = sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + ': ' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return



GO

-- =============================================
-- Procedure: dt_adduserobject_vcs
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create procedure dbo.dt_adduserobject_vcs
    @vchProperty varchar(64)

as

set nocount on

declare @iReturn int
    /*
    ** Create the user object if it does not exist already
    */
    begin transaction
        select @iReturn = objectid from dbo.dtproperties where property = @vchProperty
        if @iReturn IS NULL
        begin
            insert dbo.dtproperties (property) VALUES (@vchProperty)
            update dbo.dtproperties set objectid=@@identity
                    where id=@@identity and property=@vchProperty
            select @iReturn = @@identity
        end
    commit
    return @iReturn




GO

-- =============================================
-- Procedure: dt_addtosourcecontrol
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_addtosourcecontrol
    @vchSourceSafeINI varchar(255) = '',
    @vchProjectName   varchar(255) ='',
    @vchComment       varchar(255) ='',
    @vchLoginName     varchar(255) ='',
    @vchPassword      varchar(255) =''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId varchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* Create Project in SS */
    exec @iReturn = sp_OAMethod @iObjectId,
                                'AddProjectToSourceSafe',
                                NULL,
                                @vchSourceSafeINI,
                                @vchProjectName output,
                                @@SERVERNAME,
                                @vchDatabaseName,
                                @vchLoginName,
                                @vchPassword,
                                @vchComment


    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs 'VCSProjectID'

    select @vchParentId = CONVERT(varchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProjectID', @vchParentId , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSProject' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSourceSafeINI' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLServer', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid @iPropertyObjectId, 'VCSSQLDatabase', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties

    declare cursorProcNames cursor for
        select convert(varchar(255), name) from sysobjects where type = 'P' and name not like 'dt_%'
    open cursorProcNames

    while 1 = 1
    begin
        declare @vchProcName varchar(255)
        fetch next from cursorProcNames into @vchProcName
        if @@fetch_status <> 0
            break

        select colid, text into #ProcLines
        from syscomments
        where id = object_id(@vchProcName)
        order by colid

        declare @iCurProcLine int
        declare @iProcLines int
        select @iCurProcLine = 1
        select @iProcLines = (select count(*) from #ProcLines)
        while @iCurProcLine <= @iProcLines
        begin
            declare @pos int
            select @pos = 1
            declare @iCurLineSize int
            select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
            while @pos <= @iCurLineSize
            begin
                declare @vchProcLinePiece varchar(255)
                select @vchProcLinePiece = convert(varchar(255),
                    substring((select text from #ProcLines where colid = @iCurProcLine),
                              @pos, 255 ))
                exec @iReturn = sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
                if @iReturn <> 0 GOTO E_OAError
                select @pos = @pos + 255
            end
            select @iCurProcLine = @iCurProcLine + 1
        end
        drop table #ProcLines

        exec @iReturn = sp_OAMethod @iObjectId,
                                    'CheckIn_StoredProcedure',
                                    NULL,
                                    @sProjectName = @vchProjectName,
                                    @sSourceSafeINI = @vchSourceSafeINI,
                                    @sServerName = @@SERVERNAME,
                                    @sDatabaseName = @vchDatabaseName,
                                    @sObjectName = @vchProcName,
                                    @sComment = @vchComment,
                                    @sLoginName = @vchLoginName,
                                    @sPassword = @vchPassword,
                                    @iVCSFlags = 0,
                                    @iActionFlag = 0,
                                    @sStream = ''

        if @iReturn = 0 select @iObjectCount = @iObjectCount + 1

    end

CleanUp:
	close cursorProcNames
	deallocate cursorProcNames
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp




GO

-- =============================================
-- Procedure: ACCOUNT_LOGIN
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2017
-- Update date: 15.10.2017
-- Notes :
/* Return values: 
1 Successful.
2 No such register ID
3 Invalid password.
4 Your account is currently blocked. Please contact customer service if you have any question. Thank you.
5 The account is currently in use. Would you like to disconnect the previous connection?
6 Please verify your email address to complete the account activation. Once you have completed the account activation, you'll be able to fully access Knight Online World.
7 There is an error in the selected server.
11 There's not enough points remaining on this PP card
12 This PP card has expired.
14 Connecting. Please wait. (Unknown)
15 User Agreement Update.
16 Please enter the correct OTP password.
17 Error! OTP
18 ICS service has expired. If you want to keep your information safe, please renew the ICS service. Thank you.
*/
-- =============================================
CREATE PROCEDURE [dbo].[ACCOUNT_LOGIN]
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

DECLARE @strHashPassword varchar(28)
SELECT @strHashPassword = strPasswd FROM TB_USER WHERE strAccountID = @strAccountID
	IF (@strHashPassword != @strPasswd)
		RETURN 3
 
DECLARE @BanControl tinyint, @ısnull tinyint
SELECT @ısnull = count(*) FROM [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL WHERE strAccountID = @strAccountID
SELECT @BanControl = isAuthority FROM [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL WHERE strAccountID = @strAccountID
	IF(@ısnull > 0)
	BEGIN
		IF(@BanControl != 1)
			RETURN 4 
	END

DECLARE @isInGame tinyint
SELECT @isInGame = count(*) FROM CURRENTUSER WHERE strAccountID = @strAccountID
	IF(@isInGame > 0)
	BEGIN
		DELETE FROM CURRENTUSER WHERE strAccountID = @strAccountID
		RETURN 5
	END
 
DECLARE @AutoRegister tinyint
SELECT @AutoRegister = [AutoRegister] FROM [KO_DATABASE_MAIN].dbo.GAME_OPTIONS
SELECT @strAccountID = strAccountID FROM TB_USER WHERE strAccountID = @strAccountID
	IF (@@ROWCOUNT = 0 AND @AutoRegister = 1)
	BEGIN
		INSERT INTO TB_USER (strAccountID, strPasswd) VALUES (@strAccountID, @strPasswd)
		INSERT INTO [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL(strAccountID,BanGameMasterName,isAuthority,BanReason,BanCount,OpenCount, UpdateTime) VALUES (@strAccountID,'',1,'',0,0,GETDATE()) 
		RETURN 1
	END
                
DECLARE @AccountControl smallint,@AccountOTP smallint
SELECT @AccountControl = COUNT(strAccountID) FROM TB_USER WHERE strAccountID = @strAccountID  
	IF (@AccountControl > 0)
	BEGIN
		SELECT @AccountOTP = OpenOTP FROM [KO_DATABASE_MAIN].dbo.GAME_OPTIONS 
		IF (@AccountOTP = 1)
			RETURN 16
		RETURN 1
	END

RETURN 2

GO

-- =============================================
-- Procedure: dt_checkinobject
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_checkinobject
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255)='',
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '', /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '',
    @txStream3     Text = ''


as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'


declare @iPropertyObjectId int
select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, Create Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            exec @iReturn = sp_OAMethod @iObjectId,
                                        'CheckIn_StoredProcedure',
                                        NULL,
                                        @sProjectName = @vchProjectName,
                                        @sSourceSafeINI = @vchSourceSafeINI,
                                        @sServerName = @vchServerName,
                                        @sDatabaseName = @vchDatabaseName,
                                        @sObjectName = @vchObjectName,
                                        @sComment = @vchComment,
                                        @sLoginName = @vchLoginName,
                                        @sPassword = @vchPassword,
                                        @iVCSFlags = @iVCSFlags,
                                        @iActionFlag = @iActionFlag,
                                        @sStream = @txStream2
        end
        else
        begin
            declare @iStreamObjectId int
            declare @iReturnValue int

            exec @iReturn = sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT
            if @iReturn <> 0 GOTO E_OAError

            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                declare @pos int
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin
                    declare @vchProcLinePiece varchar(255)
                    select @vchProcLinePiece = convert(varchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = sp_OAMethod @iStreamObjectId, 'AddStream', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = sp_OAMethod @iObjectId,
                                        'CheckIn_StoredProcedure',
                                        NULL,
                                        @sProjectName = @vchProjectName,
                                        @sSourceSafeINI = @vchSourceSafeINI,
                                        @sServerName = @vchServerName,
                                        @sDatabaseName = @vchDatabaseName,
                                        @sObjectName = @vchObjectName,
                                        @sComment = @vchComment,
                                        @sLoginName = @vchLoginName,
                                        @sPassword = @vchPassword,
                                        @iVCSFlags = @iVCSFlags,
                                        @iActionFlag = @iActionFlag,
                                        @sStream = ''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
    return

E_Compile_Fail:
    declare @lerror int
    select @lerror = @@error
    rollback tran compile_all
    RAISERROR (@lerror,16,-1)
    goto CleanUp

E_OAError:
    if @iActionFlag = 1 rollback tran compile_all
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp




GO

-- =============================================
-- Procedure: ACCOUNT_PREMIUM
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2017
-- Update date: 15.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[ACCOUNT_PREMIUM]
@strAccountID char(20)
AS

DECLARE @sHours smallint
       DECLARE @dtPremiumTime datetime
           SELECT @dtPremiumTime = dtPremiumTime FROM TB_USER WHERE strAccountID = @strAccountID
                 SET @sHours = DATEDIFF(HH, GETDATE(), @dtPremiumTime)
                     IF (@sHours <= 0 OR @sHours IS NULL OR @@ERROR <> 0 )
                          RETURN -1
                               RETURN @sHours


GO

-- =============================================
-- Procedure: LOAD_SERVER_SETTINGS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 07.11.2018
-- Update date: 07.11.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_SERVER_SETTINGS]
AS

BEGIN
	SELECT * FROM [KO_DATABASE_MAIN].dbo.SERVER_SETTINGS
END

GO

-- =============================================
-- Procedure: dt_checkoutobject
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_checkoutobject
    @chObjectType  char(4),
    @vchObjectName varchar(255),
    @vchComment    varchar(255),
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @iReturnValue int
select @iReturnValue = 0

declare @vchTempText varchar(255)

/* this is for our strings */
declare @iStreamObjectId int
select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        /* Procedure Can have up to three streams
           Drop Stream, Create Stream, GRANT stream */

        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = sp_OAMethod @iObjectId,
                                    'CheckOut_StoredProcedure',
                                    NULL,
                                    @sProjectName = @vchProjectName,
                                    @sSourceSafeINI = @vchSourceSafeINI,
                                    @sObjectName = @vchObjectName,
                                    @sServerName = @vchServerName,
                                    @sDatabaseName = @vchDatabaseName,
                                    @sComment = @vchComment,
                                    @sLoginName = @vchLoginName,
                                    @sPassword = @vchPassword,
                                    @iVCSFlags = @iVCSFlags,
                                    @iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #commenttext (id int identity, sourcecode varchar(255))


        select @vchTempText = 'STUB'
        while @vchTempText IS NOT NULL
        begin
            exec @iReturn = sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError

            if (@vchTempText IS NOT NULL) insert into #commenttext (sourcecode) select @vchTempText
        end

        select 'VCS'=sourcecode from #commenttext order by id
        select 'SQL'=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp




GO

-- =============================================
-- Procedure: ACCOUNT_LOGOUT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2017
-- Update date: 15.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[ACCOUNT_LOGOUT]
@strAccountID varchar(21)
AS

BEGIN
	DELETE FROM CURRENTUSER WHERE strAccountID = @strAccountID
END
/*
DECLARE @FirstCharacterLastExit datetime, @TwoCharacterLastExit datetime,@ThreeCharacterLastExit datetime
DECLARE @strCharID1 Char(21),@strCharID2 Char(21),@strCharID3 Char(21)
SELECT @FirstCharacterLastExit = FirstCharacterLastExit, @TwoCharacterLastExit = TwoCharacterLastExit , @ThreeCharacterLastExit = ThreeCharacterLastExit FROM KOHSTR_OLD_CHARACTER_LETTER_SYSTEM WHERE AccountID = @strAccountID
SELECT @strCharID1 = FirstCharName ,@strCharID2 = TwoCharName, @strCharID3 = ThreeCharName FROM KOHSTR_OLD_CHARACTER_LETTER_SYSTEM WHERE AccountID = @strAccountID
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET FirstCharacterLastExit = GETDATE() WHERE FirstCharName = @strCharID1
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET TwoCharacterLastExit = GETDATE() WHERE TwoCharName = @strCharID2
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET ThreeCharacterLastExit = GETDATE() WHERE ThreeCharName = @strCharID3
*/

GO

-- =============================================
-- Procedure: dt_isundersourcecontrol
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_isundersourcecontrol
    @vchLoginName varchar(255) = '',
    @vchPassword  varchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

declare @iReturnValue int
select @iReturnValue = 0

declare @iStreamObjectId int
select @iStreamObjectId   = 0

declare @vchTempText varchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if (@vchProjectName IS NULL) or (@vchSourceSafeINI  IS NULL) or (@vchServerName IS NULL) or (@vchDatabaseName IS NULL)
    begin
        RAISERROR('Not Under Source Control',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = sp_OAMethod @iObjectId,
                                    'GetListOfObjects',
                                    NULL,
                                    @vchProjectName,
                                    @vchSourceSafeINI,
                                    @vchServerName,
                                    @vchDatabaseName,
                                    @vchLoginName,
                                    @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = sp_OAGetProperty @iObjectId, 'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #ObjectList (id int identity, vchObjectlist varchar(255))

        select @vchTempText = 'STUB'
        while @vchTempText IS NOT NULL
        begin
            exec @iReturn = sp_OAMethod @iStreamObjectId, 'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError

            if (@vchTempText IS NOT NULL) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    goto CleanUp




GO

-- =============================================
-- Procedure: LOAD_HOOK_SETTINGS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.06.2019
-- Update date: 08.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_HOOK_SETTINGS]
AS

-------------------------------------------------------------------------------------------------------
   SELECT * FROM HOOK_SETTINGS
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: CLEAR_REMAIN_USERS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[CLEAR_REMAIN_USERS]
@strServerIP varchar(50)
AS

  DELETE FROM CURRENTUSER WHERE strServerIP = @strServerIP


GO

-- =============================================
-- Procedure: dt_removefromsourcecontrol
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create procedure dbo.dt_removefromsourcecontrol

as

    set nocount on

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    exec dbo.dt_droppropertiesbyid @iPropertyObjectId, null

    /* -1 is returned by dt_droppopertiesbyid */
    if @@error <> 0 and @@error <> -1 return 1

    return 0




GO

-- =============================================
-- Procedure: SET_LOGIN_INFO
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
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


GO

-- =============================================
-- Procedure: dt_validateloginparams
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_validateloginparams
    @vchLoginName  varchar(255),
    @vchPassword   varchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchSourceSafeINI varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT

    exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = sp_OAMethod @iObjectId,
                                'ValidateLoginParams',
                                NULL,
                                @sSourceSafeINI = @vchSourceSafeINI,
                                @sLoginName = @vchLoginName,
                                @sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp




GO

-- =============================================
-- Procedure: DELETE_GM
-- Database: KO_DATABASE_SERVER_001
-- =============================================
-- =============================================
-- Create date: 15.02.2021
-- Update date: 15.02.2021
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_GM]
@strUserID varchar(21)
AS
BEGIN
DECLARE @strAccountID varchar(21)
SELECT @strAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID1 = @strUserID or strCharID2 = @strUserID or strCharID3 = @strUserID  or strCharID4 = @strUserID 
END
BEGIN
UPDATE USERDATA SET Authority = 1 WHERE strUserID = @strUserID

DELETE FROM [KO_DATABASE_MAIN].dbo.GAME_MASTER_SETTINGS WHERE strCharID = @strUserID

print 'Felicidades, El usuario ha sido eliminado correctamente como GM'

END

GO

-- =============================================
-- Procedure: LOAD_PREMIUM_SERVICE_USER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_PREMIUM_SERVICE_USER]
@strAccountID char(20),
@bType tinyint OUTPUT,
@sTime smallint OUTPUT
AS

   DECLARE @bPremiumType tinyint
     DECLARE @dtPremiumTime datetime
       SELECT @bPremiumType = bPremiumType, @dtPremiumTime = dtPremiumTime FROM TB_USER WHERE strAccountID = @strAccountID
         SET @sTime = DATEDIFF(HH, GETDATE(), @dtPremiumTime)
           SET @bType = @bPremiumType
             IF (@sTime <= 0 OR @sTime IS NULL OR @@ERROR <> 0 )
               BEGIN
                 SET @bType = 0
                   SET @sTime = 0
                     END

GO

-- =============================================
-- Procedure: dt_vcsenabled
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_vcsenabled

as

set nocount on

declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iReturn int
    exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 raiserror('', 16, -1) /* Can't Load Helper DLLC */




GO

-- =============================================
-- Procedure: ADD_GM
-- Database: KO_DATABASE_SERVER_001
-- =============================================
-- =============================================
-- Create date: 15.02.2021
-- Update date: 15.02.2021
-- =============================================
CREATE PROCEDURE    [dbo].[ADD_GM]
@strUserID varchar(21)
AS
BEGIN
DECLARE @strAccountID varchar(21)
SELECT @strAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID1 = @strUserID or strCharID2 = @strUserID or strCharID3 = @strUserID  or strCharID4 = @strUserID 
END
BEGIN
UPDATE USERDATA SET Authority = 0 WHERE strUserID = @strUserID

insert into [KO_DATABASE_MAIN].dbo.GAME_MASTER_SETTINGS values (@strAccountID ,@strUserID,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)

print 'Felicidades, ya eres GM '

END

GO

-- =============================================
-- Procedure: LOAD_CHAOS_STONE_STAGE
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.06.2019
-- Update date: 08.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_CHAOS_STONE_STAGE]
AS

-------------------------------------------------------------------------------------------------------
   SELECT * FROM CHAOS_STONE_SUMMON_STAGE
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: SAVE_PREMIUM_SERVICE_USER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[SAVE_PREMIUM_SERVICE_USER]
@strAccountID char(20),
@strCharID char(20),
@bType tinyint,
@sTime smallint
AS

   DECLARE @dtExpiry datetime
     SET @dtExpiry = DATEADD(HH, @sTime, GETDATE())
       UPDATE TB_USER SET bPremiumType = @bType, dtPremiumTime = @dtExpiry, sHours = @sTime WHERE strAccountID = @strAccountID
  /* DECLARE @strSenderID char(20) = 'The Knight Crown'
     DECLARE @strMessage char(128) = 'Premium Bonus Item'
       DECLARE @LetterType tinyint = 2 
         BEGIN
           INSERT INTO MAIL_BOX (strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability) 
             SELECT @strSenderID, @strCharID, strItemName, @strMessage, @LetterType, nItemID, sCount, sDurability FROM PREMIUM_ITEM_LETTER_GIFT WHERE bType = @bType and @sTime = 720
               END*/

GO

-- =============================================
-- Procedure: dt_whocheckedout
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_whocheckedout
        @chObjectType  char(4),
        @vchObjectName varchar(255),
        @vchLoginName  varchar(255),
        @vchPassword   varchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID varchar(100)
select @VSSGUID = 'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   varchar(255)
    declare @vchSourceSafeINI varchar(255)
    declare @vchServerName    varchar(255)
    declare @vchDatabaseName  varchar(255)
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue varchar(255)
        select @vchReturnValue = ''

        exec @iReturn = sp_OAMethod @iObjectId,
                                    'WhoCheckedOut',
                                    @vchReturnValue OUT,
                                    @sProjectName = @vchProjectName,
                                    @sSourceSafeINI = @vchSourceSafeINI,
                                    @sObjectName = @vchObjectName,
                                    @sServerName = @vchServerName,
                                    @sDatabaseName = @vchDatabaseName,
                                    @sLoginName = @vchLoginName,
                                    @sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror @iObjectId, @iReturn
    GOTO CleanUp




GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_CREATE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 25.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_CREATE]
@sMainClanID smallint,
@sSubClanID smallint,
@byEmptyIndex tinyint
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	INSERT INTO KNIGHTS_ALLIANCE (sMainAllianceKnights,sSubAllianceKnights,sMercenaryClan_1,sMercenaryClan_2) VALUES (@sMainClanID,@sSubClanID,0,0)
	UPDATE KNIGHTS SET sAllianceKnights = @sMainClanID WHERE IDNum = @sSubClanID
	UPDATE KNIGHTS SET sAllianceKnights = @sMainClanID WHERE IDNum = @sMainClanID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_KNIGHTS_SIEGE_WAR_REGISTER
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 30.07.2018
-- Update date: 30.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_SIEGE_WAR_REGISTER]
AS

BEGIN
	SELECT TOP(30) KNIGHTS_SIEGE_WARFARE_REGISTER.sBaseClanCommander,KNIGHTS.IDName,sMarkVersion,IDNum FROM KNIGHTS_SIEGE_WARFARE_REGISTER INNER JOIN KNIGHTS ON KNIGHTS.IDNum = KNIGHTS_SIEGE_WARFARE_REGISTER.sBaseClanNum ORDER BY sIndex
END

GO

-- =============================================
-- Procedure: dt_addtosourcecontrol_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_addtosourcecontrol_u
    @vchSourceSafeINI nvarchar(255) = '',
    @vchProjectName   nvarchar(255) ='',
    @vchComment       nvarchar(255) ='',
    @vchLoginName     nvarchar(255) ='',
    @vchPassword      nvarchar(255) =''

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @iStreamObjectId int
select @iStreamObjectId = 0

declare @VSSGUID nvarchar(100)
select @VSSGUID = N'SQLVersionControl.VCS_SQL'

declare @vchDatabaseName varchar(255)
select @vchDatabaseName = db_name()

declare @iReturnValue int
select @iReturnValue = 0

declare @iPropertyObjectId int
declare @vchParentId nvarchar(255)

declare @iObjectCount int
select @iObjectCount = 0

    exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError


    /* Create Project in SS */
    exec @iReturn = sp_OAMethod @iObjectId,
                                'AddProjectToSourceSafe',
                                NULL,
                                @vchSourceSafeINI,
                                @vchProjectName output,
                                @@SERVERNAME,
                                @vchDatabaseName,
                                @vchLoginName,
                                @vchPassword,
                                @vchComment


    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = sp_OAGetProperty @iObjectId, N'GetStreamObject', @iStreamObjectId OUT

    if @iReturn <> 0 GOTO E_OAError

    /* Set Database Properties */

    begin tran SetProperties

    /* add high level object */

    exec @iPropertyObjectId = dbo.dt_adduserobject_vcs 'VCSProjectID'

    select @vchParentId = CONVERT(nvarchar(255),@iPropertyObjectId)

    exec dbo.dt_setpropertybyid_u @iPropertyObjectId, 'VCSProjectID', @vchParentId , NULL
    exec dbo.dt_setpropertybyid_u @iPropertyObjectId, 'VCSProject' , @vchProjectName , NULL
    exec dbo.dt_setpropertybyid_u @iPropertyObjectId, 'VCSSourceSafeINI' , @vchSourceSafeINI , NULL
    exec dbo.dt_setpropertybyid_u @iPropertyObjectId, 'VCSSQLServer', @@SERVERNAME, NULL
    exec dbo.dt_setpropertybyid_u @iPropertyObjectId, 'VCSSQLDatabase', @vchDatabaseName, NULL

    if @@error <> 0 GOTO E_General_Error

    commit tran SetProperties

    declare cursorProcNames cursor for
        select convert(nvarchar(255), name) from sysobjects where type = N'P' and name not like N'dt_%'
    open cursorProcNames

    while 1 = 1
    begin
        declare @vchProcName nvarchar(255)
        fetch next from cursorProcNames into @vchProcName
        if @@fetch_status <> 0
            break

        select colid, text into #ProcLines
        from syscomments
        where id = object_id(@vchProcName)
        order by colid

        declare @iCurProcLine int
        declare @iProcLines int
        select @iCurProcLine = 1
        select @iProcLines = (select count(*) from #ProcLines)
        while @iCurProcLine <= @iProcLines
        begin
            declare @pos int
            select @pos = 1
            declare @iCurLineSize int
            select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
            while @pos <= @iCurLineSize
            begin
                declare @vchProcLinePiece nvarchar(255)
                select @vchProcLinePiece = convert(nvarchar(255),
                    substring((select text from #ProcLines where colid = @iCurProcLine),
                              @pos, 255 ))
                exec @iReturn = sp_OAMethod @iStreamObjectId, N'AddStream', @iReturnValue OUT, @vchProcLinePiece
                if @iReturn <> 0 GOTO E_OAError
                select @pos = @pos + 255
            end
            select @iCurProcLine = @iCurProcLine + 1
        end
        drop table #ProcLines

        exec @iReturn = sp_OAMethod @iObjectId,
                                    'CheckIn_StoredProcedure',
                                    NULL,
                                    @sProjectName = @vchProjectName,
                                    @sSourceSafeINI = @vchSourceSafeINI,
                                    @sServerName = @@SERVERNAME,
                                    @sDatabaseName = @vchDatabaseName,
                                    @sObjectName = @vchProcName,
                                    @sComment = @vchComment,
                                    @sLoginName = @vchLoginName,
                                    @sPassword = @vchPassword,
                                    @iVCSFlags = 0,
                                    @iActionFlag = 0,
                                    @sStream = ''

        if @iReturn = 0 select @iObjectCount = @iObjectCount + 1

    end

CleanUp:
	close cursorProcNames
	deallocate cursorProcNames
    select @vchProjectName
    select @iObjectCount
    return

E_General_Error:
    /* this is an all or nothing.  No specific error messages */
    goto CleanUp

E_OAError:
    exec dbo.dt_displayoaerror_u @iObjectId, @iReturn
    goto CleanUp




GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_INSERT
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 25.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_INSERT]
@sMainClanID smallint,
@sSubClanID smallint,
@byEmptyIndex tinyint
AS
-------------------------------------------------------------------------------------------------------
	  IF @byEmptyIndex = 1
	    BEGIN
	      UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = @sSubClanID WHERE sMainAllianceKnights = @sMainClanID	
	        END
	          IF @byEmptyIndex = 2
	            BEGIN
	              UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = @sSubClanID WHERE sMainAllianceKnights = @sMainClanID	
	                END
	                  IF @byEmptyIndex = 3
	                    BEGIN
	                      UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = @sSubClanID WHERE sMainAllianceKnights = @sMainClanID	
	                        END
							 UPDATE KNIGHTS SET sAllianceKnights = @sMainClanID WHERE IDNum = @sSubClanID
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: dt_checkinobject_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_checkinobject_u
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255)='',
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)='',
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0,   /* 0 => AddFile, 1 => CheckIn */
    @txStream1     Text = '', /* There is a bug that if items are NULL they do not pass to OLE servers */
    @txStream2     Text = '',
    @txStream3     Text = ''


as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId = 0

declare @VSSGUID nvarchar(100)
select @VSSGUID = N'SQLVersionControl.VCS_SQL'


declare @iPropertyObjectId int
select @iPropertyObjectId  = 0

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   nvarchar(255)
    declare @vchSourceSafeINI nvarchar(255)
    declare @vchServerName    nvarchar(255)
    declare @vchDatabaseName  nvarchar(255)
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        if @iActionFlag = 1
        begin
            /* Procedure Can have up to three streams
            Drop Stream, Create Stream, GRANT stream */

            begin tran compile_all

            /* try to compile the streams */
            exec (@txStream1)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream2)
            if @@error <> 0 GOTO E_Compile_Fail

            exec (@txStream3)
            if @@error <> 0 GOTO E_Compile_Fail
        end

        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            exec @iReturn = sp_OAMethod @iObjectId,
                                        N'CheckIn_StoredProcedure',
                                        NULL,
                                        @sProjectName = @vchProjectName,
                                        @sSourceSafeINI = @vchSourceSafeINI,
                                        @sServerName = @vchServerName,
                                        @sDatabaseName = @vchDatabaseName,
                                        @sObjectName = @vchObjectName,
                                        @sComment = @vchComment,
                                        @sLoginName = @vchLoginName,
                                        @sPassword = @vchPassword,
                                        @iVCSFlags = @iVCSFlags,
                                        @iActionFlag = @iActionFlag,
                                        @sStream = @txStream2
        end
        else
        begin
            declare @iStreamObjectId int
            declare @iReturnValue int

            exec @iReturn = sp_OAGetProperty @iObjectId, N'GetStreamObject', @iStreamObjectId OUT
            if @iReturn <> 0 GOTO E_OAError

            select colid, text into #ProcLines
            from syscomments
            where id = object_id(@vchObjectName)
            order by colid

            declare @iCurProcLine int
            declare @iProcLines int
            select @iCurProcLine = 1
            select @iProcLines = (select count(*) from #ProcLines)
            while @iCurProcLine <= @iProcLines
            begin
                declare @pos int
                select @pos = 1
                declare @iCurLineSize int
                select @iCurLineSize = len((select text from #ProcLines where colid = @iCurProcLine))
                while @pos <= @iCurLineSize
                begin
                    declare @vchProcLinePiece nvarchar(255)
                    select @vchProcLinePiece = convert(nvarchar(255),
                        substring((select text from #ProcLines where colid = @iCurProcLine),
                                  @pos, 255 ))
                    exec @iReturn = sp_OAMethod @iStreamObjectId, N'AddStream', @iReturnValue OUT, @vchProcLinePiece
                    if @iReturn <> 0 GOTO E_OAError
                    select @pos = @pos + 255
                end
                select @iCurProcLine = @iCurProcLine + 1
            end
            drop table #ProcLines

            exec @iReturn = sp_OAMethod @iObjectId,
                                        N'CheckIn_StoredProcedure',
                                        NULL,
                                        @sProjectName = @vchProjectName,
                                        @sSourceSafeINI = @vchSourceSafeINI,
                                        @sServerName = @vchServerName,
                                        @sDatabaseName = @vchDatabaseName,
                                        @sObjectName = @vchObjectName,
                                        @sComment = @vchComment,
                                        @sLoginName = @vchLoginName,
                                        @sPassword = @vchPassword,
                                        @iVCSFlags = @iVCSFlags,
                                        @iActionFlag = @iActionFlag,
                                        @sStream = ''
        end

        if @iReturn <> 0 GOTO E_OAError

        if @iActionFlag = 1
        begin
            commit tran compile_all
            if @@error <> 0 GOTO E_Compile_Fail
        end

    end

CleanUp:
    return

E_Compile_Fail:
    declare @lerror int
    select @lerror = @@error
    rollback tran compile_all
    RAISERROR (@lerror,16,-1)
    goto CleanUp

E_OAError:
    if @iActionFlag = 1 rollback tran compile_all
    exec dbo.dt_displayoaerror_u @iObjectId, @iReturn
    goto CleanUp




GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_DESTROY
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 25.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_DESTROY]
@sAllianceID smallint
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	DELETE FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sAllianceID
	UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sAllianceID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_KNIGHTS_SIEGE_WAR_START_RANK_REGISTER
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 30.07.2018
-- Update date: 30.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_SIEGE_WAR_START_RANK_REGISTER]
AS

TRUNCATE TABLE KNIGHTS_SIEGE_WARFARE_RANK

BEGIN
	INSERT INTO KNIGHTS_SIEGE_WARFARE_RANK (sBaseClanNum,sBaseClanCommander,sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount) SELECT sBaseClanNum,sBaseClanCommander,0,0,0 FROM KNIGHTS_SIEGE_WARFARE_REGISTER
END

BEGIN
	SELECT TOP(30) KNIGHTS_SIEGE_WARFARE_RANK.sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount,KNIGHTS.IDName,sMarkVersion,IDNum FROM KNIGHTS_SIEGE_WARFARE_RANK INNER JOIN KNIGHTS ON KNIGHTS.IDNum = KNIGHTS_SIEGE_WARFARE_RANK.sBaseClanNum
END

GO

-- =============================================
-- Procedure: dt_checkoutobject_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_checkoutobject_u
    @chObjectType  char(4),
    @vchObjectName nvarchar(255),
    @vchComment    nvarchar(255),
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255),
    @iVCSFlags     int = 0,
    @iActionFlag   int = 0/* 0 => Checkout, 1 => GetLatest, 2 => UndoCheckOut */

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID nvarchar(100)
select @VSSGUID = N'SQLVersionControl.VCS_SQL'

declare @iReturnValue int
select @iReturnValue = 0

declare @vchTempText nvarchar(255)

/* this is for our strings */
declare @iStreamObjectId int
select @iStreamObjectId = 0

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   nvarchar(255)
    declare @vchSourceSafeINI nvarchar(255)
    declare @vchServerName    nvarchar(255)
    declare @vchDatabaseName  nvarchar(255)
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        /* Procedure Can have up to three streams
           Drop Stream, Create Stream, GRANT stream */

        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = sp_OAMethod @iObjectId,
                                    N'CheckOut_StoredProcedure',
                                    NULL,
                                    @sProjectName = @vchProjectName,
                                    @sSourceSafeINI = @vchSourceSafeINI,
                                    @sObjectName = @vchObjectName,
                                    @sServerName = @vchServerName,
                                    @sDatabaseName = @vchDatabaseName,
                                    @sComment = @vchComment,
                                    @sLoginName = @vchLoginName,
                                    @sPassword = @vchPassword,
                                    @iVCSFlags = @iVCSFlags,
                                    @iActionFlag = @iActionFlag

        if @iReturn <> 0 GOTO E_OAError


        exec @iReturn = sp_OAGetProperty @iObjectId, N'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #commenttext (id int identity, sourcecode nvarchar(255))


        select @vchTempText = N'STUB'
        while @vchTempText IS NOT NULL
        begin
            exec @iReturn = sp_OAMethod @iStreamObjectId, N'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError

            if (@vchTempText IS NOT NULL) insert into #commenttext (sourcecode) select @vchTempText
        end

        select N'VCS'=sourcecode from #commenttext order by id
        select N'SQL'=text from syscomments where id = object_id(@vchObjectName) order by colid

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror_u @iObjectId, @iReturn
    GOTO CleanUp




GO

-- =============================================
-- Procedure: LOAD_HOOK_PUS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.06.2019
-- Update date: 08.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_HOOK_PUS]
AS

-------------------------------------------------------------------------------------------------------
   SELECT ItemID,BuyCount,Price,Category FROM HOOK_PUS_ITEMS
-------------------------------------------------------------------------------------------------------
--TheThyke



GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_REMOVE
-- Database: KO_DATABASE_SERVER_001
-- =============================================



/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 25.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_REMOVE]
@sMainClanID smallint,
@sSubClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @SubAlly smallint,@MercenaryClan1 smallint,@MercenaryClan2 smallint
	  SELECT @SubAlly = sSubAllianceKnights,@MercenaryClan1 = sMercenaryClan_1,@MercenaryClan2 = sMercenaryClan_2 FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sMainClanID
	      IF @sSubClanID = @SubAlly
	        BEGIN
	          UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = 0 WHERE sMainAllianceKnights = @sMainClanID
	            END
	              IF @sSubClanID = @MercenaryClan1
	                BEGIN
	                  UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = 0 WHERE sMainAllianceKnights = @sMainClanID	
	                    END
	                      IF @sSubClanID = @MercenaryClan2
	                        BEGIN
	                          UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = 0 WHERE sMainAllianceKnights = @sMainClanID	
	                            END
							  	 UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sSubClanID	
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: dt_displayoaerror_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE dbo.dt_displayoaerror_u
    @iObject int,
    @iresult int
as

set nocount on

declare @vchOutput      nvarchar(255)
declare @hr             int
declare @vchSource      nvarchar(255)
declare @vchDescription nvarchar(255)

    exec @hr = sp_OAGetErrorInfo @iObject, @vchSource OUT, @vchDescription OUT

    select @vchOutput = @vchSource + ': ' + @vchDescription
    raiserror (@vchOutput,16,-1)

    return



GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_PUNISH
-- Database: KO_DATABASE_SERVER_001
-- =============================================



/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 25.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_PUNISH]
@sMainClanID smallint,
@sSubClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @SubAlly smallint,@MercenaryClan1 smallint,@MercenaryClan2 smallint
	  SELECT @SubAlly = sSubAllianceKnights,@MercenaryClan1 = sMercenaryClan_1,@MercenaryClan2 = sMercenaryClan_2 FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sMainClanID
	      IF @sSubClanID = @SubAlly
	        BEGIN
	          UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = 0 WHERE sMainAllianceKnights = @sMainClanID
	            END
	              IF @sSubClanID = @MercenaryClan1
	                BEGIN
	                  UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = 0 WHERE sMainAllianceKnights = @sMainClanID	
	                    END
	                      IF @sSubClanID = @MercenaryClan2
	                        BEGIN
	                          UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = 0 WHERE sMainAllianceKnights = @sMainClanID	
	                            END
							  	 UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sSubClanID	
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: dt_getpropertiesbyid_vcs_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create procedure dbo.dt_getpropertiesbyid_vcs_u
    @id       int,
    @property varchar(64),
    @value    nvarchar(255) = NULL OUT

as

    set nocount on

    select @value = (
        select uvalue
                from dbo.dtproperties
                where @id=objectid and @property=property
                )



GO

-- =============================================
-- Procedure: dt_isundersourcecontrol_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_isundersourcecontrol_u
    @vchLoginName nvarchar(255) = '',
    @vchPassword  nvarchar(255) = '',
    @iWhoToo      int = 0 /* 0 => Just check project; 1 => get list of objs */

as

	set nocount on

	declare @iReturn int
	declare @iObjectId int
	select @iObjectId = 0

	declare @VSSGUID nvarchar(100)
	select @VSSGUID = N'SQLVersionControl.VCS_SQL'

	declare @iReturnValue int
	select @iReturnValue = 0

	declare @iStreamObjectId int
	select @iStreamObjectId   = 0

	declare @vchTempText nvarchar(255)

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   nvarchar(255)
    declare @vchSourceSafeINI nvarchar(255)
    declare @vchServerName    nvarchar(255)
    declare @vchDatabaseName  nvarchar(255)
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if (@vchProjectName IS NULL) or (@vchSourceSafeINI  IS NULL) or (@vchServerName IS NULL) or (@vchDatabaseName IS NULL)
    begin
        RAISERROR(N'Not Under Source Control',16,-1)
        return
    end

    if @iWhoToo = 1
    begin

        /* Get List of Procs in the project */
        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = sp_OAMethod @iObjectId,
                                    N'GetListOfObjects',
                                    NULL,
                                    @vchProjectName,
                                    @vchSourceSafeINI,
                                    @vchServerName,
                                    @vchDatabaseName,
                                    @vchLoginName,
                                    @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        exec @iReturn = sp_OAGetProperty @iObjectId, N'GetStreamObject', @iStreamObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        create table #ObjectList (id int identity, vchObjectlist nvarchar(255))

        select @vchTempText = N'STUB'
        while @vchTempText IS NOT NULL
        begin
            exec @iReturn = sp_OAMethod @iStreamObjectId, N'GetStream', @iReturnValue OUT, @vchTempText OUT
            if @iReturn <> 0 GOTO E_OAError

            if (@vchTempText IS NOT NULL) insert into #ObjectList (vchObjectlist ) select @vchTempText
        end

        select vchObjectlist from #ObjectList order by id
    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror_u @iObjectId, @iReturn
    goto CleanUp




GO

-- =============================================
-- Procedure: dt_validateloginparams_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_validateloginparams_u
    @vchLoginName  nvarchar(255),
    @vchPassword   nvarchar(255)
as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID nvarchar(100)
select @VSSGUID = N'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int
    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchSourceSafeINI nvarchar(255)
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT

    exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT
    if @iReturn <> 0 GOTO E_OAError

    exec @iReturn = sp_OAMethod @iObjectId,
                                N'ValidateLoginParams',
                                NULL,
                                @sSourceSafeINI = @vchSourceSafeINI,
                                @sLoginName = @vchLoginName,
                                @sPassword = @vchPassword
    if @iReturn <> 0 GOTO E_OAError

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror_u @iObjectId, @iReturn
    GOTO CleanUp




GO

-- =============================================
-- Procedure: dt_whocheckedout_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
create proc dbo.dt_whocheckedout_u
        @chObjectType  char(4),
        @vchObjectName nvarchar(255),
        @vchLoginName  nvarchar(255),
        @vchPassword   nvarchar(255)

as

set nocount on

declare @iReturn int
declare @iObjectId int
select @iObjectId =0

declare @VSSGUID nvarchar(100)
select @VSSGUID = N'SQLVersionControl.VCS_SQL'

    declare @iPropertyObjectId int

    select @iPropertyObjectId = (select objectid from dbo.dtproperties where property = 'VCSProjectID')

    declare @vchProjectName   nvarchar(255)
    declare @vchSourceSafeINI nvarchar(255)
    declare @vchServerName    nvarchar(255)
    declare @vchDatabaseName  nvarchar(255)
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSProject',       @vchProjectName   OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSourceSafeINI', @vchSourceSafeINI OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLServer',     @vchServerName    OUT
    exec dbo.dt_getpropertiesbyid_vcs_u @iPropertyObjectId, 'VCSSQLDatabase',   @vchDatabaseName  OUT

    if @chObjectType = 'PROC'
    begin
        exec @iReturn = sp_OACreate @VSSGUID, @iObjectId OUT

        if @iReturn <> 0 GOTO E_OAError

        declare @vchReturnValue nvarchar(255)
        select @vchReturnValue = ''

        exec @iReturn = sp_OAMethod @iObjectId,
                                    N'WhoCheckedOut',
                                    @vchReturnValue OUT,
                                    @sProjectName = @vchProjectName,
                                    @sSourceSafeINI = @vchSourceSafeINI,
                                    @sObjectName = @vchObjectName,
                                    @sServerName = @vchServerName,
                                    @sDatabaseName = @vchDatabaseName,
                                    @sLoginName = @vchLoginName,
                                    @sPassword = @vchPassword

        if @iReturn <> 0 GOTO E_OAError

        select @vchReturnValue

    end

CleanUp:
    return

E_OAError:
    exec dbo.dt_displayoaerror_u @iObjectId, @iReturn
    GOTO CleanUp




GO

-- =============================================
-- Procedure: KNIGHTS_LOAD_MEMBERSDATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_LOAD_MEMBERSDATA]
AS

-----------------------------------------------------------------------------------------------------------------
SELECT sClanID,strUserID,nDonatedNP,strMemo,Fame,sClass,[Level],lastlogin,Loyalty FROM USER_KNIGHTDATA WHERE sClanID > 0
-----------------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_JOIN
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_JOIN]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @bMembers tinyint,@bUserMembers tinyint,@bCount tinyint
	  SELECT @bMembers = Members FROM KNIGHTS WHERE IDNum = @sClanID
	    SELECT @bUserMembers = COUNT(*) FROM USERDATA WHERE Knights = @sClanID	
	      IF (@bMembers >= 50 OR @bUserMembers >= 50)
	        RETURN 8
	SELECT @bCount = COUNT(*) FROM USERDATA WHERE strUserID = @strCharID
	  IF (@bCount = 0)
	    RETURN 2
	BEGIN TRAN
	  BEGIN
	    UPDATE KNIGHTS SET Members += 1 WHERE IDNum = @sClanID
	      UPDATE USERDATA SET Knights = @sClanID WHERE strUserID = @strCharID
		   UPDATE USER_KNIGHTDATA SET sClanID = @sClanID WHERE strUserID = @strCharID
	        END
	IF (@@ERROR <> 0)
	  BEGIN	 
	    ROLLBACK TRAN
	      RETURN 2
	        END
	          COMMIT TRAN
	            RETURN 0
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_OLD_ITEM_PASSWD
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_OLD_ITEM_PASSWD]
@strAccountID varchar(21)
AS

BEGIN
  SELECT strSealPasswd FROM TB_USER WHERE strAccountID = @strAccountID
END

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_REMOVE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_REMOVE]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @ClanNumber tinyint,@strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @ClanNumber = Members, @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	BEGIN
	  UPDATE USERDATA SET Knights = 0 WHERE strUserID = @strCharID
	  UPDATE USER_KNIGHTDATA SET sClanID = 0, strMemo = '' WHERE strUserID = @strCharID
	    END
	IF (@ClanNumber <= 1)
	  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @sClanID
	    ELSE
	      UPDATE KNIGHTS SET Members -= 1 WHERE IDNum = @sClanID
	IF (@strViceChief1 = @strCharID)
	  BEGIN
	    UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	      END
	        ELSE IF (@strViceChief2 = @strCharID)
	          BEGIN
	            UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	              END
	                ELSE IF (@strViceChief3 = @strCharID)
	                  BEGIN
	                    UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                      END
	BEGIN
	  DELETE FROM [EN.KOHSTR_KO_MAIN_LOG].dbo.KOHSTR_DONATED_NP_LOG WHERE UserID = @strCharID
	    END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_QUEST_OPEN_SKILL
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 07.11.2018
-- Update date: 07.11.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_QUEST_OPEN_SKILL]
AS

BEGIN
	SELECT * FROM QUEST_SKILLS_OPEN_SET_UP
END


GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_LEAVE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.12.2017
-- Update date: 28.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_LEAVE]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @ClanNumber tinyint,@strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @ClanNumber = Members, @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	BEGIN
	  UPDATE USERDATA SET Knights = 0 WHERE strUserID = @strCharID
	  UPDATE USER_KNIGHTDATA SET sClanID = 0, strMemo = '' WHERE strUserID = @strCharID
	    END
	IF (@ClanNumber <= 1)
	  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @sClanID
	    ELSE
	      UPDATE KNIGHTS SET Members -= 1 WHERE IDNum = @sClanID
	IF (@strViceChief1 = @strCharID)
	  BEGIN
	    UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	      END
	        ELSE IF (@strViceChief2 = @strCharID)
	          BEGIN
	            UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	              END
	                ELSE IF (@strViceChief3 = @strCharID)
	                  BEGIN
	                    UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                      END
	BEGIN
	 DELETE FROM [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG WHERE UserID = @strCharID
	    END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_ADMIT
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
--
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_ADMIT]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE USERDATA SET Fame = 3 WHERE strUserID = @strCharID AND Knights = @sClanID
	UPDATE USER_KNIGHTDATA SET Fame = 3 WHERE strUserID = @strCharID AND sClanID = @sClanID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_REJECT
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
--
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_REJECT]
@strCharID char(21),
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_CHIEF
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
--
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_CHIEF]
@strCharID char(21),
@sClanID smallint
AS

DECLARE @strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @strViceChief1 = ViceChief_1,@strViceChief2 = ViceChief_2,@strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	    UPDATE KNIGHTS SET Chief = @strCharID WHERE IDNum = @sClanID
	      IF (@strViceChief1 = @strCharID)
	        BEGIN
	          UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	            END
	              IF (@strViceChief2 = @strCharID)
	                BEGIN
	                  UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	                    END
	                      IF (@strViceChief3 = @strCharID)
	                        BEGIN
	                          UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                            END
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE USERDATA SET Fame = 1 WHERE strUserID = @strCharID AND Knights = @sClanID
	UPDATE USER_KNIGHTDATA SET Fame = 1 WHERE strUserID = @strCharID AND sClanID = @sClanID
END
-------------------------------------------------------------------------------------------------------
RETURN 1
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_VICECHIEF
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_VICECHIEF]
@strCharID char(21),
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------
	DECLARE @strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	    IF (@strViceChief1 IS NOT NULL AND @strViceChief2 IS NOT NULL AND @strViceChief3 IS NOT NULL)
	        RETURN 8
 
	IF (@strViceChief1 IS NULL)
	  BEGIN
	    UPDATE KNIGHTS SET ViceChief_1 = @strCharID WHERE IDNum = @sClanID
	      END
	        ELSE IF (@strViceChief2 IS NULL)
	          BEGIN
	            UPDATE KNIGHTS SET ViceChief_2 = @strCharID WHERE IDNum = @sClanID
	              END
	                ELSE IF (@strViceChief3 IS NULL)
	                  BEGIN
	                    UPDATE KNIGHTS SET ViceChief_3 = @strCharID WHERE IDNum = @sClanID
	                      END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_OFFICER
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
--
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_OFFICER]
@strCharID char(21),
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE USERDATA SET Fame = 4 WHERE strUserID = @strCharID AND Knights = @sClanID
	UPDATE USER_KNIGHTDATA SET Fame = 4 WHERE strUserID = @strCharID AND sClanID = @sClanID
END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: SAVE_PREMIUM_SERVICE_CLAN
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		YNG
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[SAVE_PREMIUM_SERVICE_CLAN]
@sClanID smallint,
@sPremiumInUse tinyint,
@sPremiumTime int
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE KNIGHTS SET sPremiumInUse = @sPremiumInUse, sPremiumTime = @sPremiumTime WHERE IDNum = @sClanID
END
-------------------------------------------------------------------------------------------------------

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_PUNISH
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_PUNISH]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @ClanNumber tinyint,@strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @ClanNumber = Members, @strViceChief1 = ViceChief_1, @strViceChief2 = ViceChief_2, @strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	BEGIN
	  UPDATE USERDATA SET Knights = 0 WHERE strUserID = @strCharID
	  UPDATE USER_KNIGHTDATA SET sClanID = 0, strMemo ='' WHERE strUserID = @strCharID
	    END
	IF (@ClanNumber <= 1)
	  UPDATE KNIGHTS SET Members = 1 WHERE IDNum = @sClanID
	    ELSE
	      UPDATE KNIGHTS SET Members -= 1 WHERE IDNum = @sClanID
	IF (@strViceChief1 = @strCharID)
	  BEGIN
	    UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	      END
	        ELSE IF (@strViceChief2 = @strCharID)
	          BEGIN
	            UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	              END
	                ELSE IF (@strViceChief3 = @strCharID)
	                  BEGIN
	                    UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                      END
	BEGIN
	  DELETE FROM [EN.KOHSTR_KO_MAIN_LOG].dbo.KOHSTR_DONATED_NP_LOG WHERE UserID = @strCharID
	    END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_POINT_METHOD_CHANGE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_POINT_METHOD_CHANGE]
@sClanID smallint,
@bDomination tinyint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET ClanPointMethod = @bDomination WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: CHARACTER_SELECT_NAME_CHANGE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2017
-- Update date: 15.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[CHARACTER_SELECT_NAME_CHANGE]
@AccountID char(21),
@OldCharID char(21),
@NewCharID char(21)
AS

DECLARE @AlreadyCharName int

BEGIN TRAN
IF (dbo.IsValidCharacters(@NewCharID) = 1)
	RETURN 0

SELECT @AlreadyCharName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @NewCharID
IF(@AlreadyCharName != 0)
	RETURN 0

SELECT @AlreadyCharName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @NewCharID
IF(@AlreadyCharName = 0)
BEGIN
	UPDATE ACCOUNT_CHAR SET strCharID1 = @NewCharID WHERE strCharID1 = @OldCharID AND strCharID1 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID2 = @NewCharID WHERE strCharID2 = @OldCharID AND strCharID2 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID3 = @NewCharID WHERE strCharID3 = @OldCharID AND strCharID3 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID4 = @NewCharID WHERE strCharID4 = @OldCharID AND strCharID4 IS NOT NULL
	UPDATE USERDATA SET strUserId = @NewCharID WHERE strUserId = @OldCharID AND strUserId IS NOT NULL
	UPDATE KNIGHTS SET Chief = @NewCharID WHERE Chief = @OldCharID AND Chief IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_1 = @NewCharID WHERE ViceChief_1 = @OldCharID AND ViceChief_1 IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_2 = @NewCharID WHERE ViceChief_2 = @OldCharID AND ViceChief_2 IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_3 = @NewCharID WHERE ViceChief_3 = @OldCharID AND ViceChief_3 IS NOT NULL
	UPDATE FRIEND_LIST SET strUserID = @NewCharID where strUserID = @OldCharID
	UPDATE RENTAL_ITEM SET strLenderCharID = @NewCharID WHERE strLenderCharID = @OldCharID AND strLenderCharID IS NOT NULL
	UPDATE RENTAL_ITEM SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE RENTAL_ITEM_LIST SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @OldCharID
	UPDATE CURRENTUSER SET strCharID = @NewCharID WHERE strAccountID = @AccountID AND strCharID = @OldCharID
	UPDATE USERDATA_SKILLSHORTCUT SET strCharID = @NewCharID WHERE strCharID = @OldCharID AND strCharID IS NOT NULL
	UPDATE BATTLE SET strUserName = @NewCharID WHERE strUserName = @OldCharID AND strUserName IS NOT NULL
	UPDATE USER_DAILY_OP SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE MAIL_BOX SET strSenderID = @NewCharID WHERE strSenderID = @OldCharID AND strSenderID IS NOT NULL
	UPDATE MAIL_BOX SET strRecipientID = @NewCharID WHERE strRecipientID = @OldCharID AND strRecipientID IS NOT NULL
	UPDATE USER_ACHIEVE_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE RENTAL_ITEM SET strLenderCharID = @NewCharID WHERE strLenderCharID = @OldCharID AND strLenderCharID IS NOT NULL
	UPDATE RENTAL_ITEM SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE RENTAL_ITEM_LIST SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE SEALED_ITEMS SET strUserID = @NewCharID WHERE strUserID = @OldCharID  AND strUserID IS NOT NULL
	UPDATE USER_SEAL_EXP SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE USER_DRAKI_TOWER_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE DRAKI_TOWER_RIFT_RANK SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE WEB_ITEMMALL SET strCharID = @NewCharID WHERE strAccountID = @AccountID AND strCharID = @OldCharID
	UPDATE USER_GENIE_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE SHERIFF_REPORTS SET ReportedName = @NewCharID WHERE ReportedName = @OldCharID AND ReportedName IS NOT NULL
	UPDATE SHERIFF_REPORTS SET ReportedSheriffName = @NewCharID WHERE ReportedSheriffName = @OldCharID AND ReportedSheriffName IS NOT NULL
	UPDATE USER_RENTAL_ITEM SET strUserID = @NewCharID WHERE strAccountID = @AccountID AND strUserID = @OldCharID
	UPDATE USER_KNIGHTDATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sBaseClanCommander = @NewCharID WHERE sBaseClanCommander = @OldCharID AND sBaseClanCommander IS NOT NULL
	UPDATE KNIGHTS_SIEGE_WARFARE_REGISTER SET sBaseClanCommander = @NewCharID WHERE sBaseClanCommander = @OldCharID AND sBaseClanCommander IS NOT NULL
	UPDATE USER_RETURN_DATA SET strCharID = @NewCharID WHERE strCharID = @OldCharID AND strCharID IS NOT NULL
	UPDATE USER_QUEST_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.NAME_CHANGE_LOG (AccountID, OldCharID, NewCharID, LogTime) VALUES (@AccountID, @OldCharID, @NewCharID, GETDATE())
END
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 0
	END
COMMIT TRAN

RETURN 1

GO

-- =============================================
-- Procedure: KNIGHTS_DESTROY
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		YNG
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_DESTROY]
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @bCount tinyint
	  SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID
	    IF (@bCount = 0)
	      RETURN 7
	        BEGIN TRAN
	          DELETE FROM KNIGHTS WHERE IDNum = @sClanID
	            DELETE FROM KNIGHTS_ALLIANCE WHERE sMainAllianceKnights = @sClanID
	              UPDATE KNIGHTS SET sAllianceKnights = 0 WHERE IDNum = @sClanID
	                UPDATE KNIGHTS_ALLIANCE SET sSubAllianceKnights = 0 WHERE sSubAllianceKnights = @sClanID
	                  UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_1 = 0 WHERE sMercenaryClan_1 = @sClanID
	                    UPDATE KNIGHTS_ALLIANCE SET sMercenaryClan_2 = 0 WHERE sMercenaryClan_2 = @sClanID
						  UPDATE USERDATA SET Knights = 0, Fame = 0 WHERE Knights = @sClanID
						   UPDATE USER_KNIGHTDATA SET sClanID = 0,Fame = 0,strMemo='' WHERE sClanID = @sClanID
						     DELETE FROM KNIGHTS_CASTELLAN WHERE IDNum = @sClanID
	IF (@@ERROR <> 0)
	  BEGIN
	    ROLLBACK TRAN
	      RETURN 7
	        END
	  COMMIT TRAN
	    RETURN 0
-------------------------------------------------------------------------------------------------------
--YNG

GO

-- =============================================
-- Procedure: ITEMLERI_BUL
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE procedure [dbo].[ITEMLERI_BUL] 
@StrUserID varchar(30)
AS
DECLARE
@length int, -- stritem uzunluðu
@i int, -- item'in stritem deki yeri
@dwid int, 
@dur int,
@duar int,
@StackSize1 int,
@Sira int,
@Row int,
@name varchar(100),
@extname varchar(100),
@ext int


    set @i = 14*0+1
    set @length = 601--401

select @row=count(*) from userdata where 
struserid=@StrUserID

delete from itemler where struserid=@StrUserID

if @row>0 
  begin

WHILE @i < @length
Begin

Select 
@dwid=cast(cast(substring(cast(substring(strItem, 
@i,4) as varbinary(4)), 4, 
1)+substring(cast(substring(strItem, @i,4) as 
varbinary(4)), 3, 1)+substring(cast(substring(strItem, 
@i,4) as 
varbinary(4)), 2, 1)+substring(cast(substring(strItem, 
@i,4) as varbinary(4)), 1, 1) as varbinary(4)) as varbinary(4)),
@dur = cast(cast(cast( substring(strItem, @i+5, 1) as 
varbinary(1))+cast(substring(strItem, @i+4, 1) as 
varbinary(1)) as varbinary(2)) as smallint),
@StackSize1 = cast(cast(cast( substring(strItem, 
@i+7, 1) as varbinary(1))+cast(substring(strItem, 
@i+6, 1) as 
varbinary(1)) as varbinary(2)) as smallint),
        @StrUserID = strUserID
        From UserData
        Where strUserID = @StrUserID



if @dwid is null
  set @dwid=0
if @stacksize1 is null
  set @stacksize1=0
if @dur is null
 set @dur=0

insert into itemler 
(dwid,stacksize,durability,struserid,sira,itembasicname
,extname) 
values(@dwid,@stacksize1,@dur,@StrUserID,(@i-1) 
/ 8,@extname,@name )

set @i=@i+8

end
end


GO

-- =============================================
-- Procedure: KNIGHTS_UPDATE_MARK
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_MARK]
@sClanID smallint,
@clanSymbol binary(2400),
@sSymbolSize smallint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET Mark = @clanSymbol,sMarkLen = @sSymbolSize,sMarkVersion +=1 WHERE IDNum = @sClanID
	END

	RETURN 0
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_UPDATE_CAPE
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_CAPE]
@sClanID smallint,
@sCapeID smallint,
@r tinyint,
@g tinyint,
@b tinyint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS Set sCape= @sCapeID, bCapeR = @r, bCapeG = @g, bCapeB = @b Where IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_HANDOVER
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_HANDOVER]
@strCharID char(21),
@sClanID smallint
AS
-------------------------------------------------------------------------------------------------------
	DECLARE @strViceChief1 char(21),@strViceChief2 char(21),@strViceChief3 char(21)
	  SELECT @strViceChief1 = ViceChief_1,@strViceChief2 = ViceChief_2,@strViceChief3 = ViceChief_3 FROM KNIGHTS WHERE IDNum = @sClanID
	    UPDATE KNIGHTS SET Chief = @strCharID WHERE IDNum = @sClanID
	      IF (@strViceChief1 = @strCharID)
	        BEGIN
	          UPDATE KNIGHTS SET ViceChief_1 = NULL WHERE IDNum = @sClanID
	            END
	              IF (@strViceChief2 = @strCharID)
	                BEGIN
	                  UPDATE KNIGHTS SET ViceChief_2 = NULL WHERE IDNum = @sClanID
	                    END
	                      IF (@strViceChief3 = @strCharID)
	                        BEGIN
	                          UPDATE KNIGHTS SET ViceChief_3 = NULL WHERE IDNum = @sClanID
	                            END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_SIEGE_RANK
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 30.07.2018
-- Update date: 30.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_SIEGE_RANK]
AS

BEGIN
	SELECT TOP(30) KNIGHTS_SIEGE_WARFARE_RANK.sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount,KNIGHTS.IDName,sMarkVersion,IDNum FROM KNIGHTS_SIEGE_WARFARE_RANK INNER JOIN KNIGHTS ON KNIGHTS.IDNum = KNIGHTS_SIEGE_WARFARE_RANK.sBaseClanNum
END


GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_BARRACK_INSERT
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_BARRACK_INSERT]
@Type tinyint,
@ClanID smallint,
@X int,
@Z int
AS

DECLARE @Sign tinyint

IF (@Type = 1)
BEGIN

SELECT @Sign = count(*) FROM KNIGHTS_SIEGE_WARFARE_BARRACK WHERE BaseClanID = @ClanID

IF (@Sign > 0)
	RETURN 2

INSERT INTO KNIGHTS_SIEGE_WARFARE_BARRACK(BaseClanID, BasePosX, BasePosZ) VALUES (@ClanID, @X, @Z)
END

IF (@Type = 2)
BEGIN
	DELETE KNIGHTS_SIEGE_WARFARE_BARRACK WHERE BaseClanID = @ClanID
END

IF (@Type = 3)
BEGIN
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sWarClanBaseRemainCount = 1 WHERE sBaseClanNum = @ClanID
END

RETURN 1


GO

-- =============================================
-- Procedure: KNIGHTS_UPDATE_GRADE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_GRADE]
@sClanID smallint,
@sCapeID smallint,
@byFlag tinyint
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET Flag = @byFlag,sCape = @sCapeID WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_BARRACK_RESET
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_BARRACK_RESET]
AS

TRUNCATE TABLE KNIGHTS_SIEGE_WARFARE_BARRACK


GO

-- =============================================
-- Procedure: KNIGHTS_UPDATE_CLANNOTICE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_CLANNOTICE]
@sClanID smallint,
@strClanNotice varchar(128)
AS
-------------------------------------------------------------------------------------------------------
BEGIN
	UPDATE KNIGHTS SET strClanNotice = @strClanNotice WHERE IDNum = @sClanID
END

-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_UPDATE_FUND
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_FUND]
@sClanID smallint,
@nClanPointFund int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET ClanPointFund = @nClanPointFund WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KNIGHTS_UPDATE_USERMEMO
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_UPDATE_USERMEMO]
@strUserID char(21),
@strMemo char(20)
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE USER_KNIGHTDATA SET strMemo = @strMemo WHERE strUserID = @strUserID
	END

	RETURN 1
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: KING_UPDATE_DATABASE
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROC [dbo].[KING_UPDATE_DATABASE]
@byNation           tinyint,
@nNationalTreasury  int,
@KingTax	        int
AS

   UPDATE KING_SYSTEM SET nNationalTreasury = @nNationalTreasury,nTerritoryTax = @KingTax WHERE byNation = @byNation

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_DONATE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 26.12.2017
-- Update date: 29.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_DONATE]
@strUserID char(21),
@sClanID smallint,
@amountNP int,
@UserAmountNP int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
	  UPDATE KNIGHTS SET ClanPointFund = @amountNP WHERE IDNum = @sClanID
	    UPDATE USERDATA SET nDonatedNP += @UserAmountNP WHERE strUserID = @strUserID AND Knights = @sClanID
		 UPDATE USER_KNIGHTDATA SET nDonatedNP += @UserAmountNP WHERE strUserID = @strUserID AND sClanID = @sClanID
	      END
	DECLARE @Count tinyint
	  SELECT @Count = COUNT(UserID) FROM [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG WHERE UserID = @strUserID
	    IF (@Count > 0)
	      BEGIN
	        UPDATE [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG SET DonatedNP += @UserAmountNP WHERE UserID = @strUserID
	          END
	            ELSE
	              BEGIN
	                INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.DONATED_NP_LOG VALUES (@strUserID, @sClanID, @amountNP)
	                  END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_MONSTER_DROP_MAIN
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 27.2.2020
-- Update date: 27.2.2020
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_MONSTER_DROP_MAIN]
AS
-------------------------------------------------------------------------------------------------------
SELECT MonsterID,
MonsterOpenDrop,
MonsterMoney,
ItemListID1,
ItemListPersent1,
ItemListID2,
ItemListPersent2,
ItemListID3,
ItemListPersent3,
ItemListID4,
ItemListPersent4,
ItemListID5,
ItemListPersent5,
ItemListID6,
ItemListPersent6,
ItemListID7,
ItemListPersent7,
ItemSingleID1,
ItemSinglePersent1,
ItemSingleID2,
ItemSinglePersent2,
ItemSingleID3,
ItemSinglePersent3,
ItemSingleID4,
ItemSinglePersent4,
ItemSingleID5,
ItemSinglePersent5,
ItemSingleID6,
ItemSinglePersent6,
ItemSingleID7,
ItemSinglePersent7 FROM [KO_DATABASE_SERVER_001_DROP].dbo.MONSTER_DROP_MAIN
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: KNIGHTS_LOAD_MEMBERS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_LOAD_MEMBERS]
@sClanID smallint
AS

-------------------------------------------------------------------------------------------------------
SELECT strUserID, fame, [Level], sClass FROM USER_KNIGHTDATA WHERE sClanID = @sClanID
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: LOAD_MONSTER_ITEM_GROUP_ITEM_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 27.2.2020
-- Update date: 27.2.2020
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_MONSTER_ITEM_GROUP_ITEM_LIST]
AS

-------------------------------------------------------------------------------------------------------
SELECT* FROM [KO_DATABASE_SERVER_001_DROP].dbo.MONSTER_GROUP_ITEM_LIST
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: LOAD_USER_QUEST_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.12.2018
-- Update date: 08.12.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_USER_QUEST_DATA]
@strCharID varchar(21)
AS

BEGIN
	SELECT sQuestCount,strQuest FROM USER_QUEST_DATA WHERE strUserID = @strCharID
END

GO

-- =============================================
-- Procedure: KNIGHTS_SAVE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		YNG
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_SAVE]
@sClanID smallint,
@bFlag tinyint,
@nClanFund int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS SET Flag = @bFlag,ClanPointFund = @nClanFund WHERE IDNum = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--YNG

GO

-- =============================================
-- Procedure: UPDATE_USER_QUEST_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.12.2018
-- Update date: 08.12.2018
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_USER_QUEST_DATA]
@strCharID char(21),
@strQuest binary(3888),
@sQuestCount smallint
AS

BEGIN
	UPDATE USER_QUEST_DATA SET sQuestCount = @sQuestCount, strQuest = @strQuest WHERE strUserID = @strCharID
END

GO

-- =============================================
-- Procedure: KNIGHTS_MEMBER_REFUNDNP
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_MEMBER_REFUNDNP]
@strUserID char(21),
@nRefundNP int
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE USERDATA SET Loyalty += @nRefundNP WHERE strUserID = @strUserID
		UPDATE USER_KNIGHTDATA SET loyalty += @nRefundNP WHERE strUserID = @strUserID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: CREATE_NEW_DRAKI_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================


CREATE PROCEDURE [dbo].[CREATE_NEW_DRAKI_DATA]
@strCharID char(21),
@Class tinyint
AS

DECLARE @CharCount tinyint,@ClassName varchar(20)
SELECT @CharCount = COUNT(strUserID) FROM USER_DRAKI_TOWER_DATA WHERE strUserID = @strCharID

IF (@Class = 1)
	SET @ClassName = 'Warrior'
ELSE IF (@Class = 2)
	SET @ClassName = 'Rogue'
ELSE IF (@Class = 3)
	SET @ClassName = 'Mage'
ELSE IF (@Class = 4)
	SET @ClassName = 'Priest'
ELSE IF (@Class = 13)
	SET @ClassName = 'Kurian'

IF (@CharCount = 0)
BEGIN
	INSERT INTO USER_DRAKI_TOWER_DATA (strUserID,Class,ClassName,iDrakiTime,bDrakiStage,bDrakiEnteranceLimit) VALUES (@strCharID,@Class,@ClassName,3600,1,3)
END

RETURN 1

GO

-- =============================================
-- Procedure: GAME_START_CLEAR_REMAIN_USERS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.05.2019
-- Update date: 28.05.2019
-- =============================================
CREATE PROCEDURE [dbo].[GAME_START_CLEAR_REMAIN_USERS]
AS

BEGIN
  TRUNCATE TABLE CURRENTUSER
END

GO

-- =============================================
-- Procedure: UPDATE_SHERIFF_REPORTS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_SHERIFF_REPORTS]
@Type tinyint,
@strCharID varchar(21),
@Yes tinyint,
@No tinyint,
@Sheriff varchar(21)
AS

   DECLARE @EvetA varchar(21), @EvetB varchar(21), @NoA varchar(21), @NoB varchar(21), @NoC varchar(21)
      IF (@Type = 1)
         BEGIN
            SELECT @EvetA = SheriffYesB, @EvetB = SheriffYesC FROM SHERIFF_REPORTS WHERE ReportedName = @strCharID	
               IF(@EvetA IS NULL)
                  UPDATE SHERIFF_REPORTS SET Yes = @Yes, SheriffYesB = @Sheriff WHERE ReportedName = @strCharID
                     ELSE IF(@EvetB IS NULL)
                        UPDATE SHERIFF_REPORTS SET Yes = @Yes, SheriffYesC = @Sheriff WHERE ReportedName = @strCharID
                           END
   ELSE IF (@Type = 2)
      BEGIN 
         SELECT @NoA = SheriffNoA, @NoB = SheriffNoB, @NoC = SheriffNoC FROM SHERIFF_REPORTS WHERE ReportedName = @strCharID
            IF(@NoA IS NULL)
               UPDATE SHERIFF_REPORTS SET [No] = @No, SheriffNoA = @Sheriff WHERE ReportedName = @strCharID
                  ELSE IF(@NoB IS NULL)
                     UPDATE SHERIFF_REPORTS SET [No] = @No, SheriffNoB = @Sheriff WHERE ReportedName = @strCharID
                        ELSE IF(@NoC IS NULL)
                           UPDATE SHERIFF_REPORTS SET [No] = @No, SheriffNoC = @Sheriff WHERE ReportedName = @strCharID
                              END
IF (@yes > 2 or @No >= 2)
BEGIN
      DELETE FROM SHERIFF_REPORTS WHERE ReportedName = @strCharID
END


GO

-- =============================================
-- Procedure: INSERT_K_MONSTER_ITEM_IS_NULL_NPC
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_K_MONSTER_ITEM_IS_NULL_NPC]AS

DECLARE @NpcSsid smallint

DECLARE @Count2 smallint
SET @Count2 = 0

DECLARE Backup_Cursor2 CURSOR
	FOR
	SELECT sSid FROM K_NPC

	OPEN Backup_Cursor2

	FETCH NEXT FROM Backup_Cursor2 INTO @NpcSsid

WHILE @@FETCH_STATUS = 0
BEGIN
	select @Count2 = count(*) from K_MONSTER_ITEM2 where sIndex = @NpcSsid AND isMonster = 0
	IF @Count2 = 0 
	BEGIN
		INSERT INTO K_MONSTER_ITEM2 (sIndex,isMonster,iItem01,sPersent01,iItem02,sPersent02,iItem03,sPersent03,iItem04,sPersent04,iItem05,sPersent05,iItem06,sPersent06,iItem07,sPersent07)
		VALUES (@NpcSsid,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	END
	FETCH NEXT FROM Backup_Cursor2 INTO @NpcSsid
END

CLOSE Backup_Cursor2
DEALLOCATE Backup_Cursor2

GO

-- =============================================
-- Procedure: SHERIF_REPORTS_SAVE
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[SHERIF_REPORTS_SAVE]
@ReportedName varchar(21),
@ReportedSheriff varchar(21),
@Crime varchar(128),
@Yes tinyint,
@SherifYesA varchar(21),
@No tinyint,
@ReportDateTime varchar(128)
AS

--DECLARE @ReportedCount smallint
--SELECT @ReportedCount = COUNT(*) FROM SHERIFF_REPORTS WHERE ReportedName = @ReportedName
--IF (@ReportedName <= 0)
BEGIN
   INSERT INTO SHERIFF_REPORTS (ReportedName, ReportedSheriffName, Crime, [Yes], SheriffYesA, [No], ReportDateTime) VALUES (@ReportedName, @ReportedSheriff, @Crime, @Yes, @SherifYesA, @No, @ReportDateTime)
END

GO

-- =============================================
-- Procedure: UPDATE_BATTLE_RESULT
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_BATTLE_RESULT]
@strUserID  varchar(30),
@byNation tinyint,
@index  smallint
AS

   IF @byNation = 1
     BEGIN
       UPDATE BATTLE SET byNation = @byNation, strUserName = @strUserID WHERE sIndex = 1
         END
           ELSE IF @byNation = 2
             BEGIN
               UPDATE BATTLE SET byNation = @byNation, strUserName = @strUserID WHERE sIndex = 1
                 END


GO

-- =============================================
-- Procedure: LOAD_RENTAL_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_RENTAL_DATA]
@strAccountID	char(21)
AS




DECLARE @CurrentTime smalldatetime
SET @CurrentTime = getdate()

SELECT 
	strUserID, 
	byRentalType, 
	byRegType, 
	nRentalIndex,
	nItemIndex, 
	sDurability, 
	nSerialNumber, 
	nRentalMoney, 
	sRentalTime, 
	sDuringTime=datediff( n, timeRental, @CurrentTime ), 
	timeRental FROM USER_RENTAL_ITEM WHERE strAccountID = @strAccountID

DELETE FROM USER_RENTAL_ITEM WHERE strAccountID = @strAccountID and (byRentalType=2 or byRentalType=3) and sRentalTime< datediff( n, timeRental, @CurrentTime ) 

UPDATE USER_RENTAL_ITEM SET nRentalMoney = 0 WHERE strAccountID = @strAccountID and byRentalType=2 and nRentalMoney>0

GO

-- =============================================
-- Procedure: GAME_LOGIN_V2
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 12.1.2018
-- Notes :
/* Return values: 
-1 Successfully connected to %s server but failed logging into the game. (%d)
0 Nation select
1 Nation Karus
2 Nation El Morad
4 Server is undergoing maintenance. Please try again later.
17 Error OTP
18 Access Restricted This server is open for NTTGame users who are registered for ICS.
20 Your current region is not able to login to this server. Please try other servers. Thank you.
21 Due to high volume, only premium players may log in at the moment. Please try later or purchase premium from the website to continue playing!
22 Invalid security code. Please try again.
23 empty dialog
30 Error has been occurred during nation transfer Please contact customer service ERRORCODE = 0x01 Irk Human ve Karus Değil.
31 Error has been occurred during nation transfer Please contact customer service ERRORCODE = 0x02 Karakterler Arası ırk uyumsuzluğu
32 Error has been occurred during nation transfer Please contact customer service ERRORCODE = 0x03 Böyle bir ırk race class yok.
255 Successfully connected to %s server but failed logging into the game. (%d)
*/
-- =============================================
CREATE PROCEDURE [dbo].[GAME_LOGIN_V2]
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

    DECLARE @bNation tinyint
         DECLARE @strHashPassword varchar(28)
              DECLARE @strAuthority tinyint
                   DECLARE @Premium smallint
    SELECT @strHashPassword = strPasswd, @strAuthority = strAuthority FROM TB_USER WHERE strAccountID = @strAccountID
             IF (@@ROWCOUNT = 0 OR @strHashPassword != @strPasswd OR @strAuthority = 9)
                     RETURN -1
    DECLARE @FreeLimit smallint, @TotalUser smallint
           DECLARE @ServerIPAddress varchar(15) 
                 DECLARE @MaintenanceMode tinyint
                       DECLARE @AccountID smallint
                              DECLARE @GmLoginID smallint
    SELECT @FreeLimit = FreeLimit, @TotalUser = TotalUserLimit, @ServerIPAddress = ServerIPAddress, @MaintenanceMode = MaintenanceMode FROM [KO_DATABASE_MAIN].dbo.GAME_OPTIONS
        IF (@MaintenanceMode = 1 AND @strAuthority != 0)
             BEGIN
                  SELECT @AccountID = COUNT(GmLoginID) FROM [KO_DATABASE_MAIN].dbo.GM_MAINTENANCE_LOGIN WHERE GmLoginID = @strAccountID  
                           IF (@AccountID = 0)
                                   BEGIN
                                       RETURN 4
                                          END
                                             END
    DECLARE @TotalUserCount smallint
         SELECT @TotalUserCount = COUNT(strServerIP) FROM CURRENTUSER WHERE strServerIP = @ServerIPAddress
			SELECT @Premium = sPremiumCount FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
                IF (@Premium = 0 AND @TotalUserCount >= @FreeLimit)
                      RETURN 21
				IF (@TotalUserCount >= @TotalUser)
					  RETURN 21

DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20),@CharID4 varchar(20)
DECLARE @AccountNation tinyint, @CharNum tinyint
DECLARE @Nation tinyint, @Class smallint, @Race tinyint

SELECT @AccountNation = bNation, @CharNum = bCharNum, @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''),@CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@AccountNation != 1 AND @AccountNation != 2)
	RETURN 30

DECLARE @ValidCharacters tinyint

IF (@CharID1 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID1

	IF (@Nation != @AccountNation)
		RETURN 31
	
	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID2 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID2

	IF (@Nation != @AccountNation)
		RETURN 31
	
	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID3 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID3

	IF (@Nation != @AccountNation)
		RETURN 31

	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID4 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID4

	IF (@Nation != @AccountNation)
		RETURN 31

	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

RETURN @AccountNation

GO

-- =============================================
-- Procedure: UPDATE_DRAKI_TOWER_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 7.06.2019
-- Update date: 7.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_DRAKI_TOWER_DATA]
@strCharID char(21),
@DrakiTime int,
@DrakiStage tinyint
AS

DECLARE @tempStage tinyint, @tempTime int

DECLARE @FinalStage tinyint = 41

SELECT @TempTime = iDrakiTime, @TempStage = bDrakiStage  FROM USER_DRAKI_TOWER_DATA where strUserID = @strCharID

/*IF (@DrakiStage >= @TempStage AND @DrakiTime <= @TempTime/* AND @DrakiStage != @FinalStage*/)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END

IF (@DrakiTime <= @TempTime AND @DrakiStage = @FinalStage)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END*/

IF (@DrakiStage > @TempStage AND @DrakiStage != @FinalStage)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END
ELSE IF (@DrakiStage = @TempStage AND @DrakiTime <= @TempTime AND @DrakiStage != @FinalStage)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END
ELSE IF (@DrakiStage >= @TempStage AND @DrakiTime <= @TempTime)
BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET iDrakiTime = @DrakiTime, bDrakiStage = @DrakiStage where strUserID = @strCharID
	EXEC UPDATE_DRAKI_RANK
END

GO

-- =============================================
-- Procedure: LOAD_DRAKI_RANK
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[LOAD_DRAKI_RANK]
AS

BEGIN
	SELECT top(5)sIndex,Class,RankID, strUserID, bStage, FinishTime FROM DRAKI_TOWER_RIFT_RANK
END

GO

-- =============================================
-- Procedure: UPDATE_DRAKI_RANK
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 10.06.2019
-- Update date: 10.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_DRAKI_RANK]
AS

DECLARE @tempStage tinyint, @tempTime int, @tempUserID char(21),@tempClassID int
DECLARE @nWarriorRank int = 1,@nRogueRank int = 1,@nMageRank int = 1,@nPriestRank int = 1,@nKurianRank int = 1, @nIndex int = 1

TRUNCATE TABLE DRAKI_TOWER_RIFT_RANK

DECLARE WarriorDrakiRank CURSOR FOR
SELECT Class,strUserID, iDrakiTime, bDrakiStage FROM USER_DRAKI_TOWER_DATA WHERE Class = 1 ORDER BY bDrakiStage DESC, iDrakiTime ASC

OPEN WarriorDrakiRank

FETCH NEXT FROM WarriorDrakiRank INTO @tempClassID, @tempUserID, @tempTime, @tempStage
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT DRAKI_TOWER_RIFT_RANK (sIndex,Class,ClassName,RankID, strUserID, bStage, FinishTime) VALUES (@nIndex,@tempClassID,'Warrior', @nWarriorRank, @tempUserID, @tempStage, @tempTime)

	SET @nWarriorRank += 1
	SET @nIndex += 1

FETCH NEXT FROM WarriorDrakiRank INTO @tempClassID,@tempUserID, @tempTime, @tempStage
END

CLOSE WarriorDrakiRank
DEALLOCATE WarriorDrakiRank


DECLARE RogueDrakiRank CURSOR FOR
SELECT Class,strUserID, iDrakiTime, bDrakiStage FROM USER_DRAKI_TOWER_DATA WHERE Class = 2 ORDER BY bDrakiStage DESC, iDrakiTime ASC

OPEN RogueDrakiRank

FETCH NEXT FROM RogueDrakiRank INTO @tempClassID, @tempUserID, @tempTime, @tempStage
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT DRAKI_TOWER_RIFT_RANK (sIndex,Class,ClassName,RankID, strUserID, bStage, FinishTime) VALUES (@nIndex,@tempClassID,'Rogue', @nRogueRank, @tempUserID, @tempStage, @tempTime)

	SET @nRogueRank += 1
	SET @nIndex += 1

FETCH NEXT FROM RogueDrakiRank INTO @tempClassID,@tempUserID, @tempTime, @tempStage
END

CLOSE RogueDrakiRank
DEALLOCATE RogueDrakiRank

DECLARE MageDrakiRank CURSOR FOR
SELECT Class,strUserID, iDrakiTime, bDrakiStage FROM USER_DRAKI_TOWER_DATA WHERE Class = 3 ORDER BY bDrakiStage DESC, iDrakiTime ASC

OPEN MageDrakiRank

FETCH NEXT FROM MageDrakiRank INTO @tempClassID, @tempUserID, @tempTime, @tempStage
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT DRAKI_TOWER_RIFT_RANK (sIndex,Class,ClassName,RankID, strUserID, bStage, FinishTime) VALUES (@nIndex,@tempClassID,'Mage', @nMageRank, @tempUserID, @tempStage, @tempTime)

	SET @nMageRank += 1
	SET @nIndex += 1

FETCH NEXT FROM MageDrakiRank INTO @tempClassID,@tempUserID, @tempTime, @tempStage
END

CLOSE MageDrakiRank
DEALLOCATE MageDrakiRank


DECLARE PriestDrakiRank CURSOR FOR
SELECT Class,strUserID, iDrakiTime, bDrakiStage FROM USER_DRAKI_TOWER_DATA WHERE Class = 4 ORDER BY bDrakiStage DESC, iDrakiTime ASC

OPEN PriestDrakiRank

FETCH NEXT FROM PriestDrakiRank INTO @tempClassID, @tempUserID, @tempTime, @tempStage
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT DRAKI_TOWER_RIFT_RANK (sIndex,Class,ClassName,RankID, strUserID, bStage, FinishTime) VALUES (@nIndex,@tempClassID,'Priest', @nPriestRank, @tempUserID, @tempStage, @tempTime)

	SET @nPriestRank += 1
	SET @nIndex += 1

FETCH NEXT FROM PriestDrakiRank INTO @tempClassID,@tempUserID, @tempTime, @tempStage
END

CLOSE PriestDrakiRank
DEALLOCATE PriestDrakiRank

DECLARE KurianDrakiRank CURSOR FOR
SELECT Class,strUserID, iDrakiTime, bDrakiStage FROM USER_DRAKI_TOWER_DATA WHERE Class = 13 ORDER BY bDrakiStage DESC, iDrakiTime ASC

OPEN KurianDrakiRank

FETCH NEXT FROM KurianDrakiRank INTO @tempClassID, @tempUserID, @tempTime, @tempStage
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT DRAKI_TOWER_RIFT_RANK (sIndex,Class,ClassName,RankID, strUserID, bStage, FinishTime) VALUES (@nIndex,@tempClassID,'Kurian', @nKurianRank, @tempUserID, @tempStage, @tempTime)

	SET @nKurianRank += 1
	SET @nIndex += 1

FETCH NEXT FROM KurianDrakiRank INTO @tempClassID,@tempUserID, @tempTime, @tempStage
END

CLOSE KurianDrakiRank
DEALLOCATE KurianDrakiRank

GO

-- =============================================
-- Procedure: DELETE_MOB_UNNECESARRY
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_MOB_UNNECESARRY]
AS

DECLARE @MonsterSsid smallint

DECLARE @Count smallint
SET @Count = 0

DECLARE Backup_Cursor CURSOR
	FOR
	SELECT sSid FROM K_MONSTER

	OPEN Backup_Cursor

	FETCH NEXT FROM Backup_Cursor INTO @MonsterSsid

WHILE @@FETCH_STATUS = 0
BEGIN
	select @Count = count(sSid) from USKO_MOB_ID_LIST where Ssid = @MonsterSsid
	IF @Count = 0 
	BEGIN
		DELETE K_MONSTER WHERE sSid = @MonsterSsid
	END

	FETCH NEXT FROM Backup_Cursor INTO @MonsterSsid
END

CLOSE Backup_Cursor
DEALLOCATE Backup_Cursor

GO

-- =============================================
-- Procedure: LOAD_KNIGHT_ROYALE_CHEST_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 29.09.2018
-- Update date: 29.09.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_KNIGHT_ROYALE_CHEST_LIST]
AS

BEGIN
	SELECT* FROM KNIGHT_ROYALE_CHEST_LIST
END


GO

-- =============================================
-- Procedure: VIP_STORAGE_PASSWORD
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================

CREATE PROCEDURE [dbo].[VIP_STORAGE_PASSWORD]
@strAccountID char(21),
@strPassword char(4),
@key tinyint
AS

DECLARE @bCount tinyint
SELECT @bCount = COUNT(strAccountID) FROM VIP_WAREHOUSE WHERE strAccountID = @strAccountID

IF (@bCount = 0)
    RETURN 2
ELSE
	UPDATE VIP_WAREHOUSE SET strPassword = @strPassword, WipPasswordRequest = @key WHERE strAccountID = @strAccountID

RETURN 1

GO

-- =============================================
-- Procedure: CHANGE_NEW_CLANID
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Notes :
/*Return Values:
1 Please enter the new Clan ID you wish to use. You can use Clan name Change scroll to change you Clan ID only once. 
	Once you select your new Clan ID your old Clan ID will not be recoverable. 
	Please select your new Clan ID carefully.
2 The Clan ID you've entered is already being used by another clan, Please select a different Clan ID.
4 You cannot change your Clan ID if you're already in a clan.
16 Congratulation. Your Clan ID has been changed.
*/
-- =============================================
CREATE PROCEDURE [dbo].[CHANGE_NEW_CLANID]
@strClanID		varchar(30),
@strNewClanID	varchar(30)
AS

DECLARE @AccountID varchar(20),@UserID varchar(20)

SELECT @UserID = Chief from KNIGHTS where IDName = @strClanID

SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID1 = @UserID
SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID2 = @UserID
SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID3 = @UserID
SELECT @AccountID = strAccountID from ACCOUNT_CHAR where strCharID4 = @UserID

DECLARE @Count tinyint
SELECT @Count = COUNT(IDName) FROM KNIGHTS WHERE IDName = @strNewClanID
IF (@Count > 0)
	RETURN 2

IF (@Count = 0)
BEGIN
	DECLARE @IDNum smallint
	SELECT @IDNum = IDNum FROM KNIGHTS WHERE IDName = @strClanID

	UPDATE KNIGHTS SET IDName = @strNewClanID WHERE IDNum = @IDNum
	--UPDATE KNIGHTS_SIEGE_WARFARE_REGISTER SET sBaseClanNum = @strNewClanID WHERE sBaseClanNum = @strClanID
	--UPDATE KNIGHTS_SIEGE_WARFARE_BARRACK SET BaseClanID = @strNewClanID WHERE BaseClanID = @strClanID
	--UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sBaseClanNum = @strNewClanID WHERE sBaseClanNum = @strClanID
	--UPDATE KNIGHTS_SIEGE_WARFARE_RANK_RESULT SET sBaseClanNum = @strNewClanID WHERE sBaseClanNum = @strClanID
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.CLAN_NAME_CHANGE_LOG (AccountID,UserID,  ClanID, ClanName, NewClanName,LogTime) VALUES (@AccountID,@UserID, @IDNum, @strClanID, @strNewClanID, GETDATE())
END
IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 1
	END
COMMIT TRAN

RETURN 3

GO

-- =============================================
-- Procedure: INSERT_K_NPC_NULL_MOB
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_K_NPC_NULL_MOB]AS

DECLARE @NpcSsid smallint,@NpcName varchar(50),@NpcPid smallint

DECLARE @Count2 smallint
SET @Count2 = 0

DECLARE Backup_Cursor2 CURSOR
	FOR
	SELECT Ssid, MobName, Spid FROM USKO_NPC_ID_LIST

	OPEN Backup_Cursor2

	FETCH NEXT FROM Backup_Cursor2 INTO @NpcSsid,@NpcName,@NpcPid

WHILE @@FETCH_STATUS = 0
BEGIN
	select @Count2 = count(*) from K_NPC where sSid = @NpcSsid
	IF @Count2 = 0 
	BEGIN
		INSERT INTO K_NPC(sSid,strName,sPid,sSize,iWeapon1,iWeapon2,byGroup,byActType,byType,byFamily,byRank,byTitle,iSellingGroup,sLevel,iExp,iLoyalty,iHpPoint,sMpPoint,sAtk,sAc,sHitRate,sEvadeRate,sDamage,sAttackDelay,bySpeed1,bySpeed2,sStandtime,sItem,iMagic1,iMagic2,iMagic3,sFireR,sColdR,sLightningR,sMagicR,sDiseaseR,sPoisonR,sBulk,byAttackRange,bySearchRange,byTracingRange,iMoney,byDirectAttack,byMagicAttack) 
		VALUES (@NpcSsid,@NpcName,@NpcPid,100,0,0,0,1,0,0,0,0,0,80,100,0,1000,1000,1,500,2500,1700,300,1500,2,3,1000,@NpcSsid,0,0,0,10,10,10,10,10,10,70,7,15,30,50,0,0)
	END

	FETCH NEXT FROM Backup_Cursor2 INTO @NpcSsid,@NpcName,@NpcPid
END

CLOSE Backup_Cursor2
DEALLOCATE Backup_Cursor2

GO

-- =============================================
-- Procedure: RENTAL_ITEM_CANCEL
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[RENTAL_ITEM_CANCEL]
@AccountID	char(21),		
@CharID	char(21),			
@nRentalIndex  int,
@nItemNumber   int
AS

BEGIN
	DELETE FROM RENTAL_ITEM WHERE nRentalIndex = @nRentalIndex and nItemIndex = @nItemNumber
	DELETE FROM USER_RENTAL_ITEM WHERE nRentalIndex = @nRentalIndex and nItemIndex = @nItemNumber
END

RETURN 1

GO

-- =============================================
-- Procedure: VIP_STORAGE_USE_VAULTKEY
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================

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

GO

-- =============================================
-- Procedure: DELETE_NPC_UNNECESARRY
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_NPC_UNNECESARRY]
AS

DECLARE @NpcSsid smallint

DECLARE @Count2 smallint
SET @Count2 = 0

DECLARE Backup_Cursor2 CURSOR
	FOR
	SELECT Ssid FROM K_NPC

	OPEN Backup_Cursor2

	FETCH NEXT FROM Backup_Cursor2 INTO @NpcSsid

WHILE @@FETCH_STATUS = 0
BEGIN
	select @Count2 = count(sSid) from USKO_NPC_ID_LIST where sSid = @NpcSsid
	IF @Count2 = 0 
	BEGIN
		DELETE K_NPC WHERE sSid = @NpcSsid
	END

	FETCH NEXT FROM Backup_Cursor2 INTO @NpcSsid
END

CLOSE Backup_Cursor2
DEALLOCATE Backup_Cursor2

GO

-- =============================================
-- Procedure: RENTAL_ITEM_DESTORY
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[RENTAL_ITEM_DESTORY]
@AccountID	char(21),	
@CharID	char(21),		
@nItemNumber   int,
@nRentalIndex   int,
@nDurability	smallint,
@nRet		smallint OUTPUT
AS

BEGIN
	DELETE FROM USER_RENTAL_ITEM WHERE strAccountID = @AccountID and nItemIndex = @nItemNumber
	EXEC RENTAL_ITEM_DURABILITY_UPDATE @nRentalIndex, @nDurability
END

RETURN 1

GO

-- =============================================
-- Procedure: DELETE_HDDBAN
-- Database: KO_DATABASE_SERVER_001
-- =============================================
-- =============================================
-- Create date: 15.02.2021
-- Update date: 15.02.2021
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_HDDBAN]
@strUserID varchar(21)
AS
BEGIN
DECLARE @strAccountID varchar(21)
SELECT @strAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID1 = @strUserID or strCharID2 = @strUserID or strCharID3 = @strUserID  or strCharID4 = @strUserID 
END
BEGIN
UPDATE USERDATA SET Authority = 1 WHERE strUserID = @strUserID

update USER_HDD_BAN_LIST set Banned = '0' where  UserID = @strUserID

print 'Congratulations, User unbanned //TEMUKO '

END

GO

-- =============================================
-- Procedure: INSERT_K_MONSTER_ITEM_IS_NULL_MOB
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_K_MONSTER_ITEM_IS_NULL_MOB]AS

TRUNCATE TABLE K_MONSTER_ITEM2

DECLARE @MonsterSsid smallint

DECLARE @Count smallint
SET @Count = 0

DECLARE Backup_Cursor CURSOR
	FOR
	SELECT sSid FROM K_MONSTER

	OPEN Backup_Cursor

	FETCH NEXT FROM Backup_Cursor INTO @MonsterSsid

WHILE @@FETCH_STATUS = 0
BEGIN
	select @Count = count(*) from K_MONSTER_ITEM2 where sIndex = @MonsterSsid AND isMonster = 1
	IF @Count = 0 
	BEGIN
		INSERT INTO K_MONSTER_ITEM2 (sIndex,isMonster,iItem01,sPersent01,iItem02,sPersent02,iItem03,sPersent03,iItem04,sPersent04,iItem05,sPersent05,iItem06,sPersent06,iItem07,sPersent07)
		VALUES (@MonsterSsid,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
	END
	FETCH NEXT FROM Backup_Cursor INTO @MonsterSsid
END

CLOSE Backup_Cursor
DEALLOCATE Backup_Cursor

GO

-- =============================================
-- Procedure: RENTAL_ITEM_DURABILITY_UPDATE
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[RENTAL_ITEM_DURABILITY_UPDATE]
@nRentalIndex  int,
@nDurability   int

AS

DECLARE @LendercharID char(21), @LenderAccountID char(21)

SELECT @LendercharID = strLenderCharID, @LenderAccountID = strLenderAcID FROM RENTAL_ITEM_LIST WHERE nRentalIndex = @nRentalIndex

BEGIN
UPDATE USER_RENTAL_ITEM SET sDurability = @nDurability WHERE strAccountID = @LenderAccountID and nRentalIndex = @nRentalIndex
END

GO

-- =============================================
-- Procedure: INSERT_K_MONSTER_NULL_MOB
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_K_MONSTER_NULL_MOB]AS

DECLARE @MonsterSsid smallint,@MonsterstrName varchar(50),@MonstersPid smallint

DECLARE @Count smallint
SET @Count = 0

DECLARE Backup_Cursor CURSOR
	FOR
	SELECT Ssid, MobName, Spid FROM USKO_MOB_ID_LIST

	OPEN Backup_Cursor

	FETCH NEXT FROM Backup_Cursor INTO @MonsterSsid,@MonsterstrName,@MonstersPid

WHILE @@FETCH_STATUS = 0
BEGIN
	select @Count = count(*) from K_MONSTER where sSid = @MonsterSsid
	IF @Count = 0 
	BEGIN
		INSERT INTO K_MONSTER (sSid,strName,sPid,sSize,iWeapon1,iWeapon2,byGroup,byActType,byType,byFamily,byRank,byTitle,iSellingGroup,sLevel,iExp,iLoyalty,iHpPoint,sMpPoint,sAtk,sAc,sHitRate,sEvadeRate,sDamage,sAttackDelay,bySpeed1,bySpeed2,sStandtime,sItem,iMagic1,iMagic2,iMagic3,sFireR,sColdR,sLightningR,sMagicR,sDiseaseR,sPoisonR,sBulk,byAttackRange,bySearchRange,byTracingRange,iMoney,byDirectAttack,byMagicAttack) 
		VALUES (@MonsterSsid,@MonsterstrName,@MonstersPid,100,0,0,0,1,0,0,0,0,0,80,100,0,1000,1000,1,500,2500,1700,300,1500,2,3,1000,@MonsterSsid,0,0,0,10,10,10,10,10,10,70,7,15,30,50,0,0)
	END
	FETCH NEXT FROM Backup_Cursor INTO @MonsterSsid,@MonsterstrName,@MonstersPid
END

CLOSE Backup_Cursor
DEALLOCATE Backup_Cursor

GO

-- =============================================
-- Procedure: RENTAL_ITEM_LEND
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[RENTAL_ITEM_LEND]
@AccountID char(21),
@CharID char(21),
@nRentalIndex int,
@nItemNumber int,
@nRet smallint OUTPUT
AS

DECLARE @Row tinyint, @sDurability smallint, @nSerialNumber bigint
DECLARE @bItemType tinyint, @bItemClass tinyint, @sRentalTime smallint, @nMoney int, @LendercharID char(21), @LenderAccountID char(21)
DECLARE @timeLend smalldatetime, @timeRegister smalldatetime
SET @Row = 0
SET @timeLend = getdate()

SELECT @sDurability=sDurability, @nSerialNumber=nSerialNumber, @bItemType=byItemType, @bItemClass=byClass, 
@sRentalTime=sRentalTime, @nMoney=nRentalMoney, @LendercharID=strLenderCharID, @LenderAccountID=strLenderAcID, @timeRegister=timeRegister
FROM RENTAL_ITEM 
WHERE nRentalIndex = @nRentalIndex and nItemIndex = @nItemNumber

IF @bItemType = 0
BEGIN
SET @nRet = -5
RETURN
END


INSERT INTO 
RENTAL_ITEM_LIST ( nRentalIndex, nItemIndex, sDurability, nSerialNumber, byItemType, byClass, sRentalTime, nRentalMoney, strLenderCharID, strLenderAcID, strBorrowerCharID, strBorrowerAcID, timeLender, timeRegister ) 
VALUES (@nRentalIndex, @nItemNumber, @sDurability, @nSerialNumber, @bItemType, @bItemClass, @sRentalTime, @nMoney, @LendercharID, @LenderAccountID, @CharID, @AccountID, @timeLend, @timeLend )


DELETE FROM RENTAL_ITEM WHERE nRentalIndex = @nRentalIndex and nItemIndex = @nItemNumber


INSERT INTO 
USER_RENTAL_ITEM ( strUserID, strAccountID, byRentalType, nRentalIndex, nItemIndex, sDurability, nSerialNumber, nRentalMoney, sRentalTime, sDuringTime, timeRental, timeRegister ) 
VALUES ( @CharID, @AccountID, 3, @nRentalIndex, @nItemNumber, @sDurability, @nSerialNumber, 0, @sRentalTime, @sRentalTime, @timeLend, @timeRegister )


UPDATE USER_RENTAL_ITEM
SET byRentalType=2, nRentalMoney = @nMoney, timeRental = @timeLend
WHERE strAccountID = @LenderAccountID and nRentalIndex = @nRentalIndex

SET @nRet = 1

GO

-- =============================================
-- Procedure: LOAD_KNIGHTS_SIEGE_WAR_RANK_RESULT
-- Database: KO_DATABASE_SERVER_001
-- =============================================


CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_SIEGE_WAR_RANK_RESULT]
AS

DECLARE @sBaseClanNum smallint ,@sWarKillCount smallint,@sWarBaseKillCount tinyint,@sWarClanBaseRemainCount tinyint
DECLARE @nRank int = 1

TRUNCATE TABLE KNIGHTS_SIEGE_WARFARE_RANK_RESULT

DECLARE CswRank CURSOR FOR
SELECT sBaseClanNum, sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount FROM KNIGHTS_SIEGE_WARFARE_RANK ORDER BY sWarBaseKillCount DESC, sWarKillCount DESC

OPEN CswRank

FETCH NEXT FROM CswRank INTO @sBaseClanNum, @sWarKillCount,@sWarBaseKillCount,@sWarClanBaseRemainCount
WHILE (@@FETCH_STATUS = 0)
BEGIN
	INSERT KNIGHTS_SIEGE_WARFARE_RANK_RESULT (sRankNumber, sBaseClanNum, sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount) VALUES (@nRank, @sBaseClanNum, @sWarKillCount,@sWarBaseKillCount,@sWarClanBaseRemainCount)

	SET @nRank += 1

FETCH NEXT FROM CswRank INTO @sBaseClanNum, @sWarKillCount,@sWarBaseKillCount,@sWarClanBaseRemainCount
END

CLOSE CswRank
DEALLOCATE CswRank

SELECT TOP(10)sBaseClanNum,sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount FROM KNIGHTS_SIEGE_WARFARE_RANK_RESULT

GO

-- =============================================
-- Procedure: PROC_INSERT_CURRENTUSER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE PROC_INSERT_CURRENTUSER
@AccountID 	varchar(50),
@CharID         varchar(50),
@ServerNo 	int, 
@ServerIP       varchar(50),
@ClientIP       varchar(50),
@nret smallint output 
AS
-- UniqTurk.Net
DECLARE @Sayi int
SELECT @Sayi = count(Numara) FROM UNIQTURK_IPBAN WHERE Numara = @ClientIP
IF @Sayi > 0 
	BEGIN
		SET @nRet = 0
	RETURN
END

ELSE IF @Sayi = 0
	BEGIN
           INSERT INTO CURRENTUSER (nServerNo, strServerIP,  strAccountID, strCharID, strClientIP )  Values  (@ServerNo, @ServerIP, @AccountID, @CharID, @ClientIP )
	DECLARE @RAccountID char(21)

SELECT @RAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID1 = @CharID and strCharID1 IS NOT NULL
SELECT @RAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID2 = @CharID and strCharID2 IS NOT NULL
SELECT @RAccountID = strAccountID FROM ACCOUNT_CHAR WHERE strCharID3 = @CharID and strCharID3 IS NOT NULL

IF @RAccountID IS NULL
BEGIN
	SET @nRet = 0
RETURN
END
ELSE IF @RAccountID = ''
BEGIN
	SET @nRet = 0
RETURN
END
ELSE IF @RAccountID <> @AccountID
BEGIN
	SET @nRet = 0
RETURN 
END	
-- UniqTurk.Net
update tb_user set strClientIP=@ClientIP where strAccountID=@AccountID
update userdata set ip=@ClientIP where strUserID=@CharID
SET @nRet = 1
	RETURN
END


GO

-- =============================================
-- Procedure: RENTAL_ITEM_REGISTER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE [dbo].[RENTAL_ITEM_REGISTER]
@charID char(21), 
@AccountID char(21),
@sRentalTime smallint,
@nItemID int,
@sDurability smallint,
@nMoney int,
@bGameBangType tinyint,
@bItemType tinyint,
@bItemClass tinyint,
@nSerialNumber bigint,
@nRet_Index int OUTPUT,
@nRet smallint OUTPUT

AS

DECLARE @Row tinyint, @nRentalIndex int
DECLARE @timeRegister smalldatetime
SET @Row = 0
SET @nRet_Index = -1
SET @timeRegister = getdate()

---------------------------------------

SELECT @Row = COUNT(*) FROM RENTAL_ITEM WHERE nItemIndex = @nItemID and strLenderAcID = @AccountID 
IF @Row > 0
BEGIN
SET @nRet = -9
RETURN
END

BEGIN TRAN 

INSERT INTO 
RENTAL_ITEM ( nItemIndex, sDurability, nSerialNumber, byRegType, byItemType, byClass, sRentalTime, nRentalMoney, strLenderCharID, strLenderAcID ) 
VALUES (@nItemID, @sDurability, @nSerialNumber, @bGameBangType, @bItemType, @bItemClass, @sRentalTime, @nMoney, @charID, @AccountID )

IF @@ERROR <> 0
BEGIN 
ROLLBACK TRAN 
SET @nRet = -16
RETURN
END

SELECT @nRentalIndex = nRentalIndex FROM RENTAL_ITEM WHERE nItemIndex = @nItemID and strLenderAcID = @AccountID 

INSERT INTO 
USER_RENTAL_ITEM ( strUserID, strAccountID, byRentalType, byRegType, nRentalIndex, nItemIndex, sDurability, nSerialNumber, nRentalMoney, sRentalTime, sDuringTime, timeRegister ) 
VALUES ( @charID, @AccountID, 1, @bGameBangType, @nRentalIndex, @nItemID, @sDurability, @nSerialNumber, @nMoney, @sRentalTime, @sRentalTime, @timeRegister )

IF @@ERROR <> 0
BEGIN 
ROLLBACK TRAN 
SET @nRet = -17
RETURN
END

-- SELECT @nRentalIndex = nRentalIndex FROM RENTAL_ITEM WHERE nItemIndex = @nItemID and strLenderAcID = @AccountID 
SET @nRet_Index = @nRentalIndex

COMMIT TRAN
SET @nRet = 1

GO

-- =============================================
-- Procedure: LOAD_NEW_CHAR_VALUE_orj
-- Database: KO_DATABASE_SERVER_001
-- =============================================


CREATE PROCEDURE [dbo].[LOAD_NEW_CHAR_VALUE]
@CharID varchar(20),
@Class smallint,
@ServerNo smallint
AS

DECLARE @JobType tinyint, @Level tinyint, @Exp bigint
DECLARE @Strength tinyint, @Health tinyint, @Dexterity tinyint, @Intelligence tinyint, @MagicPower tinyint, @FreePoints smallint
DECLARE @SkillPointFree tinyint, @SkillPointCat1 tinyint, @SkillPointCat2 tinyint, @SkillPointCat3 tinyint, @SkillPointMaster tinyint
DECLARE @binarySkill binary(10),@Gold int,@BeginnerType tinyint


SELECT @BeginnerType = BeginnerType FROM [KO_DATABASE_MAIN].dbo.BEGINNER_SETTINGS WHERE ServerNo = @ServerNo
IF (@@ROWCOUNT = 0)
	RETURN

SELECT @JobType = JobType, @Level = [Level], @Exp = [Exp], @Strength = Strength, @Health = Health, @Dexterity = Dexterity, @Intelligence = Intelligence, @MagicPower = MagicPower, @FreePoints = FreePoints, @SkillPointFree = SkillPointFree, @SkillPointCat1 = SkillPointCat1, @SkillPointCat2 = SkillPointCat2, @SkillPointCat3 = SkillPointCat3, @SkillPointMaster = SkillPointMaster, @Gold = Gold FROM CREATE_NEW_CHAR_VALUE WHERE ClassType = @Class % 100 AND JobType = @BeginnerType
IF (@@ROWCOUNT = 0)
	RETURN

IF (@JobType = 1) -- Skilled
BEGIN
	IF (@Class % 100 = 1) -- Warrior
		SET @Class += 4
	ELSE IF (@Class % 100 = 2) -- Rogue
		SET @Class += 5
	ELSE IF (@Class % 100 = 3) -- Magician
		SET @Class += 6
	ELSE IF (@Class % 100 = 4) -- Priest
		SET @Class += 7
	ELSE IF (@Class % 100 = 13) -- Kurian
		SET @Class += 1
END
ELSE IF (@JobType = 2 or @JobType = 3) -- Mastered
BEGIN
	IF (@Class % 100 = 1) -- Warrior
		SET @Class += 5
	ELSE IF (@Class % 100 = 2) -- Rogue
		SET @Class += 6
	ELSE IF (@Class % 100 = 3) -- Magician
		SET @Class += 7
	ELSE IF (@Class % 100 = 4) -- Priest
		SET @Class += 8
	ELSE IF (@Class % 100 = 13) -- Kurian
		SET @Class += 2
END

IF (@Gold > 0)
	UPDATE USERDATA SET Gold = @Gold WHERE strUserID = @CharID

IF (@Level > 0)
	UPDATE USERDATA SET [Level] = @Level WHERE strUserID = @CharID

IF (@Exp > 0)
	UPDATE USERDATA SET [Exp] = @Exp WHERE strUserID = @CharID

IF (@Strength > 0)
	UPDATE USERDATA SET Strong = @Strength WHERE strUserID = @CharID

IF (@Health > 0)
	UPDATE USERDATA SET Sta = @Health WHERE strUserID = @CharID

IF (@Dexterity > 0)
	UPDATE USERDATA SET Dex = @Dexterity WHERE strUserID = @CharID

IF (@Intelligence > 0)
	UPDATE USERDATA SET Intel = @Intelligence WHERE strUserID = @CharID

IF (@MagicPower > 0)
	UPDATE USERDATA SET Cha = @MagicPower WHERE strUserID = @CharID

IF (@FreePoints > 0)
	UPDATE USERDATA SET Points = @FreePoints WHERE strUserID = @CharID

SET @binarySkill = CONVERT(VARBINARY(1), @SkillPointFree) -- Free points
SET @binarySkill += CONVERT(VARBINARY(4), 0) -- Command, Politics, Language, Siege weapon
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat1) -- Skill 1
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat2) -- Skill 2
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat3) -- Skill 3
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointMaster) -- Master
SET @binarySkill += CONVERT(VARBINARY(1), 0) -- Padding

UPDATE USERDATA SET Class = @Class, strSkill = @binarySkill WHERE strUserID = @CharID


GO

-- =============================================
-- Procedure: LOAD_CASTELLAN_ENTERED_CLAN
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 30.07.2018
-- Update date: 30.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_CASTELLAN_ENTERED_CLAN]
AS

BEGIN
	SELECT TOP(10)sBaseClanNum,sWarKillCount,sWarBaseKillCount,sWarClanBaseRemainCount FROM KNIGHTS_SIEGE_WARFARE_RANK_RESULT
END

GO

-- =============================================
-- Procedure: LOAD_HOOK_COLLECTIONRACE_HUNT_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.06.2019
-- Update date: 08.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_HOOK_COLLECTIONRACE_HUNT_LIST]
AS

-------------------------------------------------------------------------------------------------------
   SELECT * FROM HOOK_COLLECTIONRACE_HUNT_LIST
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: LOAD_NEW_CHAR_SET
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_NEW_CHAR_SET]
@CharID varchar(20),
@Class smallint
AS

DECLARE @SlotID tinyint = 0, @binaryLoop int = 0, @binaryLoopEx int = 0
DECLARE @ItemID int, @ItemDuration smallint, @ItemCount smallint, @ItemFlag tinyint, @ItemExpireTime int
DECLARE @binaryItemID varbinary(4), @binaryItemDuration varbinary(2), @binaryItemCount varbinary(2), @binaryItemFlag varbinary(1), @binaryItemExpireTime varbinary(4)
DECLARE @binaryItemData binary(600) = 0x00, @binaryItemDataEx binary(370) = 0x00

WHILE (@SlotID < 75)
BEGIN
	SELECT @ItemID = ItemID, @ItemDuration = ItemDuration, @ItemCount = ItemCount, @ItemFlag = ItemFlag, @ItemExpireTime = ItemExpireTime FROM CREATE_NEW_CHAR_SET WHERE ClassType = @Class % 100 AND SlotID = @SlotID

	IF (@@ROWCOUNT = 0)
		RETURN

	SET @binaryItemID = SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 4, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 3, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 2, 1) + SUBSTRING(CAST(@ItemID AS VARBINARY(4)), 1, 1)
	SET @binaryItemDuration = SUBSTRING(CAST(@ItemDuration AS VARBINARY(2)), 2, 1) + SUBSTRING(CAST(@ItemDuration AS VARBINARY(2)), 1, 1)
	SET @binaryItemCount = SUBSTRING(CAST(@ItemCount AS VARBINARY(2)), 2, 1) + SUBSTRING(CAST(@ItemCount AS VARBINARY(2)), 1, 1)
	SET @binaryItemFlag = SUBSTRING(CAST(@ItemFlag AS VARBINARY(1)), 1, 1)
	SET @binaryItemExpireTime = SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 4, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 3, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 2, 1) + SUBSTRING(CAST(@ItemExpireTime AS VARBINARY(4)), 1, 1)

	SET @binaryItemData = CAST(SUBSTRING(@binaryItemData, 1, @binaryLoop) + CAST(CAST(@binaryItemID AS VARBINARY(4)) + @binaryItemDuration +  @binaryItemCount AS VARBINARY(8)) + SUBSTRING(@binaryItemData, @binaryLoop + 8, 593 - @binaryLoop) AS BINARY(592))
	SET @binaryItemDataEx = CAST(SUBSTRING(@binaryItemDataEx, 1, @binaryLoopEx) + CAST(CAST(@binaryItemFlag AS VARBINARY(1)) + @binaryItemExpireTime AS VARBINARY(5)) + SUBSTRING(@binaryItemDataEx, @binaryLoopEx + 5, 371 - @binaryLoopEx) AS BINARY(370))

	SET @SlotID += 1
	SET @binaryLoop += 8
	SET @binaryLoopEx += 5
END
/* codigo para inicializar items segun BEGINNER_ITEMS */

SELECT @binaryItemData = strItem FROM BEGINNER_ITEMS WHERE iClass = @Class % 100
    
UPDATE USERDATA SET strItem = @binaryItemData, strItemTime = @binaryItemDataEx WHERE strUserID = @CharID

GO

-- =============================================
-- Procedure: LOAD_HOOK_COLLECTIONRACE_SETTINGS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 08.06.2019
-- Update date: 08.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_HOOK_COLLECTIONRACE_SETTINGS]
AS

-------------------------------------------------------------------------------------------------------
   SELECT * FROM HOOK_COLLECTIONRACE_SETTINGS
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: ACCOUNT_LOGIN_OTP
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2017
-- Update date: 15.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[ACCOUNT_LOGIN_OTP]
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

	RETURN 1

GO

-- =============================================
-- Procedure: SAVE_KNIGHT_SIEGE_RANK
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[SAVE_KNIGHT_SIEGE_RANK]
@ClanID smallint,
@TotalKil smallint,
@BarrackKil tinyint,
@RemainBarrack tinyint
AS

BEGIN
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sWarKillCount = @TotalKil, sWarBaseKillCount = @BarrackKil, sWarClanBaseRemainCount = @RemainBarrack WHERE sBaseClanNum = @ClanID
END

RETURN 1

GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_LOAD
-- Database: KO_DATABASE_SERVER_001
-- =============================================



/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_LOAD]
AS

-------------------------------------------------------------------------------------------------------
SELECT sMainAllianceKnights,sSubAllianceKnights,sMercenaryClan_1,sMercenaryClan_2,strAllianceNotice FROM KNIGHTS_ALLIANCE
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: LOAD_PET_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================


CREATE PROCEDURE [dbo].[LOAD_PET_DATA]
@nSerialID bigint
AS

SELECT sPetName, bLevel, sHP, sMP,nIndex, sSatisfaction, nExp, sPid, sSize, sItems FROM PET_USER_DATA where nSerialID = @nSerialID

GO

-- =============================================
-- Procedure: GET_ALL_CHARID
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.1.2018
-- Update date: 13.1.2018
-- +
-- =============================================
CREATE PROCEDURE [dbo].[GET_ALL_CHARID]
@strAccountID varchar(21)
AS

-------------------------------------------------------------------------------------------------------
   SELECT strCharID1,strCharID2,strCharID3,strCharID4 FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: UPDATE_SAVED_MAGIC
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE  PROCEDURE [dbo].[UPDATE_SAVED_MAGIC]
@strUserID 	char(21),
@Skill1		int,
@During1	smallint,
@Skill2		int,
@During2	smallint,
@Skill3		int,
@During3	smallint,
@Skill4		int,
@During4	smallint,
@Skill5		int,
@During5	smallint,
@Skill6		int,
@During6	smallint,
@Skill7		int,
@During7	smallint,
@Skill8		int,
@During8	smallint,
@Skill9		int,
@During9	smallint,
@Skill10	int,
@During10	smallint
AS

DECLARE @Row smallint
     SET @Row = 0
	     SELECT @Row = COUNT(*) FROM USER_SAVED_MAGIC WHERE strCharID = @strUserID
	          IF @Row = 0
	             BEGIN
		             INSERT INTO USER_SAVED_MAGIC (strCharID, nSkill1, nDuring1, nSkill2, nDuring2, nSkill3, nDuring3, nSkill4, nDuring4, nSkill5, nDuring5, nSkill6, nDuring6, nSkill7, nDuring7, nSkill8, nDuring8, nSkill9, nDuring9, nSkill10, nDuring10 )
					          VALUES (@strUserID, @Skill1, @During1, @Skill2, @During2, @Skill3, @During3, @Skill4, @During4, @Skill5, @During5, @Skill6, @During6, @Skill7, @During7, @Skill8, @During8, @Skill9, @During9, @Skill10, @During10 )
		                        RETURN
	                              END
								  ELSE
                                    UPDATE USER_SAVED_MAGIC SET nSkill1 = @Skill1,nDuring1 = @During1,nSkill2 = @Skill2,nDuring2 = @During2,nSkill3 = @Skill3,nDuring3 = @During3,nSkill4 = @Skill4,nDuring4 = @During4,nSkill5 = @Skill5,nDuring5 = @During5,nSkill6 = @Skill6,nDuring6 = @During6,nSkill7 = @Skill7,nDuring7 = @During7,nSkill8 = @Skill8,nDuring8 = @During8,nSkill9 = @Skill9,nDuring9 = @During9,nSkill10 = @Skill10,nDuring10 = @During10 WHERE strCharID = @strUserID

GO

-- =============================================
-- Procedure: UPDATE_PET_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================


-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_PET_DATA]
@nSerialID bigint,
@strPetName varchar(50),
@bLevel tinyint,
@sHP smallint,
@sMP smallint,
@sSatisfaction smallint,
@nExp int,
@sItems binary(81)
AS

UPDATE PET_USER_DATA
SET
sPetName = @strPetName,
bLevel = @bLevel,
sHP = @sHP,
sMP = @sMP,
sSatisfaction = @sSatisfaction,
nExp = @nExp,
sItems = @sItems

WHERE nSerialID = @nSerialID




GO

-- =============================================
-- Procedure: GAME_LOGIN
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 12.1.2018
-- Notes :
/* Return values: 
-1 Successfully connected to %s server but failed logging into the game. (%d)
0 Nation select
1 Nation Karus
2 Nation El Morad
4 Server is undergoing maintenance. Please try again later.
17 Error OTP
18 Access Restricted This server is open for NTTGame users who are registered for ICS.
20 Your current region is not able to login to this server. Please try other servers. Thank you.
21 Due to high volume, only premium players may log in at the moment. Please try later or purchase premium from the website to continue playing!
22 Invalid security code. Please try again.
23 empty dialog
30 Error has been occurred during nation transfer Please contact customer service ERRORCODE = 0x01 Irk Human ve Karus Değil.
31 Error has been occurred during nation transfer Please contact customer service ERRORCODE = 0x02 Karakterler Arası ırk uyumsuzluğu
32 Error has been occurred during nation transfer Please contact customer service ERRORCODE = 0x03 Böyle bir ırk race class yok.
255 Successfully connected to %s server but failed logging into the game. (%d)
*/
-- =============================================
CREATE PROCEDURE [dbo].[GAME_LOGIN]
@strAccountID varchar(21),
@strPasswd varchar(28)
AS

    DECLARE @bNation tinyint
         DECLARE @strHashPassword varchar(28)
              DECLARE @strAuthority tinyint
                   DECLARE @PremiumType smallint
    SELECT @strHashPassword = strPasswd, @strAuthority = strAuthority,@PremiumType = bPremiumType FROM TB_USER WHERE strAccountID = @strAccountID
             IF (@@ROWCOUNT = 0 OR @strHashPassword != @strPasswd OR @strAuthority = 9)
                     RETURN -1
    DECLARE @FreeLimit smallint, @TotalUser smallint
           DECLARE @ServerIPAddress varchar(15) 
                 DECLARE @MaintenanceMode tinyint
                       DECLARE @AccountID smallint
                              DECLARE @GmLoginID smallint
    SELECT @FreeLimit = FreeLimit, @TotalUser = TotalUserLimit, @ServerIPAddress = ServerIPAddress, @MaintenanceMode = MaintenanceMode FROM [KO_DATABASE_MAIN].dbo.GAME_OPTIONS
        IF (@MaintenanceMode = 1 AND @strAuthority != 0)
             BEGIN
                  SELECT @AccountID = COUNT(GmLoginID) FROM [KO_DATABASE_MAIN].dbo.GM_MAINTENANCE_LOGIN WHERE GmLoginID = @strAccountID  
                           IF (@AccountID = 0)
                                   BEGIN
                                       RETURN 4
                                          END
                                             END
    DECLARE @TotalUserCount smallint
         SELECT @TotalUserCount = COUNT(strServerIP) FROM CURRENTUSER WHERE strServerIP = @ServerIPAddress
                IF (@PremiumType = 0 AND @TotalUserCount >= @FreeLimit)
                      RETURN 21
				IF (@TotalUserCount >= @TotalUser)
					  RETURN 21

DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20),@CharID4 varchar(20)
DECLARE @AccountNation tinyint, @CharNum tinyint
DECLARE @Nation tinyint, @Class smallint, @Race tinyint

SELECT @AccountNation = bNation, @CharNum = bCharNum, @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''),@CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@AccountNation != 1 AND @AccountNation != 2)
	RETURN 30

DECLARE @ValidCharacters tinyint

IF (@CharID1 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID1

	IF (@Nation != @AccountNation)
		RETURN 31
	
	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID2 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID2

	IF (@Nation != @AccountNation)
		RETURN 31
	
	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID3 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID3

	IF (@Nation != @AccountNation)
		RETURN 31

	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

IF (@CharID4 <> '')
BEGIN
	SELECT @Nation = Nation, @Race = Race, @Class = Class FROM USERDATA WHERE strUserID = @CharID4

	IF (@Nation != @AccountNation)
		RETURN 31

	SELECT @ValidCharacters = COUNT(ClassIndex) FROM CHARACTER_VALIDS WHERE NationValue = @Nation AND RaceValue = @Race AND ClassValue = @Class

	IF (@ValidCharacters = 0)
		RETURN 32
END

RETURN @AccountNation
/*
UPDATE KOHSTR_OLD_CHARACTER_LETTER_SYSTEM SET GameAccessCountGameServer = GameAccessCountGameServer +1 WHERE AccountID = @strAccountID
*/

GO

-- =============================================
-- Procedure: UPDATE_DRAKI_LIMIT_DAY
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.06.2019
-- Update date: 11.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_DRAKI_LIMIT_DAY]
AS

BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET bDrakiEnteranceLimit = 3
END

GO

-- =============================================
-- Procedure: NATION_SELECT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[NATION_SELECT]
@strAccountID varchar(21),
@bNation tinyint
AS
      
DECLARE @aCount tinyint,@bCount tinyint,@cCount tinyint,@dCount tinyint,@eCount tinyint,@fCount tinyint

BEGIN TRAN
	SELECT @aCount = COUNT(strAccountID) FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
	IF (@aCount = 0)
	BEGIN
		INSERT INTO ACCOUNT_CHAR (strAccountID, bNation) VALUES (@strAccountID, @bNation)
	END
                  
	SELECT @bCount = COUNT(strAccountID) FROM WAREHOUSE WHERE strAccountID = @strAccountID
	IF (@bCount = 0)
	BEGIN
		INSERT INTO WAREHOUSE (strAccountID, nMoney, dwTime, WarehouseData, strSerial, WarehouseDataTime) VALUES (@strAccountID, 0, 0, 0x00, 0x00, 0x00)	
	END
                      
	SELECT @cCount = COUNT(strAccountID) FROM VIP_WAREHOUSE WHERE strAccountID = @strAccountID
	IF (@cCount = 0)
	BEGIN
		INSERT INTO VIP_WAREHOUSE (strAccountID, strPassword,WipPasswordRequest, strExpirationDate, VIPWarehouseData, strSerial, VIPWarehouseDataTime) VALUES (@strAccountID, 1234,0, 0, 0x00, 0x00, 0x00)											
	END

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 0
	END
COMMIT TRAN

RETURN @bNation

GO

-- =============================================
-- Procedure: CREATE_NEW_CHAR
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Notes :
/* Return Values:
-1     : Disconnect
0      : Successful
1      : You cannot create anymore characters.
2      : The selected nation and the race does not match.
3      : This ID is already used on another character.
4      : Failed creating Database
5      : You cannot use this character ID.
6      : Please enter your character ID.
7      : Please select a race.
8      : This race is not available yet.
9      : Please select a specialty.
10     : There are stat points still remaining.
11+ 0- : Unkown Error (No packet)
*/
-- =============================================
CREATE PROCEDURE [dbo].[CREATE_NEW_CHAR]
@strAccountID varchar(21),
@index tinyint,
@strCharID varchar(21),
@bRace tinyint,
@sClass smallint,
@nHair int,
@bFace tinyint,
@bStr tinyint,
@bSta tinyint,
@bDex tinyint,
@bIntel tinyint,
@bCha tinyint
AS

------------------------------------------------------------------------------------------------------------
DECLARE @bNation tinyint,@bCharCount tinyint,@bCount tinyint

--===================KURIAN CANCELACION==================
--IF @bRace = 6 OR @bRace = 14
--RETURN 4
--===================================================

SELECT @bNation = bNation, @bCharCount = bCharNum FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
	
	IF (@bNation = 1 AND @bRace > 10)
		RETURN 2
	ELSE IF (@bNation = 2 AND @bRace < 10)
		RETURN 2
	ELSE IF (@bNation <> 1 AND @bNation <> 2)
		RETURN 2
	
	IF (dbo.IsValidCharacters(@strCharID) = 1)
		RETURN 5

SELECT @bCount = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strCharID
	IF (@bCount > 0)
		RETURN 3
------------------------------------------------------------------------------------------------------------
BEGIN TRAN
	IF (@index = 0)
		UPDATE ACCOUNT_CHAR SET strCharID1 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID 
	ELSE IF (@index = 1)
		UPDATE ACCOUNT_CHAR SET strCharID2 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@index = 2)
		UPDATE ACCOUNT_CHAR SET strCharID3 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@index = 3)
		UPDATE ACCOUNT_CHAR SET strCharID4 = @strCharID, bCharNum += 1 WHERE strAccountID = @strAccountID
	
	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 4
	END

	BEGIN
		/* Character Creation */
		INSERT INTO USERDATA (strUserID, Nation, Race, Class, HairRGB, Face, Strong, Sta, Dex, Intel, Cha)
		VALUES (@strCharID, @bNation, @bRace, @sClass, @nHair, @bFace, @bStr, @bSta, @bDex, @bIntel, @bCha)
		--VALUES (@strCharID, @bNation, @bRace, @sClass, @nHair, @bFace, 255, 255, 255, 255, 255)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
    		
		/* Creating Character Skill Data */
		INSERT INTO USERDATA_SKILLSHORTCUT (strCharID, nCount, strSkillData) VALUES (@strCharID, 0, 0x00)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Creating a Character Skill Bar */
		INSERT INTO USER_SAVED_MAGIC (strCharID, nSkill1, nDuring1, nSkill2, nDuring2, nSkill3, nDuring3, nSkill4, nDuring4, nSkill5, nDuring5, nSkill6, nDuring6, nSkill7, nDuring7, nSkill8, nDuring8, nSkill9, nDuring9, nSkill10, nDuring10 )
		VALUES (@strCharID, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Creating User Clan Information */
		INSERT INTO USER_KNIGHTDATA (sClanID,strUserID,nDonatedNP,strMemo,fame,sClass,[level],lastLogin,Loyalty) VALUES (0,@strCharID,0,'',0,@sClass,1,0,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Sending a Character Starter Gift */
		INSERT INTO MAIL_BOX (strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability) 
		SELECT SenderID, @strCharID, ItemName, ItemDescription, LetterType, ItemID, ItemCount, ItemDuration FROM LETTER_GIFT WHERE SendingStatus = 1
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Character Achieve Initial Creation */
		--Status 1: Let All Tasks Begin Unfinished.
		--Status 2: Let All Tasks Begin Done.
		INSERT INTO USER_ACHIEVE_DATA(strUserID,sCoverID,sSkillID,sAchieveCount,strAchieve) SELECT @strCharID,sCoverID,sSkillID,sAchieveCount,strAchieve FROM USER_ACHIEVE_LOAD_DATA WHERE sStatus = 1

		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END
		
		/* Creating a Character Genie */
		INSERT INTO USER_GENIE_DATA (strUserID,sGenieTime,strGenieOptions,sFirstUsingGenie) VALUES (@strCharID,0,0x00,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Creating User Seal Exp */
		INSERT INTO USER_SEAL_EXP (strUserID,sSealedExp) VALUES (@strCharID,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Return Data */
		INSERT INTO USER_RETURN_DATA (strCharID,ReturnSymbolisOK,ReturnisLogOutTime,ReturnSymbolTime) VALUES (@strCharID,0,0,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_RETURN_DATA WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Quest Data */
		INSERT INTO USER_QUEST_DATA (strUserID,sQuestCount,strQuest) VALUES (@strCharID,0,0x00)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_RETURN_DATA WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_QUEST_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Quest Closed Skill Data */
		INSERT INTO QUEST_SKILLS_CLOSED_DATA (strUserID,strQuestSkill,strQuestSkillCount,strCheck) VALUES (@strCharID,0x00,0,0)
		IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		BEGIN
			DELETE FROM USERDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_KNIGHTDATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM MAIL_BOX WHERE strRecipientID = @strCharID AND strRecipientID IS NOT NULL
			DELETE FROM USER_ACHIEVE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_GENIE_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_SEAL_EXP WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM USER_RETURN_DATA WHERE strCharID = @strCharID AND strCharID IS NOT NULL
			DELETE FROM USER_QUEST_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			DELETE FROM QUEST_SKILLS_CLOSED_DATA WHERE strUserID = @strCharID AND strUserID IS NOT NULL
			ROLLBACK TRAN
			RETURN 4
		END

		/* Character Start */
		EXEC LOAD_NEW_CHAR_VALUE @StrCharID , @sClass;
		UPDATE TB_USER set CashPoint = '50000' WHERE strAccountID = @strAccountID;
		UPDATE TB_USER set BonusCashPoint = '55000' WHERE strAccountID = @strAccountID;
    	EXEC DELETE_GM @StrUserID = @strCharID;
	END

   IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 4
	END

COMMIT TRAN
RETURN 0

GO

-- =============================================
-- Procedure: UPDATE_SIEGE_DATABASE
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 18.12.2017
-- Update date: 18.12.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_SIEGE_DATABASE]
@nMoradonTax int,
@nDelosTax int,
@nDungeonCharge int
AS

UPDATE KNIGHTS_SIEGE_WARFARE SET nMoradonTax = @nMoradonTax,nDellosTax = @nDelosTax, nDungeonCharge = @nDungeonCharge

GO

-- =============================================
-- Procedure: CHANGE_HAIR
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2017
-- Update date: 15.10.2017
-- Notes :
/* The opcode values:
0 seems to be an in-game implementation for converting from old -> new hair data
2 seems to be used with the hair change item(?).
	Another note: there's 4 bytes at the end of the packet data that I can't account for (maybe a[nother] checksum?)
*/
-- =============================================
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

GO

-- =============================================
-- Procedure: CHANGE_NEW_ID
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Notes :
/* Return values:
5 King of Nation cannot change ID
4 You cannot change your ID if you're already in a clan.
3 Congratulation. Your ID has been changed.
2 The ID you've entered is already being used by another character.
	Please select a different ID.
1 Please enter the new ID you wish to use. 
	You can use Scroll of Identity to change you ID only once. 
	Once you select your new ID your old ID will not be recoverable. 
	Please select your new ID carefully.
0 empty
*/
-- =============================================
CREATE PROCEDURE [dbo].[CHANGE_NEW_ID]
@byType char(21),
@AccountID char(21),
@OldCharID char(21),
@NewCharID char(21),
@nRet smallint output
AS

DECLARE @AlreadyCharName int

BEGIN TRAN
IF (dbo.IsValidCharacters(@NewCharID) = 1)
	RETURN 1

SELECT @AlreadyCharName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @NewCharID
IF(@AlreadyCharName != 0)
	RETURN 2

IF(@AlreadyCharName = 0)
BEGIN
	UPDATE ACCOUNT_CHAR SET strCharID1 = @NewCharID WHERE strCharID1 = @OldCharID AND strCharID1 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID2 = @NewCharID WHERE strCharID2 = @OldCharID AND strCharID2 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID3 = @NewCharID WHERE strCharID3 = @OldCharID AND strCharID3 IS NOT NULL
	UPDATE ACCOUNT_CHAR SET strCharID4 = @NewCharID WHERE strCharID4 = @OldCharID AND strCharID4 IS NOT NULL
	UPDATE USERDATA SET strUserId = @NewCharID WHERE strUserId = @OldCharID AND strUserId IS NOT NULL
	UPDATE KNIGHTS SET Chief = @NewCharID WHERE Chief = @OldCharID AND Chief IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_1 = @NewCharID WHERE ViceChief_1 = @OldCharID AND ViceChief_1 IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_2 = @NewCharID WHERE ViceChief_2 = @OldCharID AND ViceChief_2 IS NOT NULL
	UPDATE KNIGHTS SET ViceChief_3 = @NewCharID WHERE ViceChief_3 = @OldCharID AND ViceChief_3 IS NOT NULL
	UPDATE FRIEND_LIST SET strUserID = @NewCharID where strUserID = @OldCharID
	UPDATE RENTAL_ITEM SET strLenderCharID = @NewCharID WHERE strLenderCharID = @OldCharID AND strLenderCharID IS NOT NULL
	UPDATE RENTAL_ITEM SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE RENTAL_ITEM_LIST SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	DELETE FROM USER_SAVED_MAGIC WHERE strCharID = @OldCharID
	UPDATE CURRENTUSER SET strCharID = @NewCharID WHERE strAccountID = @AccountID AND strCharID = @OldCharID
	UPDATE USERDATA_SKILLSHORTCUT SET strCharID = @NewCharID WHERE strCharID = @OldCharID AND strCharID IS NOT NULL
	UPDATE BATTLE SET strUserName = @NewCharID WHERE strUserName = @OldCharID AND strUserName IS NOT NULL
	UPDATE USER_DAILY_OP SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE MAIL_BOX SET strSenderID = @NewCharID WHERE strSenderID = @OldCharID AND strSenderID IS NOT NULL
	UPDATE MAIL_BOX SET strRecipientID = @NewCharID WHERE strRecipientID = @OldCharID AND strRecipientID IS NOT NULL
	UPDATE USER_ACHIEVE_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE RENTAL_ITEM SET strLenderCharID = @NewCharID WHERE strLenderCharID = @OldCharID AND strLenderCharID IS NOT NULL
	UPDATE RENTAL_ITEM SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE RENTAL_ITEM_LIST SET strBorrowerCharID = @NewCharID WHERE strBorrowerCharID = @OldCharID AND strBorrowerCharID IS NOT NULL
	UPDATE SEALED_ITEMS SET strUserID = @NewCharID WHERE strUserID = @OldCharID  AND strUserID IS NOT NULL
	UPDATE USER_SEAL_EXP SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE USER_DRAKI_TOWER_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE DRAKI_TOWER_RIFT_RANK SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE WEB_ITEMMALL SET strCharID = @NewCharID WHERE strAccountID = @AccountID AND strCharID = @OldCharID
	UPDATE USER_GENIE_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE SHERIFF_REPORTS SET ReportedName = @NewCharID WHERE ReportedName = @OldCharID AND ReportedName IS NOT NULL
	UPDATE SHERIFF_REPORTS SET ReportedSheriffName = @NewCharID WHERE ReportedSheriffName = @OldCharID AND ReportedSheriffName IS NOT NULL
	UPDATE USER_RENTAL_ITEM SET strUserID = @NewCharID WHERE strAccountID = @AccountID AND strUserID = @OldCharID
	UPDATE USER_KNIGHTDATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	UPDATE KNIGHTS_SIEGE_WARFARE_RANK SET sBaseClanCommander = @NewCharID WHERE sBaseClanCommander = @OldCharID AND sBaseClanCommander IS NOT NULL
	UPDATE KNIGHTS_SIEGE_WARFARE_REGISTER SET sBaseClanCommander = @NewCharID WHERE sBaseClanCommander = @OldCharID AND sBaseClanCommander IS NOT NULL
	UPDATE USER_RETURN_DATA SET strCharID = @NewCharID WHERE strCharID = @OldCharID AND strCharID IS NOT NULL
	UPDATE USER_QUEST_DATA SET strUserID = @NewCharID WHERE strUserID = @OldCharID AND strUserID IS NOT NULL
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.NAME_CHANGE_LOG (AccountID, OldCharID, NewCharID, LogTime) VALUES (@AccountID, @OldCharID, @NewCharID, GETDATE())
END
	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN 1
	END
COMMIT TRAN

RETURN 3

GO

-- =============================================
-- Procedure: LOAD_USER_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_USER_DATA]
@strAccountID varchar(21),
@strCharID varchar(21)
AS

DECLARE @strCharID1 varchar(21), @strCharID2 varchar(21), @strCharID3 varchar(21),@strCharID4 varchar(21)
SELECT @strCharID1 = ISNULL(strCharID1, ''),  @strCharID2 = ISNULL(strCharID2, ''), @strCharID3 = ISNULL(strCharID3, ''),@strCharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

	IF (@strCharID NOT IN(@strCharID1, @strCharID2, @strCharID3,@strCharID4))
		RETURN

	UPDATE USERDATA SET Zone='21' WHERE strUserID = @strCharID and Zone='22' or Zone='23' or Zone='24' or Zone='25'
	UPDATE USERDATA SET Zone='1'  WHERE strUserID = @strCharID and Zone='5'  or Zone='6'
	UPDATE USERDATA SET Zone='2'  WHERE strUserID = @strCharID and Zone='7'  or Zone='8'
	-- UPDATE USERDATA SET PX='81570',PZ='44600',PY='469' WHERE strUserID = @strCharID and Zone='21' or Zone='22' or Zone='23' or Zone='24' or Zone='25'	
	UPDATE USERDATA SET Zone='11'  WHERE strUserID = @strCharID and Zone='13'  or Zone='14'	 
	UPDATE USERDATA SET Zone='12'  WHERE strUserID = @strCharID and Zone='15'  or Zone='16'	
  
SELECT Nation, Race, Class, HairRGB, [Rank], Title, [Level],bRebirthLevel, [Exp], Loyalty, Face, City, Knights, Fame, Hp, Mp, Sp, Strong, Sta, Dex, Intel, Cha,bRebStr,bRebSta,bRebDex,bRebIntel,bRebCha, Authority, Points, Gold, Zone, Bind, PX, PZ, PY, dwTime, strSkill, strItem,strDeletedItem, strSerial, strItemTime, MannerPoint, LoyaltyMonthly,TimePunishment FROM USERDATA WHERE strUserID = @strCharID

GO

-- =============================================
-- Procedure: LOAD_KNIGHTS_SIEGE_WARFARE_USERS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_SIEGE_WARFARE_USERS]
@strUserId char(25)
AS

  DECLARE @Knights smallint
    DECLARE @MasterKnightsID smallint
      DECLARE @CSWFreeLoyaltyUpdateTime datetime
        DECLARE @AddedLoyalty int
          DECLARE @IsOnline tinyint
  SET @AddedLoyalty = 500
    SELECT @Knights = Knights FROM USERDATA WHERE strUserId = @strUserId
      SELECT @MasterKnightsID = sMasterKnights FROM KNIGHTS_SIEGE_WARFARE WHERE sCastleIndex = 1
        IF (@Knights <> 0) AND (@Knights = @MasterKnightsID)
          BEGIN
            SELECT @CSWFreeLoyaltyUpdateTime = CSWFreeLoyaltyUpdateTime FROM USERDATA WHERE strUserId = @strUserId
              IF DATEDIFF(day,@CSWFreeLoyaltyUpdateTime,GETDATE()) >= 1
                UPDATE USERDATA SET Loyalty = Loyalty + @AddedLoyalty,CSWFreeLoyaltyUpdateTime = GETDATE() WHERE strUserId = @strUserId
                  ELSE IF @CSWFreeLoyaltyUpdateTime IS NULL
                    UPDATE USERDATA SET Loyalty = Loyalty + @AddedLoyalty,CSWFreeLoyaltyUpdateTime = GETDATE() WHERE strUserId = @strUserId
  DECLARE KSWU_CURSOR CURSOR FOR
    SELECT strUserId FROM USERDATA WHERE Knights = @MasterKnightsID
      OPEN KSWU_CURSOR
        FETCH NEXT FROM KSWU_CURSOR INTO @strUserId
          WHILE @@FETCH_STATUS = 0
            BEGIN
              SET @CSWFreeLoyaltyUpdateTime = 0
                SET @IsOnline = 0
                  SELECT @IsOnline = COUNT(strCharID) FROM CURRENTUSER WHERE strCharID = @strUserId
                    IF @IsOnline = 0
                      BEGIN
                        SELECT @CSWFreeLoyaltyUpdateTime = CSWFreeLoyaltyUpdateTime FROM USERDATA WHERE strUserId = @strUserId
                          IF DATEDIFF(day,@CSWFreeLoyaltyUpdateTime,GETDATE()) >= 1
                            UPDATE USERDATA SET Loyalty = Loyalty + @AddedLoyalty,CSWFreeLoyaltyUpdateTime = GETDATE() WHERE strUserId = @strUserId
                              ELSE IF @CSWFreeLoyaltyUpdateTime IS NULL
                                UPDATE USERDATA SET Loyalty = Loyalty + @AddedLoyalty,CSWFreeLoyaltyUpdateTime = GETDATE() WHERE strUserId = @strUserId
                                  END
  FETCH NEXT FROM KSWU_CURSOR INTO @strUserId
    END
      CLOSE KSWU_CURSOR
        DEALLOCATE KSWU_CURSOR
          END

GO

-- =============================================
-- Procedure: USER_ITEM_SEAL
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================

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


GO

-- =============================================
-- Procedure: UPDATE_KNIGHT_CASH
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 29.12.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_KNIGHT_CASH]
@strAccountID char(21),
@KnightCash int
AS

BEGIN
   UPDATE TB_USER SET CashPoint += @KnightCash WHERE strAccountID = @strAccountID
END

GO

-- =============================================
-- Procedure: INSERT_FRIEND_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_FRIEND_LIST]
@strUserID char(21),
@strFriend char(21)
AS
/* Return values:
0 Successful
1 Failed to add a buddy.
2 There are too many buddies on buddy list.
*/
DECLARE @strFriend1 char(21), @strFriend2 char(21), @strFriend3 char(21), @strFriend4 char(21), @strFriend5 char(21), @strFriend6 char(21)
DECLARE @strFriend7 char(21), @strFriend8 char(21), @strFriend9 char(21), @strFriend10 char(21), @strFriend11 char(21), @strFriend12 char(21)
DECLARE @strFriend13 char(21), @strFriend14 char(21), @strFriend15 char(21), @strFriend16 char(21), @strFriend17 char(21), @strFriend18 char(21)
DECLARE @strFriend19 char(21), @strFriend20 char(21), @strFriend21 char(21), @strFriend22 char(21), @strFriend23 char(21), @strFriend24 char(21) 
SELECT	@strFriend1 = strFriend1, @strFriend2 = strFriend2,@strFriend3 = strFriend3,@strFriend4 = strFriend4,
		@strFriend5 = strFriend5, @strFriend6 = strFriend6,@strFriend7 = strFriend7,@strFriend8 = strFriend8,
		@strFriend9 = strFriend9, @strFriend10 = strFriend10,@strFriend11 = strFriend11,@strFriend12 = strFriend12,
		@strFriend13 = strFriend13, @strFriend14 = strFriend14,@strFriend15 = strFriend15,@strFriend16 = strFriend16,
		@strFriend17 = strFriend17, @strFriend18 = strFriend18,@strFriend19 = strFriend19,@strFriend20 = strFriend20,
		@strFriend21 = strFriend21, @strFriend22 = strFriend22,@strFriend23 = strFriend23,@strFriend24 = strFriend24 
		FROM FRIEND_LIST WHERE strUserID = @strUserID
IF (@@ROWCOUNT = 0)
BEGIN
	INSERT INTO FRIEND_LIST (strUserID, strFriend1) VALUES (@strUserID, @strFriend)
	IF (@@ERROR <> 0)
		RETURN 1

	RETURN 0
END
IF (@strFriend1 IS NULL)
	UPDATE FRIEND_LIST SET strFriend1 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend2 IS NULL)
	UPDATE FRIEND_LIST SET strFriend2 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend3 IS NULL)
	UPDATE FRIEND_LIST SET strFriend3 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend4 IS NULL)
	UPDATE FRIEND_LIST SET strFriend4 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend5 IS NULL)
	UPDATE FRIEND_LIST SET strFriend5 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend6 IS NULL)
	UPDATE FRIEND_LIST SET strFriend6 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend7 IS NULL)
	UPDATE FRIEND_LIST SET strFriend7 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend8 IS NULL)
	UPDATE FRIEND_LIST SET strFriend8 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend9 IS NULL)
	UPDATE FRIEND_LIST SET strFriend9 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend10 IS NULL)
	UPDATE FRIEND_LIST SET strFriend10 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend11 IS NULL)
	UPDATE FRIEND_LIST SET strFriend11 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend12 IS NULL)
	UPDATE FRIEND_LIST SET strFriend12 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend13 IS NULL)
	UPDATE FRIEND_LIST SET strFriend13 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend14 IS NULL)
	UPDATE FRIEND_LIST SET strFriend14 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend15 IS NULL)
	UPDATE FRIEND_LIST SET strFriend15 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend16 IS NULL)
	UPDATE FRIEND_LIST SET strFriend16 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend17 IS NULL)
	UPDATE FRIEND_LIST SET strFriend17 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend18 IS NULL)
	UPDATE FRIEND_LIST SET strFriend18 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend19 IS NULL)
	UPDATE FRIEND_LIST SET strFriend19 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend20 IS NULL)
	UPDATE FRIEND_LIST SET strFriend20 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend21 IS NULL)
	UPDATE FRIEND_LIST SET strFriend21 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend22 IS NULL)
	UPDATE FRIEND_LIST SET strFriend22 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend23 IS NULL)
	UPDATE FRIEND_LIST SET strFriend23 = @strFriend WHERE strUserID = @strUserID
ELSE IF (@strFriend24 IS NULL)
	UPDATE FRIEND_LIST SET strFriend24 = @strFriend WHERE strUserID = @strUserID
ELSE
	RETURN 2

IF (@@ERROR <> 0)
	RETURN 1

RETURN 0


GO

-- =============================================
-- Procedure: RESET_LOYALTY_MONTHLY
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[RESET_LOYALTY_MONTHLY]
AS

BEGIN
	UPDATE USERDATA SET LoyaltyMonthly = 0 WHERE LoyaltyMonthly != 0
END

GO

-- =============================================
-- Procedure: DELETE_FRIEND_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Notes :
/* Return values:
0 Successful
1 Failed to delete a buddy.
2 Failed to delete a buddy. Invalid buddy name.
*/
-- =============================================
CREATE PROCEDURE [dbo].[DELETE_FRIEND_LIST]
@strUserID char(21),
@strFriend char(21)
AS

  DECLARE @strFriend1 char(21), @strFriend2 char(21), @strFriend3 char(21), @strFriend4 char(21), @strFriend5 char(21), @strFriend6 char(21)
    DECLARE @strFriend7 char(21), @strFriend8 char(21), @strFriend9 char(21), @strFriend10 char(21), @strFriend11 char(21), @strFriend12 char(21)
      DECLARE @strFriend13 char(21), @strFriend14 char(21), @strFriend15 char(21), @strFriend16 char(21), @strFriend17 char(21), @strFriend18 char(21)
        DECLARE @strFriend19 char(21), @strFriend20 char(21), @strFriend21 char(21), @strFriend22 char(21), @strFriend23 char(21), @strFriend24 char(21) 
  SELECT @strFriend1 = strFriend1, @strFriend2 = strFriend2,@strFriend3 = strFriend3,@strFriend4 = strFriend4,
    @strFriend5 = strFriend5, @strFriend6 = strFriend6,@strFriend7 = strFriend7,@strFriend8 = strFriend8,
      @strFriend9 = strFriend9, @strFriend10 = strFriend10,@strFriend11 = strFriend11,@strFriend12 = strFriend12,
        @strFriend13 = strFriend13, @strFriend14 = strFriend14,@strFriend15 = strFriend15,@strFriend16 = strFriend16,
          @strFriend17 = strFriend17, @strFriend18 = strFriend18,@strFriend19 = strFriend19,@strFriend20 = strFriend20,
            @strFriend21 = strFriend21, @strFriend22 = strFriend22,@strFriend23 = strFriend23,@strFriend24 = strFriend24 
              FROM FRIEND_LIST WHERE strUserID = @strUserID
  IF (@@ROWCOUNT = 0)
    RETURN 1
  IF (@strFriend1 = @strFriend)
    UPDATE FRIEND_LIST SET strFriend1 = NULL WHERE strUserID = @strUserID
      ELSE IF (@strFriend2 = @strFriend)
        UPDATE FRIEND_LIST SET strFriend2 = NULL WHERE strUserID = @strUserID
          ELSE IF (@strFriend3 = @strFriend)
            UPDATE FRIEND_LIST SET strFriend3 = NULL WHERE strUserID = @strUserID
              ELSE IF (@strFriend4 = @strFriend)
                UPDATE FRIEND_LIST SET strFriend4 = NULL WHERE strUserID = @strUserID
                  ELSE IF (@strFriend5 = @strFriend)
                    UPDATE FRIEND_LIST SET strFriend5 = NULL WHERE strUserID = @strUserID
                      ELSE IF (@strFriend6 = @strFriend)
                        UPDATE FRIEND_LIST SET strFriend6 = NULL WHERE strUserID = @strUserID
                          ELSE IF (@strFriend7 = @strFriend)
                            UPDATE FRIEND_LIST SET strFriend7 = NULL WHERE strUserID = @strUserID
                              ELSE IF (@strFriend8 = @strFriend)
                                UPDATE FRIEND_LIST SET strFriend8 = NULL WHERE strUserID = @strUserID
                                  ELSE IF (@strFriend9 = @strFriend)
                                    UPDATE FRIEND_LIST SET strFriend9 = NULL WHERE strUserID = @strUserID
                                      ELSE IF (@strFriend10 = @strFriend)
                                        UPDATE FRIEND_LIST SET strFriend10 = NULL WHERE strUserID = @strUserID
                                          ELSE IF (@strFriend11 = @strFriend)
                                            UPDATE FRIEND_LIST SET strFriend11 = NULL WHERE strUserID = @strUserID
                                              ELSE IF (@strFriend12 = @strFriend)
                                                UPDATE FRIEND_LIST SET strFriend12 = NULL WHERE strUserID = @strUserID
                                                  ELSE IF (@strFriend13 = @strFriend)
                                                    UPDATE FRIEND_LIST SET strFriend13 = NULL WHERE strUserID = @strUserID
                                                      ELSE IF (@strFriend14 = @strFriend)
                                                        UPDATE FRIEND_LIST SET strFriend14 = NULL WHERE strUserID = @strUserID
                                                          ELSE IF (@strFriend15 = @strFriend)
                                                            UPDATE FRIEND_LIST SET strFriend15 = NULL WHERE strUserID = @strUserID
                                                              ELSE IF (@strFriend16 = @strFriend)
                                                                UPDATE FRIEND_LIST SET strFriend16 = NULL WHERE strUserID = @strUserID
                                                                  ELSE IF (@strFriend17 = @strFriend)
                                                                    UPDATE FRIEND_LIST SET strFriend17 = NULL WHERE strUserID = @strUserID
                                                                      ELSE IF (@strFriend18 = @strFriend)
                                                                        UPDATE FRIEND_LIST SET strFriend18 = NULL WHERE strUserID = @strUserID
                                                                          ELSE IF (@strFriend19 = @strFriend)
                                                                            UPDATE FRIEND_LIST SET strFriend19 = NULL WHERE strUserID = @strUserID
                                                                              ELSE IF (@strFriend20 = @strFriend)
                                                                                UPDATE FRIEND_LIST SET strFriend20 = NULL WHERE strUserID = @strUserID
                                                                                  ELSE IF (@strFriend21 = @strFriend)
                                                                                    UPDATE FRIEND_LIST SET strFriend21 = NULL WHERE strUserID = @strUserID
                                                                                      ELSE IF (@strFriend22 = @strFriend)
                                                                                        UPDATE FRIEND_LIST SET strFriend22 = NULL WHERE strUserID = @strUserID
                                                                                          ELSE IF (@strFriend23 = @strFriend)
                                                                                            UPDATE FRIEND_LIST SET strFriend23 = NULL WHERE strUserID = @strUserID
                                                                                              ELSE IF (@strFriend24 = @strFriend)
                                                                                                UPDATE FRIEND_LIST SET strFriend24 = NULL WHERE strUserID = @strUserID
  ELSE
    RETURN 2
      IF (@@ERROR <> 0)
        RETURN 1
          RETURN 0


GO

-- =============================================
-- Procedure: LOAD_DRAKI_TOWER
-- Database: KO_DATABASE_SERVER_001
-- =============================================


CREATE PROCEDURE [dbo].[LOAD_DRAKI_TOWER]
@strCharID char(21)
AS

BEGIN
	SELECT iDrakiTime,bDrakiStage,bDrakiEnteranceLimit FROM USER_DRAKI_TOWER_DATA WHERE strUserID = @strCharID
END

GO

-- =============================================
-- Procedure: KING_CANDIDACY_NOTICE_BOARD_PROC
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 25.12.2017
-- =============================================
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

GO

-- =============================================
-- Procedure: UPDATE_USER_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================

CREATE PROCEDURE [dbo].[UPDATE_USER_DATA]
@strCharID char(21),
@bNation tinyint,
@bRace tinyint,
@sClass smallint,
@nHair int,
@bRank tinyint,
@bTitle tinyint,
@bLevel tinyint,
@bRebirthLeveL tinyint,
@iExp bigint,
@nLoyalty int,
@bFace tinyint,
@bCity tinyint,
@sClanID smallint,
@bFame tinyint,
@sHp smallint,
@sMp smallint,
@sSp smallint,
@bStr tinyint,
@bSta tinyint,
@bDex tinyint,
@bIntel tinyint,
@bCha tinyint,
@bRebStr tinyint,
@bRebSta tinyint,
@bRebDex tinyint,
@bRebIntel tinyint,
@bRebCha tinyint,
@bAuthority tinyint,
@sPoints smallint,		
@nCoins int,
@bZone tinyint,
@sBind smallint,
@iPosX int,
@iPosZ int,
@iPosY int,
@dwTime int,
@strSkill varchar(10),
@strItem binary(600),
@strDeletedItem binary(480),
@strSerial binary(600),
@strItemTime binary(300),
@nMannerPoint int,
@nLoyaltyMonthly int,
@nLastLogin int,
@nDonatedNP int,
@iTimePunishment int
AS

   UPDATE USERDATA SET 
	 Nation = @bNation, 
	 Race	= @bRace,
	 Class = @sClass, 
	 HairRGB = @nHair, 
	 [Rank] = @bRank, 
	 Title = @bTitle, 
	 [Level] = @bLevel, 
	 bRebirthLevel = @bRebirthLeveL,
	 [Exp] = @iExp, 
     Loyalty = @nLoyalty, 
	 Face = @bFace, 
	 City = @bCity, 
	 Knights = @sClanID, 
	 Fame = @bFame, 
	 Hp = @sHp, 
	 Mp = @sMp, 
	 Sp = @sSp, 
	 Strong = @bStr, 
     Sta = @bSta, 
     Dex = @bDex, 
	 Intel = @bIntel, 
	 Cha = @bCha, 
	 bRebStr = @bRebStr, 
	 bRebSta = @bRebSta,
	 bRebDex = @bRebDex,  
	 bRebIntel = @bRebIntel, 
	 bRebCha = @bRebCha, 
	 Authority = @bAuthority, 
	 Points = @sPoints,
	 Gold = @nCoins,
     [Zone] = @bZone, 
     Bind = @sBind, 
	 PX = @iPosX, 
	 PZ  = @iPosZ, 
	 PY = @iPosY, 
	 dwTime = @dwTime, 
	 strSkill = @strSkill, 
	 strItem = @strItem,
	 strDeletedItem = @strDeletedItem, 
	 strSerial = @strSerial,
	 strItemTime = @strItemTime, 
	 MannerPoint = @nMannerPoint, 
	 LoyaltyMonthly = @nLoyaltyMonthly, 
	 dtUpdateTime = GETDATE(),
	 nLastLogin = @nLastLogin,
	 nDonatedNP = @nDonatedNP,
	 TimePunishment = @iTimePunishment WHERE strUserID = @strCharID
  
     UPDATE USER_KNIGHTDATA SET sClanID = @sClanID,nDonatedNP = @nDonatedNP,fame = @bFame,sClass = @sClass,[level] = @bLevel,lastLogin = @nLastLogin,Loyalty = @nLoyalty WHERE strUserID = @strCharID

GO

-- =============================================
-- Procedure: UPDATE_DRAKI_LIMIT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.06.2019
-- Update date: 11.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_DRAKI_LIMIT]
@strCharID char(21),
@DrakiEnteranceLimit tinyint
AS

BEGIN
	UPDATE USER_DRAKI_TOWER_DATA SET bDrakiEnteranceLimit = @DrakiEnteranceLimit WHERE strUserID = @strCharID
END

GO

-- =============================================
-- Procedure: UPDATE_SIEGE
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_SIEGE]
@m_sCastleIndex     smallint,
@m_sMasterKnights   smallint,
@m_bySiegeType		smallint,
@m_byWarDay			smallint,
@m_byWarTime	    smallint,
@m_byWarMinute      smallint 
AS

BEGIN
	    UPDATE KNIGHTS_SIEGE_WARFARE SET bySiegeType = @m_bySiegeType, 
		byWarDay = @m_byWarDay, byWarTime = @m_byWarTime, byWarMinute = @m_byWarMinute,
        sChallengeList_1 = sMasterKnights, sMasterKnights = @m_sMasterKnights, sChallengeList_3 = 0,
        sChallengeList_4 = 0, sChallengeList_5 = 0, sChallengeList_6 = 0,
        sChallengeList_7 = 0, sChallengeList_8 = 0, sChallengeList_9 = 0, sChallengeList_10 = 0
		WHERE sCastleIndex = @m_sCastleIndex
END

GO

-- =============================================
-- Procedure: KING_CANDIDACY_RECOMMEND
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 18.12.2017
-- Update date: 18.12.2017
-- Opcode:
-- +0 : Succes.
-- -1 : ID does ot exits.
-- -2 : Nominations are not accepted at this time.
-- -3 : You do not have the authory to nominate.
-- -4 : You can only nominate a user from the same nation.
-- -5 : This person has already been nominated.
-- -6 : You have failed to register a canditae. Please try again few minutes after.
-- -7 : Candidate number has extended a valid range
-- =============================================
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

GO

-- =============================================
-- Procedure: CREATE_KNIGHTS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Notes:
/* Return values:
0 You are now a leader of a clan. Congratulations!!!
2 Sorry. A weakling like you are not fit to become a leader!!
3 Oh~ I'm sorry, but somebody else is already using that name. Try a different name. 
4 Sorry.  You need %d Coins in order to create a clan. 
5 You can't create a clan because you're already in another clan.
6 Hm.. You can't create a clan right now. Please come back later.
7 You cannot create a clan today. 
8 Creating a clan is only allowed in the 1st server group.
9 Creating a clan is only allowed in the Breth Village/Piana Village.
*/
-- =============================================
CREATE PROCEDURE [dbo].[CREATE_KNIGHTS]
@sClanID smallint,
@bNation tinyint,
@bFlag tinyint,
@strKnightsName char(21),
@strChief char(21)
AS

     DECLARE @bCount tinyint,@ServerNo smallint
       SELECT @bCount = COUNT(*) FROM KNIGHTS WHERE IDNum = @sClanID OR IDName = @strKnightsName
         IF (@bCount > 0)
           RETURN 3
		SELECT @ServerNo = nServerNo FROM CURRENTUSER where strCharID = @strChief
			IF (@ServerNo > 15001)
				RETURN 8
			     IF (@sClanID = 0)
	                RETURN 6
             BEGIN TRAN
               INSERT INTO KNIGHTS (IDNum, Nation, Flag, IDName, Chief) VALUES (@sClanID, @bNation, @bFlag, @strKnightsName, @strChief)
			     UPDATE USER_KNIGHTDATA SET sClanID = @sClanID,Fame = 1 WHERE strUserID = @strChief
			       UPDATE USERDATA SET Knights = @sClanID, Fame = 1 WHERE strUserID = @strChief
                   --INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.KOHSTR_CREATE_CLAN_LOG (UserID,ClanName,CreatedLogTime) VALUES (@strChief,@strKnightsName,GETDATE())
   IF (@@ERROR <> 0)
     BEGIN
       ROLLBACK TRAN
         RETURN 6
           END
             COMMIT TRAN
               RETURN 0

GO

-- =============================================
-- Procedure: UPDATE_USER_SEAL_EXP
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[UPDATE_USER_SEAL_EXP]
@strCharID char(21),
@SealExp int
AS

BEGIN
	UPDATE USER_SEAL_EXP SET sSealedExp = @SealExp WHERE strUserID = @strCharID
END


GO

-- =============================================
-- Procedure: KING_CHANGE_TAX
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROC [dbo].[KING_CHANGE_TAX]
@opcode             tinyint,
@Nation             tinyint,
@TerritoryTariff	int, 
@TerritoryTax	    int
AS

  IF @opcode = 4
    BEGIN
      UPDATE KING_SYSTEM SET byTerritoryTariff = @TerritoryTariff WHERE byNation = @Nation
        END
  IF @opcode = 2
    BEGIN
      UPDATE KING_SYSTEM SET nTerritoryTax = @TerritoryTax WHERE byNation = @Nation
        END


GO

-- =============================================
-- Procedure: LOAD_USER_SEAL_EXP
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[LOAD_USER_SEAL_EXP]
@strCharID char(21)
AS

BEGIN
	SELECT sSealedExp FROM USER_SEAL_EXP WHERE strUserID = @strCharID
END


GO

-- =============================================
-- Procedure: KING_ELECTION_PROC
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 18.12.2017
-- Update date: 18.12.2017
-- =============================================
CREATE PROCEDURE [dbo].[KING_ELECTION_PROC]
@strVoterAccountID	char(21),
@strVoterUserID	    char(21),
@byNation	        tinyint,
@strNominee     	char(21)
AS

  DECLARE @Check smallint
    SELECT @Check = COUNT(strAccountID) FROM KING_BALLOT_BOX WHERE  strAccountID = @strVoterAccountID
      IF @Check > 0
        BEGIN
          RETURN -3
            END
  DECLARE @CheckLevel tinyint
    SELECT @CheckLevel = Level FROM USERDATA WHERE strUserID = @strVoterUserID
      IF (@CheckLevel < 50)
        BEGIN
          RETURN -4
            END
  UPDATE KING_ELECTION_LIST SET nMoney = nMoney +1 WHERE byType = 4 and strName = @strNominee and byNation = @byNation
    INSERT INTO KING_BALLOT_BOX (strAccountID,strUserID,Nation,strCandidateName,LogTime) VALUES (@strVoterAccountID,@strVoterUserID,@byNation,@strNominee,GETDATE())
      RETURN 1

GO

-- =============================================
-- Procedure: MOB_NPC_İNSERT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[MOB_NPC_İNSERT]
@Type int,
@MobID int,
@MobAd int,
@Zone int,
@KX int,
@KZ int,
@XZ int,
@RegT int
AS
 
DECLARE @LeftX int
DECLARE @TopZ int
DECLARE @RightX int
DECLARE @BottomZ int
DECLARE @LimitMinX int
DECLARE @LimitMinZ int
DECLARE @LimitMaxX int
DECLARE @LimitMaxZ int
IF @Type=1
BEGIN
SET @RightX=@KX+23+@XZ
SET @BottomZ =@KZ-24-@XZ
SET @LimitMinX =@KX+2+@XZ
SET @LimitMinZ =@KZ-1-@XZ
SET @LimitMaxX =@KX+25+@XZ
SET @LimitMaxZ =@KZ-26-@XZ
BEGIN
INSERT INTO K_NPCPOS VALUES(@Zone, @MobID,1,0,0,0,0,@KX,@KZ,@RightX,@BottomZ,@LimitMinX,@LimitMinZ,@LimitMaxX,@LimitMaxZ,@MobAd,@RegT,0,0,NULL,1)
END
END
 
IF @Type=2
BEGIN
SET @RightX=@KX
SET @BottomZ =@KZ
SET @LimitMinX =@KX
SET @LimitMinZ =@KZ
SET @LimitMaxX =@KX
SET @LimitMaxZ =@KZ
BEGIN
INSERT INTO K_NPCPOS VALUES(@Zone, @MobID,100,0,0,0,0,@KX,@KZ,@RightX,@BottomZ,@LimitMinX,@LimitMinZ,@LimitMaxX,@LimitMaxZ,1,@RegT,0,0,NULL,1)
END
END
----------------------------- Kullanımı ------------------------------
-- EXEC INMOB_NPC'A','B','C','D','E','F','H','M'

-- A=1 Monster, 2 NPC
-- B=NPC ID --
-- C=Kaç Tane Eklensin
-- D=Zone ID
-- E=Koordinat 1
-- F=Koordinat 2
-- H=Yaratıkların bir birinden ayrık kalması için. Uygun Sayı 5-10 arasıdır.
-- M=Tekrar doğma süresi
------------------------------ Kullanım bitiş -------------------------


GO

-- =============================================
-- Procedure: KING_INSERT_PRIZE_EVENT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 18.12.2017
-- Update date: 18.12.2017
-- =============================================
CREATE PROCEDURE [dbo].[KING_INSERT_PRIZE_EVENT] 
@byType tinyint,
@byNation  tinyint,
@nCoins int,
@strCharID varchar(21)
AS

  DECLARE @nType tinyint
    IF @byType IN(3, 5)
      BEGIN
        SET @nType = @nType + 2
          END
  UPDATE KING_SYSTEM SET nNationalTreasury = @nCoins WHERE byNation = @byNation AND strKingName = @strCharID

GO

-- =============================================
-- Procedure: KING_UPDATE_ELECTION_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 18.12.2017
-- Update date: 18.12.2017
-- =============================================
CREATE PROC [dbo].[KING_UPDATE_ELECTION_LIST]
@byDBType tinyint,
@byType tinyint,
@byNation tinyint,
@sKnights smallint,
@nAmount int,
@strNominee char(21)
AS

  IF (@byDBType = 1)
    BEGIN
      INSERT INTO KING_ELECTION_LIST (byType, byNation, nKnights, nMoney,strName) VALUES (@byType, @byNation, @sKnights,@nAmount, @strNominee)
        END
  IF (@byDBType = 2)
    BEGIN
		DELETE FROM KING_ELECTION_LIST WHERE strName = @strNominee and byType = @byType
		DELETE FROM KING_NOMINATION_LIST WHERE strNominee = @strNominee
        END
  IF @byType = 1
    BEGIN
      UPDATE KING_SYSTEM SET strKingName = @strNominee WHERE byNation = @byNation
        UPDATE USERDATA SET Rank = 1 WHERE strUserID = @strNominee
          END

GO

-- =============================================
-- Procedure: UPDATE_KNIGHT_CASH_ADD
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.1.2018
-- Update date: 13.1.2018
-- =============================================
CREATE PROCEDURE [dbo].[ACCOUNT_ADD_NPOINTS]
@strAccountID varchar(21),
@sNPointAmount smallint
AS

BEGIN
   UPDATE TB_USER SET CashPoint += @sNPointAmount WHERE strAccountID = @strAccountID
END

RETURN 0

GO

-- =============================================
-- Procedure: KING_UPDATE_ELECTION_STATUS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 18.12.2017
-- Update date: 18.12.2017
-- =============================================
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

GO

-- =============================================
-- Procedure: INSERT_USER_DAILY_OP
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_USER_DAILY_OP]
@strCharID char(21),
@iChaosMapTime int,
@iUserRankRewardTime int,
@iPersonalRankRewardTime int,
@iKingWingTime int,
@iWarderKillerTime1 int,
@iWarderKillerTime2 int,
@iKeeperKillerTime int,
@iUserLoyaltyWingRewardTime int
AS

   DELETE FROM USER_DAILY_OP WHERE strUserID = @strCharID
     INSERT INTO USER_DAILY_OP (strUserID, ChaosMapTime, UserRankRewardTime, PersonalRankRewardTime, KingWingTime, WarderKillerTime1, WarderKillerTime2, KeeperKillerTime, UserLoyaltyWingRewardTime) VALUES (@strCharID, @iChaosMapTime, @iUserRankRewardTime, @iPersonalRankRewardTime, @iKingWingTime, @iWarderKillerTime1, @iWarderKillerTime2, @iKeeperKillerTime, @iUserLoyaltyWingRewardTime)

GO

-- =============================================
-- Procedure: UPDATE_USER_DAILY_OP
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_USER_DAILY_OP]
@strCharID char(21),
@bType tinyint,
@iUnixTime int
AS

  IF (@bType = 1)
    UPDATE USER_DAILY_OP SET ChaosMapTime = @iUnixTime WHERE strUserID = @strCharID
      ELSE IF (@bType = 2)
        UPDATE USER_DAILY_OP SET UserRankRewardTime = @iUnixTime WHERE strUserID = @strCharID
          ELSE IF (@bType = 3)
            UPDATE USER_DAILY_OP SET PersonalRankRewardTime = @iUnixTime WHERE strUserID = @strCharID
              ELSE IF (@bType = 4)
                UPDATE USER_DAILY_OP SET KingWingTime = @iUnixTime WHERE strUserID = @strCharID
                  ELSE IF (@bType = 5)
                    UPDATE USER_DAILY_OP SET WarderKillerTime1 = @iUnixTime WHERE strUserID = @strCharID
                      ELSE IF (@bType = 6)
                        UPDATE USER_DAILY_OP SET WarderKillerTime2 = @iUnixTime WHERE strUserID = @strCharID
                          ELSE IF (@bType = 7)
                            UPDATE USER_DAILY_OP SET KeeperKillerTime = @iUnixTime WHERE strUserID = @strCharID
                              ELSE IF (@bType = 8)
                                UPDATE USER_DAILY_OP SET UserLoyaltyWingRewardTime = @iUnixTime WHERE strUserID = @strCharID

GO

-- =============================================
-- Procedure: KING_UPDATE_NOAH_OR_EXP_EVENT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROC [dbo].[KING_UPDATE_NOAH_OR_EXP_EVENT]
@byType tinyint,
@byNation tinyint,
@byAmount tinyint,
@byDay tinyint,
@byHour tinyint,
@byMinute tinyint,
@sDuration	smallint,
@nCoins int
AS

  IF @byType = 1
    BEGIN
      UPDATE KING_SYSTEM SET byNoahEvent = @byAmount, byNoahEvent_Day = @byDay, byNoahEvent_Hour = @byHour, byNoahEvent_Minute = @byMinute, sNoahEvent_Duration = @sDuration, nNationalTreasury = @nCoins WHERE byNation = @byNation
		END
		  ELSE IF @byType = 2
		    BEGIN
		      UPDATE KING_SYSTEM SET byExpEvent = @byAmount, byExpEvent_Day = @byDay, byExpEvent_Hour = @byHour, byExpEvent_Minute = @byMinute, sExpEvent_Duration = @sDuration,nNationalTreasury = @nCoins WHERE byNation = @byNation
		        END

GO

-- =============================================
-- Procedure: UPDATE_USER_KNIGHTS_RANK
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Note : Design By DuslerinSokagi and give TheThyke.Hediye sonrası düzenlemeler bana aittir.
-- =============================================

CREATE PROCEDURE [dbo].[UPDATE_USER_KNIGHTS_RANK]
AS

DECLARE @strUserID char(21),@Loyalty int,@Knights int,@KnightName char(50)
DECLARE @IsValidKnight int,@Index smallint,@IsValidCount tinyint,@nMoney int
DECLARE @RankName varchar(30)

SELECT @IsValidCount = Count(*) FROM USER_KNIGHTS_RANK
	IF @IsValidCount < 200
	BEGIN
		SET @Index = 1
	WHILE @Index < 201
	BEGIN
	IF @Index = 1
	BEGIN
		SET @RankName = 'Gold Knight' 
		SET @nMoney = 1000000
	END
	IF @Index > 1 AND @Index <= 4
	BEGIN
		SET @RankName = 'Silver Knight'
		SET @nMoney = 700000
	END
	IF @Index > 4 AND @Index <= 10
	BEGIN
		SET @RankName = 'Mirage Knight'
		SET @nMoney = 500000 
	END
	IF @Index > 10 AND @Index <= 40
	BEGIN
		SET @RankName = 'Shadow Knight'
		SET @nMoney = 300000 
	END
	IF @Index > 40 AND @Index <= 100
	BEGIN
		SET @RankName = 'Mist Knight'
		SET @nMoney = 200000 
	END
	IF @Index > 100 AND @Index <= 200
	BEGIN
		SET @RankName = 'Training Knight'
		SET @nMoney = 100000 
	END
  
		INSERT INTO USER_KNIGHTS_RANK (shIndex,strName,strElmoUserID,strElmoKnightsName,nElmoLoyalty,strKarusUserID,strKarusKnightsName,nKarusLoyalty,nMoney,sKarusKnights,sElmoKnights) VALUES (@Index,@RankName,NULL,NULL,0,NULL,NULL,0,@nMoney,0,0)
		SET @Index = @Index + 1
	END
	END

	SET @Index = 1
	SET @strUserID = NULL
	SET @Loyalty = 0
	SET @Knights = 0
  
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserID,Loyalty,Knights FROM USERDATA WHERE Nation = 1 AND Authority = 1 ORDER BY Loyalty DESC
OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @KnightName = NULL
		SET @IsValidKnight = 0
	IF @Knights <> 0
	BEGIN
	SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights
	IF @IsValidKnight <> 0
	BEGIN
	SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
	END
	END
   
	UPDATE USER_KNIGHTS_RANK SET sKarusKnights = @Knights, strKarusUserID = @strUserID, strKarusKnightsName = @KnightName, nKarusLoyalty = @Loyalty WHERE shIndex = @Index
	SET @Index = @Index + 1           
	FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
	END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS
	SET @Index = 1
	SET @strUserID = NULL
	SET @Loyalty = 0
	SET @Knights = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserID,Loyalty,Knights FROM USERDATA WHERE Nation = 2 AND Authority = 1 ORDER BY Loyalty DESC
OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
WHILE @@FETCH_STATUS = 0 
	BEGIN
	SET @KnightName = NULL
	SET @IsValidKnight = 0
	IF @Knights <> 0
	BEGIN
	SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights 
	IF @IsValidKnight <> 0
	BEGIN
	SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
	END
	END
		UPDATE USER_KNIGHTS_RANK SET sElmoKnights = @Knights, strElmoUserID = @strUserID, strElmoKnightsName = @KnightName, nElmoLoyalty = @Loyalty WHERE shIndex = @Index
		SET @Index = @Index + 1           
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@Loyalty,@Knights
	END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS

GO

-- =============================================
-- Procedure: UPDATE_USER_PERSONAL_RANK
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Note : Design By DuslerinSokagi and give TheThyke.Hediye sonrası düzenlemeler bana aittir.
-- =============================================

CREATE PROCEDURE [dbo].[UPDATE_USER_PERSONAL_RANK]
AS

BEGIN TRAN
DECLARE 
 @strUserID char(21),
 @LoyaltyMonthly int,
 @Knights int,
 @KnightName char(50),
 @IsValidKnight int,
 @Index smallint,
 @IsValidCount tinyint,
 @RankName varchar(30),
 @DifferenceBetweenUser int

SELECT @IsValidCount = Count(*) FROM USER_PERSONAL_RANK
IF @IsValidCount < 200
BEGIN
	TRUNCATE TABLE USER_PERSONAL_RANK
	SET @Index = 1
WHILE @Index < 201
	BEGIN
	IF @Index = 1
	BEGIN
		SET @RankName = 'Gold Knight'
	END
	IF @Index > 1 AND @Index <= 4
	BEGIN
		SET @RankName = 'Silver Knight'
	END
	IF @Index > 4 AND @Index <= 10
	BEGIN
		SET @RankName = 'Mirage Knight'
	END
	IF @Index > 10 AND @Index <= 40
	BEGIN
		SET @RankName = 'Shadow Knight'
	END
	IF @Index > 40 AND @Index <= 100
	BEGIN
		SET @RankName = 'Mist Knight'
	END
	
	IF @Index > 100 AND @Index <= 200
	BEGIN
		SET @RankName = 'Training Knight'
	END
  
		INSERT INTO USER_PERSONAL_RANK (nRank,strRankName,nElmoUP,strElmoUserID,nElmoLoyaltyMonthly,nElmoCheck,nKarusUP,strKarusUserID,nKarusLoyaltyMonthly,nKarusCheck,nSalary,UpdateDate,sElmoKnights,sKarusKnights) VALUES (@Index,@RankName,0,NULL,0,1000000,0,NULL,0,1000000,1000000,GETDATE(),0,0)
		SET @Index = @Index + 1
	END
	END
 
	SET @Index = 1
	SET @Knights = 0
	SET @strUserID = NULL
	SET @LoyaltyMonthly = 0

DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserID,LoyaltyMonthly,Knights FROM USERDATA WHERE Nation = 1 AND Authority = 1 ORDER BY LoyaltyMonthly DESC

OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@LoyaltyMonthly,@Knights
WHILE @@FETCH_STATUS = 0 
	BEGIN 
SET @KnightName = NULL
SET @IsValidKnight = 0	
	IF @Knights <> 0
	BEGIN
	SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights
	IF @IsValidKnight <> 0
	BEGIN
	SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
	END
	END
		UPDATE USER_PERSONAL_RANK SET strKarusUserID = @strUserID,strKarusClanName = @KnightName, sKarusKnights = @Knights, nKarusUP = @Index, nKarusLoyaltyMonthly = @LoyaltyMonthly WHERE nRank = @Index 
		SET @DifferenceBetweenUser = 0
	IF @Index = 1
	BEGIN
		UPDATE USER_PERSONAL_RANK SET nKarusCheck = 0 WHERE nRank = @Index
	END
	ELSE
	BEGIN
	SELECT @DifferenceBetweenUser = nKarusLoyaltyMonthly FROM USER_PERSONAL_RANK WHERE nRank = @Index + 1  
	SET @DifferenceBetweenUser = @LoyaltyMonthly - @DifferenceBetweenUser  
		UPDATE USER_PERSONAL_RANK SET nKarusCheck = @DifferenceBetweenUser WHERE nRank = @Index + 1     
	END
  
	SET @Index = @Index + 1
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@LoyaltyMonthly,@Knights
	END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS
	SET @Index = 1
	SET @Knights = 0
	SET @strUserID = NULL
	SET @LoyaltyMonthly = 0
DECLARE RANKING_CRS CURSOR FOR
SELECT TOP 200 strUserID,LoyaltyMonthly,Knights FROM USERDATA WHERE Nation = 2 AND Authority = 1 ORDER BY LoyaltyMonthly DESC
OPEN RANKING_CRS
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@LoyaltyMonthly,@Knights
WHILE @@FETCH_STATUS = 0 
	BEGIN
		SET @KnightName = NULL
		SET @IsValidKnight = 0
	IF @Knights <> 0
	BEGIN
	SELECT @IsValidKnight = COUNT(IDName) FROM KNIGHTS WHERE IDNum = @Knights 
	IF @IsValidKnight <> 0
	BEGIN
	SELECT @KnightName = IDName FROM KNIGHTS WHERE IDNum = @Knights
	END
	END
		UPDATE USER_PERSONAL_RANK SET strElmoUserID = @strUserID,strElmoClanName = @KnightName ,sElmoKnights = @Knights, nElmoUP = @Index, nElmoLoyaltyMonthly = @LoyaltyMonthly WHERE nRank = @Index   
		SET @DifferenceBetweenUser = 0
	IF @Index = 1
	BEGIN
		UPDATE USER_PERSONAL_RANK SET nElmoCheck = 0 WHERE nRank = @Index 
	END
	ELSE
	BEGIN
	SELECT @DifferenceBetweenUser = nElmoLoyaltyMonthly FROM USER_PERSONAL_RANK WHERE nRank = @Index + 1
		SET @DifferenceBetweenUser = @LoyaltyMonthly - @DifferenceBetweenUser
		UPDATE USER_PERSONAL_RANK SET nElmoCheck = @DifferenceBetweenUser WHERE nRank = @Index + 1
	END
		SET @Index = @Index + 1           
FETCH NEXT FROM RANKING_CRS INTO @strUserID,@LoyaltyMonthly,@Knights
	END
CLOSE RANKING_CRS
DEALLOCATE RANKING_CRS
		UPDATE USER_PERSONAL_RANK SET nSalary = REPLACE(nElmoLoyaltyMonthly - nKarusLoyaltyMonthly,'-','')
COMMIT TRAN

GO

-- =============================================
-- Procedure: VIP_STORAGE_CANCEL_PASSWORD
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================

CREATE PROCEDURE [dbo].[VIP_STORAGE_CANCEL_PASSWORD]
@strAccountID char(21),
@key tinyint
AS

DECLARE @bCount tinyint
SELECT @bCount = COUNT(strAccountID) FROM VIP_WAREHOUSE WHERE strAccountID = @strAccountID

IF (@bCount = 0)
    RETURN 2
ELSE
	UPDATE VIP_WAREHOUSE SET WipPasswordRequest = @key WHERE strAccountID = @strAccountID

RETURN 1


GO

-- =============================================
-- Procedure: UPDATE_KNIGHTS_RATING
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 29.12.2017
-- Update date: 29.12.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_KNIGHTS_RATING]
AS


BEGIN
	TRUNCATE TABLE KNIGHTS_RATING

	UPDATE KNIGHTS SET 
	Points = (SELECT ISNULL(SUM(Loyalty), 0) FROM USERDATA WHERE Knights = IDNum),
	ClanPointFund = (SELECT ISNULL(SUM(nDonatedNP), 0) FROM USERDATA WHERE Knights = IDNum)

	INSERT INTO KNIGHTS_RATING 
	SELECT ROW_NUMBER() OVER (ORDER BY ClanPointFund DESC, Points DESC), IDNum, IDName, Points, ClanPointFund FROM KNIGHTS ORDER BY ClanPointFund DESC, Points DESC

	UPDATE KNIGHTS SET Ranking = 0 WHERE Ranking != 0
	UPDATE KNIGHTS SET Ranking = (SELECT nRank FROM KNIGHTS_RATING WHERE shIndex = IDNum AND nRank <= 5) WHERE (SELECT nRank FROM KNIGHTS_RATING WHERE shIndex = IDNum AND nRank <= 5) <= 5
END

GO

-- =============================================
-- Procedure: UPDATE_RANKS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[UPDATE_RANKS]
AS


BEGIN
	EXEC UPDATE_USER_KNIGHTS_RANK
	EXEC UPDATE_USER_PERSONAL_RANK
	EXEC UPDATE_KNIGHTS_RATING
END


GO

-- =============================================
-- Procedure: UPDATE_ALL_CHAR_ID
-- Database: KO_DATABASE_SERVER_001
-- =============================================



/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 29.12.2017
-- =============================================
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

GO

-- =============================================
-- Procedure: SAVE_PREMIUM_SERVICE_USER_V2
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[SAVE_PREMIUM_SERVICE_USER_V2]
@strAccountID char(20),
@strPremium binary(30),
@Counter int,
@bPremiumInUse tinyint,
@time int
AS

BEGIN
	UPDATE ACCOUNT_PREMIUM_DATA SET strPremium = @strPremium, sPremiumCount = @Counter,sPremiumInUse = @bPremiumInUse,sPremiumTime = @time WHERE strAccountID = @strAccountID
END


GO

-- =============================================
-- Procedure: LOAD_NEW_CHAR_VALUE
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_NEW_CHAR_VALUE]
@CharID varchar(20),
@Class smallint
AS

DECLARE @JobType tinyint, @Level tinyint, @Exp bigint
DECLARE @Strength tinyint, @Health tinyint, @Dexterity tinyint, @Intelligence tinyint, @MagicPower tinyint, @FreePoints smallint
DECLARE @SkillPointFree tinyint, @SkillPointCat1 tinyint, @SkillPointCat2 tinyint, @SkillPointCat3 tinyint, @SkillPointMaster tinyint
DECLARE @binarySkill binary(10)
DECLARE @strQuest binary(600)
DECLARE @sQuestCount smallint, @sHP smallint, @sMP smallint
DECLARE @TempClass smallint

DECLARE @Gold int
SET @sQuestCount  = 0

SELECT @JobType = JobType, @Level = [Level], @FreePoints = FreePoints, @SkillPointFree = SkillPointFree, @SkillPointCat1 = SkillPointCat1, @SkillPointCat2 = SkillPointCat2, @SkillPointCat3 = SkillPointCat3, @SkillPointMaster = SkillPointMaster, @Gold = Gold FROM NEW_CHAR_VALUE WHERE ClassType = @Class % 100;

IF (@@ROWCOUNT = 0)
	RETURN

IF (@JobType = 1) -- Skilled
BEGIN
	IF (@Class % 100 = 1) -- Warrior
		SET @Class += 4
	ELSE IF (@Class % 100 = 2) -- Rogue
		SET @Class += 5
	ELSE IF (@Class % 100 = 3) -- Magician
		SET @Class += 6
	ELSE IF (@Class % 100 = 4) -- Priest
		SET @Class += 7
	ELSE IF (@Class % 100 = 13) -- Kurian
		SET @Class += 1
	
END
ELSE IF (@JobType = 2) -- Mastered
BEGIN
	IF (@Class % 100 = 1) -- Warrior
		SET @Class += 5
	ELSE IF (@Class % 100 = 2) -- Rogue
		SET @Class += 6
	ELSE IF (@Class % 100 = 3) -- Magician
		SET @Class += 7
	ELSE IF (@Class % 100 = 4) -- Priest
		SET @Class += 8
	ELSE IF (@Class % 100 = 13) -- Kurian
		SET @Class += 2

	SET @sQuestCount = 1
	SET @strQuest = SUBSTRING(CAST(71 AS VARBINARY(2)),2,1) + SUBSTRING(CAST(71 AS VARBINARY(2)),1,1) + CAST(2 AS VARBINARY(1))

END

IF (@Gold > 0)
	UPDATE USERDATA SET Gold = @Gold WHERE strUserID = @CharID

IF (@Level > 0)
	UPDATE USERDATA SET [Level] = @Level WHERE strUserID = @CharID

IF (@FreePoints > 0)
	UPDATE USERDATA SET Points = @FreePoints WHERE strUserID = @CharID

SET @binarySkill = CONVERT(VARBINARY(1), @SkillPointFree) -- Free points
SET @binarySkill += CONVERT(VARBINARY(4), 0) -- Command, Politics, Language, Siege weapon
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat1) -- Skill 1
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat2) -- Skill 2
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointCat3) -- Skill 3
SET @binarySkill += CONVERT(VARBINARY(1), @SkillPointMaster) -- Master
SET @binarySkill += CONVERT(VARBINARY(1), 0) -- Padding

UPDATE USERDATA SET Class = @Class, strSkill = @binarySkill WHERE strUserID = @CharID

GO

-- =============================================
-- Procedure: LOAD_PREMIUM_SERVICE_USER_V2
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_PREMIUM_SERVICE_USER_V2]
@strAccountID char(20)
AS

BEGIN
	SELECT sPremiumInUse,sPremiumCount,strPremium FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
END


GO

-- =============================================
-- Procedure: AUTHORITY_CHANGE_UPDATE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 01.05.2018
-- +
-- =============================================
CREATE PROCEDURE [dbo].[AUTHORITY_CHANGE_UPDATE]
@strAccountID char(21),
@GameMaster char(21),
@nAuthority smallint,
@reason varchar(100),
@strUserID char(21)
AS

IF (@nAuthority = 255)
BEGIN
	UPDATE [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL SET BanCount +=1 WHERE strAccountID = @strAccountID
END
ELSE IF (@nAuthority = 1)
BEGIN
	UPDATE [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL SET OpenCount +=1 WHERE strAccountID = @strAccountID
END

BEGIN
	UPDATE [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL SET BanGameMasterName = @GameMaster,isAuthority = @nAuthority, BanReason = @reason, UpdateTime = GETDATE() WHERE strAccountID = @strAccountID
END

INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.ACCOUNT_BLOCKED_DATA (AccountID, UserID, GameMaster, reason,CreatedTime) VALUES (@strAccountID, @strUserID, @GameMaster,@reason,GETDATE())



GO

-- =============================================
-- Procedure: ACCOUNT_PREMIUM_V2
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 05.01.2017
-- Update date: 19.08.2019
-- =============================================
CREATE PROCEDURE [dbo].[ACCOUNT_PREMIUM_V2]
@strAccountID char(20)
AS

DECLARE @AccountPremium tinyint,@PremiumOkey tinyint, @sHours int,@HoursSetting int

BEGIN TRAN
	SELECT @AccountPremium = COUNT(strAccountID) FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
	IF (@AccountPremium = 0)
	BEGIN
		INSERT INTO ACCOUNT_PREMIUM_DATA (strAccountID,strPremium,sPremiumCount,sPremiumInUse,sPremiumTime) VALUES (@strAccountID,0x00,0,0,0)
	END

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
COMMIT TRAN

DECLARE @BinaryLoopType int = 1,@BinaryLoopTime int = 2,@Dongu int = 1,@test int = 0
DECLARE @SorguPremiumType int = 0,@PremiumType1 int = 0,@PremiumType2 int = 0,@PremiumType3 int = 0,@PremiumType4 int = 0,@PremiumType5 int = 0
DECLARE @SorguPremiumTime int  = 0,@PremiumTime1 int  = 0,@PremiumTime2  int = 0,@PremiumTime3 int  = 0,@PremiumTime4 int  = 0,@PremiumTime5 int  = 0, @CurrentUnixTime int = 0, @OnlyPremiumTime int = 0, @ShowPremiumTime int = 0
DECLARE @PremiumInUse tinyint
DECLARE @Premium binary(30)

SELECT @PremiumInUse = sPremiumInUse,@PremiumOkey = sPremiumCount,@Premium = strPremium FROM ACCOUNT_PREMIUM_DATA WHERE strAccountID = @strAccountID
IF (@PremiumOkey = 0)
	RETURN -1

WHILE (@Dongu < 6)
BEGIN
	SET @SorguPremiumType = CAST(CAST(REVERSE(SUBSTRING(@Premium, @BinaryLoopType, 1)) AS varbinary) AS int)
	SET @SorguPremiumTime = CAST(CAST(REVERSE(SUBSTRING(@Premium, @BinaryLoopTime, 4)) AS varbinary) AS int)

	IF (@Dongu = 6)
		BREAK

	IF (@SorguPremiumType > 0 AND @Dongu = 1)
	BEGIN
		SET @PremiumType1 = @SorguPremiumType
		SET @PremiumTime1 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 2)
	BEGIN
		SET @PremiumType2 = @SorguPremiumType
		SET @PremiumTime2 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 3)
	BEGIN
		SET @PremiumType3 = @SorguPremiumType
		SET @PremiumTime3 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 4)
	BEGIN
		SET @PremiumType4 = @SorguPremiumType
		SET @PremiumTime4 = @SorguPremiumTime
		SET @test = 1
	END

	IF (@SorguPremiumType > 0 AND @Dongu = 5)
	BEGIN
		SET @PremiumType5 = @SorguPremiumType
		SET @PremiumTime5 = @SorguPremiumTime
		SET @test = 1
	END

	SET @BinaryLoopType += 5
	SET @BinaryLoopTime += 5
	SET @Dongu += 1
END

IF (@test = 0)
	RETURN -1

SET @CurrentUnixTime = DATEDIFF(s, '1970-01-01', GETUTCDATE())
IF (@CurrentUnixTime = 0)
	RETURN -1

IF (@PremiumInUse = @PremiumType1 AND @PremiumTime1 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime1 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType2 AND @PremiumTime2 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime2 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType3 AND @PremiumTime3 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime3 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType4 AND @PremiumTime4 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime4 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE IF (@PremiumInUse = @PremiumType5 AND @PremiumTime5 > 0)
BEGIN
	SET @OnlyPremiumTime = (@PremiumTime5 - @CurrentUnixTime)
	SET @ShowPremiumTime = (@OnlyPremiumTime / 3600)
END
ELSE
	RETURN -1

IF (@ShowPremiumTime <= 0)
	RETURN -1
	
IF (@OnlyPremiumTime >= 1 AND @OnlyPremiumTime <= 3600)
	SET @ShowPremiumTime = 1

RETURN @ShowPremiumTime

GO

-- =============================================
-- Procedure: LOAD_WEB_ITEMMALL
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_WEB_ITEMMALL]
@strCharID	char(21)
AS

BEGIN TRAN
	SELECT strAccountID, ItemID, ItemCount, BuyTime, itemtime FROM WEB_ITEMMALL WHERE strCharID = @strCharID
	DELETE FROM WEB_ITEMMALL WHERE strCharID = @strCharID
COMMIT TRAN

GO

-- =============================================
-- Procedure: CHARACTER_SEAL_ITEM_CHECK
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[CHARACTER_SEAL_ITEM_CHECK]
@CharID varchar(20)
AS

DECLARE @binaryLoop int = 1
DECLARE @ItemID int

WHILE (@binaryLoop < 600)
BEGIN
	SELECT 
	@ItemID = /*ItemID*/CAST(CAST(REVERSE(SUBSTRING(strItem, @binaryLoop, 4)) AS VARBINARY) AS INT)
	FROM [KO_DATABASE_SERVER_001].dbo.USERDATA WHERE (CAST(CAST(REVERSE(SUBSTRING(strItem, @binaryLoop, 4)) AS VARBINARY) AS INT)) <> 0 AND strUserID = @CharID

	SET @binaryLoop += 8

	IF (@ItemID != 0)
		RETURN 0
END

SET @binaryLoop = 1

RETURN 1

GO

-- =============================================
-- Procedure: LOAD_GENIE_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 15.10.2018
-- Update date: 15.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_GENIE_DATA]
@strUserID char(21)
AS

DECLARE @Count smallint
SELECT @Count = COUNT(strUserID) FROM USER_GENIE_DATA WHERE strUserID = @strUserID

IF (@Count = 0)
BEGIN
	INSERT INTO USER_GENIE_DATA (strUserID,sGenieTime,strGenieOptions,sFirstUsingGenie) VALUES (@strUserID,0,0x00,0)
	SELECT sGenieTime,strGenieOptions,sFirstUsingGenie FROM USER_GENIE_DATA WHERE strUserID = @strUserID
END
ELSE
BEGIN
	SELECT sGenieTime,strGenieOptions,sFirstUsingGenie FROM USER_GENIE_DATA WHERE strUserID = @strUserID
END

GO

-- =============================================
-- Procedure: UPDATE_GENIE_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[UPDATE_GENIE_DATA]
@strUserID char(21),
@strGenieOptions binary(100),
@sGenieTime	smallint,
@First tinyint
AS

BEGIN
	UPDATE USER_GENIE_DATA SET sGenieTime = @sGenieTime , strGenieOptions = @strGenieOptions, sFirstUsingGenie = @First WHERE strUserID = @strUserID
END

GO

-- =============================================
-- Procedure: CREATE_NEW_PET
-- Database: KO_DATABASE_SERVER_001
-- =============================================


CREATE PROCEDURE [dbo].[CREATE_NEW_PET]
@nSerialID bigint,
@bStartLevel tinyint,
@strPetName varchar(50)
AS

DECLARE @nIndex int,@PetName varchar(15)
SELECT @PetName = count(*) FROM PET_USER_DATA WHERE sPetName = @strPetName

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
		RETURN 4

	IF (@PetName > 0)
		RETURN 2

BEGIN
	SET NOCOUNT ON;

	SELECT @nIndex = count(*) from PET_USER_DATA
	SET @nIndex = @nIndex + 10
END

DECLARE @sMaxHP int, @sMaxMP int, @sAttack int, @sDefense int, @bRes tinyint, @nExp int
SELECT @sMaxHP = PetMaxHp, @sMaxMP = PetMaxSp, @sAttack = PetAttack, @sDefense = PetDefence, @bRes = PetRes, @nExp = PetExp FROM PET_STATS_INFO WHERE PetLevel = @bStartLevel	

BEGIN TRANSACTION
	INSERT INTO PET_USER_DATA VALUES (@nSerialID, @strPetName, @bStartLevel, @sMaxHP, @sMaxMP, 0x00, @nIndex, 9000, @nExp, 25500, 100)

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 1
	END
COMMIT TRANSACTION

RETURN @nIndex


GO

-- =============================================
-- Procedure: KNIGHTS_ALLIANCE_UPDATE_ALLIANCENOTICE
-- Database: KO_DATABASE_SERVER_001
-- =============================================



/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 10.1.2018
-- Update date: 10.1.2018
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_ALLIANCE_UPDATE_ALLIANCENOTICE]
@sClanID smallint,
@strClanNotice char(128)
AS
-------------------------------------------------------------------------------------------------------
	BEGIN
		UPDATE KNIGHTS_ALLIANCE SET strAllianceNotice = @strClanNotice WHERE sMainAllianceKnights = @sClanID
	END
-------------------------------------------------------------------------------------------------------
--TheThyke

GO

-- =============================================
-- Procedure: DELETE_PET
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[DELETE_PET]
@nSerialID bigint,
@strPetName varchar(50)
AS


GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER_RESET
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER_RESET]
AS

BEGIN
	TRUNCATE TABLE KNIGHTS_SIEGE_WARFARE_REGISTER
END

GO

-- =============================================
-- Procedure: SELECT_CHARACTER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.06.2018
-- Update date: 28.06.2018
-- Notes :
/* Return values: 
0 cannot select the character.
1 Successful
2 Your account is currently blocked. Please contact customer support.
3 Another player is already using the ID you entered. Please try a different ID.
4 You must complete Discipline Dungeon Quest of the following character.
5 It is currently shut-down maintenance time.Please login after 06:00
6 Disconnect From Server
*/
-- =============================================
CREATE PROCEDURE [dbo].[SELECT_CHARACTER]
@strAccountID varchar(20),
@strUserID varchar(20)
AS

DECLARE @CharID1 char(21), @CharID2 char(21), @CharID3 char(21),@CharID4 char(21), @strAuthorıty tinyint, @Authority tinyint, @MaintenanceMode tinyint,@AccountID smallint,@Zone1 tinyint,@Zone2 tinyint,@Zone3 tinyint,@Zone4 tinyint,@CharNameCount smallint,@CharacterSelectLogin smallint
DECLARE @ZONE_PRISON tinyint = 92

SELECT @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''), @CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
SELECT @Zone1 = [Zone] FROM USERDATA WHERE strUserID = @CharID1 AND strUserID IS NOT NULL
SELECT @Zone2 = [Zone] FROM USERDATA WHERE strUserID = @CharID2 AND strUserID IS NOT NULL
SELECT @Zone3 = [Zone] FROM USERDATA WHERE strUserID = @CharID3 AND strUserID IS NOT NULL
SELECT @Zone4 = [Zone] FROM USERDATA WHERE strUserID = @CharID4 AND strUserID IS NOT NULL
	
IF (@strUserID NOT IN(@CharID1, @CharID2, @CharID3,@CharID4))
BEGIN
	RETURN 0
END

SELECT @MaintenanceMode = MaintenanceMode FROM [KO_DATABASE_MAIN].dbo.GAME_OPTIONS
IF (@MaintenanceMode = 1)
BEGIN
	SELECT @AccountID = COUNT(GmLoginID) FROM [KO_DATABASE_MAIN].dbo.GM_MAINTENANCE_LOGIN WHERE GmLoginID = @strAccountID  
	IF (@AccountID = 0)
	BEGIN
		RETURN 5
	END
END

SELECT @CharacterSelectLogin = CharacterSelectLogin FROM [KO_DATABASE_MAIN].dbo.GAME_OPTIONS
IF (@CharacterSelectLogin = 1)
BEGIN
	IF (@AccountID = 0)
	BEGIN
		RETURN 6
	END
END

SELECT @strAuthorıty = strAuthority FROM TB_USER WHERE strAccountID = @strAccountID
IF (@strAuthorıty = 255)
BEGIN
	RETURN 2
END

SELECT @Authority = Authority FROM USERDATA WHERE strUserID = @strUserID
IF (@Authority = 255)
BEGIN
	RETURN 2
END

SELECT @CharNameCount = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strUserID
IF (@CharNameCount >= 2)
BEGIN
	RETURN 3
END

IF (@Zone1 = @ZONE_PRISON  or @Zone2 = @ZONE_PRISON  or @Zone3 = @ZONE_PRISON  or @Zone4 = @ZONE_PRISON)
BEGIN
	IF (@CharID1 <> '')
	BEGIN
		SELECT @Zone1 = [Zone] FROM USERDATA WHERE strUserID = @CharID1
		IF (@Zone1 != @ZONE_PRISON AND @CharID1 = @strUserID)
			RETURN 4
	END

	IF (@CharID2 <> '')
	BEGIN
		SELECT @Zone2 = [Zone] FROM USERDATA WHERE strUserID = @CharID2
		IF (@Zone2 != @ZONE_PRISON AND @CharID2 = @strUserID)
			RETURN 4
	END

	IF (@CharID3 <> '')
	BEGIN
		SELECT @Zone3 = [Zone] FROM USERDATA WHERE strUserID = @CharID3
		IF (@Zone3 != @ZONE_PRISON AND @CharID3 = @strUserID)
			RETURN 4
	END

	IF (@CharID4 <> '')
	BEGIN
		SELECT @Zone4 = [Zone] FROM USERDATA WHERE strUserID = @CharID4
		IF (@Zone4 != @ZONE_PRISON AND @CharID4 = @strUserID)
			RETURN 4
		END
END

RETURN 1

GO

-- =============================================
-- Procedure: UPDATE_USER_PET
-- Database: KO_DATABASE_SERVER_001
-- =============================================


-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_USER_PET]
@nSerialID bigint,
@strPetName varchar(50),
@bLevel tinyint,
@sHP smallint,
@sMP smallint,
@sSatisfaction smallint,
@nExp int,
@sPid smallint,
@sSize smallint,
@sItems binary(81)
AS

UPDATE PET_USER_DATA
SET
sPetName = @strPetName,
bLevel = @bLevel,
sHP = @sHP,
sMP = @sMP,
sSatisfaction = @sSatisfaction,
nExp = @nExp,
sPid = @sPid,
sSize = @sSize,
sItems = @sItems
WHERE nSerialID = @nSerialID




GO

-- =============================================
-- Procedure: AUTHORITY_CHANGE
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 19.12.2017
-- Update date: 01.05.2018
-- +
-- =============================================
CREATE PROCEDURE [dbo].[AUTHORITY_CHANGE]
@strUserID char(21),
@GameMaster char(21),
@reason varchar(50),
@nAuthority smallint,
@iPeriod int,
@banType tinyint
AS

DECLARE @sRet tinyint 
DECLARE @strAccountID char(21)
SELECT @strAccountID = strAccountID from ACCOUNT_CHAR where strCharID1 = @strUserID or strCharID2 = @strUserID or strCharID3 = @strUserID or strCharID4 = @strUserID

DECLARE @KarakterName char(21),@KarakterAuthority smallint
SELECT @KarakterName = COUNT(strUserID) FROM USERDATA WHERE strUserID = @strUserID

DECLARE @R smallint
SELECT @R = isAuthority FROM [KO_DATABASE_MAIN].dbo.ACCOUNT_LOGIN_CONTROL where strAccountID = @strAccountID

DECLARE @R2 smallint

SELECT @R2 = Authority FROM USERDATA WHERE strUserID = @strUserID

SELECT @KarakterAuthority = Authority FROM USERDATA WHERE strUserID = @strUserID

IF (@KarakterName = 0)
BEGIN
	SELECT sRet = 1, strRealUserID = @strUserID,strAccountID = @strAccountID
	RETURN
END

IF (@KarakterAuthority = 0)
BEGIN
	SELECT sRet = 2, strRealUserID = @strUserID,strAccountID = @strAccountID
	RETURN
END

IF (@banType = 0 or @banType = 1)
BEGIN
	IF (@R = @nAuthority)
	BEGIN
		SELECT sRet = 3, strRealUserID = @strUserID,strAccountID = @strAccountID
		RETURN
	END
END

IF (@banType = 5 or @banType = 6 or @banType = 7 or @banType = 8)
BEGIN
	IF (@R2 = @nAuthority)
	BEGIN
		SELECT sRet = 3, strRealUserID = @strUserID,strAccountID = @strAccountID
		RETURN
	END
END

IF (@banType = 5 or @banType = 6 or @banType = 7 or @banType = 8)
BEGIN
	UPDATE USERDATA SET Authority = @nAuthority,TimePunishment = @iPeriod WHERE strUserID = @strUserID
END

IF (@banType = 0 or @banType = 1)
BEGIN
	EXEC AUTHORITY_CHANGE_UPDATE @strAccountID , @GameMaster,@nAuthority, @reason, @strUserID
END	

SELECT sRet = 0, strRealUserID = @strUserID,strAccountID = @strAccountID


GO

-- =============================================
-- Procedure: CREATE_ESN
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE [dbo].[CREATE_ESN] -- USKO PANEL ESN KIRDIRMA
	@CashAmount int,
	@CashCount smallint,
	@Descaptaion varchar(150)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @i as smallint,@serialpart1 as varchar(10),@serialpart2 as varchar(10),@serialpart3 as varchar(10),@serialpart4 as varchar(10),@SerialCode as varchar(120)
	SET @i=0
	while @i < @CashCount
	BEGIN

	/*
	CREATE TABLE [dbo].[_PUS_CODE](
	[CharID] [varchar](21) NULL,
	[AccountID] [varchar](21) NULL,
	[SerialCode] [varchar](150) NULL,
	[Descaption] [varchar](150) NULL,
	[Cashpoint] [int] NULL,
	[Used] [smallint] NULL,
	[UsedTime] [varchar](21) NULL,
	[UsedIP] [varchar](21) NULL
) ON [PRIMARY]
GO
	*/

		SET @serialpart1 = substring(convert(varchar(36), newid()),0,5)
		SET @serialpart2 = substring(convert(varchar(36), newid()),0,5)
		SET @serialpart3 = substring(convert(varchar(36), newid()),0,5)
		SET @serialpart4 = substring(convert(varchar(36), newid()),0,5)
		SET @SerialCode = ''+@serialpart1+'-'+@serialpart2+'-'+@serialpart3+'-'+@serialpart4
		INSERT INTO PPCARD_LIST(PPKeyCode,KnightCash,status) values (ltrim(rtrim(@SerialCode)),@CashAmount,0)
		print 'KESN codigo serial: '+@SerialCode+' amount '+convert(varchar,@CashAmount)
	SET @i = @i+1
	END
	print 'Total '+convert(varchar,@CashCount)+' KSN codes have been created'
END

GO

-- =============================================
-- Procedure: LOAD_USER_RETURN_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 03.10.2018
-- Update date: 03.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_USER_RETURN_DATA]
@CharID char(21)
AS

BEGIN
	SELECT ReturnSymbolisOK,ReturnisLogOutTime,ReturnSymbolTime FROM USER_RETURN_DATA WHERE strCharID = @CharID
END

GO

-- =============================================
-- Procedure: LOAD_DRAKI_MONSTER_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 06.07.2018
-- Update date: 06.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_DRAKI_MONSTER_LIST]
AS

BEGIN
   SELECT * FROM DRAKI_MONSTER_LIST
END


GO

-- =============================================
-- Procedure: UPDATE_USER_RETURN_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 03.10.2018
-- Update date: 03.10.2018
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_USER_RETURN_DATA]
@CharID char(21),
@isOK int,
@loqtime bigint,
@symboltime bigint
AS

BEGIN
	UPDATE USER_RETURN_DATA SET ReturnSymbolisOK = @isOK,ReturnisLogOutTime = @loqtime,ReturnSymbolTime = @symboltime WHERE strCharID = @CharID
END


GO

-- =============================================
-- Procedure: LOAD_DRAKI_TOWER_STAGES
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 06.07.2018
-- Update date: 06.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_DRAKI_TOWER_STAGES]
AS

BEGIN
   SELECT* FROM DRAKI_TOWER_STAGES
END


GO

-- =============================================
-- Procedure: UPDATE_RANKS_UNLOAD
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_RANKS2]
AS

BEGIN
	EXEC UPDATE_USER_KNIGHTS_RANK
	EXEC UPDATE_USER_PERSONAL_RANK
	EXEC UPDATE_KNIGHTS_RATING
END

GO

-- =============================================
-- Procedure: USER_ITEM_SEAL_PASSWORD
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 07.07.2018
-- Update date: 07.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[USER_ITEM_SEAL_PASSWORD]
@strAccountID varchar(21),
@strPasswd char(8)
AS

DECLARE @strSealPasswd char(8)
SELECT @strSealPasswd = strSealPasswd FROM TB_USER WHERE strAccountID = @strAccountID
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	RETURN 2

IF (@strSealPasswd <> @strPasswd)
	RETURN 2

RETURN 0

GO

-- =============================================
-- Procedure: CHARACTER_SEAL_PROCEED
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 07.07.2018
-- Update date: 07.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[CHARACTER_SEAL_PROCEED]
@strAccountID varchar(21),
@strUserID char(21),
@nItemSerial bigint
AS

DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20), @CharID4 varchar(20)

SELECT @CharID1 = ISNULL(strCharID1, ''), @CharID2 = ISNULL(strCharID2, ''), @CharID3 = ISNULL(strCharID3, ''), @CharID4 = ISNULL(strCharID4, '') FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID

IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	RETURN 2

BEGIN TRANSACTION
	IF (@CharID1 <> '' AND @strUserID = @CharID1)
		UPDATE ACCOUNT_CHAR SET strCharID1 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID
	ELSE IF (@CharID2 <> '' AND @strUserID = @CharID2)
		UPDATE ACCOUNT_CHAR SET strCharID2 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID
	ELSE IF (@CharID3 <> '' AND @strUserID = @CharID3)
		UPDATE ACCOUNT_CHAR SET strCharID3 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID
	ELSE IF (@CharID4 <> '' AND @strUserID = @CharID4)
		UPDATE ACCOUNT_CHAR SET strCharID4 = NULL, bCharNum -= 1 WHERE strAccountID = @strAccountID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	INSERT INTO USER_CHARACTER_SEAL_ITEMS (strUserID,strAccountID,nItemSerial) VALUES (@strUserID,@strAccountID,@nItemSerial)

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.CHARACTER_SEAL_LOG (strAccountID, strUserID, nSerialNum, SeatType,SealTypeDescription) VALUES (@strAccountID, @strUserID, @nItemSerial,2,'Character Seal')

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

COMMIT TRANSACTION

RETURN 1

GO

-- =============================================
-- Procedure: CHARACTER_UNSEAL_PROCEED
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 07.07.2018
-- Update date: 07.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[CHARACTER_UNSEAL_PROCEED]
@strAccountID varchar(21),
@Index tinyint,
@nItemSerial bigint
AS

DECLARE @AccountNation tinyint, @CharNum tinyint
DECLARE @CharID1 varchar(20), @CharID2 varchar(20), @CharID3 varchar(20), @CharID4 varchar(20)

SELECT @AccountNation = bNation, @CharNum = bCharNum, @CharID1 = strCharID1, @CharID2 = strCharID2, @CharID3 = strCharID3, @CharID4 = strCharID4 FROM ACCOUNT_CHAR WHERE strAccountID = @strAccountID
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0 OR @CharNum = 4)
	RETURN 2

DECLARE @strUserID char(21)
SELECT @strUserID = strUserID FROM USER_CHARACTER_SEAL_ITEMS WHERE strAccountID = @strAccountID AND nItemSerial = @nItemSerial
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	RETURN 2

DECLARE @Nation tinyint, @CypherRingSerial bigint
SELECT @Nation = Nation FROM USERDATA WHERE strUserID = @strUserID
SELECT @CypherRingSerial = nItemSerial FROM USER_CHARACTER_SEAL_ITEMS WHERE strUserID = @strUserID
IF (@@ERROR <> 0 OR @@ROWCOUNT = 0 OR @CypherRingSerial = 0 OR @AccountNation != @Nation)
	RETURN 2

BEGIN TRANSACTION
	IF (@Index = 0 AND @CharID1 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID1 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@Index = 1 AND @CharID2 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID2 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@Index = 2 AND @CharID3 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID3 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID
	ELSE IF (@Index = 3 AND @CharID4 IS NULL)
		UPDATE ACCOUNT_CHAR SET strCharID4 = @strUserID, bCharNum += 1 WHERE strAccountID = @strAccountID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	DELETE FROM USER_CHARACTER_SEAL_ITEMS WHERE strAccountID = @strAccountID AND nItemSerial = @nItemSerial AND strUserID = @strUserID

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END

	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.CHARACTER_SEAL_LOG (strAccountID, strUserID, nSerialNum, SeatType,SealTypeDescription) VALUES (@strAccountID, @strUserID, @nItemSerial,3,'Character Use Ring (UnSeal)')

	IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
	BEGIN
		ROLLBACK TRANSACTION
		RETURN 2
	END
COMMIT TRANSACTION

RETURN 1

GO

-- =============================================
-- Procedure: CHARACTER_SEAL_LOAD_USER_DATA
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 07.07.2018
-- Update date: 07.07.2018
-- =============================================
CREATE PROCEDURE [dbo].[CHARACTER_SEAL_LOAD_USER_DATA]
@strAccountID varchar(21),
@strUserID char(21)
AS

SELECT Race,Class,HairRGB,[Rank],Title,[Level],bRebirthLevel,[Exp],Loyalty,Face,City,Knights,Fame,Hp,Mp,Sp,Strong,Sta,Dex,Intel,Cha,bRebStr,bRebSta,bRebDex,bRebIntel,bRebCha,Authority,Points,Gold,[Zone],strSkill,strItem,strSerial,strItemTime,MannerPoint,LoyaltyMonthly FROM USERDATA WHERE strUserID = @strUserID

--SELECT strUserID,strAccountID,nItemSerial FROM USER_CHARACTER_SEAL_ITEMS WHERE strUserID = @strUserID AND strAccountID = @strAccountID

GO

-- =============================================
-- Procedure: INSERT_CURRENTUSER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_CURRENTUSER]
@AccountID	varchar(50),
@CharID	varchar(50),
@ServerNo 	int, 
@ServerIP	varchar(50),
@ClientIP	varchar(50),
@nRet		smallint output 
AS

  INSERT INTO CURRENTUSER (strAccountID, strCharID, nServerNo, strServerIP, strClientIP) VALUES (@AccountID, @CharID, @ServerNo, @ServerIP, @ClientIP)
    SET @nRet =1
      RETURN

GO

-- =============================================
-- Procedure: LOAD_GAMEMASTER_SETTINGS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
CREATE PROCEDURE [dbo].[LOAD_GAMEMASTER_SETTINGS]
@strAccountID char(21),
@strCharID char(21),
@ServerNo smallint
AS

DECLARE @Count smallint,@Count2 smallint

SELECT @Count = COUNT(*) FROM [KO_DATABASE_MAIN].dbo.GAME_MASTER_SETTINGS WHERE strCharID = @strCharID AND sServerNo = @ServerNo AND strAccountID = @strAccountID
IF (@Count = 0)
BEGIN
	INSERT INTO [KO_DATABASE_MAIN].dbo.GAME_MASTER_SETTINGS (strAccountID,strCharID,sServerNo) VALUES (@strAccountID,@strCharID,@ServerNo)
END

BEGIN
	SELECT 
	sMute,
	sUnMute,
	sUnBan,
	sBanPermit,
	sAllowAttack,
	sDisabledAttack,
	sNpAdd,
	sExpAdd,
	sMoneyAdd,
	sLoyaltyChange,
	sExpChange,
	sMoneyChange,
	sGiveItem,
	sGiveItemSelf,
	sSummonUser,
	sTpOnUser,
	sZoneChange,
	sLocationChange,
	sMonsterSummon,
	sNpcSummon,
	sMonKilled,
	sTeleportAllUser,
	sClanSummon,
	sResetPlayerRanking,
	sChangeEventRoom,
	sWarOpen1,
	sWarOpen2,
	sWarOpen3,
	sWarOpen4,
	sWarOpen5,
	sWarOpen6,
	sWarOpen9,
	sWarSiegeOpen,
	sWarClose,
	sCaptainElection,
	sWarSiegeClose,
	sSendPrsion
	FROM [KO_DATABASE_MAIN].dbo.GAME_MASTER_SETTINGS WHERE strAccountID = @strAccountID AND strCharID = @strCharID AND sServerNo = @ServerNo
END

GO

-- =============================================
-- Procedure: MAIL_BOX_CHECK_COUNT
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[MAIL_BOX_CHECK_COUNT]
@strRecipientID varchar(21)
AS

DECLARE @bCount tinyint

SELECT TOP(20) @bCount = COUNT(*) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0

RETURN @bCount

GO

-- =============================================
-- Procedure: KNIGHTS_CASTELLAN_UPDATE_CAPE
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.09.2019
-- Update date: 13.09.2019
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_CASTELLAN_UPDATE_CAPE]
@sClanID smallint,
@sCapeID smallint,
@r tinyint,
@g tinyint,
@b tinyint,
@time bigint,
@active tinyint
AS

DECLARE @counts tinyint

BEGIN TRAN
	SELECT @counts = count(IDNum) FROM KNIGHTS_CASTELLAN WHERE IDNum = @sClanID
	IF (@counts = 0)
	BEGIN
		INSERT INTO KNIGHTS_CASTELLAN (IDNum, sCape,bCapeR,bCapeG,bCapeB,isActive,RemainingTime) VALUES (@sClanID, @sCapeID,@r,@g,@b, @active, @time)
	END
	ELSE
	BEGIN
		UPDATE KNIGHTS_CASTELLAN SET sCape= @sCapeID, bCapeR = @r, bCapeG = @g, bCapeB = @b,isActive = @active,RemainingTime = @time WHERE IDNum = @sClanID
	END

	IF (@@ERROR <> 0)
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
COMMIT TRAN

GO

-- =============================================
-- Procedure: UPDATE_USER_HDD_BANS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
CREATE PROCEDURE [dbo].[UPDATE_USER_HDD_BANS]

-- =============================================
-- Author: HALO
-- Create date: 2019-01-27
-- =============================================

@StrUserID varchar(21),
@Status int
AS

DECLARE @ListedeVarmiyiz tinyint

IF dbo.IsValidCharacters(@StrUserID) = 1
BEGIN
RETURN 9 -- isim hatasi
END

SELECT @ListedeVarmiyiz = COUNT(*) FROM USER_HDD_BAN_LIST WHERE UserID = @StrUserID

IF (@ListedeVarmiyiz = 0)
RETURN 31 -- karakter yok reis
BEGIN
UPDATE USER_HDD_BAN_LIST Set Banned =  @Status where UserID = @StrUserID
RETURN 31--RETURN 62 -- Update basarli
END

IF (@@ERROR <> 0)
BEGIN	
ROLLBACK TRAN
RETURN 74
END

GO

-- =============================================
-- Procedure: MAIL_BOX_GET_ITEM
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[MAIL_BOX_GET_ITEM]
@strRecipientID	varchar(21),
@nLetterID int
AS

SELECT nItemID, sCount, sDurability, nCoins, nSerialNum, nItemTime FROM MAIL_BOX WHERE nLetterID = @nLetterID AND bStatus = 1 AND strRecipientID = @strRecipientID

IF (@@ROWCOUNT = 0)
	RETURN -1

UPDATE MAIL_BOX SET bStatus = 2 WHERE nLetterID = @nLetterID AND strRecipientID = @strRecipientID 
RETURN 1


GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER_CHECK
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER_CHECK]
@ClanID smallint,
@strUserID char(21)
AS

DECLARE @Count tinyint,@Count2 tinyint,@Count3 tinyint
SELECT @Count = count(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID --AND sBaseClanCommander = @strUserID
IF (@Count > 0)
	RETURN 4

SELECT @Count3 = count(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER
IF (@Count3 >= 30)
	RETURN 5

GO

-- =============================================
-- Procedure: MAIL_BOX_READ
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[MAIL_BOX_READ]
@strRecipientID	varchar(21),
@nLetterID		int
AS

SELECT strMessage FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND nLetterID = @nLetterID
	
IF (@@ROWCOUNT != 0)
BEGIN
	UPDATE MAIL_BOX SET dtReadDate = GETDATE(), bStatus = 2 WHERE nLetterID = @nLetterID AND bType = 1 AND dtReadDate IS NULL
	UPDATE MAIL_BOX SET dtReadDate = GETDATE() WHERE nLetterID = @nLetterID AND bType = 2 AND dtReadDate IS NULL
END

GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_REGISTER]
@ClanID smallint,
@strUserID char(21)
AS

DECLARE @Count tinyint
SELECT @Count = COUNT(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID --AND sBaseClanCommander = @strUserID

IF (@Count = 0)
BEGIN
	INSERT INTO KNIGHTS_SIEGE_WARFARE_REGISTER (sBaseClanNum,sBaseClanCommander) VALUES (@ClanID,@strUserID)
END

RETURN 1

GO

-- =============================================
-- Procedure: MAIL_BOX_REQUEST_LIST
-- Database: KO_DATABASE_SERVER_001
-- =============================================

CREATE PROCEDURE [dbo].[MAIL_BOX_REQUEST_LIST]
@strRecipientID varchar(21),
@bNewLettersOnly tinyint
AS

DECLARE @expiresInDays int = 7

IF (@bNewLettersOnly = 1)
	SELECT TOP (12) nLetterID, bStatus, bType, strSubject, strSenderID, bType, nItemID, sCount, nCoins, YEAR(dtSendDate) * 10000 + MONTH(dtSendDate) * 100 + DAY(dtSendDate), DATEDIFF(DD, GETDATE(), dtSendDate + @expiresInDays) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0
ELSE
	SELECT TOP (20) nLetterID, bStatus, bType, strSubject, strSenderID, bType, nItemID, sCount, nCoins, YEAR(dtReadDate) * 10000 + MONTH(dtReadDate) * 100 + DAY(dtReadDate), DATEDIFF(DD, dtReadDate, GETDATE()) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 2 AND bDeleted = 0

RETURN @@ROWCOUNT

GO

-- =============================================
-- Procedure: KING_ELECTION_RESULTS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 25.12.2017
-- Update date: 28.03.2018
-- Notes : Krallık Sonuc Tamamen Düzeltildi.
-- =============================================
CREATE PROCEDURE [dbo].[KING_ELECTION_RESULTS]
@byNation	tinyint
AS

DECLARE @strUserID char(20),@bRank tinyint,@sClanID smallint,@bMonth tinyint,@sYear smallint,@kingvotes int,@totalvotes int,@perc int

SELECT @totalvotes = sum(nMoney) FROM KING_ELECTION_LIST WHERE byNation = @byNation

SELECT @strUserID = strName,@sClanID = nKnights FROM KING_ELECTION_LIST WHERE byNation = @byNation ORDER BY nMoney

SELECT @kingvotes = nMoney FROM KING_ELECTION_LIST WHERE strName = @strUserID and byNation = @byNation

SET @perc = (@kingvotes * 100) / @totalvotes

BEGIN
	INSERT INTO KING_NOMINATION_RESULT (byNation,strUserID,bRank,sClanID,bMonth,sYear,kingvotes,totalvotes) 
	SELECT @byNation,@strUserID,1,@sClanID,MONTH(GETDATE()),YEAR(GETDATE()),nMoney,@totalvotes FROM KING_ELECTION_LIST WHERE strName = @strUserID and byNation = @byNation
END

BEGIN
	DELETE FROM KING_ELECTION_LIST WHERE strName = @strUserID and byNation = @byNation
END

BEGIN
	INSERT INTO KING_NOMINATION_RESULT (byNation,strUserID,bRank,sClanID,bMonth,sYear,kingvotes,totalvotes) 
	SELECT @byNation,strName,2,nKnights,MONTH(GETDATE()),YEAR(GETDATE()),nMoney,@totalvotes FROM KING_ELECTION_LIST WHERE byNation = @byNation
END

SELECT @bMonth = byMonth FROM KING_SYSTEM WHERE byNation = @byNation

IF (@bMonth = 12)
	BEGIN
		UPDATE KING_SYSTEM SET strKingName = @strUserID,sKingClanID = @sClanID,byMonth = 1 ,sYear = YEAR(GETDATE()) WHERE byNation = @byNation
	END
ELSE
	BEGIN
		UPDATE KING_SYSTEM SET strKingName = @strUserID,sKingClanID = @sClanID,byMonth = MONTH(GETDATE()) +1 ,sYear = YEAR(GETDATE()) WHERE byNation = @byNation
	END

IF @strUserID IS NULL
	BEGIN
		RETURN 
	END

SELECT strUserID,bRank,sClanID,bMonth,sYear,kingvotes,totalvotes FROM KING_NOMINATION_RESULT WHERE byNation = @byNation

GO

-- =============================================
-- Procedure: MAIL_BOX_SEND
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- Notes :
/* Return values: 
-32 You cannot send this item.
-31 You cannot with this account.
-30 There is no receive target.
-6 You cannot send a letter to yourself.
-5 Exceeded the allowed limit for sending coins.
-4 There's not enough coins in the bag.
-3 You do not have enough money for postage.
-2 (Dialog)The receiver's mailbox is full.
	Please try sending your letter at a time.
-1 Failed sending letter.
1 A letter will be returned
to the original sender if it's
not opened within 1 week.

*A returned letter will be stored
for 1 week. After that, the contained 
item and the letter itself will disappear. 
*/
-- =============================================
CREATE PROCEDURE [dbo].[MAIL_BOX_SEND]
@strSenderID varchar(21),
@strRecipientID varchar(21),
@strSubject varchar(31),
@strMessage varchar(128),
@bType tinyint,
@nItemID int,
@sCount smallint,
@sDurability smallint,
@nSerialNum bigint,
@nCoins int
AS

DECLARE @strRecvAccountID char(20)
DECLARE @bPremiumType tinyint
DECLARE @sLimitLine smallint
DECLARE @nCount int

SET @strRecvAccountID = dbo.GetAccountID(@strRecipientID)

IF (@strRecvAccountID IS NULL)
	RETURN -1

IF (NOT EXISTS(SELECT strUserID FROM USERDATA WHERE strUserID = @strRecipientID))
     RETURN -1

SELECT @bPremiumType = bPremiumType FROM [KO_DATABASE_SERVER_001].dbo.TB_USER WHERE strAccountID = @strRecvAccountID

IF (@bPremiumType >= 5)
	SET @sLimitLine = 20
ELSE
	SET @sLimitLine = 10

SELECT @nCount = COUNT(strRecipientID) FROM MAIL_BOX WHERE strRecipientID = @strRecipientID AND bStatus = 1 AND bDeleted = 0

IF (@nCount >= @sLimitLine)
	RETURN -2

	INSERT INTO MAIL_BOX (strSenderID, strRecipientID, strSubject, strMessage, bType, nItemID, sCount, sDurability, nSerialNum, nCoins) VALUES (@strSenderID, @strRecipientID, @strSubject, @strMessage, @bType, @nItemID, @sCount, @sDurability, @nSerialNum, @nCoins)
		
RETURN 1

GO

-- =============================================
-- Procedure: LOAD_CHAR_INFO
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.1.2018
-- Update date: 13.1.2018
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_CHAR_INFO]
@strCharID	char(21)
AS

-------------------------------------------------------------------------------------------------------
   SELECT Race, Class, HairRGB, [Level], Face, [Zone], strItem, strItemTime FROM USERDATA WHERE strUserID = @strCharID
-------------------------------------------------------------------------------------------------------
--TheThyke


GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_DEATMATCH_CANCEL
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_CANCEL]
@ClanID smallint,
@strUserID char(21)
AS

DECLARE @Count tinyint
SELECT @Count = COUNT(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID AND sBaseClanCommander = @strUserID

IF (@Count > 0)
BEGIN
	DELETE KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID AND sBaseClanCommander = @strUserID
END

RETURN 1

GO

-- =============================================
-- Procedure: LOAD_KNIGHTS_MEMBERS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_KNIGHTS_MEMBERS]
@knightsindex	smallint
AS

  SELECT strUserID, fame, [Level], sClass FROM USER_KNIGHTDATA WHERE sClanID = @knightsindex

GO

-- =============================================
-- Procedure: KNIGHTS_LOAD
-- Database: KO_DATABASE_SERVER_001
-- =============================================



/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		YNG
-- Create date: 19.12.2017
-- Update date: 19.12.2017
-- +
-- =============================================
CREATE PROCEDURE [dbo].[KNIGHTS_LOAD]
AS

BEGIN
-------------------------------------------------------------------------------------------------------
--SELECT * FROM KNIGHTS 
SELECT IDNum, Flag, Nation, Ranking, IDName, Gold, Domination, Mark, sMarkVersion, sMarkLen, sCape, bCapeR, bCapeG, bCapeB, sAllianceKnights, ClanPointFund, strClanNotice, ClanPointMethod, bySiegeFlag, nLose, nVictory, sPremiumInUse, sPremiumTime, nMoney, WarehouseData, strSerial, WarehouseDataTime FROM KNIGHTS
-------------------------------------------------------------------------------------------------------
END
--YNG	


GO

-- =============================================
-- Procedure: KNIGHTS_SIEGE_WAR_DEATMATCH_CANCEL_CHECK
-- Database: KO_DATABASE_SERVER_001
-- =============================================


/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 28.07.2018
-- Update date: 28.07.2018
-- =============================================
CREATE PROC [dbo].[KNIGHTS_SIEGE_WAR_DEATMATCH_CANCEL_CHECK]
@ClanID smallint,
@strUserID char(21)
AS

DECLARE @Count tinyint,@Count2 tinyint,@Count3 tinyint
SELECT @Count = count(*) FROM KNIGHTS_SIEGE_WARFARE_REGISTER WHERE sBaseClanNum = @ClanID AND sBaseClanCommander = @strUserID
IF (@Count = 0)
	RETURN 3

GO

-- =============================================
-- Procedure: dt_generateansiname
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* 
**	Generate an ansi name that is unique in the dtproperties.value column 
*/ 
create procedure dbo.dt_generateansiname(@name varchar(255) output) 
as 
	declare @prologue varchar(20) 
	declare @indexstring varchar(20) 
	declare @index integer 
 
	set @prologue = 'MSDT-A-' 
	set @index = 1 
 
	while 1 = 1 
	begin 
		set @indexstring = cast(@index as varchar(20)) 
		set @name = @prologue + @indexstring 
		if not exists (select value from dtproperties where value = @name) 
			break 
		 
		set @index = @index + 1 
 
		if (@index = 10000) 
			goto TooMany 
	end 
 
Leave: 
 
	return 
 
TooMany: 
 
	set @name = 'DIAGRAM' 
	goto Leave 


GO

-- =============================================
-- Procedure: dt_adduserobject
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Add an object to the dtproperties table
*/
create procedure dbo.dt_adduserobject
as
	set nocount on
	/*
	** Create the user object if it does not exist already
	*/
	begin transaction
		insert dbo.dtproperties (property) VALUES ('DtgSchemaOBJECT')
		update dbo.dtproperties set objectid=@@identity 
			where id=@@identity and property='DtgSchemaOBJECT'
	commit
	return @@identity


GO

-- =============================================
-- Procedure: INSERT_USER_HDD_BANS
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Return values: 
/* Return values: 
9 IsValidCharacter Error
3 Banned HardwareID or MacID
2 Login Successfully
4 Unknow Error Type
6 Is Exist Banned Computer.
*/
CREATE PROCEDURE [dbo].[INSERT_USER_HDD_BANS]
@StrUserID varchar(21),
@HddKey varchar(32),
@MacKey int
AS


IF dbo.IsValidCharacters(@StrUserID) = 1
BEGIN
RETURN 9
END

DECLARE @ListedeVarmiyiz tinyint
DECLARE @BanStatus tinyint
DECLARE @BanStatusv2 int
DECLARE @BanStatusv3 int
DECLARE @BanStatusv4 int

SELECT @BanStatusv4 = LEN(@HddKey)
SELECT @ListedeVarmiyiz = COUNT(*) FROM USER_HDD_BAN_LIST WHERE UserID = @StrUserID

IF (@BanStatusv4 < 5)
RETURN 7

IF (@ListedeVarmiyiz = 0)
INSERT INTO USER_HDD_BAN_LIST (UserID, HwidKey, MacKey) VALUES (@StrUserID, @HddKey, @MacKey)

SELECT TOP 1 @BanStatusv2 = Banned
FROM USER_HDD_BAN_LIST where MacKey = @MacKey
ORDER BY Banned DESC

IF (@BanStatusv2 = 1)
RETURN 6

SELECT TOP 1 @BanStatusv3 = Banned
FROM USER_HDD_BAN_LIST where HwidKey = @HddKey
ORDER BY Banned DESC

IF (@BanStatusv3 = 1)
RETURN 6

SELECT @BanStatus = Banned FROM USER_HDD_BAN_LIST
WHERE UserID = @StrUserID

IF (@BanStatus = 1)
RETURN 3
BEGIN
RETURN 2
END

IF (@@ERROR <> 0)
BEGIN	
ROLLBACK TRAN
RETURN 4
END
go
*/
CREATE PROCEDURE [dbo].[INSERT_USER_HDD_BANS]
@StrUserID varchar(21),
@HddKey varchar(32),
@MacKey int
AS

BEGIN
    -- Procedimiento deshabilitado temporalmente para debug
    RETURN 2  -- Siempre retorna éxito (puedes poner el código que quieras)
END

GO

-- =============================================
-- Procedure: dt_setpropertybyid
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		value -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
create procedure dbo.dt_setpropertybyid
	@id int,
	@property varchar(64),
	@value varchar(255),
	@lvalue image
as
	set nocount on
	declare @uvalue nvarchar(255) 
	set @uvalue = convert(nvarchar(255), @value) 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@value, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @value, @uvalue, @lvalue)
	end



GO

-- =============================================
-- Procedure: LOAD_USER_BOTS
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		YNG
-- Create date: 08.06.2019
-- Update date: 08.06.2019
-- =============================================
CREATE PROCEDURE [dbo].[LOAD_USER_BOTS]
AS

-------------------------------------------------------------------------------------------------------
   SELECT * FROM USER_BOTS
-------------------------------------------------------------------------------------------------------
--YNG


GO

-- =============================================
-- Procedure: dt_getobjwithprop
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Retrieve the owner object(s) of a given property
*/
create procedure dbo.dt_getobjwithprop
	@property varchar(30),
	@value varchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@value is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and value=@value


GO

-- =============================================
-- Procedure: dt_getpropertiesbyid
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
create procedure dbo.dt_getpropertiesbyid
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, value, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property


GO

-- =============================================
-- Procedure: dt_setpropertybyid_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	If the property already exists, reset the value; otherwise add property
**		id -- the id in sysobjects of the object
**		property -- the name of the property
**		uvalue -- the text value of the property
**		lvalue -- the binary value of the property (image)
*/
create procedure dbo.dt_setpropertybyid_u
	@id int,
	@property varchar(64),
	@uvalue nvarchar(255),
	@lvalue image
as
	set nocount on
	-- 
	-- If we are writing the name property, find the ansi equivalent. 
	-- If there is no lossless translation, generate an ansi name. 
	-- 
	declare @avalue varchar(255) 
	set @avalue = null 
	if (@uvalue is not null) 
	begin 
		if (convert(nvarchar(255), convert(varchar(255), @uvalue)) = @uvalue) 
		begin 
			set @avalue = convert(varchar(255), @uvalue) 
		end 
		else 
		begin 
			if 'DtgSchemaNAME' = @property 
			begin 
				exec dbo.dt_generateansiname @avalue output 
			end 
		end 
	end 
	if exists (select * from dbo.dtproperties 
			where objectid=@id and property=@property)
	begin
		--
		-- bump the version count for this row as we update it
		--
		update dbo.dtproperties set value=@avalue, uvalue=@uvalue, lvalue=@lvalue, version=version+1
			where objectid=@id and property=@property
	end
	else
	begin
		--
		-- version count is auto-set to 0 on initial insert
		--
		insert dbo.dtproperties (property, objectid, value, uvalue, lvalue)
			values (@property, @id, @avalue, @uvalue, @lvalue)
	end


GO

-- =============================================
-- Procedure: dt_getobjwithprop_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Retrieve the owner object(s) of a given property
*/
create procedure dbo.dt_getobjwithprop_u
	@property varchar(30),
	@uvalue nvarchar(255)
as
	set nocount on

	if (@property is null) or (@property = '')
	begin
		raiserror('Must specify a property name.',-1,-1)
		return (1)
	end

	if (@uvalue is null)
		select objectid id from dbo.dtproperties
			where property=@property

	else
		select objectid id from dbo.dtproperties
			where property=@property and uvalue=@uvalue


GO

-- =============================================
-- Procedure: NATION_TRANSFER_SAVEUSER
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 11.11.2017
-- Update date: 11.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[NATION_TRANSFER_SAVEUSER]
@strAccountID varchar(21),
@strCharID varchar(21),
@nNum int,
@bnewRace tinyint,
@bNewClass smallint,
@bNewNation tinyint,
@bNewFace tinyint,
@iNewHair int
AS

BEGIN
	UPDATE USERDATA SET Nation = @bNewNation, Race = @bnewRace, Class = @bNewClass,HairRGB = @iNewHair,Face = @bNewFace WHERE strUserID = @strCharID
	UPDATE ACCOUNT_CHAR SET bNation = @bNewNation,bCharNum = @nNum WHERE strAccountID = @strAccountID
	UPDATE USER_KNIGHTDATA SET sClass = @bNewClass WHERE strUserID = @strCharID
	INSERT INTO [KO_DATABASE_SERVER_001_LOG].dbo.NATION_TRANSFER_LOG(AccountID, UserID, Race,NewClass,Face,NewNation,LogTime) VALUES (@strAccountID, @strCharID, @bnewRace,@bNewClass,@bNewFace,@bNewNation,GETDATE())
END

GO

-- =============================================
-- Procedure: dt_getpropertiesbyid_u
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/*
**	Retrieve properties by id's
**
**	dt_getproperties objid, null or '' -- retrieve all properties of the object itself
**	dt_getproperties objid, property -- retrieve the property specified
*/
create procedure dbo.dt_getpropertiesbyid_u
	@id int,
	@property varchar(64)
as
	set nocount on

	if (@property is null) or (@property = '')
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid
	else
		select property, version, uvalue, lvalue
			from dbo.dtproperties
			where  @id=objectid and @property=property


GO

-- =============================================
-- Procedure: UPGRADE_RATE
-- Database: KO_DATABASE_SERVER_001
-- =============================================

/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 1.11.2017
-- Update date: 1.11.2017
-- =============================================
CREATE PROCEDURE [dbo].[UPGRADE_RATE]
AS
---------------------------------------------
  DECLARE 
  @1x2UpgrdeScroll379016000 int,@2x3UpgrdeScroll379016000 int,@3x4UpgrdeScroll379016000 int,@4x5UpgrdeScroll379016000 int,@1x2UpgrdeScroll379016000Noah int,@2x3UpgrdeScroll379016000Noah int,@3x4UpgrdeScroll379016000Noah int,@4x5UpgrdeScroll379016000Noah int,@ReduceScrollLowClassitem379228000 int,@ReduceScrollLowClassitem379228000Noah int, @6x7ReverseItemStrengthenScrollType11Noah int,
  @1x2LowClassScroll379221000 int, @2x3LowClassScroll379221000 int, @3x4LowClassScroll379221000 int, @4x5LowClassScroll379221000 int, @5x6LowClassScroll379221000 int, @6x7LowClassScroll379221000 int, @7x8LowClassScroll379221000 int, @8x9LowClassScroll379221000 int, @9x10LowClassScroll379221000 int,@BlessedReduceScroll379024000 int,@BlessedReduceScroll379024000Noah int,
  @1x2LowClassScroll379221000Noah int, @2x3LowClassScroll379221000Noah int, @3x4LowClassScroll379221000Noah int, @4x5LowClassScroll379221000Noah int, @5x6LowClassScroll379221000Noah int, @6x7LowClassScroll379221000Noah int, @7x8LowClassScroll379221000Noah int, @8x9LowClassScroll379221000Noah int, @9x10LowClassScroll379221000Noah int,@6x7ReverseItemStrengthenScrollType11 int,
  @1x2MiddleClassScroll379205000 int,@2x3MiddleClassScroll379205000 int,@3x4MiddleClassScroll379205000 int,@4x5MiddleClassScroll379205000 int,@5x6MiddleClassScroll379205000 int,@6x7MiddleClassScroll379205000 int,@7x8MiddleClassScroll379205000 int,@8x9MiddleClassScroll379205000 int,@9x10MiddleClassScroll379205000 int,@5x6ReverseItemStrengthenScrollType11 int,
  @1x2MiddleClassScroll379205000Noah int,@2x3MiddleClassScroll379205000Noah int,@3x4MiddleClassScroll379205000Noah int,@4x5MiddleClassScroll379205000Noah int,@5x6MiddleClassScroll379205000Noah int,@6x7MiddleClassScroll379205000Noah int,@7x8MiddleClassScroll379205000Noah int,@8x9MiddleClassScroll379205000Noah int,@9x10MiddleClassScroll379205000Noah int,@DispellScrollAllType11Noah int,
  @1x2BlessedeScroll379021000 int,@2x3BlessedeScroll379021000 int,@3x4BlessedeScroll379021000 int,@4x5BlessedeScroll379021000 int,@5x6BlessedeScroll379021000 int,@6x7BlessedeScroll379021000 int,@7x8BlessedeScroll379021000 int,@8x9BlessedeScroll379021000 int,@9x10BlessedeScroll379021000 int,@ReduceScrollMiddleClassitem379213000 int,@ReduceScrollMiddleClassitem379213000Noah int,
  @1x2BlessedeScroll379021000Noah int,@2x3BlessedeScroll379021000Noah int,@3x4BlessedeScroll379021000Noah int,@4x5BlessedeScroll379021000Noah int,@5x6BlessedeScroll379021000Noah int,@6x7BlessedeScroll379021000Noah int,@7x8BlessedeScroll379021000Noah int,@8x9BlessedeScroll379021000Noah int,@9x10BlessedeScroll379021000Noah int,@5x6ReverseItemStrengthenScrollType11Noah int,
  @ElementalScroll379020000 int,@ElementalScroll379020000Noah int,@ImmuneScroll379018000 int,@ImmuneScroll379018000Noah int,@ReduceScroll379019000 int,@ReduceScroll379019000Noah int,@EnchantScrollSTR379017000 int,@EnchantScrollSTR379017000Noah int,@EnchantScrollHP379026000 int,@EnchantScrollHP379026000Noah int,@4x5ReverseItemStrengthenScrollType11Noah int,
  @EnchantScrollDEX379027000 int,@EnchantScrollDEX379027000Noah int,@EnchantScrollINT379028000 int,@EnchantScrollINT379028000Noah int,@EnchantScrollMAGIC379029000 int,@EnchantScrollMAGIC379029000Noah int,@ElementalScrollLowClassitem379229000 int,@ElementalScrollLowClassitem379229000Noah int,@BlessedImmuneScroll379023000 int,@BlessedImmuneScroll379023000Noah int,
  @ElementalScrollMiddleClassitem379214000 int,@ElementalScrollMiddleClassitem379214000Noah int,@BlessedElementalScroll379025000 int,@BlessedElementalScroll379025000Noah int,@ImmuneScrollLowClassitem379227000 int,@ImmuneScrollLowClassitem379227000Noah int,@ImmuneScrollMiddleClassitem379212000 int,@ImmuneScrollMiddleClassitem379212000Noah int,@7x8ReverseItemStrengthenScrollType11 int,
  @EnchantScrollSTRLowClassitem379222000 int,@EnchantScrollSTRLowClassitem379222000Noah int,@EnchantScrollHPLowClassitem379223000 int,@EnchantScrollHPLowClassitem379223000Noah int,@EnchantScrollDEXLowClassitem379224000 int ,@EnchantScrollDEXLowClassitem379224000Noah int,@EnchantScrollINTLowClassitem379225000 int,@EnchantScrollINTLowClassitem379225000Noah int,
  @EnchantScrollMAGICClassitem379226000 int,@EnchantScrollMAGICClassitem379226000Noah int,@EnchantScrollSTRMiddleClassitem379206000 int,@EnchantScrollSTRMiddleClassitem379206000Noah int,@EnchantScrollHPMiddleClassitem379208000 int,@EnchantScrollHPMiddleClassitem379208000Noah int,@EnchantScrollDEXMiddleClassitem379209000 int, @EnchantScrollDEXMiddleClassitem379209000Noah int,
  @EnchantScrollINTMiddleClassitem379210000 int,@EnchantScrollINTMiddleClassitem379210000Noah int,@EnchantScrollMAGICMiddleClassitem379211000 int,@EnchantScrollMAGICMiddleClassitem379211000Noah int,@BlessedEnchantScrollSTR379022000 int,@BlessedEnchantScrollSTR379022000Noah int,@BlessedEnchantScrollHP379030000 int,@BlessedEnchantScrollHP379030000Noah int,
  @BlessedEnchantScrollDEX379031000 int,@BlessedEnchantScrollDEX379031000Noah int,@BlessedEnchantScrollINT379032000 int,@BlessedEnchantScrollINT379032000Noah int,@BlessedEnchantScrollMAGIC379033000 int,@BlessedEnchantScrollMAGIC379033000Noah int,@ReverseScroll379256000Type5 int,@ReverseScroll379256000Type5Noah int,@4x5ReverseItemStrengthenScrollType11 int,
  @ReverseScroll379256000Type4 int,@ReverseScroll379256000Type4Noah int,@1x2ReverseItemStrengthenScrollType11 int,@1x2ReverseItemStrengthenScrollType11Noah int,@2x3ReverseItemStrengthenScrollType11 int,@2x3ReverseItemStrengthenScrollType11Noah int,@3x4ReverseItemStrengthenScrollType11 int,@3x4ReverseItemStrengthenScrollType11Noah int,@7x8ReverseItemStrengthenScrollType11Noah int,
  @8x9ReverseItemStrengthenScrollType11 int,@8x9ReverseItemStrengthenScrollType11Noah int,@9x10ReverseItemStrengthenScrollType11 int,@9x10ReverseItemStrengthenScrollType11Noah int,@10x11ReverseItemStrengthenScrollType11 int,@10x11ReverseItemStrengthenScrollType11Noah int,@11x12ReverseItemStrengthenScrollType11 int,@11x12ReverseItemStrengthenScrollType11Noah int,
  @12x13ReverseItemStrengthenScrollType11 int,@12x13ReverseItemStrengthenScrollType11Noah int,@13x14ReverseItemStrengthenScrollType11 int, @13x14ReverseItemStrengthenScrollType11Noah int,@14x15ReverseItemStrengthenScrollType11 int,@14x15ReverseItemStrengthenScrollType11Noah int,@15x16ReverseItemStrengthenScrollType11 int,@15x16ReverseItemStrengthenScrollType11Noah int,
  @16x17ReverseItemStrengthenScrollType11 int,@16x17ReverseItemStrengthenScrollType11Noah int,@17x18ReverseItemStrengthenScrollType11 int,@17x18ReverseItemStrengthenScrollType11Noah int,@18x19ReverseItemStrengthenScrollType11 int,@18x19ReverseItemStrengthenScrollType11Noah int,@19x20ReverseItemStrengthenScrollType11 int,@19x20ReverseItemStrengthenScrollType11Noah int,
  @20x21ReverseItemStrengthenScrollType11 int,@20x21ReverseItemStrengthenScrollType11Noah int,@1x2ReverseItemStrengthenScrollType12 int,@1x2ReverseItemStrengthenScrollType12Noah int,@2x3ReverseItemStrengthenScrollType12 int,@2x3ReverseItemStrengthenScrollType12Noah int,@3x4ReverseItemStrengthenScrollType12 int,@3x4ReverseItemStrengthenScrollType12Noah int,
  @4x5ReverseItemStrengthenScrollType12 int,@4x5ReverseItemStrengthenScrollType12Noah int,@5x6ReverseItemStrengthenScrollType12 int,@5x6ReverseItemStrengthenScrollType12Noah int,@6x7ReverseItemStrengthenScrollType12 int,@6x7ReverseItemStrengthenScrollType12Noah int,@7x8ReverseItemStrengthenScrollType12 int,@7x8ReverseItemStrengthenScrollType12Noah int,@DispellScrollAllType11 int,
  @8x9ReverseItemStrengthenScrollType12 int,@8x9ReverseItemStrengthenScrollType12Noah int,@9x10ReverseItemStrengthenScrollType12 int,@9x10ReverseItemStrengthenScrollType12Noah int,@10x11ReverseItemStrengthenScrollType12 int,@10x11ReverseItemStrengthenScrollType12Noah int,@11x12ReverseItemStrengthenScrollType12 int,@11x12ReverseItemStrengthenScrollType12Noah int,
  @12x13ReverseItemStrengthenScrollType12 int,@12x13ReverseItemStrengthenScrollType12Noah int,@13x14ReverseItemStrengthenScrollType12 int,@13x14ReverseItemStrengthenScrollType12Noah int,@14x15ReverseItemStrengthenScrollType12 int,@14x15ReverseItemStrengthenScrollType12Noah int,@15x16ReverseItemStrengthenScrollType12 int,@15x16ReverseItemStrengthenScrollType12Noah int,
  @16x17ReverseItemStrengthenScrollType12 int,@16x17ReverseItemStrengthenScrollType12Noah int,@17x18ReverseItemStrengthenScrollType12 int,@17x18ReverseItemStrengthenScrollType12Noah int,@18x19ReverseItemStrengthenScrollType12 int,@18x19ReverseItemStrengthenScrollType12Noah int,@19x20ReverseItemStrengthenScrollType12 int,@19x20ReverseItemStrengthenScrollType12Noah int,
  @20x21ReverseItemStrengthenScrollType12 int,@20x21ReverseItemStrengthenScrollType12Noah int,@1x2BlessedeScroll379021000Type4 int,@1x2BlessedeScroll379021000Type4Noah int,@2x3BlessedeScroll379021000Type4 int,@2x3BlessedeScroll379021000Type4Noah int,@3x4BlessedeScroll379021000Type4 int,@3x4BlessedeScroll379021000Type4Noah int,@4x5BlessedeScroll379021000Type4 int,
  @4x5BlessedeScroll379021000Type4Noah int,@5x6BlessedeScroll379021000Type4 int,@5x6BlessedeScroll379021000Type4Noah int,@6x7BlessedeScroll379021000Type4 int,@6x7BlessedeScroll379021000Type4Noah int,@7x8BlessedeScroll379021000Type4 int,@7x8BlessedeScroll379021000Type4Noah int,@8x9BlessedeScroll379021000Type4 int,@8x9BlessedeScroll379021000Type4Noah int,
  @9x10BlessedeScroll379021000Type4 int,@9x10BlessedeScroll379021000Type4Noah int,@0x1AccessoryCompoundScroll379159000Type4 int,@0x1AccessoryCompoundScroll379159000Type4Noah int,@1x2AccessoryCompoundScroll379159000Type4 int,@1x2AccessoryCompoundScroll379159000Type4Noah int,@2x3AccessoryCompoundScroll379159000Type4 int,@2x3AccessoryCompoundScroll379159000Type4Noah int,
  @3x4AccessoryCompoundScroll379159000Type4 int,@3x4AccessoryCompoundScroll379159000Type4Noah int,@4x5AccessoryCompoundScroll379159000Type4 int,@4x5AccessoryCompoundScroll379159000Type4Noah int,@5x6AccessoryCompoundScroll379159000Type5 int,@5x6AccessoryCompoundScroll379159000Type5Noah int,@6x7AccessoryCompoundScroll379159000Type5 int,@6x7AccessoryCompoundScroll379159000Type5Noah int,
  @7x8AccessoryCompoundScroll379159000Type5 int,@7x8AccessoryCompoundScroll379159000Type5Noah int,@8x9AccessoryCompoundScroll379159000Type5 int,@8x9AccessoryCompoundScroll379159000Type5Noah int,@9x10AccessoryCompoundScroll379159000Type5 int,@9x10AccessoryCompoundScroll379159000Type5Noah int,@1x2AccessoryCompoundScroll379159000Type5Con int,@1x2AccessoryCompoundScroll379159000Type5ConNoah int,
  @2x3AccessoryCompoundScroll379159000Type5Con int,@2x3AccessoryCompoundScroll379159000Type5ConNoah int,@3x4AccessoryCompoundScroll379159000Type5Con int,@3x4AccessoryCompoundScroll379159000Type5ConNoah int,@4x5AccessoryCompoundScroll379159000Type5Con int,@4x5AccessoryCompoundScroll379159000Type5ConNoah int,@AccessoryEnchantScrollSTR379160000 int,@AccessoryEnchantScrollSTR379160000Noah int,
  @AccessoryEnchantScrollHP379161000 int,@AccessoryEnchantScrollHP379161000Noah int,@AccessoryEnchantScrollDEX379162000 int,@AccessoryEnchantScrollDEX379162000Noah int,@AccessoryEnchantScrollINT379163000 int,@AccessoryEnchantScrollINT379163000Noah int,@AccessoryEnchantScrollMP379164000 int,@AccessoryEnchantScrollMP379164000Noah int,@DispellScrollAll int,@DispellScrollAllNoah int,
  @0x1BlessedElementalScroll379025000Type4 int,@0x1BlessedElementalScroll379025000Type4Noah int,@6x7100UpgradeScrollItemType5 int,@6x7100UpgradeScrollItemType5Noah int,@6x7100UpgradeScrollItemType4 int,@6x7100UpgradeScrollItemType4Noah int
---------------------------------------------
/* Item Numarası :379016000 & Upgrade Scroll  */
    SET @1x2UpgrdeScroll379016000        = 8500  --1 -> 2
      SET @2x3UpgrdeScroll379016000        = 7500  --2 -> 3        
        SET @3x4UpgrdeScroll379016000        = 5500 --3 -> 4
          SET @4x5UpgrdeScroll379016000        = 4500 --4 -> 5
      --------------Noah---------------
      SET @1x2UpgrdeScroll379016000Noah    = 3000  --1 -> 2 Noah
        SET @2x3UpgrdeScroll379016000Noah    = 6000  --2 -> 3 Noah
          SET @3x4UpgrdeScroll379016000Noah    = 9000  --3 -> 4 Noah
            SET @4x5UpgrdeScroll379016000Noah    = 12000  --4 -> 5 Noah
---------------------------------------------
/* Item Numarası :379221000 & Upgrade Scroll (Low Class item) */ 
      SET @1x2LowClassScroll379221000    = 10000  --1 -> 2
        SET @2x3LowClassScroll379221000    = 10000  --2 -> 3
          SET @3x4LowClassScroll379221000    = 9500  --3 -> 4
            SET @4x5LowClassScroll379221000    = 8500  --4 -> 5
              SET @5x6LowClassScroll379221000    = 6500  --5 -> 6
                SET @6x7LowClassScroll379221000    = 4500  --6 -> 7
                  SET @7x8LowClassScroll379221000    = 3000  --7 -> 8
                    SET @8x9LowClassScroll379221000    = 2000  --8 -> 9
                      SET @9x10LowClassScroll379221000   = 1000  --9 -> 10
      --------------Noah---------------------
        SET @1x2LowClassScroll379221000Noah = 1000  --1 -> 2 Noah
          SET @2x3LowClassScroll379221000Noah  = 2000  --2 -> 3 Noah
            SET @3x4LowClassScroll379221000Noah  = 3000  --3 -> 4 Noah
              SET @4x5LowClassScroll379221000Noah  = 4000  --4 -> 5 Noah
                SET @5x6LowClassScroll379221000Noah  = 5000  --5 -> 6 Noah
                  SET @6x7LowClassScroll379221000Noah  = 6000  --6 -> 7 Noah
                    SET @7x8LowClassScroll379221000Noah  = 7000  --7 -> 8 Noah
                      SET @8x9LowClassScroll379221000Noah  = 8000  --8 -> 9 Noah
                        SET @9x10LowClassScroll379221000Noah = 9000  --9 -> 10 Noah
---------------------------------------------
/* Item Numarası :379205000 & Upgrade Scroll (Middle Class item) */ 
      SET @1x2MiddleClassScroll379205000    = 10000  --1 -> 2
        SET @2x3MiddleClassScroll379205000    = 10000  --2 -> 3
          SET @3x4MiddleClassScroll379205000    = 8500  --3 -> 4
            SET @4x5MiddleClassScroll379205000    = 7500  --4 -> 5
              SET @5x6MiddleClassScroll379205000    = 5500  --5 -> 6
                SET @6x7MiddleClassScroll379205000    = 4000  --6 -> 7
                  SET @7x8MiddleClassScroll379205000    = 1500  --7 -> 8
                    SET @8x9MiddleClassScroll379205000    = 200  --8 -> 9
                      SET @9x10MiddleClassScroll379205000   = 20  --9 -> 10
      --------------Noah---------------------
        SET @1x2MiddleClassScroll379205000Noah = 2000  --1 -> 2 Noah
          SET @2x3MiddleClassScroll379205000Noah  = 4000  --2 -> 3 Noah
            SET @3x4MiddleClassScroll379205000Noah  = 6000  --3 -> 4 Noah
              SET @4x5MiddleClassScroll379205000Noah  = 8000  --4 -> 5 Noah
                SET @5x6MiddleClassScroll379205000Noah  = 10000  --5 -> 6 Noah
                  SET @6x7MiddleClassScroll379205000Noah  = 12000  --6 -> 7 Noah
                    SET @7x8MiddleClassScroll379205000Noah  = 14000  --7 -> 8 Noah
                      SET @8x9MiddleClassScroll379205000Noah  = 16000  --8 -> 9 Noah
                        SET @9x10MiddleClassScroll379205000Noah = 18000  --9 -> 10 Noah
---------------------------------------------
/* Item Numarası :379021000 & Blessed Upgrade Scroll ItemType : 5 */
      SET @1x2BlessedeScroll379021000    = 10000  --1 -> 2
        SET @2x3BlessedeScroll379021000    = 10000  --2 -> 3
          SET @3x4BlessedeScroll379021000    = 9000  --3 -> 4
            SET @4x5BlessedeScroll379021000    = 6500  --4 -> 5
              SET @5x6BlessedeScroll379021000    = 4500  --5 -> 6
                SET @6x7BlessedeScroll379021000    = 1500  --6 -> 7
                  SET @7x8BlessedeScroll379021000    = 500  --7 -> 8
                    SET @8x9BlessedeScroll379021000    = 200  --8 -> 9
                      SET @9x10BlessedeScroll379021000   = 100  --9 -> 10
      --------------Noah---------------------
        SET @1x2BlessedeScroll379021000Noah = 3000  --1 -> 2 Noah
          SET @2x3BlessedeScroll379021000Noah  = 6000  --2 -> 3 Noah
            SET @3x4BlessedeScroll379021000Noah  = 9000  --3 -> 4 Noah
              SET @4x5BlessedeScroll379021000Noah  = 12000  --4 -> 5 Noah
                SET @5x6BlessedeScroll379021000Noah  = 15000  --5 -> 6 Noah
                  SET @6x7BlessedeScroll379021000Noah  = 18000  --6 -> 7 Noah
                    SET @7x8BlessedeScroll379021000Noah  = 21000  --7 -> 8 Noah
                      SET @8x9BlessedeScroll379021000Noah  = 26000  --8 -> 9 Noah
                        SET @9x10BlessedeScroll379021000Noah = 30000  --9 -> 10 Noah
---------------------------------------------
/* Item Numarası :379021000 & Blessed Upgrade Scroll ItemType 4 */
      SET @0x1BlessedElementalScroll379025000Type4 = 10000  --0 -> 1
        SET @1x2BlessedeScroll379021000Type4         = 10000  --1 -> 2
          SET @2x3BlessedeScroll379021000Type4         = 10000  --2 -> 3
            SET @3x4BlessedeScroll379021000Type4         = 9000  --3 -> 4
              SET @4x5BlessedeScroll379021000Type4         = 6000  --4 -> 5
                SET @5x6BlessedeScroll379021000Type4         = 4000  --5 -> 6
                  SET @6x7BlessedeScroll379021000Type4         = 1000  --6 -> 7
                    SET @7x8BlessedeScroll379021000Type4         = 250  --7 -> 8
                      SET @8x9BlessedeScroll379021000Type4         = 200  --8 -> 9
                        SET @9x10BlessedeScroll379021000Type4         = 100  --9 -> 10
      --------------Noah---------------------
      SET @0x1BlessedElementalScroll379025000Type4Noah = 500000  --0 -> 1 Noah
        SET @1x2BlessedeScroll379021000Type4Noah         = 33000  --1 -> 2 Noah
          SET @2x3BlessedeScroll379021000Type4Noah         = 66000  --2 -> 3 Noah
            SET @3x4BlessedeScroll379021000Type4Noah         = 99000  --3 -> 4 Noah
              SET @4x5BlessedeScroll379021000Type4Noah         = 132000  --4 -> 5 Noah
                SET @5x6BlessedeScroll379021000Type4Noah         = 165000  --5 -> 6 Noah
                  SET @6x7BlessedeScroll379021000Type4Noah         = 198000  --6 -> 7 Noah
                    SET @7x8BlessedeScroll379021000Type4Noah         = 231000  --7 -> 8 Noah
                      SET @8x9BlessedeScroll379021000Type4Noah         = 250000  --8 -> 9 Noah
                        SET @9x10BlessedeScroll379021000Type4Noah         = 300000  --9 -> 10 Noah
---------------------------------------------
/* Item Numarası :379257000 & Reverse Item Strengthen Scroll ItemType :11 */
      SET @1x2ReverseItemStrengthenScrollType11 = 3000  --1 -> 2
        SET @2x3ReverseItemStrengthenScrollType11 = 3000  --2 -> 3
          SET @3x4ReverseItemStrengthenScrollType11 = 3000  --3 -> 4
            SET @4x5ReverseItemStrengthenScrollType11 = 3000  --4 -> 5
              SET @5x6ReverseItemStrengthenScrollType11 = 0  --5 -> 6
                SET @6x7ReverseItemStrengthenScrollType11 = 3000  --6 -> 7
                  SET @7x8ReverseItemStrengthenScrollType11 = 3000  --7 -> 8
                    SET @8x9ReverseItemStrengthenScrollType11 = 3000  --8 -> 9
                      SET @9x10ReverseItemStrengthenScrollType11 = 3000  --9 -> 10
                        SET @10x11ReverseItemStrengthenScrollType11 = 2500  --10 -> 11
                          SET @11x12ReverseItemStrengthenScrollType11 = 2500  --11 -> 12
                            SET @12x13ReverseItemStrengthenScrollType11 = 2500  --12 -> 13
                              SET @13x14ReverseItemStrengthenScrollType11 = 2500  --13 -> 14
                                SET @14x15ReverseItemStrengthenScrollType11 = 2500  --14 -> 15
                                  SET @15x16ReverseItemStrengthenScrollType11 = 2000  --15 -> 16
                                    SET @16x17ReverseItemStrengthenScrollType11 = 2000  --16 -> 17
                                      SET @17x18ReverseItemStrengthenScrollType11 = 2000  --17 -> 18
                                        SET @18x19ReverseItemStrengthenScrollType11 = 2000  --18 -> 19
                                          SET @19x20ReverseItemStrengthenScrollType11 = 2000  --19 -> 20
                                            SET @20x21ReverseItemStrengthenScrollType11 = 2000  --20 -> 21
       ----------------------------Noah----------------------------
      SET @1x2ReverseItemStrengthenScrollType11Noah = 5000  --1 -> 2 Noah
        SET @2x3ReverseItemStrengthenScrollType11Noah = 10000  --2 -> 3 Noah
          SET @3x4ReverseItemStrengthenScrollType11Noah = 15000  --3 -> 4 Noah
            SET @4x5ReverseItemStrengthenScrollType11Noah = 20000  --4 -> 5 Noah
              SET @5x6ReverseItemStrengthenScrollType11Noah = 25000  --5 -> 6 Noah
                SET @6x7ReverseItemStrengthenScrollType11Noah = 30000  --6 -> 7 Noah
                  SET @7x8ReverseItemStrengthenScrollType11Noah = 35000  --7 -> 8 Noah
                    SET @8x9ReverseItemStrengthenScrollType11Noah = 0  --8 -> 9 Noah
                      SET @9x10ReverseItemStrengthenScrollType11Noah = 0  --9 -> 10 Noah
                        SET @10x11ReverseItemStrengthenScrollType11Noah = 0  --10 -> 11 Noah
                          SET @11x12ReverseItemStrengthenScrollType11Noah = 0  --11 -> 12 Noah
                            SET @12x13ReverseItemStrengthenScrollType11Noah = 0  --12 -> 13 Noah
                              SET @13x14ReverseItemStrengthenScrollType11Noah = 0  --13 -> 14 Noah
                                SET @14x15ReverseItemStrengthenScrollType11Noah = 0  --14 -> 15 Noah
                                  SET @15x16ReverseItemStrengthenScrollType11Noah = 0  --15 -> 16 Noah
                                    SET @16x17ReverseItemStrengthenScrollType11Noah = 0  --16 -> 17 Noah
                                      SET @17x18ReverseItemStrengthenScrollType11Noah = 0  --17 -> 18 Noah
                                        SET @18x19ReverseItemStrengthenScrollType11Noah = 0  --18 -> 19 Noah
                                          SET @19x20ReverseItemStrengthenScrollType11Noah = 0  --19 -> 20 Noah
                                            SET @20x21ReverseItemStrengthenScrollType11Noah = 0  --20 -> 21 Noah
---------------------------------------------
/* Item Numarası :379257000 & Reverse Item Strengthen Scroll ItemType :12 */
      SET @1x2ReverseItemStrengthenScrollType12 = 2500  --1 -> 2
        SET @2x3ReverseItemStrengthenScrollType12 = 2500  --2 -> 3
          SET @3x4ReverseItemStrengthenScrollType12 = 2500  --3 -> 4
            SET @4x5ReverseItemStrengthenScrollType12 = 2500  --4 -> 5
              SET @5x6ReverseItemStrengthenScrollType12 = 2500  --5 -> 6
                SET @6x7ReverseItemStrengthenScrollType12 = 2500  --6 -> 7
                  SET @7x8ReverseItemStrengthenScrollType12 = 2500  --7 -> 8
                    SET @8x9ReverseItemStrengthenScrollType12 = 2500  --8 -> 9
                      SET @9x10ReverseItemStrengthenScrollType12 = 2500  --9 -> 10
                        SET @10x11ReverseItemStrengthenScrollType12 = 2500  --10 -> 11
                          SET @11x12ReverseItemStrengthenScrollType12 = 2250  --11 -> 12
                            SET @12x13ReverseItemStrengthenScrollType12 = 2250  --12 -> 13
                              SET @13x14ReverseItemStrengthenScrollType12 = 2250  --13 -> 14
                                SET @14x15ReverseItemStrengthenScrollType12 = 2250  --14 -> 15
                                  SET @15x16ReverseItemStrengthenScrollType12 = 2000  --15 -> 16
                                    SET @16x17ReverseItemStrengthenScrollType12 = 2000  --16 -> 17
                                      SET @17x18ReverseItemStrengthenScrollType12 = 2000  --17 -> 18
                                        SET @18x19ReverseItemStrengthenScrollType12 = 2000  --18 -> 19
                                          SET @19x20ReverseItemStrengthenScrollType12 = 2000  --19 -> 20
                                            SET @20x21ReverseItemStrengthenScrollType12 = 2000  --20 -> 21
       ----------------------------Noah----------------------------
      SET @1x2ReverseItemStrengthenScrollType12Noah = 35000  --1 -> 2 Noah
        SET @2x3ReverseItemStrengthenScrollType12Noah = 70000  --2 -> 3 Noah
          SET @3x4ReverseItemStrengthenScrollType12Noah = 105000  --3 -> 4 Noah
            SET @4x5ReverseItemStrengthenScrollType12Noah = 140000  --4 -> 5 Noah
              SET @5x6ReverseItemStrengthenScrollType12Noah = 175000  --5 -> 6 Noah
                SET @6x7ReverseItemStrengthenScrollType12Noah = 210000  --6 -> 7 Noah
                  SET @7x8ReverseItemStrengthenScrollType12Noah = 245000  --7 -> 8 Noah
                    SET @8x9ReverseItemStrengthenScrollType12Noah = 0  --8 -> 9 Noah
                      SET @9x10ReverseItemStrengthenScrollType12Noah = 0  --9 -> 10 Noah
                        SET @10x11ReverseItemStrengthenScrollType12Noah = 0  --10 -> 11 Noah
                          SET @11x12ReverseItemStrengthenScrollType12Noah = 0  --11 -> 12 Noah
                            SET @12x13ReverseItemStrengthenScrollType12Noah = 0  --12 -> 13 Noah
                              SET @13x14ReverseItemStrengthenScrollType12Noah = 0  --13 -> 14 Noah
                                SET @14x15ReverseItemStrengthenScrollType12Noah = 0  --14 -> 15 Noah
                                  SET @15x16ReverseItemStrengthenScrollType12Noah = 0  --15 -> 16 Noah
                                    SET @16x17ReverseItemStrengthenScrollType12Noah = 0  --16 -> 17 Noah
                                      SET @17x18ReverseItemStrengthenScrollType12Noah = 0  --17 -> 18 Noah
                                        SET @18x19ReverseItemStrengthenScrollType12Noah = 0  --18 -> 19 Noah
                                          SET @19x20ReverseItemStrengthenScrollType12Noah = 0  --19 -> 20 Noah
                                            SET @20x21ReverseItemStrengthenScrollType12Noah = 0  --20 -> 21 Noah
---------------------------------------------
/* Item Numarası :379159000 & Accessory Compound Scroll ItemType :4 Upgrade*/ 
      SET @0x1AccessoryCompoundScroll379159000Type4 = 5000
        SET @1x2AccessoryCompoundScroll379159000Type4 = 7500
          SET @2x3AccessoryCompoundScroll379159000Type4 = 0
            SET @3x4AccessoryCompoundScroll379159000Type4 = 0
              SET @4x5AccessoryCompoundScroll379159000Type4 = 0
               ------------------Noah---------------------
      SET @0x1AccessoryCompoundScroll379159000Type4Noah = 100000000
        SET @1x2AccessoryCompoundScroll379159000Type4Noah = 200000000
          SET @2x3AccessoryCompoundScroll379159000Type4Noah = 0
            SET @3x4AccessoryCompoundScroll379159000Type4Noah = 0
              SET @4x5AccessoryCompoundScroll379159000Type4Noah = 0
---------------------------------------------
/* Item Numarası :379159000 & Accessory Compound Scroll ItemType :5 Upgrade */ 
      SET @5x6AccessoryCompoundScroll379159000Type5 = 10000
        SET @6x7AccessoryCompoundScroll379159000Type5 = 10000
          SET @7x8AccessoryCompoundScroll379159000Type5 = 10000
            SET @8x9AccessoryCompoundScroll379159000Type5 = 10000
              SET @9x10AccessoryCompoundScroll379159000Type5 = 10000
               ------------------Noah---------------------
      SET @5x6AccessoryCompoundScroll379159000Type5Noah = 0
        SET @6x7AccessoryCompoundScroll379159000Type5Noah = 0
          SET @7x8AccessoryCompoundScroll379159000Type5Noah = 0
            SET @8x9AccessoryCompoundScroll379159000Type5Noah = 0
              SET @9x10AccessoryCompoundScroll379159000Type5Noah = 0
---------------------------------------------
/* Item Numarası :379159000 & Accessory Compound Scroll ItemType :5 Conversion. 12 dex 1str vs. Upgrade */ 
      SET @1x2AccessoryCompoundScroll379159000Type5Con = 10000
        SET @2x3AccessoryCompoundScroll379159000Type5Con = 9000
          SET @3x4AccessoryCompoundScroll379159000Type5Con = 8000
            SET @4x5AccessoryCompoundScroll379159000Type5Con = 7500
               ------------------Noah---------------------
      SET @1x2AccessoryCompoundScroll379159000Type5ConNoah = 0
        SET @2x3AccessoryCompoundScroll379159000Type5ConNoah = 0
          SET @3x4AccessoryCompoundScroll379159000Type5ConNoah = 0
            SET @4x5AccessoryCompoundScroll379159000Type5ConNoah = 0
---------------------------------------------
/* Item Numarası :379160000 & Accessory Enchant Scroll(STR) */ 
   SET @AccessoryEnchantScrollSTR379160000 = 9500
     SET @AccessoryEnchantScrollSTR379160000Noah  = 0
---------------------------------------------
/* Item Numarası :379161000 & Accessory Enchant Scroll(HP) */ 
   SET @AccessoryEnchantScrollHP379161000 = 9500
     SET @AccessoryEnchantScrollHP379161000Noah  = 0
---------------------------------------------
/* Item Numarası :379162000 & Accessory Enchant Scroll(DEX) */ 
   SET @AccessoryEnchantScrollDEX379162000 = 9500
     SET @AccessoryEnchantScrollDEX379162000Noah  = 0
---------------------------------------------
/* Item Numarası :379163000 & Accessory Enchant Scroll(INT) */ 
   SET @AccessoryEnchantScrollINT379163000 = 9500
     SET @AccessoryEnchantScrollINT379163000Noah  = 0
---------------------------------------------
/* Item Numarası :379164000 & Accessory Enchant Scroll(MP) */ 
   SET @AccessoryEnchantScrollMP379164000 = 9500
     SET @AccessoryEnchantScrollMP379164000Noah  = 0
---------------------------------------------
/* Item Numarası :379020000 & Elemental Scroll & Low Success Rate */ 
   SET @ElementalScroll379020000 = 9500
     SET @ElementalScroll379020000Noah  = 0
---------------------------------------------
/* Item Numarası :379018000 & Immune Scroll & Low Success Rate */ 
   SET @ImmuneScroll379018000      = 9500
      SET @ImmuneScroll379018000Noah  = 0
---------------------------------------------
/* Item Numarası :379019000 & Reduce Scroll & Low Success Rate */ 
   SET @ReduceScroll379019000      = 9500
      SET @ReduceScroll379019000Noah  = 0
---------------------------------------------
/* Item Numarası :379017000 & Enchant Scroll(STR) & Low Success Rate */
   SET @EnchantScrollSTR379017000      = 9500
      SET @EnchantScrollSTR379017000Noah  = 0
---------------------------------------------
/* Item Numarası :379026000 & Enchant Scroll(HP) & Low Success Rate */
   SET @EnchantScrollHP379026000      = 9500
      SET @EnchantScrollHP379026000Noah  = 0
---------------------------------------------
/* Item Numarası :379027000 & Enchant Scroll(DEX) & Low Success Rate */
   SET @EnchantScrollDEX379027000      = 9500
      SET @EnchantScrollDEX379027000Noah  = 0
---------------------------------------------
/* Item Numarası :379028000 & Enchant Scroll(INT) & Low Success Rate */
   SET @EnchantScrollINT379028000      = 9500
      SET @EnchantScrollINT379028000Noah  = 0
---------------------------------------------
/* Item Numarası :379029000 & Enchant Scroll(MAGIC) & Low Success Rate */
   SET @EnchantScrollMAGIC379029000      = 9500
      SET @EnchantScrollMAGIC379029000Noah  = 0
---------------------------------------------
/* Item Numarası :379229000 & Elemental Scroll (Low Class item) */ 
   SET @ElementalScrollLowClassitem379229000      = 9500
      SET @ElementalScrollLowClassitem379229000Noah  = 0
---------------------------------------------
/* Item Numarası :379214000 & Elemental Scroll (Middle Class item) */ 
   SET @ElementalScrollMiddleClassitem379214000      = 9500
      SET @ElementalScrollMiddleClassitem379214000Noah  = 0
---------------------------------------------
/* Item Numarası :379025000 & Blessed Elemental Scroll */ 
   SET @BlessedElementalScroll379025000      = 9500
      SET @BlessedElementalScroll379025000Noah  = 0
---------------------------------------------
/* Item Numarası :379227000 & Immune Scroll (Low Class item) */ 
   SET @ImmuneScrollLowClassitem379227000      = 9500
      SET @ImmuneScrollLowClassitem379227000Noah  = 0
---------------------------------------------
/* Item Numarası :379212000 & Immune Scroll (Middle Class item) */ 
   SET @ImmuneScrollMiddleClassitem379212000      = 9500
      SET @ImmuneScrollMiddleClassitem379212000Noah  = 0
---------------------------------------------
/* Item Numarası :379023000 & Blessed Immune Scroll */ 
   SET @BlessedImmuneScroll379023000      = 9500
      SET @BlessedImmuneScroll379023000Noah  = 0
---------------------------------------------
/* Item Numarası :379228000 & Reduce Scroll (Low Class item) */ 
   SET @ReduceScrollLowClassitem379228000      = 9500
      SET @ReduceScrollLowClassitem379228000Noah  = 0
---------------------------------------------
/* Item Numarası :379213000 & Reduce Scroll (Middle Class item) */ 
   SET @ReduceScrollMiddleClassitem379213000      = 9500
      SET @ReduceScrollMiddleClassitem379213000Noah  = 0
---------------------------------------------
/* Item Numarası :379024000 & Blessed Reduce Scroll */  
   SET @BlessedReduceScroll379024000      = 9500
      SET @BlessedReduceScroll379024000Noah  = 0
---------------------------------------------
/* Item Numarası :379222000 & Enchant Scroll(STR) (Low Class item) */  
   SET @EnchantScrollSTRLowClassitem379222000      = 9500
      SET @EnchantScrollSTRLowClassitem379222000Noah  = 0
---------------------------------------------
/* Item Numarası :379223000 & Enchant Scroll(HP) (Low Class item) */  
   SET @EnchantScrollHPLowClassitem379223000      = 9500
      SET @EnchantScrollHPLowClassitem379223000Noah  = 0
---------------------------------------------
/* Item Numarası :379224000 & Enchant Scroll(DEX) (Low Class item) */  
   SET @EnchantScrollDEXLowClassitem379224000      = 9500
      SET @EnchantScrollDEXLowClassitem379224000Noah  = 0
---------------------------------------------
/* Item Numarası :379225000 & Enchant Scroll(INT) (Low Class item) */  
   SET @EnchantScrollINTLowClassitem379225000      = 9500
      SET @EnchantScrollINTLowClassitem379225000Noah  = 0
---------------------------------------------
/* Item Numarası :379226000 & Enchant Scroll(MAGIC) (Low Class item) */  
   SET @EnchantScrollMAGICClassitem379226000      = 9500
      SET @EnchantScrollMAGICClassitem379226000Noah  = 0
---------------------------------------------
/* Item Numarası :379206000 & Enchant Scroll(STR) (Middle Class item) */  
   SET @EnchantScrollSTRMiddleClassitem379206000      = 9500
      SET @EnchantScrollSTRMiddleClassitem379206000Noah  = 0
---------------------------------------------
/* Item Numarası :379208000 & Enchant Scroll(HP) (Middle Class item) */  
    SET @EnchantScrollHPMiddleClassitem379208000      = 9500
      SET @EnchantScrollHPMiddleClassitem379208000Noah  = 0
---------------------------------------------
/* Item Numarası :379209000 & Enchant Scroll(DEX) (Middle Class item) */  
   SET @EnchantScrollDEXMiddleClassitem379209000      = 9500
      SET @EnchantScrollDEXMiddleClassitem379209000Noah  = 0
---------------------------------------------
/* Item Numarası :379210000 & Enchant Scroll(INT) (Middle Class item) */  
   SET @EnchantScrollINTMiddleClassitem379210000      = 9500
      SET @EnchantScrollINTMiddleClassitem379210000Noah  = 0
---------------------------------------------
/* Item Numarası :379211000 & Enchant Scroll(MAGIC) (Middle Class item) */  
   SET @EnchantScrollMAGICMiddleClassitem379211000      = 9500
      SET @EnchantScrollMAGICMiddleClassitem379211000Noah  = 0
---------------------------------------------
/* Item Numarası :379022000 & Blessed Enchant Scroll(STR) */  
   SET @BlessedEnchantScrollSTR379022000      = 9500
      SET @BlessedEnchantScrollSTR379022000Noah  = 0
---------------------------------------------
/* Item Numarası :379030000 & Blessed Enchant Scroll(HP) */  
   SET @BlessedEnchantScrollHP379030000      = 9500
      SET @BlessedEnchantScrollHP379030000Noah  = 0
---------------------------------------------
/* Item Numarası :379031000 & Blessed Enchant Scroll(DEX) */  
   SET @BlessedEnchantScrollDEX379031000      = 9500
      SET @BlessedEnchantScrollDEX379031000Noah  = 0
---------------------------------------------
/* Item Numarası :379032000 & Blessed Enchant Scroll(INT) */  
   SET @BlessedEnchantScrollINT379032000      = 9500
      SET @BlessedEnchantScrollINT379032000Noah  = 0
---------------------------------------------
/* Item Numarası :379033000 & Blessed Enchant Scroll(MAGIC) */  
   SET @BlessedEnchantScrollMAGIC379033000      = 9500
      SET @BlessedEnchantScrollMAGIC379033000Noah  = 0
---------------------------------------------
/* Item Numarası :379256000 & Reverse Scroll İtemType :5 */  
   SET @ReverseScroll379256000Type5      = 10000
      SET @ReverseScroll379256000Type5Noah  = 0
---------------------------------------------
/* Item Numarası :379256000 & Reverse Scroll İtemType :4 */  
   SET @ReverseScroll379256000Type4      = 10000
      SET @ReverseScroll379256000Type4Noah  = 0
---------------------------------------------
/* Dispell Scroll ALL Type 5 */  
   SET @DispellScrollAll      = 10000
      SET @DispellScrollAllNoah  = 500000
---------------------------------------------
/* Dispell Scroll ALL Type 11 */  
   SET @DispellScrollAllType11      = 10000
      SET @DispellScrollAllType11Noah  = 500000
/*%100 Blessed Upgrade Scroll ItemType : 5 */
	SET @6x7100UpgradeScrollItemType5 = 10000
		SET @6x7100UpgradeScrollItemType5Noah = 0
/*%100 Blessed Upgrade Scroll ItemType : 4 */
	SET @6x7100UpgradeScrollItemType4 = 10000
		SET @6x7100UpgradeScrollItemType4Noah = 250000
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 BEGIN
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2UpgrdeScroll379016000, nReqNoah = @1x2UpgrdeScroll379016000Noah WHERE ItemType='5' and nReqItem1='379016000' and UpgradeNote='(+1 -> +2)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3UpgrdeScroll379016000, nReqNoah = @2x3UpgrdeScroll379016000Noah WHERE ItemType='5' and nReqItem1='379016000' and UpgradeNote='(+2 -> +3)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4UpgrdeScroll379016000, nReqNoah = @3x4UpgrdeScroll379016000Noah WHERE ItemType='5' and nReqItem1='379016000' and UpgradeNote='(+3 -> +4)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5UpgrdeScroll379016000, nReqNoah = @4x5UpgrdeScroll379016000Noah WHERE ItemType='5' and nReqItem1='379016000' and UpgradeNote='(+4 -> +5)'
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2LowClassScroll379221000, nReqNoah  = @1x2LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+1 -> +2)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3LowClassScroll379221000, nReqNoah  = @2x3LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+2 -> +3)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4LowClassScroll379221000, nReqNoah  = @3x4LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+3 -> +4)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5LowClassScroll379221000, nReqNoah  = @4x5LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+4 -> +5)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @5x6LowClassScroll379221000, nReqNoah  = @5x6LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+5 -> +6)'
            UPDATE ITEM_UPGRADE SET nGenRate =  @6x7LowClassScroll379221000, nReqNoah  = @6x7LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+6 -> +7)'
              UPDATE ITEM_UPGRADE SET nGenRate =  @7x8LowClassScroll379221000, nReqNoah  = @7x8LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+7 -> +8)'
                UPDATE ITEM_UPGRADE SET nGenRate =  @8x9LowClassScroll379221000, nReqNoah  = @8x9LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and  UpgradeNote='(+8 -> +9)'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @9x10LowClassScroll379221000, nReqNoah = @9x10LowClassScroll379221000Noah WHERE ItemType='5' and nReqItem1='379221000' and UpgradeNote='(+9 -> +10)'
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2MiddleClassScroll379205000, nReqNoah  = @1x2MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+1 -> +2)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3MiddleClassScroll379205000, nReqNoah  = @2x3MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+2 -> +3)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4MiddleClassScroll379205000, nReqNoah  = @3x4MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+3 -> +4)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5MiddleClassScroll379205000, nReqNoah  = @4x5MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+4 -> +5)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @5x6MiddleClassScroll379205000, nReqNoah  = @5x6MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+5 -> +6)'
            UPDATE ITEM_UPGRADE SET nGenRate =  @6x7MiddleClassScroll379205000, nReqNoah  = @6x7MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+6 -> +7)'
              UPDATE ITEM_UPGRADE SET nGenRate =  @7x8MiddleClassScroll379205000, nReqNoah  = @7x8MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+7 -> +8)'
                UPDATE ITEM_UPGRADE SET nGenRate =  @8x9MiddleClassScroll379205000, nReqNoah  = @8x9MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+8 -> +9)'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @9x10MiddleClassScroll379205000, nReqNoah  = @9x10MiddleClassScroll379205000Noah WHERE ItemType='5' and nReqItem1='379205000' and  UpgradeNote='(+9 -> +10)'
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2BlessedeScroll379021000, nReqNoah  = @1x2BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+1 -> +2)' and isUnique='0'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3BlessedeScroll379021000, nReqNoah  = @2x3BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+2 -> +3)' and isUnique='0'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4BlessedeScroll379021000, nReqNoah  = @3x4BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+3 -> +4)' and isUnique='0'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5BlessedeScroll379021000, nReqNoah  = @4x5BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+4 -> +5)' and isUnique='0'
          UPDATE ITEM_UPGRADE SET nGenRate =  @5x6BlessedeScroll379021000, nReqNoah  = @5x6BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+5 -> +6)' and isUnique='0'
            UPDATE ITEM_UPGRADE SET nGenRate =  @6x7BlessedeScroll379021000, nReqNoah  = @6x7BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+6 -> +7)' and isUnique='0'
              UPDATE ITEM_UPGRADE SET nGenRate =  @7x8BlessedeScroll379021000, nReqNoah  = @7x8BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+7 -> +8)' and isUnique='0'
                UPDATE ITEM_UPGRADE SET nGenRate =  @8x9BlessedeScroll379021000, nReqNoah  = @8x9BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+8 -> +9)' and isUnique='0'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @9x10BlessedeScroll379021000, nReqNoah  = @9x10BlessedeScroll379021000Noah WHERE ItemType='5' and nReqItem1='379021000' and  UpgradeNote='(+9 -> +10)' and isUnique='0'
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2BlessedeScroll379021000Type4, nReqNoah  = @1x2BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+1+)->(+2+)' and isUnique='1'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3BlessedeScroll379021000Type4, nReqNoah  = @2x3BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+2+)->(+3+)' and isUnique='1'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4BlessedeScroll379021000Type4, nReqNoah  = @3x4BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+3+)->(+4+)' and isUnique='1'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5BlessedeScroll379021000Type4, nReqNoah  = @4x5BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+4+)->(+5+)' and isUnique='1'
          UPDATE ITEM_UPGRADE SET nGenRate =  @5x6BlessedeScroll379021000Type4, nReqNoah  = @5x6BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+5+)->(+6+)' and isUnique='1'
            UPDATE ITEM_UPGRADE SET nGenRate =  @6x7BlessedeScroll379021000Type4, nReqNoah  = @6x7BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+6+)->(+7+)' and isUnique='1'
              UPDATE ITEM_UPGRADE SET nGenRate =  @7x8BlessedeScroll379021000Type4, nReqNoah  = @7x8BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+7+)->(+8+)' and isUnique='1'
                UPDATE ITEM_UPGRADE SET nGenRate =  @8x9BlessedeScroll379021000Type4, nReqNoah  = @8x9BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+8+)->(+9+)' and isUnique='1'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @9x10BlessedeScroll379021000Type4, nReqNoah  = @9x10BlessedeScroll379021000Type4Noah WHERE ItemType='4' and nReqItem1='379021000' and  UpgradeNote='(+9+)->(+10+)' and isUnique='1'
  UPDATE ITEM_UPGRADE SET nGenRate =  @ElementalScroll379020000, nReqNoah  = @ElementalScroll379020000Noah WHERE ItemType='5' and nReqItem1='379020000' and  UpgradeNote='Alteration'
    UPDATE ITEM_UPGRADE SET nGenRate =  @ImmuneScroll379018000, nReqNoah  = @ImmuneScroll379018000Noah WHERE ItemType='5' and nReqItem1='379018000' and  UpgradeNote='Alteration'
      UPDATE ITEM_UPGRADE SET nGenRate =  @ReduceScroll379019000, nReqNoah  = @ReduceScroll379019000Noah WHERE ItemType='5' and nReqItem1='379019000' and  UpgradeNote='Alteration'
        UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollSTR379017000, nReqNoah  = @EnchantScrollSTR379017000Noah WHERE ItemType='5' and nReqItem1='379017000' and  UpgradeNote='Alteration'
          UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollHP379026000, nReqNoah  = @EnchantScrollHP379026000Noah WHERE ItemType='5' and nReqItem1='379026000' and  UpgradeNote='Alteration'
            UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollDEX379027000, nReqNoah  = @EnchantScrollDEX379027000Noah WHERE ItemType='5' and nReqItem1='379027000' and  UpgradeNote='Alteration'
              UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollINT379028000, nReqNoah  = @EnchantScrollINT379028000Noah WHERE ItemType='5' and nReqItem1='379028000' and  UpgradeNote='Alteration'
                UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollMAGIC379029000, nReqNoah  = @EnchantScrollMAGIC379029000Noah WHERE ItemType='5' and nReqItem1='379029000' and  UpgradeNote='Alteration'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @ElementalScrollLowClassitem379229000, nReqNoah  = @ElementalScrollLowClassitem379229000Noah WHERE ItemType='5' and nReqItem1='379229000' and  UpgradeNote='Alteration'
                    UPDATE ITEM_UPGRADE SET nGenRate =  @ElementalScrollMiddleClassitem379214000, nReqNoah  = @ElementalScrollMiddleClassitem379214000Noah WHERE ItemType='5' and nReqItem1='379214000' and  UpgradeNote='Alteration'
  UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedElementalScroll379025000, nReqNoah  = @BlessedElementalScroll379025000Noah WHERE ItemType='5' and nReqItem1='379025000' and  UpgradeNote='Alteration'
    UPDATE ITEM_UPGRADE SET nGenRate =  @ImmuneScrollLowClassitem379227000, nReqNoah  = @ImmuneScrollLowClassitem379227000Noah WHERE ItemType='5' and nReqItem1='379227000' and  UpgradeNote='Alteration'
      UPDATE ITEM_UPGRADE SET nGenRate =  @ImmuneScrollMiddleClassitem379212000, nReqNoah  = @ImmuneScrollMiddleClassitem379212000Noah WHERE ItemType='5' and nReqItem1='379212000' and  UpgradeNote='Alteration'
        UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedImmuneScroll379023000, nReqNoah  = @BlessedImmuneScroll379023000Noah WHERE ItemType='5' and nReqItem1='379023000' and  UpgradeNote='Alteration'
          UPDATE ITEM_UPGRADE SET nGenRate =  @ReduceScrollLowClassitem379228000, nReqNoah  = @ReduceScrollLowClassitem379228000Noah WHERE ItemType='5' and nReqItem1='379228000' and  UpgradeNote='Alteration'
            UPDATE ITEM_UPGRADE SET nGenRate =  @ReduceScrollMiddleClassitem379213000, nReqNoah  = @ReduceScrollMiddleClassitem379213000Noah WHERE ItemType='5' and nReqItem1='379213000' and  UpgradeNote='Alteration'
              UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedReduceScroll379024000, nReqNoah  = @BlessedReduceScroll379024000Noah WHERE ItemType='5' and nReqItem1='379024000' and  UpgradeNote='Alteration'
                UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollSTRLowClassitem379222000, nReqNoah  = @EnchantScrollSTRLowClassitem379222000nOAH WHERE ItemType='5' and nReqItem1='379222000' and  UpgradeNote='Alteration'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollHPLowClassitem379223000, nReqNoah  = @EnchantScrollHPLowClassitem379223000Noah WHERE ItemType='5' and nReqItem1='379223000' and  UpgradeNote='Alteration'
  UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollDEXLowClassitem379224000, nReqNoah  = @EnchantScrollDEXLowClassitem379224000Noah WHERE ItemType='5' and nReqItem1='379224000' and  UpgradeNote='Alteration'
    UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollINTLowClassitem379225000, nReqNoah  = @EnchantScrollINTLowClassitem379225000Noah WHERE ItemType='5' and nReqItem1='379225000' and  UpgradeNote='Alteration'
      UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollMAGICClassitem379226000, nReqNoah  = @EnchantScrollMAGICClassitem379226000Noah WHERE ItemType='5' and nReqItem1='379226000' and  UpgradeNote='Alteration'
        UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollSTRMiddleClassitem379206000, nReqNoah  = @EnchantScrollSTRMiddleClassitem379206000Noah WHERE ItemType='5' and nReqItem1='379206000' and  UpgradeNote='Alteration'
          UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollHPMiddleClassitem379208000, nReqNoah  = @EnchantScrollHPMiddleClassitem379208000Noah WHERE ItemType='5' and nReqItem1='379208000' and  UpgradeNote='Alteration'
            UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollDEXMiddleClassitem379209000, nReqNoah  = @EnchantScrollDEXMiddleClassitem379209000Noah WHERE ItemType='5' and nReqItem1='379209000' and  UpgradeNote='Alteration'
              UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollINTMiddleClassitem379210000, nReqNoah  = @EnchantScrollINTMiddleClassitem379210000Noah WHERE ItemType='5' and nReqItem1='379210000' and  UpgradeNote='Alteration'
                UPDATE ITEM_UPGRADE SET nGenRate =  @EnchantScrollMAGICMiddleClassitem379211000, nReqNoah  = @EnchantScrollMAGICMiddleClassitem379211000Noah WHERE ItemType='5' and nReqItem1='379211000' and  UpgradeNote='Alteration'
  UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedEnchantScrollSTR379022000, nReqNoah  = @BlessedEnchantScrollSTR379022000Noah WHERE ItemType='5' and nReqItem1='379022000' and  UpgradeNote='Alteration'
    UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedEnchantScrollHP379030000, nReqNoah  = @BlessedEnchantScrollHP379030000Noah WHERE ItemType='5' and nReqItem1='379030000' and  UpgradeNote='Alteration'
      UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedEnchantScrollDEX379031000, nReqNoah  = @BlessedEnchantScrollDEX379031000Noah WHERE ItemType='5' and nReqItem1='379031000' and  UpgradeNote='Alteration'
        UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedEnchantScrollINT379032000, nReqNoah  = @BlessedEnchantScrollINT379032000Noah WHERE ItemType='5' and nReqItem1='379032000' and  UpgradeNote='Alteration'
          UPDATE ITEM_UPGRADE SET nGenRate =  @BlessedEnchantScrollMAGIC379033000, nReqNoah  = @BlessedEnchantScrollMAGIC379033000Noah WHERE ItemType='5' and nReqItem1='379033000' and  UpgradeNote='Alteration'
            UPDATE ITEM_UPGRADE SET nGenRate =  @ReverseScroll379256000Type5, nReqNoah  = @ReverseScroll379256000Type5Noah WHERE ItemType='5' and nReqItem1='379256000' and Conversion='1'
              UPDATE ITEM_UPGRADE SET nGenRate =  @ReverseScroll379256000Type4, nReqNoah  = @ReverseScroll379256000Type4Noah WHERE ItemType='4' and nReqItem1='379256000' and Conversion='1'
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2ReverseItemStrengthenScrollType11, nReqNoah = @1x2ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+1)->(+2)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3ReverseItemStrengthenScrollType11, nReqNoah = @2x3ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+2)->(+3)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4ReverseItemStrengthenScrollType11, nReqNoah = @3x4ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+3)->(+4)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5ReverseItemStrengthenScrollType11, nReqNoah = @4x5ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+4)->(+5)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @5x6ReverseItemStrengthenScrollType11, nReqNoah = @5x6ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+5)->(+6)'
            UPDATE ITEM_UPGRADE SET nGenRate =  @6x7ReverseItemStrengthenScrollType11, nReqNoah = @6x7ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+6)->(+7)'
              UPDATE ITEM_UPGRADE SET nGenRate =  @7x8ReverseItemStrengthenScrollType11, nReqNoah = @7x8ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+7)->(+8)'
                UPDATE ITEM_UPGRADE SET nGenRate =  @8x9ReverseItemStrengthenScrollType11, nReqNoah = @8x9ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+8)->(+9)'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @9x10ReverseItemStrengthenScrollType11, nReqNoah = @9x10ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+9)->(+10)'
                    UPDATE ITEM_UPGRADE SET nGenRate =  @10x11ReverseItemStrengthenScrollType11, nReqNoah = @10x11ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+10)->(+11)'
                      UPDATE ITEM_UPGRADE SET nGenRate =  @11x12ReverseItemStrengthenScrollType11, nReqNoah = @11x12ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+11)->(+12)'
                        UPDATE ITEM_UPGRADE SET nGenRate =  @12x13ReverseItemStrengthenScrollType11, nReqNoah = @12x13ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+12)->(+13)'
                          UPDATE ITEM_UPGRADE SET nGenRate =  @13x14ReverseItemStrengthenScrollType11, nReqNoah = @13x14ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+13)->(+14)'
                            UPDATE ITEM_UPGRADE SET nGenRate =  @14x15ReverseItemStrengthenScrollType11, nReqNoah = @14x15ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+14)->(+15)'
                              UPDATE ITEM_UPGRADE SET nGenRate =  @15x16ReverseItemStrengthenScrollType11, nReqNoah = @15x16ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+15)->(+16)'
                                UPDATE ITEM_UPGRADE SET nGenRate =  @16x17ReverseItemStrengthenScrollType11, nReqNoah = @16x17ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+16)->(+17)'
                                  UPDATE ITEM_UPGRADE SET nGenRate =  @17x18ReverseItemStrengthenScrollType11, nReqNoah = @17x18ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+17)->(+18)'
                                    UPDATE ITEM_UPGRADE SET nGenRate =  @18x19ReverseItemStrengthenScrollType11, nReqNoah = @18x19ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+18)->(+19)'
                                      UPDATE ITEM_UPGRADE SET nGenRate =  @19x20ReverseItemStrengthenScrollType11, nReqNoah = @19x20ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+19)->(+20)'
                                        UPDATE ITEM_UPGRADE SET nGenRate =  @20x21ReverseItemStrengthenScrollType11, nReqNoah = @20x21ReverseItemStrengthenScrollType11Noah WHERE ItemType='11' and nReqItem1='379257000' and UpgradeNote='(+20)->(+21)'
  UPDATE ITEM_UPGRADE SET nGenRate =  @1x2ReverseItemStrengthenScrollType12, nReqNoah = @1x2ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+1)+->(+2)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @2x3ReverseItemStrengthenScrollType12, nReqNoah = @2x3ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+2)+->(+3)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @3x4ReverseItemStrengthenScrollType12, nReqNoah = @3x4ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+3)+->(+4)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @4x5ReverseItemStrengthenScrollType12, nReqNoah = @4x5ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+4)+->(+5)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @5x6ReverseItemStrengthenScrollType12, nReqNoah = @5x6ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+5)+->(+6)'
            UPDATE ITEM_UPGRADE SET nGenRate =  @6x7ReverseItemStrengthenScrollType12, nReqNoah = @6x7ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+6)+->(+7)'
              UPDATE ITEM_UPGRADE SET nGenRate =  @7x8ReverseItemStrengthenScrollType12, nReqNoah = @7x8ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+7)+->(+8)'
                UPDATE ITEM_UPGRADE SET nGenRate =  @8x9ReverseItemStrengthenScrollType12, nReqNoah = @8x9ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+8)+->(+9)'
                  UPDATE ITEM_UPGRADE SET nGenRate =  @9x10ReverseItemStrengthenScrollType12, nReqNoah = @9x10ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+9)+->(+10)'
                    UPDATE ITEM_UPGRADE SET nGenRate =  @10x11ReverseItemStrengthenScrollType12, nReqNoah = @10x11ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+10)+->(+11)'
                      UPDATE ITEM_UPGRADE SET nGenRate =  @11x12ReverseItemStrengthenScrollType12, nReqNoah = @11x12ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+11)+->(+12)'
                        UPDATE ITEM_UPGRADE SET nGenRate =  @12x13ReverseItemStrengthenScrollType12, nReqNoah = @12x13ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+12)+->(+13)'
                          UPDATE ITEM_UPGRADE SET nGenRate =  @13x14ReverseItemStrengthenScrollType12, nReqNoah = @13x14ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+13)+->(+14)'
                            UPDATE ITEM_UPGRADE SET nGenRate =  @14x15ReverseItemStrengthenScrollType12, nReqNoah = @14x15ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+14)+->(+15)'
                              UPDATE ITEM_UPGRADE SET nGenRate =  @15x16ReverseItemStrengthenScrollType12, nReqNoah = @15x16ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+15)+->(+16)'
                                UPDATE ITEM_UPGRADE SET nGenRate =  @16x17ReverseItemStrengthenScrollType12, nReqNoah = @16x17ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+16)+->(+17)'
                                  UPDATE ITEM_UPGRADE SET nGenRate =  @17x18ReverseItemStrengthenScrollType12, nReqNoah = @17x18ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+17)+->(+18)'
                                    UPDATE ITEM_UPGRADE SET nGenRate =  @18x19ReverseItemStrengthenScrollType12, nReqNoah = @18x19ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+18)+->(+19)'
                                      UPDATE ITEM_UPGRADE SET nGenRate =  @19x20ReverseItemStrengthenScrollType12, nReqNoah = @19x20ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+19)+->(+20)'
                                        UPDATE ITEM_UPGRADE SET nGenRate =  @20x21ReverseItemStrengthenScrollType12, nReqNoah = @20x21ReverseItemStrengthenScrollType12Noah WHERE ItemType='12' and nReqItem1='379257000' and UpgradeNote='(+20)+->(+21)'
  UPDATE ITEM_UPGRADE SET nGenRate =  @0x1AccessoryCompoundScroll379159000Type4, nReqNoah = @0x1AccessoryCompoundScroll379159000Type4Noah WHERE ItemType='4' and nReqItem1='379159000' and UpgradeNote='(+0)-->(+1)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @1x2AccessoryCompoundScroll379159000Type4, nReqNoah = @1x2AccessoryCompoundScroll379159000Type4Noah WHERE ItemType='4' and nReqItem1='379159000' and UpgradeNote='(+1)-->(+2)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @2x3AccessoryCompoundScroll379159000Type4, nReqNoah = @2x3AccessoryCompoundScroll379159000Type4Noah WHERE ItemType='4' and nReqItem1='379159000' and UpgradeNote='(+2)-->(+3)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @3x4AccessoryCompoundScroll379159000Type4, nReqNoah = @3x4AccessoryCompoundScroll379159000Type4Noah WHERE ItemType='4' and nReqItem1='379159000' and UpgradeNote='(+3)-->(+4)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @4x5AccessoryCompoundScroll379159000Type4, nReqNoah = @4x5AccessoryCompoundScroll379159000Type4Noah WHERE ItemType='4' and nReqItem1='379159000' and UpgradeNote='(+4)-->(+5)'
  UPDATE ITEM_UPGRADE SET nGenRate =  @5x6AccessoryCompoundScroll379159000Type5, nReqNoah = @5x6AccessoryCompoundScroll379159000Type5Noah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-5)->(+-6)'
    UPDATE ITEM_UPGRADE SET nGenRate =  @6x7AccessoryCompoundScroll379159000Type5, nReqNoah = @6x7AccessoryCompoundScroll379159000Type5Noah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-6)->(+-7)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @7x8AccessoryCompoundScroll379159000Type5, nReqNoah = @7x8AccessoryCompoundScroll379159000Type5Noah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-7)->(+-8)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @8x9AccessoryCompoundScroll379159000Type5, nReqNoah = @8x9AccessoryCompoundScroll379159000Type5Noah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-8)->(+-9)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @9x10AccessoryCompoundScroll379159000Type5, nReqNoah = @9x10AccessoryCompoundScroll379159000Type5Noah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-9)->(+-10)'
	UPDATE ITEM_UPGRADE SET nGenRate =  @1x2AccessoryCompoundScroll379159000Type5Con, nReqNoah = @1x2AccessoryCompoundScroll379159000Type5ConNoah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-1)->(+-2)'
      UPDATE ITEM_UPGRADE SET nGenRate =  @2x3AccessoryCompoundScroll379159000Type5Con, nReqNoah = @2x3AccessoryCompoundScroll379159000Type5ConNoah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-2)->(+-3)'
        UPDATE ITEM_UPGRADE SET nGenRate =  @3x4AccessoryCompoundScroll379159000Type5Con, nReqNoah = @3x4AccessoryCompoundScroll379159000Type5ConNoah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-3)->(+-4)'
          UPDATE ITEM_UPGRADE SET nGenRate =  @4x5AccessoryCompoundScroll379159000Type5Con, nReqNoah = @4x5AccessoryCompoundScroll379159000Type5ConNoah WHERE ItemType='5' and nReqItem1='379159000' and UpgradeNote='(+-4)->(+-5)'
	UPDATE ITEM_UPGRADE SET nGenRate =  @AccessoryEnchantScrollSTR379160000, nReqNoah = @AccessoryEnchantScrollSTR379160000Noah WHERE ItemType='5' and nReqItem1='379160000' and UpgradeNote='(--10)->(--1)'
	  UPDATE ITEM_UPGRADE SET nGenRate =  @AccessoryEnchantScrollHP379161000, nReqNoah = @AccessoryEnchantScrollHP379161000Noah WHERE ItemType='5' and nReqItem1='379161000' and UpgradeNote='(--10)->(--1)'
	    UPDATE ITEM_UPGRADE SET nGenRate =  @AccessoryEnchantScrollDEX379162000, nReqNoah = @AccessoryEnchantScrollDEX379162000Noah WHERE ItemType='5' and nReqItem1='379162000' and UpgradeNote='(--10)->(--1)'
	      UPDATE ITEM_UPGRADE SET nGenRate =  @AccessoryEnchantScrollINT379163000, nReqNoah = @AccessoryEnchantScrollINT379163000Noah WHERE ItemType='5' and nReqItem1='379163000' and UpgradeNote='(--10)->(--1)'
	        UPDATE ITEM_UPGRADE SET nGenRate =  @AccessoryEnchantScrollMP379164000, nReqNoah = @AccessoryEnchantScrollMP379164000Noah WHERE ItemType='5' and nReqItem1='379164000' and UpgradeNote='(--10)->(--1)'
	UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379216000' and ItemType='5'
	  UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379217000' and ItemType='5'
	    UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379218000' and ItemType='5'
	      UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379219000' and ItemType='5'
	        UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379220000' and ItemType='5'
	          UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379230000' and ItemType='5'
	            UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379231000' and ItemType='5'
	              UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379232000' and ItemType='5'
	                UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379233000' and ItemType='5'
	                  UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379234000' and ItemType='5'
	                    UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379235000' and ItemType='5'
	                      UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379215000' and ItemType='5'
	                        UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379138000' and ItemType='5'
	                          UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379139000' and ItemType='5'
	                            UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379140000' and ItemType='5'
	                              UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379141000' and ItemType='5'
	                                UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379034000' and ItemType='5'
	                                  UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAll, nReqNoah = @DispellScrollAllNoah WHERE nReqItem1='379035000' and ItemType='5'
	UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379216000' and ItemType='11'
	  UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379217000' and ItemType='11'
	    UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379218000' and ItemType='11'
	      UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379219000' and ItemType='11'
	        UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379220000' and ItemType='11'
	          UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379230000' and ItemType='11'
	            UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379231000' and ItemType='11'
	              UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379232000' and ItemType='11'
	                UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379233000' and ItemType='11'
	                  UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379234000' and ItemType='11'
	                    UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379235000' and ItemType='11'
	                      UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379215000' and ItemType='11'
	                        UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379138000' and ItemType='11'
	                          UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379139000' and ItemType='11'
	                            UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379140000' and ItemType='11'
	                              UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379141000' and ItemType='11'
	                                UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379034000' and ItemType='11'
	                                  UPDATE ITEM_UPGRADE SET nGenRate =  @DispellScrollAllType11, nReqNoah = @DispellScrollAllType11Noah WHERE nReqItem1='379035000' and ItemType='11'
	UPDATE ITEM_UPGRADE SET nGenRate =  @0x1BlessedElementalScroll379025000Type4, nReqNoah = @0x1BlessedElementalScroll379025000Type4Noah WHERE nReqItem1='379025000' and ItemType='4' and UpgradeNote LIKE '(+0+)->(+1+)'

	UPDATE ITEM_UPGRADE SET nGenRate =  @6x7100UpgradeScrollItemType5, nReqNoah = @6x7100UpgradeScrollItemType5Noah WHERE nReqItem1='379152000' and ItemType='5' and UpgradeNote LIKE '(+6 -> +7)'
		UPDATE ITEM_UPGRADE SET nGenRate =  @6x7100UpgradeScrollItemType4, nReqNoah = @6x7100UpgradeScrollItemType4Noah WHERE nReqItem1='379152000' and ItemType='4' and UpgradeNote LIKE '(+6+)->(+7+)'
END

GO

-- =============================================
-- Procedure: SKILLSHORTCUT_SAVE
-- Database: KO_DATABASE_SERVER_001
-- =============================================
/* Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...*/
-- =============================================
-- Author:		TheThyke
-- Create date: 13.10.2017
-- Update date: 13.10.2017
-- =============================================
CREATE PROCEDURE [dbo].[SKILLSHORTCUT_SAVE]
@strCharID 	varchar(21),
@nCount	smallint,
@strSkillData binary(320)
AS

   SELECT strCharID FROM USERDATA_SKILLSHORTCUT WHERE strCharID = @strCharID
      IF(@@rowcount = 0)
        BEGIN
          INSERT USERDATA_SKILLSHORTCUT VALUES(@strCharID, 0,0x00)
            END
              UPDATE USERDATA_SKILLSHORTCUT SET nCount = @nCount, strSkillData = @strSkillData WHERE strCharID = @strCharID

GO



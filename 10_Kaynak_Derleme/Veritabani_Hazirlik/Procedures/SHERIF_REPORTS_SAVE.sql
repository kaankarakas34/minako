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

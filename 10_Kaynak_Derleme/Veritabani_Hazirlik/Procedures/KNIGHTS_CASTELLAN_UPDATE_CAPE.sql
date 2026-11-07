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

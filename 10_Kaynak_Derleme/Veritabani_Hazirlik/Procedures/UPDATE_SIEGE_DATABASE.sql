CREATE PROCEDURE [dbo].[UPDATE_SIEGE_DATABASE]
@nMoradonTax int,
@nDelosTax int,
@nDungeonCharge int
AS

UPDATE KNIGHTS_SIEGE_WARFARE SET nMoradonTax = @nMoradonTax,nDellosTax = @nDelosTax, nDungeonCharge = @nDungeonCharge

$ErrorActionPreference='Stop'
$taskConnection=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
    $taskConnection.Open();if($taskConnection.Database -ne 'KNIGHT_TEMU_2239'){throw 'Wrong database.'}
    $taskCommand=$taskConnection.CreateCommand()
    $taskCommand.CommandText=@'
BEGIN TRANSACTION;
UPDATE dbo.game_server_list SET strserverip='127.0.0.1',strlanip='127.0.0.1',strservername='KnightLocal2239|Local-1',strkaruskingname='',strkarusnotice='',strelmoradkingname='',strelmoradnotice='';
UPDATE dbo.event_start_schedule SET eventstatus=0;
UPDATE dbo.hook_settings SET button_facebook=0,button_discord=0,button_live=0,button_support=0,url_facebook='',url_discord='',url_live='',url_kcbayi='';
-- Foreign launcher patches are not available in this lab. With an empty list,
-- LoginServer retains its compiled 2239 version and advertises no fake patches.
DELETE FROM dbo.[version];
COMMIT;
'@
    [void]$taskCommand.ExecuteNonQuery()
    'Loopback settings applied; automatic events paused; foreign patch list removed from the lab only.'
}finally{$taskConnection.Dispose()}

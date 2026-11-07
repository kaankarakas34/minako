"""Local launcher compatibility test; original client EXE stays unmodified.

The parent process remains alive while testing the client's normal process-ID
launch argument. This does not disable or patch any client protection checks.
"""
from pathlib import Path
import argparse,datetime,json,os,subprocess

ROOT=Path(__file__).resolve().parent
def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--client-dir',type=Path,default=Path(r'C:\Users\murat\KnightOnlineLab\ClientGamesoft'))
    parser.add_argument('--seconds',type=int,default=0,help='0 keeps the launcher alive until the game exits; positive values bound a diagnostic run.')
    args=parser.parse_args();assert 0<=args.seconds<=900
    client=args.client_dir/'KnightOnLine.exe'
    if not client.is_file():raise SystemExit('Client executable not found.')
    child=subprocess.Popen([str(client),str(os.getpid())],cwd=args.client_dir)
    result={'StartedUtc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
            'ParentPid':os.getpid(),'ClientPid':child.pid,'ArgumentMode':'live parent process ID',
            'WorkingDirectory':str(args.client_dir),'ClientBinaryPatched':False,
            'GraphicalLoginVerified':False,'Published':False}
    (ROOT/'local-launcher-test.json').write_text(json.dumps(result,indent=2),encoding='utf8')
    print(json.dumps(result),flush=True)
    try:
        result['ExitCode']=child.wait(timeout=args.seconds or None)
        result['StoppedAfterTimeout']=False
    except subprocess.TimeoutExpired:
        child.terminate();child.wait();result['StoppedAfterTimeout']=True
    finally:(ROOT/'local-launcher-test.json').write_text(json.dumps(result,indent=2),encoding='utf8')

if __name__=='__main__':main()

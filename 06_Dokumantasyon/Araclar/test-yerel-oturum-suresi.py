"""Black-box check that the intended 30-second idle limit remains enforced."""
import json,select,socket,time
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
with socket.create_connection(('127.0.0.1',15001),timeout=5) as sock:
    started=time.monotonic()
    ready=select.select([sock],[],[],33)[0]
    elapsed=time.monotonic()-started
    closed=bool(ready and sock.recv(1,socket.MSG_PEEK)==b'')
    assert closed and 29.8<=elapsed<=33, ('Unexpected idle cutoff',round(elapsed,3),closed)
    result={'Endpoint':'127.0.0.1:15001','IntendedIdleSeconds':30,
            'ObservedIdleCutoffSeconds':round(elapsed,3),'IdleTimeoutStillEnforced':True,'CredentialsSent':False}
(ROOT/'11_Istemci_Uyumluluk/session-timeout-test.json').write_text(json.dumps(result,indent=2),encoding='utf8')
print(json.dumps(result))

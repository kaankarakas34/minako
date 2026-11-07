"""Verify actual socket buffering when a KO frame arrives in pieces."""
import json,select,socket,struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]

def exact(s,n):
    data=bytearray()
    while len(data)<n:
        chunk=s.recv(n-len(data))
        if not chunk:raise RuntimeError('Connection closed before complete response')
        data.extend(chunk)
    return bytes(data)

def test(port,payload):
    frame=b'\xaa\x55'+struct.pack('<H',len(payload))+payload+b'\x55\xaa'
    with socket.create_connection(('127.0.0.1',port),timeout=5) as s:
        s.settimeout(5)
        # A normal TCP split: header, payload, then the footer.
        for chunk in [frame[:4],frame[4:-2]]:
            s.sendall(chunk)
            assert not select.select([s],[],[],0.10)[0], 'Server closed/responded before footer arrived'
        s.sendall(frame[-2:])
        header=exact(s,4);assert header[:2]==b'\xaa\x55'
        n=struct.unpack_from('<H',header,2)[0]
        body=exact(s,n);assert exact(s,2)==b'\x55\xaa'
        assert body[0]==payload[0]
        return n

if __name__=='__main__':
    game=test(15001,b'\x2b');login=test(15100,b'\x01')
    result={'GameServerFragmentedFramePassed':game==13,'LoginServerFragmentedFramePassed':login==3,'ConnectionKeptUntilFooter':True,'CredentialsSent':False}
    assert all([result['GameServerFragmentedFramePassed'],result['LoginServerFragmentedFramePassed']])
    (ROOT/'11_Istemci_Uyumluluk/tcp-fragmentation-test.json').write_text(json.dumps(result,indent=2),encoding='utf8')
    print(json.dumps(result))

"""Exercise the supplied stock client's encrypted login wire protocol locally.

Credentials stay in memory and are sent only to the fixed loopback endpoint.
This proves server protocol behavior, separately from the graphical client.
"""
from pathlib import Path
import argparse, json, socket, struct, zlib
from ko_password import encode_password
from ko_server_list import parse_server_list
ROOT = Path(__file__).resolve().parents[2]
KEY = 0x1207500120128966  # supplied patch client, VA 0x48bfa0

def exact(sock, n):
    out = bytearray()
    while len(out) < n:
        part = sock.recv(n-len(out))
        if not part: raise RuntimeError('Connection closed during encrypted protocol test')
        out.extend(part)
    return bytes(out)

def exchange(sock, data):
    sock.sendall(b'\xaa\x55'+struct.pack('<H',len(data))+data+b'\x55\xaa')
    head = exact(sock,4); assert head[:2] == b'\xaa\x55'
    n = struct.unpack_from('<H',head,2)[0]; assert 0 < n <= 32768
    reply = exact(sock,n); assert exact(sock,2) == b'\x55\xaa'
    return reply

def crypt(data, key):
    keybytes = struct.pack('<Q',key); rolling = 2157; lengthkey = len(data)*157 & 255
    out = bytearray()
    for i,c in enumerate(data):
        out.append(c ^ (rolling>>8 & 255) ^ keybytes[i%8] ^ lengthkey)
        rolling = rolling*2171 & 0xffffffff
    return bytes(out)

def string(value):
    raw = value.encode('ascii'); return struct.pack('<H',len(raw))+raw

def run():
    creds = json.loads((ROOT/'11_Istemci_Uyumluluk/local-test-account.private.json').read_text(encoding='utf-8-sig'))
    assert creds['Account'] == 'KnightLab1' and creds['Database'] == 'KNIGHT_TEMU_2239'
    checks = []
    for password, code in [('WrongLocal123',3),(creds['Password'],1)]:
        with socket.create_connection(('127.0.0.1',15100),timeout=5) as sock:
            sock.settimeout(5)
            public = exchange(sock,b'\xf2'); assert len(public) == 9 and public[0] == 0xf2
            key = struct.unpack_from('<Q',public,1)[0] ^ KEY
            def request(seq, payload):
                plain = struct.pack('<I',seq)+payload
                plain += struct.pack('<I',zlib.crc32(plain)^0xffffffff)
                reply = crypt(exchange(sock,crypt(plain,key)),key)
                assert reply[:2] == b'\xfc\x1e' and struct.unpack_from('<H',reply,2)[0] == seq
                assert reply[4] == 0 and reply[5] == payload[0]
                return reply[5:]
            login = request(1,b'\xf3'+string(creds['Account'])+string(encode_password(password)))
            assert login[1:3] == b'\0\0' and login[3] == code
            if code == 1:
                servers = request(2,b'\xf5'+struct.pack('<H',0x4b4f))
                assert servers[1:3] == b'OK' and servers[3] == 1
                assert b'127.0.0.2' in servers and b'KnightLocal2239' in servers
                parsed = parse_server_list(servers)
                assert parsed['VisibleGroups'] == ['KnightLocal2239'], 'Client would show no named server group'
                assert parsed['Servers'][0]['Channel'] == 'Local-1', 'Missing local channel name'
            checks.append(code)
    return {'Endpoint':'127.0.0.1:15100','ClientProfile':'supplied patch, stock protocol', 'PasswordFormat':'HashPasswordString', 'EncryptedHandshake':True,'ValidAccountAccepted':1 in checks,'WrongPasswordRejected':3 in checks,'EncryptedServerListValidated':True,'VisibleGroups':parsed['VisibleGroups'],'Channel':parsed['Servers'][0]['Channel'],'GraphicalClientVerified':False,'CredentialsLogged':False}

if __name__ == '__main__':
    p=argparse.ArgumentParser();p.add_argument('--baseline',action='store_true');args=p.parse_args()
    try: result=run()
    except (OSError,RuntimeError,AssertionError) as e:
        result={'Passed':False,'Failure':type(e).__name__,'Detail':str(e),'CredentialsLogged':False}
    (ROOT/'11_Istemci_Uyumluluk'/('encrypted-login-baseline.json' if args.baseline else 'encrypted-login-test.json')).write_text(json.dumps(result,indent=2),encoding='utf-8')
    print(json.dumps(result))
    if result.get('Passed') is False: raise SystemExit(1)

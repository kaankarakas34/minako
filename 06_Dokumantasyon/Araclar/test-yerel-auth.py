"""Validate the local login server against the synthetic lab account.

The generated password is read from a private local file and is never printed,
logged, or sent anywhere except the fixed loopback login endpoint.
"""
from pathlib import Path
import importlib.util,json,socket,struct
from ko_password import encode_password
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('ko_protocol',Path(__file__).with_name('istemci-protokol-test.py'))
protocol=importlib.util.module_from_spec(spec);spec.loader.exec_module(protocol)
credentials=json.loads((ROOT/'11_Istemci_Uyumluluk/local-test-account.private.json').read_text(encoding='utf-8-sig'))
assert credentials['Database']=='KNIGHT_TEMU_2239' and credentials['Account']=='KnightLab1'

def ko_string(value):
    raw=value.encode('ascii');return struct.pack('<H',len(raw))+raw

def login(password):
    with socket.create_connection(('127.0.0.1',15100),timeout=5) as connection:
        connection.settimeout(5)
        reply=protocol.exchange(connection,b'\xf3'+ko_string(credentials['Account'])+ko_string(encode_password(password)))
        assert len(reply)>=4
        assert reply[1:3]==b'\0\0','Unexpected login response reserved fields'
        return reply[3],len(reply)

wrong,wrong_bytes=login('WrongLocal123');assert wrong==3,('Wrong password response',wrong)
valid,valid_bytes=login(credentials['Password']);assert valid==1,('Valid account response',valid)
result={'Endpoint':'127.0.0.1:15100','Account':'KnightLab1','ValidNativeLogin':valid==1,
        'WrongPasswordRejected':wrong==3,'ValidResponseBytes':valid_bytes,
        'WrongResponseBytes':wrong_bytes,'CredentialsLogged':False,'GraphicalClientLoginTested':False,
        'Limits':'Native source protocol integration test. Graphical client compatibility is separate.'}
(ROOT/'06_Dokumantasyon/Derleme/local-account-network-test.json').write_text(json.dumps(result,indent=2),encoding='utf8')
print(json.dumps(result))

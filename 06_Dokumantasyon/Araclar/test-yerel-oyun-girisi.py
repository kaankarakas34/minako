"""Test the real local GameServer's stock-client handshake and account login.

No nation is selected, no character is created, and credentials are not logged.
"""
from pathlib import Path
import argparse,datetime,importlib.util,json,select,socket,struct,zlib
from ko_password import encode_password
ROOT=Path(__file__).resolve().parents[2]
spec=importlib.util.spec_from_file_location('stock_wire',Path(__file__).with_name('test-yerel-sifreli-giris.py'))
wire=importlib.util.module_from_spec(spec);spec.loader.exec_module(wire)

def login(password, account, endpoint, delayed=False):
    with socket.create_connection((endpoint,15001),timeout=5) as sock:
        sock.settimeout(10)
        if delayed:
            assert not select.select([sock],[],[],2)[0], 'Server closed the idle handshake too early'
        hello=wire.exchange(sock,b'\x2b')
        assert len(hello)==13 and hello[0]==0x2b and hello[1]==0
        assert struct.unpack_from('<H',hello,2)[0]==2083
        public=struct.unpack_from('<Q',hello,4)[0];assert public and hello[12]==0
        key=public^wire.KEY
        plain=struct.pack('<I',1)+b'\x01'+wire.string(account)+wire.string(encode_password(password))
        plain+=struct.pack('<I',zlib.crc32(plain)^0xffffffff)
        response=wire.crypt(wire.exchange(sock,wire.crypt(plain,key)),key)
        assert response[:5]==b'\xfc\x1e\x01\x00\x00' and response[5]==1
        if delayed and response[6]==0:
            assert not select.select([sock],[],[],3)[0], 'Server closed country/character selection too early'
            # Read the empty character list after waiting; no nation or character mutation.
            request=struct.pack('<I',2)+b'\x0c\x01'
            request+=struct.pack('<I',zlib.crc32(request)^0xffffffff)
            chars=wire.crypt(wire.exchange(sock,wire.crypt(request,key)),key)
            assert chars[:5]==b'\xfc\x1e\x02\x00\x00' and chars[5:8]==b'\x0c\x01\x01'
        return response[6]

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--relay',action='store_true');args=parser.parse_args()
    endpoint='127.0.0.2' if args.relay else '127.0.0.1'
    def mark(event):
        if args.relay:
            with (ROOT/'11_Istemci_Uyumluluk/protocol-probe-windows.jsonl').open('a',encoding='utf8') as log:
                log.write(json.dumps({'Utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'Event':event,'Source':'Automated game account probe','Port':15001})+'\n')
    credentials=json.loads((ROOT/'11_Istemci_Uyumluluk/local-test-account.private.json').read_text(encoding='utf-8-sig'))
    assert credentials['Account']=='KnightLab1' and credentials['Database']=='KNIGHT_TEMU_2239'
    mark('ProbeStart')
    try:
        wrong=login('WrongLocal123',credentials['Account'],endpoint);assert wrong==255, 'Wrong game password accepted'
        good=login(credentials['Password'],credentials['Account'],endpoint,delayed=True);assert good==0, ('Fresh account did not reach nation selection',good)
    finally:mark('ProbeEnd')
    result={'Endpoint':endpoint+':15001','EngineSourceVersion':2239,'ClientWireVersion':2083,
            'EncryptedGameHandshake':True,'CorrectPasswordAccepted':True,'WrongPasswordRejected':True,
            'FreshAccountNationSelectionAllowed':True,'NationChanged':False,'CharacterCreated':False,
            'DelayedHandshakeSurvivedSeconds':2,'PostAuthSelectionSurvivedSeconds':3,'CharacterListAfterDelayReceived':True,
            'GraphicalGameEntryVerified':False,'CredentialsLogged':False}
    (ROOT/'11_Istemci_Uyumluluk'/('game-account-relay-test.json' if args.relay else 'game-account-network-test.json')).write_text(json.dumps(result,indent=2),encoding='utf8')
    print(json.dumps(result))

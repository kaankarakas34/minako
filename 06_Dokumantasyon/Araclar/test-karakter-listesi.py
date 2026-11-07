"""Read the repaired local character through the real encrypted GameServer.

By default only the list is read. --select also exercises character loading,
then disconnects normally without movement or gameplay requests.
"""
from pathlib import Path
import argparse, importlib.util, json, socket, struct, zlib
from ko_password import encode_password

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location('stock_wire', Path(__file__).with_name('test-yerel-sifreli-giris.py'))
wire = importlib.util.module_from_spec(spec)
spec.loader.exec_module(wire)

def run(select_character=False, expected_class=None, game_start=False):
    credentials = json.loads((ROOT/'11_Istemci_Uyumluluk/local-test-account.private.json').read_text(encoding='utf-8-sig'))
    assert credentials['Account'] == 'KnightLab1'
    with socket.create_connection(('127.0.0.1',15001), timeout=5) as sock:
        sock.settimeout(10)
        hello = wire.exchange(sock,b'\x2b')
        assert len(hello)==13 and struct.unpack_from('<H',hello,2)[0]==2083
        key = struct.unpack_from('<Q',hello,4)[0]^wire.KEY
        def request(seq,payload):
            plain = struct.pack('<I',seq)+payload
            plain += struct.pack('<I',zlib.crc32(plain)^0xffffffff)
            response = wire.crypt(wire.exchange(sock,wire.crypt(plain,key)),key)
            assert response[:5]==b'\xfc\x1e'+struct.pack('<H',seq)+b'\x00'
            return response[5:]
        response = request(1,b'\x01'+wire.string(credentials['Account'])+wire.string(encode_password(credentials['Password'])))
        assert response[0:2]==b'\x01\x01', 'Karus account login failed'
        response = request(2,b'\x0c\x01')
        assert response[:3]==b'\x0c\x01\x01'
        at=3
        characters=[]
        for slot in range(4):
            n=struct.unpack_from('<H',response,at)[0];at+=2
            name=response[at:at+n].decode('ascii');at+=n
            race,job,level,face,hair,zone=struct.unpack_from('<BHBBIB',response,at);at+=10
            equipment=[]
            for _ in range(8):
                item,durability=struct.unpack_from('<IH',response,at);at+=6
                equipment.append({'Item':item,'Durability':durability})
            if name:
                characters.append({'Slot':slot,'Name':name,'Race':race,'Class':job,'Level':level,'Face':face,'Hair':hair,'Zone':zone,'Equipment':equipment})
        assert at==len(response), (at,len(response))
        assert len(characters)==1 and characters[0]['Name']=='cabbar'
        assert characters[0]['Race']==4 and 1<=characters[0]['Level']<=83
        # Job changes and advancement can change the class after creation.
        if expected_class is not None:
            assert characters[0]['Class']==expected_class, ('Character class differs from expected database snapshot', characters[0]['Class'], expected_class)
        # '#(' ASCII inventory used to produce 0x33322823 here instead of an item ID.
        assert all(e['Item']!=0x33322823 for c in characters for e in c['Equipment'])
        select_result=None
        start_opcodes=[]
        packets=[]
        if select_character:
            response=request(3,b'\x04'+wire.string(credentials['Account'])+wire.string('cabbar')+b'\x01')
            for _ in range(30):
                packets.append({'Opcode':response[0],'Bytes':len(response)})
                if response[0]==4:
                    select_result=response[1]
                    break
                head=wire.exact(sock,4);assert head[:2]==b'\xaa\x55'
                n=struct.unpack_from('<H',head,2)[0]
                decoded=wire.crypt(wire.exact(sock,n),key)
                assert wire.exact(sock,2)==b'\x55\xaa' and decoded[:2]==b'\xfc\x1e'
                response=decoded[5:]
            assert select_result==1, ('Character selection rejected',select_result,packets)
            if game_start:
                # Story is a small, uncompressed 0x81 packet. Stop at GAMESTART;
                # do not send phase 2, movement, combat or character changes.
                response=request(4,b'\x0d\x01')
                for _ in range(100):
                    start_opcodes.append(response[0])
                    assert response[0]!=0x81, 'Unexpected introductory story packet'
                    if response[0]==0x0d:
                        break
                    head=wire.exact(sock,4);assert head[:2]==b'\xaa\x55'
                    n=struct.unpack_from('<H',head,2)[0]
                    decoded=wire.crypt(wire.exact(sock,n),key)
                    assert wire.exact(sock,2)==b'\x55\xaa' and decoded[:2]==b'\xfc\x1e'
                    response=decoded[5:]
                assert start_opcodes[-1]==0x0d, ('Game start acknowledgement missing',start_opcodes)
    return {'RealGameServerCharacterListPassed':True,'Characters':characters,'CharacterSelectAccepted':select_result,'SelectionPackets':packets,'GameStartPhaseOneAccepted':bool(start_opcodes),'IntroStoryPacketAbsent':(0x81 not in start_opcodes) if start_opcodes else None,'GameStartOpcodes':start_opcodes,'GameplayPerformed':False,'GraphicalRenderingVerified':False,'CredentialsLogged':False}

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--select',action='store_true');parser.add_argument('--expected-class',type=int);parser.add_argument('--game-start',action='store_true');args=parser.parse_args()
    result=run(args.select or args.game_start,args.expected_class,args.game_start)
    filename='character-select-network-test.json' if args.select or args.game_start else 'character-list-network-test.json'
    (ROOT/'11_Istemci_Uyumluluk'/filename).write_text(json.dumps(result,indent=2),encoding='utf8')
    print(json.dumps(result))

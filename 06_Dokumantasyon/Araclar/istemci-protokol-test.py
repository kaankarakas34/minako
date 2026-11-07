"""Local diagnostic client for this source's public version/server-list packets.

This is a protocol test, not a graphical game client or an anti-cheat bypass.
Only loopback endpoints are accepted. It never sends account credentials.
"""
from pathlib import Path
import argparse,json,socket,struct

def exact(s,count):
    data=bytearray()
    while len(data)<count:
        part=s.recv(count-len(data))
        if not part:raise RuntimeError('Server closed connection before completing the packet')
        data.extend(part)
    return bytes(data)

def exchange(s,payload):
    s.sendall(b'\xaa\x55'+struct.pack('<H',len(payload))+payload+b'\x55\xaa')
    header=exact(s,4);assert header[:2]==b'\xaa\x55',header.hex()
    length=struct.unpack_from('<H',header,2)[0];assert 0<length<=32768,length
    reply=exact(s,length);assert exact(s,2)==b'\x55\xaa'
    assert reply[0]==payload[0],(reply[0],payload[0])
    return reply

def probe(server):
    port=15001 if server=='GameServer' else 15100
    with socket.create_connection(('127.0.0.1',port),timeout=5) as connection:
        connection.settimeout(5)
        reply=exchange(connection,b'\x2b' if server=='GameServer' else b'\x01')
        if server=='GameServer':
            assert len(reply)==13,len(reply)
            assert reply[1]==0,'Version handshake rejected'
            version=struct.unpack_from('<H',reply,2)[0]
        else:
            assert len(reply)==3,len(reply)
            version=struct.unpack_from('<H',reply,1)[0]
        assert version==(2083 if server=='GameServer' else 2239),('Unexpected profile version',version)
        result={'Server':server,'Port':port,'FramingValidated':True,'NativeVersion':version,
                'EngineSourceVersion':2239,'VersionReplyBytes':len(reply),'CredentialsSent':False,'GraphicalClientTested':False}
        if server=='LogInServer':
            reply=exchange(connection,b'\xf5'+struct.pack('<H',0x4b4f))
            assert struct.unpack_from('<H',reply,1)[0]==0x4b4f
            assert reply[3]>=1,'No game servers advertised'
            assert b'127.0.0.2' in reply and b'KnightLocal2239|Local-1' in reply
            result.update(ServerListValidated=True,AdvertisedServers=reply[3])
        return result

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--server',choices=['GameServer','LogInServer'],required=True)
    args=parser.parse_args();result=probe(args.server)
    output=Path(__file__).resolve().parents[2]/'06_Dokumantasyon/Derleme'/(args.server+'-protocol-test.json')
    output.write_text(json.dumps(result,indent=2),encoding='utf8');print(json.dumps(result))

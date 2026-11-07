"""Transparent loopback relay. Records frame metadata, never login payloads."""
from pathlib import Path
import argparse,asyncio,datetime,json,struct
ROOT=Path(__file__).resolve().parents[2]
LOG=ROOT/'11_Istemci_Uyumluluk/connection-metadata.jsonl'
PORTS=[15001,*range(15100,15110)]
CONTENT_VERSION=None
VERSION_PREFIX=False

def record(**event):
    event={'Utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),**event}
    with LOG.open('a',encoding='utf8') as stream:stream.write(json.dumps(event)+'\n')

async def accept(reader,writer,port):
    record(Event='Connect',Port=port)
    try:remote_r,remote_w=await asyncio.open_connection('127.0.0.1',port)
    except Exception as e:
        record(Event='UpstreamError',Port=port,Error=type(e).__name__);writer.close();return
    async def pump(source,dest,direction):
        buffer=bytearray()
        total_bytes=0
        while data:=await source.read(32768):
            total_bytes+=len(data)
            # Experimental launcher-content revision translation only. The
            # game's 0x2B wire-version response is never changed here.
            if CONTENT_VERSION is not None and port!=15001 and direction=='ServerToClient' and len(data)>=9 and data[:5]==b'\xaa\x55\x03\x00\x01' and data[7:9]==b'\x55\xaa':
                previous=struct.unpack_from('<H',data,5)[0]
                if VERSION_PREFIX:
                    data=data[:2]+struct.pack('<H',5)+b'\x01\x00\x00'+struct.pack('<H',CONTENT_VERSION)+data[7:]
                else:data=data[:5]+struct.pack('<H',CONTENT_VERSION)+data[7:]
                record(Event='LauncherContentRevisionTrial',Port=port,Previous=previous,Revision=CONTENT_VERSION)
            buffer.extend(data)
            while len(buffer)>=4:
                if buffer[:2]!=b'\xaa\x55':
                    record(Event='UnknownFraming',Port=port,Direction=direction,Bytes=len(buffer));buffer.clear();break
                size=struct.unpack_from('<H',buffer,2)[0]
                if size>32768:record(Event='OversizeFrame',Port=port,Direction=direction,Bytes=size);buffer.clear();break
                if len(buffer)<size+6:break
                record(Event='Frame',Port=port,Direction=direction,Bytes=size,
                       FirstProtocolByte=int(buffer[4]) if size else None,FooterValid=buffer[size+4:size+6]==b'\x55\xaa')
                del buffer[:size+6]
            # Record metadata before forwarding: an upstream reset during
            # drain must not hide the packet that triggered the disconnect.
            try:
                dest.write(data);await dest.drain()
            except ConnectionError as error:
                record(Event='ForwardError',Port=port,Direction=direction,
                       Bytes=total_bytes,Error=type(error).__name__)
                raise
        record(Event='ReadEOF',Port=port,Direction=direction,Bytes=total_bytes,
               IncompleteFrameBytes=len(buffer))
        dest.close()
    try:await asyncio.gather(pump(reader,remote_w,'ClientToServer'),pump(remote_r,writer,'ServerToClient'))
    except (ConnectionError,asyncio.CancelledError):pass
    finally:writer.close();remote_w.close();record(Event='Disconnect',Port=port)

async def main(seconds):
    servers=[]
    for port in PORTS:
        servers.append(await asyncio.start_server(lambda r,w,p=port:accept(r,w,p),'127.0.0.2',port))
    print('Local protocol relay ready on 127.0.0.2; payload logging disabled.',flush=True)
    try:
        if seconds:await asyncio.sleep(seconds)
        else:await asyncio.Event().wait()
    finally:
        for server in servers:server.close();await server.wait_closed()

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--seconds',type=int,default=300);p.add_argument('--content-version',type=int);p.add_argument('--version-prefix',action='store_true');a=p.parse_args()
    assert 0<=a.seconds<=900
    if a.content_version is not None:assert 0<=a.content_version<=65535
    CONTENT_VERSION=a.content_version
    VERSION_PREFIX=a.version_prefix
    asyncio.run(main(a.seconds))

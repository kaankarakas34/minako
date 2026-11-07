"""Read IP-address strings from the isolated test client's readable memory.

No debugger attachment, writes, code injection or protection changes. No raw
memory, account names or passwords are saved. The target must be this lab copy.
"""
from pathlib import Path
import argparse,ctypes as c,json,re,ipaddress,datetime,socket,struct
from ctypes import wintypes as w
ROOT=Path(__file__).resolve().parents[2]

class MemoryInfo(c.Structure):
    _fields_=[('BaseAddress',c.c_void_p),('AllocationBase',c.c_void_p),('AllocationProtect',w.DWORD),
              ('RegionSize',c.c_size_t),('State',w.DWORD),('Protect',w.DWORD),('Type',w.DWORD)]

def main(pid):
    kernel=c.WinDLL('kernel32',use_last_error=True)
    kernel.OpenProcess.argtypes=[w.DWORD,w.BOOL,w.DWORD];kernel.OpenProcess.restype=w.HANDLE
    kernel.QueryFullProcessImageNameW.argtypes=[w.HANDLE,w.DWORD,w.LPWSTR,c.POINTER(w.DWORD)]
    kernel.VirtualQueryEx.argtypes=[w.HANDLE,c.c_void_p,c.POINTER(MemoryInfo),c.c_size_t]
    kernel.VirtualQueryEx.restype=c.c_size_t
    kernel.ReadProcessMemory.argtypes=[w.HANDLE,c.c_void_p,c.c_void_p,c.c_size_t,c.POINTER(c.c_size_t)]
    kernel.CloseHandle.argtypes=[w.HANDLE]
    handle=kernel.OpenProcess(0x0410,False,pid)
    if not handle:raise c.WinError(c.get_last_error())
    try:
        path=c.create_unicode_buffer(32768);length=w.DWORD(len(path))
        if not kernel.QueryFullProcessImageNameW(handle,0,path,c.byref(length)):raise c.WinError(c.get_last_error())
        expected=ROOT/'11_Istemci_Uyumluluk/Gamesoft_Yerel/KnightOnLine.exe'
        assert expected.samefile(path.value),'Target is not the isolated lab client'
        pattern=re.compile(rb'(?<![0-9.])(?:[0-9]{1,3}\.){3}[0-9]{1,3}(?![0-9.])')
        wide=re.compile(rb'(?<![0-9])(?:(?:[0-9]\x00){1,3}\.\x00){3}(?:[0-9]\x00){1,3}')
        address=0x10000;end=0x100000000;hits=[];seen=set();read_bytes=0;regions=0;sockaddrs=[]
        targets=['127.0.0.1','127.0.0.2','185.126.176.179']
        while address<end:
            info=MemoryInfo()
            if not kernel.VirtualQueryEx(handle,c.c_void_p(address),c.byref(info),c.sizeof(info)):break
            base=info.BaseAddress or address;size=info.RegionSize
            if not size:break
            if info.State==0x1000 and not info.Protect&0x101 and size<=64*1024*1024 and info.Type in (0x20000,0x1000000):
                regions+=1
                for offset in range(0,size,65536):
                    count=min(65536,size-offset);buffer=c.create_string_buffer(count);got=c.c_size_t()
                    kernel.ReadProcessMemory(handle,c.c_void_p(base+offset),buffer,count,c.byref(got))
                    data=buffer.raw[:got.value];read_bytes+=len(data)
                    for ip in targets:
                        sockaddr=re.compile(b'\x02\x00([\s\S]{2})'+re.escape(socket.inet_aton(ip)))
                        for match in sockaddr.finditer(data):
                            port=struct.unpack('>H',match[1])[0]
                            if port:sockaddrs.append({'IP':ip,'Port':port,'Address':hex(base+offset+match.start()),'RegionType':hex(info.Type)})
                    for regex,encoding in [(pattern,'ascii'),(wide,'utf-16-le')]:
                        for match in regex.finditer(data):
                            value=match[0].decode(encoding)
                            try:ipaddress.IPv4Address(value)
                            except ValueError:continue
                            location=base+offset+match.start();key=(value,location)
                            if key in seen:continue
                            seen.add(key);hits.append({'IP':value,'Address':hex(location),'RegionType':hex(info.Type),'Encoding':encoding})
            address=base+size
        result={'ClientPid':pid,'Utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
                'ReadOnly':True,'RegionsRead':regions,'BytesScanned':read_bytes,'Addresses':hits,
                'SocketAddresses':sockaddrs,'RawMemorySaved':False,'CredentialsSaved':False}
        output=ROOT/'11_Istemci_Uyumluluk/client-address-inspection.json'
        output.write_text(json.dumps(result,indent=2),encoding='utf8')
        print(json.dumps({'ClientPid':pid,'BytesScanned':read_bytes,'RelevantIPs':[h for h in hits if h['IP'] in targets],'SocketAddresses':sockaddrs}))
    finally:kernel.CloseHandle(handle)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--pid',type=int,required=True);main(p.parse_args().pid)

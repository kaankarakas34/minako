"""Read-only code references to a known address in the isolated client.

Only instruction summaries are saved; no raw process image or credentials.
"""
from pathlib import Path
import argparse,ctypes as c,struct,json
from ctypes import wintypes as w
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
ROOT=Path(__file__).resolve().parents[2]

def run(pid,base,needle):
    k=c.WinDLL('kernel32',use_last_error=True)
    k.OpenProcess.argtypes=[w.DWORD,w.BOOL,w.DWORD];k.OpenProcess.restype=w.HANDLE
    k.ReadProcessMemory.argtypes=[w.HANDLE,c.c_void_p,c.c_void_p,c.c_size_t,c.POINTER(c.c_size_t)]
    k.QueryFullProcessImageNameW.argtypes=[w.HANDLE,w.DWORD,w.LPWSTR,c.POINTER(w.DWORD)]
    k.CloseHandle.argtypes=[w.HANDLE]
    h=k.OpenProcess(0x410,False,pid)
    if not h:raise c.WinError(c.get_last_error())
    try:
        path=c.create_unicode_buffer(32768);n=w.DWORD(len(path))
        assert k.QueryFullProcessImageNameW(h,0,path,c.byref(n))
        assert (ROOT/'11_Istemci_Uyumluluk/Gamesoft_Yerel/KnightOnLine.exe').samefile(path.value)
        def read(address,size):
            b=c.create_string_buffer(size);got=c.c_size_t()
            k.ReadProcessMemory(h,c.c_void_p(address),b,size,c.byref(got))
            return b.raw[:got.value]
        header=read(base,4096);pe=struct.unpack_from('<I',header,0x3c)[0]
        assert header[:2]==b'MZ' and header[pe:pe+4]==b'PE\0\0'
        optional=pe+24;size=struct.unpack_from('<I',header,optional+56)[0]
        assert 0<size<128*1024*1024
        sections=[];count=struct.unpack_from('<H',header,pe+6)[0];opt_size=struct.unpack_from('<H',header,pe+20)[0]
        for i in range(count):
            at=optional+opt_size+40*i
            sections.append({'Name':header[at:at+8].split(b'\0')[0].decode('ascii',errors='replace'),
                'Size':struct.unpack_from('<I',header,at+8)[0],'RVA':struct.unpack_from('<I',header,at+12)[0],
                'Flags':struct.unpack_from('<I',header,at+36)[0]})
        image=bytearray(size)
        for offset in range(0,size,16384):
            b=read(base+offset,min(16384,size-offset));image[offset:offset+len(b)]=b
        refs=[];pattern=struct.pack('<I',needle);offset=0;dis=Cs(CS_ARCH_X86,CS_MODE_32)
        while (offset:=image.find(pattern,offset))>=0:
            section=next((s for s in sections if s['RVA']<=offset<s['RVA']+s['Size']),None)
            start=max(0,offset-24);end=min(size,offset+100)
            # Start exactly at the common push/mov immediate when possible.
            if offset>0 and image[offset-1] in [0x68,*range(0xb8,0xc0)]:start=offset-1
            instructions=[{'Address':hex(ins.address),'Instruction':ins.mnemonic+' '+ins.op_str} for ins in dis.disasm(bytes(image[start:end]),base+start)]
            refs.append({'Address':hex(base+offset),'Section':section,'Instructions':instructions});offset+=4
        result={'Pid':pid,'ModuleBase':hex(base),'TargetAddress':hex(needle),'ReadOnly':True,'Sections':sections,'References':refs}
        (ROOT/'11_Istemci_Uyumluluk/client-ip-code-references.json').write_text(json.dumps(result,indent=2),encoding='utf8')
        print(json.dumps({'Sections':sections,'ReferenceCount':len(refs),'References':refs[:8]}))
    finally:k.CloseHandle(h)

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--pid',type=int,required=True);p.add_argument('--base',type=lambda x:int(x,0),required=True);p.add_argument('--target',type=lambda x:int(x,0),required=True)
    a=p.parse_args();run(a.pid,a.base,a.target)

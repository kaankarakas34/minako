from pathlib import Path
import runpy, sys
from capstone import Cs, CS_ARCH_X86, CS_MODE_32
g=runpy.run_path(str(Path(__file__).with_name('hazir-lua-api.py')))
cs=Cs(CS_ARCH_X86, CS_MODE_32)
for arg in sys.argv[1:]:
    calls_only=arg.startswith('calls:')
    arg=arg.removeprefix('calls:')
    addr=int(arg,16) if arg.startswith('0x') else int(next(r['FunctionVA'] for r in g['rows'] if r['Name']==arg),16)
    for _ in range(3):
        off=g['vaoff'](addr)
        if g['d'][off]==0xe9:
            addr+=5+int.from_bytes(g['d'][off+1:off+5],'little',signed=True)
        else:break
    off=g['vaoff'](addr)
    print(arg,hex(addr))
    for i in cs.disasm(g['d'][off:off+(0x6000 if calls_only else 850)],addr):
        if not calls_only or i.mnemonic in ('call','ret'):
            resolved=''
            if calls_only and i.mnemonic=='call' and i.op_str.startswith('0x'):
                target=int(i.op_str,16)
                for _ in range(3):
                    at=g['vaoff'](target)
                    if at is not None and g['d'][at]==0xe9:
                        target+=5+int.from_bytes(g['d'][at+1:at+5],'little',signed=True)
                    else:break
                resolved=' => '+hex(target)
            print(hex(i.address),i.mnemonic,i.op_str+resolved)
        if i.mnemonic=='ret':break

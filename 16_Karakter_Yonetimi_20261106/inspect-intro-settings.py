from pathlib import Path
import struct,re
from capstone import Cs,CS_ARCH_X86,CS_MODE_32
r=Path.cwd();raw=(r/'11_Istemci_Uyumluluk/Gamesoft_Yerel/KnightOnLine.exe').read_bytes();pe=struct.unpack_from('<I',raw,0x3c)[0];opt=pe+24;base=struct.unpack_from('<I',raw,opt+28)[0];num=struct.unpack_from('<H',raw,pe+6)[0];optn=struct.unpack_from('<H',raw,pe+20)[0]
secs=[]
for i in range(num):
 at=opt+optn+40*i;vsz,rva,sz,ptr=struct.unpack_from('<IIII',raw,at+8);secs.append((rva,ptr,sz,vsz))
def address(off):
 for rva,ptr,sz,vsz in secs:
  if ptr<=off<ptr+sz:return base+rva+off-ptr
def string(va):
 for rva,ptr,sz,vsz in secs:
  if rva<=va-base<rva+sz:
   at=ptr+va-base-rva;return raw[at:at+90].split(b'\0')[0]
for text in [b'ShowIntroMovie',b'MovieVisible']:
 off=raw.find(text+b'\0');va=address(off);print(text,hex(va))
 for m in re.finditer(re.escape(struct.pack('<I',va)),raw):
  ref=m.start();print('Reference',hex(address(ref)))
  start=max(ref-45,0)
  # Obtain enough aligned context from the push opcode immediately before each immediate.
  for ins in Cs(CS_ARCH_X86,CS_MODE_32).disasm(raw[ref-1:ref+140],address(ref-1)):
   print(hex(ins.address),ins.mnemonic,ins.op_str)
   if ins.mnemonic=='push' and ins.op_str.startswith('0x'):
    print('STRING',string(int(ins.op_str,16)))
  print('BEFORE',raw[start:ref-1].hex())

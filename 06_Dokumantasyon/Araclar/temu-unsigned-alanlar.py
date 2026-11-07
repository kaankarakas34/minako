"""Extract unsigned ODBC destinations, preserving width and signedness."""
from pathlib import Path
import re,json
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles'

def returned_strings(s,name):
    m=re.search(r'\b'+name+r'\s*\([^)]*\)\s*(?:const\s*)?\{\s*return\s+(.+?);\s*\}',s,re.S)
    return ''.join(re.findall(r'"([^"\n]*)"',m[1])) if m else ''

def collect():
    records={}
    for path in (SRC/'shared/database').glob('*.h'):
        s=path.read_text(encoding='utf-8-sig',errors='replace')
        table=returned_strings(s,'GetTableName');cs=returned_strings(s,'GetColumns')
        if not table or not cs:continue
        # A textual i++ scan cannot infer how many times a loop executes.
        # Leave loop-based readers for explicit review rather than shifting
        # subsequent column types onto the wrong fields.
        if re.search(r'\bfor\s*\(',s):continue
        columns=[x.strip().strip('[]') for x in cs.split(',')];index=1
        for m in re.finditer(r'_dbCommand->Fetch(\w+)\s*\(\s*(\d+|i\+\+)\s*[,)]',s):
            pos=int(m[2]) if m[2].isdigit() else index
            if m[2]=='i++':index+=1
            bits={'Byte':8,'UInt16':16,'UInt32':32,'UInt64':64}.get(m[1])
            if not bits or pos>len(columns):continue
            key=(table.lower(),columns[pos-1].lower())
            item={'Table':key[0],'Column':key[1],'Bits':bits,'Fetch':m[1],'Source':str(path.relative_to(SRC))}
            if key in records:assert records[key]['Bits']==bits,key
            records[key]=item
    # CMonsterTableSet inherits CNpcTableSet's columns and Fetch implementation.
    for (table,col),entry in list(records.items()):
        if table=='k_npc':records[('k_monster',col)]={**entry,'Table':'k_monster'}
    return list(records.values())

if __name__=='__main__':
    rows=collect();out=ROOT/'06_Dokumantasyon/Derleme/temu-unsigned-columns.json'
    out.write_text(json.dumps(rows,indent=2),encoding='utf8');print('Unsigned source column destinations:',len(rows))

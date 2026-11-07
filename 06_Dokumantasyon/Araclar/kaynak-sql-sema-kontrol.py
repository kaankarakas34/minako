"""Compare explicit recordset schemas in the source copy with the restored SQL."""
from pathlib import Path
import re,csv,json
from collections import defaultdict,Counter
ROOT=Path(__file__).resolve().parents[2];SRC=ROOT/'10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles';OUT=ROOT/'06_Dokumantasyon/Derleme'
with (OUT/'original-schema-columns.csv').open(encoding='utf-8-sig') as f:actual=list(csv.DictReader(f))
schema=defaultdict(dict)
for r in actual:schema[r['TABLE_NAME'].lower()][r['COLUMN_NAME'].lower()]=r
records=[];unknown=[]
def method(s,name):
    m=re.search(r'\b'+name+r'\s*\([^)]*\)\s*(?:const\s*)?\{\s*return\s+(.+?);\s*\}',s,re.S)
    return ''.join(re.findall(r'"([^"\n]*)"',m[1])) if m else ''
types={'Byte':'tinyint','SByte':'smallint','UInt16':'int','Int16':'smallint','UInt32':'bigint','Int32':'int','UInt64':'decimal(20,0)','Int64':'bigint','Float':'real','Double':'float','String':'varchar(512)','Binary':'varbinary(max)'}
for path in sorted((SRC/'shared/database').glob('*.h')):
    text=path.read_text(encoding='utf-8-sig',errors='replace')
    if 'GetTableName' not in text:continue
    table=method(text,'GetTableName');columns=method(text,'GetColumns')
    if not table or not columns:
        unknown.append({'Path':str(path.relative_to(SRC)),'Reason':'dynamic or non-literal table/column method'});continue
    columns=[x.strip().strip('[]') for x in columns.split(',')]
    # Fetch type inference is an audit hint; it is not treated as an authored SQL schema.
    fetches=list(re.finditer(r'_dbCommand->Fetch(\w+)\s*\(\s*(\d+|i\+\+)\s*,',text))
    fetch_types={};index=1
    for m in fetches:
        pos=int(m[2]) if m[2].isdigit() else index
        if m[2]=='i++':index+=1
        fetch_types[pos]=types.get(m[1],'UNRESOLVED:'+m[1])
    for i,column in enumerate(columns,1):
        present=column.lower() in schema.get(table.lower(),{})
        records.append({'Table':table,'Column':column,'Position':i,'TableExists':table.lower() in schema,'ColumnExists':present,'FetchTypeHint':fetch_types.get(i,'UNRESOLVED'),'Source':str(path.relative_to(SRC))})
with (OUT/'kaynak-sql-sema-karsilastirma.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.DictWriter(f,fieldnames=records[0]);w.writeheader();w.writerows(records)
missing=[r for r in records if not r['ColumnExists']]
with (OUT/'kaynak-eksik-sql-alanlari.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.DictWriter(f,fieldnames=records[0]);w.writeheader();w.writerows(missing)
summary={'ExplicitRecordsetFiles':len({r['Source'] for r in records}),'RequiredTables':len({r['Table'] for r in records}),'RequiredColumns':len(records),'MissingTables':sorted({r['Table'] for r in records if not r['TableExists']}),'MissingColumnsInExistingTables':sum(r['TableExists'] and not r['ColumnExists'] for r in records),'UnparsedRecordsets':unknown,'MissingByTable':dict(Counter(r['Table'] for r in missing)),'Limits':'Static source audit, not a migration. Fetch type hints are insufficient to invent gameplay data or constraints.'}
(OUT/'kaynak-sql-sema-ozeti.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(summary,ensure_ascii=True,indent=2))

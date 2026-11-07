"""Prepare an isolated SQL Server lab from the published TemuKO reference.

Only allowlisted game/configuration COPY rows are exported. Account, character,
payment, website and player inventory rows are never imported. The original
backup and databases are not modified. Generated SQL is executed separately.
"""
from pathlib import Path
import collections, csv, gzip, hashlib, json, re, sys

ROOT=Path(__file__).resolve().parents[2]
REF=ROOT/'08_Arastirma_Adaylari/TemuKO_DB_Referans'
OUT=ROOT/'10_Kaynak_Derleme/Veritabani_Hazirlik'
SRC=ROOT/'10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles'
import importlib.util
spec=importlib.util.spec_from_file_location('temu_unsigned',Path(__file__).with_name('temu-unsigned-alanlar.py'))
unsigned_module=importlib.util.module_from_spec(spec);spec.loader.exec_module(unsigned_module)
unsigned={(r['Table'],r['Column']):r['Bits'] for r in unsigned_module.collect()}
OUT.mkdir(exist_ok=True)
DATA=OUT/'StaticData';DATA.mkdir(exist_ok=True)
METADATA_ONLY='--metadata-only' in sys.argv
previous_rows={}
if METADATA_ONLY:
    previous_rows={t['Name']:t['Rows'] for t in json.loads((OUT/'manifest.json').read_text(encoding='utf-8'))['Tables']}
COMMIT='af34b1131c21b42d1949d2a63d689165b812103d'
schemas={};copies={};keys={};identities=set()

def unquote(s): return s.strip().strip('"')
def bracket(s):
    assert re.fullmatch(r'[^\W\d]\w*',s),s
    return '['+s+']'

for name,blob in [('KO_DATABASE_SERVER_001_DUMP.sql.gz','530520da6dd648a8698ee6d093c8fb98b683da87'),
                  ('KO_DATABASE_MAIN_DUMP.sql.gz','5b64906f873906b08fe5f806fb0a2777fe4235a4')]:
    raw=(REF/name).read_bytes()
    assert hashlib.sha1(b'blob '+str(len(raw)).encode()+b'\0'+raw).hexdigest()==blob,name
    text=gzip.decompress(raw).decode('utf-8')
    for match in re.finditer(r'CREATE TABLE dbo\.(\w+) \(\n(.*?)\n\);',text,re.S):
        if match[1] in schemas:continue
        schemas[match[1]]=match[2]
    for match in re.finditer(r'COPY dbo\.(\w+) \(([^\n]*)\) FROM stdin;\n(.*?)^\\\.\r?$',text,re.S|re.M):
        if match[1] not in copies:copies[match[1]]=([unquote(x) for x in match[2].split(', ')],match[3])
    for match in re.finditer(r'ALTER TABLE ONLY dbo\.(\w+)\n\s+ADD CONSTRAINT \w+ PRIMARY KEY \(([^)]+)\)',text):
        keys[match[1]]=[unquote(x) for x in match[2].split(', ')]
    identities.update(re.findall(r'ALTER TABLE ONLY dbo\.(\w+) ALTER COLUMN (\w+) SET DEFAULT nextval',text))
    del text

meta={}
for filename in ['original-schema-columns.csv','akgame-schema-columns.csv']:
    for row in csv.DictReader((ROOT/'06_Dokumantasyon/Derleme'/filename).open(encoding='utf-8-sig')):
        meta[(row['TABLE_NAME'].lower(),row['COLUMN_NAME'].lower())]=row

allow={row['Table'].lower() for row in csv.DictReader((ROOT/'06_Dokumantasyon/Derleme/kaynak-sql-sema-karsilastirma.csv').open(encoding='utf-8-sig'))}
allow-=set('king_candidacy_notice_board king_election_list king_nomination_list knights_alliance knights_rating knights_castellan user_character_seal_items user_daily_op user_knights_rank user_personal_rank sheriff_reports ppcard'.split())
allow.update('achieve_main achieve_mon item_selltable k_monster chaos_stone_summon_stage '
             'hook_settings hook_pus_items hook_collectionrace_settings hook_collectionrace_hunt_list '
             'draki_monster_list draki_tower_stages knight_royale_chest_list quest_skills_open_set_up '
             'quest_skills_closed_check hacktool_check_list beginner_items character_valids '
             'create_new_char_set create_new_char_value quest_menu quest_talk version '
             'game_server_list server_settings beginner_settings game_options server_clean'.split())

sqltypes={'smallint':'smallint','integer':'int','bigint':'bigint','bytea':'varbinary(max)',
          'timestamp without time zone':'datetime','date':'date','boolean':'bit','double precision':'float'}
tables=[];ddl=['-- Lab database only. Authored reference schema; no imported player accounts.']
for table,body in schemas.items():
    columns=[];defs=[]
    for line in body.splitlines():
        match=re.fullmatch(r'\s*("?\w+"?)\s+(.*?)(?:,)?',line)
        assert match,(table,line)
        col=unquote(match[1]);tail=match[2].rstrip(',')
        kind=re.split(r'\s+(?:DEFAULT|NOT NULL)\b',tail)[0]
        nullable=not tail.endswith('NOT NULL')
        identity=(table,col) in identities
        if kind=='text':
            hint=meta.get((table,col),{});length=hint.get('CHARACTER_MAXIMUM_LENGTH')
            if isinstance(length,str) and length.isdigit() and int(length)>0:
                sqltype='nvarchar('+str(min(int(length),4000))+')'
            elif col in keys.get(table,[]):sqltype='nvarchar(128)'
            else:sqltype='nvarchar(max)'
        else:sqltype=sqltypes[kind]
        bits=unsigned.get((table,col))
        if bits==16 and sqltype=='smallint':sqltype='int'
        elif bits==32 and sqltype in ('smallint','int'):sqltype='bigint'
        elif bits==64:sqltype='decimal(20,0)'
        default=''
        dm=re.search(r'\bDEFAULT (.*?)(?: NOT NULL)?$',tail)
        if dm and not identity:
            value=re.sub(r'::(?:[\w ]+)$','',dm[1]).strip()
            if re.fullmatch(r"'(?:[^']|'')*'|-?\d+(?:\.\d+)?|true|false",value):
                value={'true':'1','false':'0'}.get(value,value)
                default=' DEFAULT '+value
            else:raise ValueError((table,col,'unhandled default',value))
        defs.append(bracket(col)+' '+sqltype+(' IDENTITY(1,1)' if identity else '')+
                    (' NULL' if nullable else ' NOT NULL')+default)
        columns.append({'Name':col,'Type':sqltype,'Nullable':nullable,'Identity':identity})
    ddl.append('CREATE TABLE dbo.'+bracket(table)+' (\n  '+',\n  '.join(defs)+'\n);')
    if table in keys:
        ddl.append('ALTER TABLE dbo.'+bracket(table)+' ADD CONSTRAINT '+bracket('PK_LAB_'+table)+
                   ' PRIMARY KEY NONCLUSTERED ('+', '.join(map(bracket,keys[table]))+');')
    tables.append({'Name':table,'Columns':columns,'PrimaryKey':keys.get(table,[]),'Rows':0,'ImportStaticData':table in allow})
(OUT/'schema.sql').write_text('\n\n'.join(ddl),encoding='utf-8')

escapes={'b':'\b','f':'\f','n':'\n','r':'\r','t':'\t','v':'\v','\\':'\\'}
def unescape(value):
    if value==r'\N':return None
    return re.sub(r'\\([0-7]{1,3}|x[0-9a-fA-F]{1,2}|.)',
        lambda m:chr(int(m[1],8)) if m[1][0] in '01234567' else
        chr(int(m[1][1:],16)) if m[1].startswith('x') and len(m[1])>1 else escapes.get(m[1],m[1]),value)

for entry in tables:
    table=entry['Name']
    if METADATA_ONLY:
        entry['Rows']=previous_rows.get(table,0)
        continue
    if table not in allow or table not in copies:continue
    cols,raw=copies[table];assert cols==[c['Name'] for c in entry['Columns']],table
    with (DATA/(table+'.jsonl')).open('w',encoding='utf-8',newline='\n') as stream:
        for line in raw.splitlines():
            values=[unescape(x) for x in line.split('\t')];assert len(values)==len(cols),table
            for value,column in zip(values,entry['Columns']):
                length=re.fullmatch(r'nvarchar\((\d+)\)',column['Type'])
                if length and value is not None:assert len(value)<=int(length[1]),(table,column['Name'],len(value),length[1])
            for index,column in enumerate(entry['Columns']):
                bits=unsigned.get((table,column['Name']))
                if bits and values[index] is not None:
                    number=int(values[index])
                    assert -(2**(bits-1))<=number<2**bits,(table,column['Name'],number,bits)
                    if number<0:values[index]=str(number+2**bits)
            stream.write(json.dumps(values,ensure_ascii=False)+'\n');entry['Rows']+=1

# Include only procedures called by the game/login source. Ignore obsolete
# Visual Studio dt_* / SourceSafe administration procedures in the same dump.
allsource='\n'.join(p.read_text(encoding='utf-8-sig',errors='replace') for p in SRC.rglob('*.cpp'))
allsource=re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|//[^\n]*|/\*.*?\*/',
                 lambda m: '' if m[0].startswith(('//','/*')) else m[0],allsource,flags=re.S)
required={n.upper() for n in re.findall(r'\{\s*(?:\?\s*=\s*)?CALL\s+(\w+)',allsource,re.I)}
procedures={}
for filename in ['KO_DATABASE_SERVER_001_SPs.sql','KO_DATABASE_MAIN_SPs.sql']:
    raw=(REF/filename).read_text(encoding='utf-8-sig')
    for block in re.split(r'^GO\s*$',raw,flags=re.M|re.I):
        match=re.search(r'\bCREATE\s+PROC(?:EDURE)?\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?',block,re.I)
        if not match or match[1].upper() in procedures:continue
        name=match[1].upper()
        if name not in required:continue
        block=block[match.start():].strip()
        block=re.sub(r'\[(?:KO_DATABASE_SERVER_001|KO_DATABASE_MAIN)\]', '[KNIGHT_TEMU_2239]',block,flags=re.I)
        block=re.sub(r'\b(?:KO_DATABASE_SERVER_001|KO_DATABASE_MAIN)\.', '[KNIGHT_TEMU_2239].',block,flags=re.I)
        # An original procedure may call another authored procedure. The loader
        # reports unresolved dependencies; it never generates replacement logic.
        procedures[name]=block
procdir=OUT/'Procedures';procdir.mkdir(exist_ok=True)
for name,block in procedures.items():(procdir/(name+'.sql')).write_text(block+'\n',encoding='utf-8')
manifest={'SourceRepository':'https://github.com/luisfelipe18/temuko-posix','Commit':COMMIT,
          'TargetDatabase':'KNIGHT_TEMU_2239','Tables':tables,'RequiredProcedureNames':sorted(required),
          'AvailableProcedures':sorted(procedures),'MissingProcedures':sorted(required-procedures.keys()),
          'StaticRows':sum(t['Rows'] for t in tables),'ImportedAccountRows':0,
          'Limits':'Isolated lab conversion; SQL Server dependency and native startup checks remain required.'}
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
print(json.dumps({'Tables':len(tables),'StaticRows':manifest['StaticRows'],'Procedures':len(procedures),'MissingProcedures':manifest['MissingProcedures']}))

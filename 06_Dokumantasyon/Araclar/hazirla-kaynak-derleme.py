"""Retarget only the isolated source copy to the installed MSVC/SDK."""
from pathlib import Path
import xml.etree.ElementTree as ET
import json,hashlib
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles'
NS='http://schemas.microsoft.com/developer/msbuild/2003';ET.register_namespace('',NS)
tag=lambda s:'{'+NS+'}'+s
projects=[('GameServer/proj-GameServer.vcxproj','GameServer'),('LogInServer/proj-LogInServer.vcxproj','LogInServer'),('scripting/Lua.vcxproj','Lua'),('shared/shared.vcxproj','shared')]
records=[]
for rel,name in projects:
    path=SRC/rel;before=path.read_bytes();tree=ET.parse(path);root=tree.getroot()
    for element in root.iter(tag('WindowsTargetPlatformVersion')):element.text='10.0.19041.0'
    for element in root.iter(tag('AdditionalIncludeDirectories')):
        element.text='$(SolutionDir)scripting\\Lua\\src;$(SolutionDir);%(AdditionalIncludeDirectories)'
    for element in root.iter(tag('DebugInformationFormat')):element.text='ProgramDatabase'
    if name=='shared':
        # This project has no stdafx.cpp; its old settings tried to create the
        # same PCH from unrelated translation units, including tstring.cpp.
        for element in root.iter(tag('PrecompiledHeader')):element.text='NotUsing'
    for element in root.iter(tag('AdditionalDependencies')):
        if not element.text:continue
        deps=[]
        for dep in element.text.split(';'):
            dep=dep.strip()
            if dep.lower().endswith('lua.lib'):dep='Lua.lib'
            elif dep.lower().endswith('shared.lib'):dep='shared.lib'
            deps.append(dep)
        element.text=';'.join(deps)
    for link in root.iter(tag('Link')):
        libraries=link.find(tag('AdditionalLibraryDirectories'))
        if libraries is None:libraries=ET.SubElement(link,tag('AdditionalLibraryDirectories'))
        libraries.text='$(OutDir);%(AdditionalLibraryDirectories)'
    # Insert after all original configuration property groups.
    old=root.find(tag('PropertyGroup')+"[@Label='KnightLocalBuild']")
    if old is not None:root.remove(old)
    group=ET.Element(tag('PropertyGroup'),{'Label':'KnightLocalBuild'})
    for key,value in [('OutDir','$(SolutionDir)..\\bin\\$(Platform)\\$(Configuration)\\'),('IntDir','$(ProjectDir)obj\\$(Platform)\\$(Configuration)\\'),('TargetName',name)]:ET.SubElement(group,tag(key)).text=value
    pos=next((i for i,e in enumerate(root) if e.tag==tag('ItemDefinitionGroup')),len(root)-1)
    root.insert(pos,group)
    ET.indent(tree,space='  ');tree.write(path,encoding='utf-8',xml_declaration=True)
    records.append({'Project':rel,'BeforeSHA256':hashlib.sha256(before).hexdigest(),'AfterSHA256':hashlib.sha256(path.read_bytes()).hexdigest()})
report=ROOT/'06_Dokumantasyon/Derleme';report.mkdir(exist_ok=True)
(report/'proje-yapilandirma.json').write_text(json.dumps({'SDK':'10.0.19041.0','Toolset':'v142','Changes':records},indent=2),encoding='utf-8')
print(json.dumps({'PreparedProjects':len(records),'SDK':'10.0.19041.0','OriginalSourceUntouched':True}))

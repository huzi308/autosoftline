<#include "/include/parameters.ftl">
<#if dataBaseName != "h2">
<@pp.dropOutputFile />
<#else>
<#if noCopyright!="true">
<#include "/include/copyright-minus.ftl">
</#if>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tbComment=table.@tbComment?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className=="Syslog" || className=="Sysdict" || className=="Area" || className=="Department" || className=="Uploadfile" >
    CREATE TABLE  `${tableName}`(
<#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign tablehead=prop.@colComment?trim><#assign testdata=prop.@colComment?trim>
<#if type!="Sysdict" && type!="ManyToMany">
    <#assign isNullVal="  not null">
    <#if param=="null"><#assign isNullVal=""></#if>
    <#if name=="id">
       <#if className=="Sysdict">
        `id`  bigint  not null,
       <#else>
        `id`  bigint  auto_increment,
       </#if>
    <#elseif type=="Boolean">
        `${colName}`  boolean${isNullVal},
    <#elseif type=="Double">
        `${colName}`  double${isNullVal},
    <#elseif type=="Integer">
        `${colName}`  int${isNullVal},
    <#elseif type=="Long">
        `${colName}`  bigint${isNullVal},
    <#elseif type=="String">
       <#if dbType=="Text">
        `${colName}`  text${isNullVal},
       <#elseif dbType=="">
        `${colName}`  varchar(255)${isNullVal},
       <#else>
        `${colName}`  ${dbType}${isNullVal},
       </#if>
    <#elseif type=="Date" && dbType=="Timestamp">
        `${colName}`  Timestamp  not null default current_timestamp,
    <#else>
        `${colName}`  ${dbType}${isNullVal},
    </#if>
</#if>
<#if type=="Sysdict">
        `${colName}`  bigint  not null,
</#if>
</#list>
        primary key (id)
    );


</#if>
</#list>


<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tbComment=table.@tbComment?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className=="Myuser" || className=="Role" || className=="Permission" >
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount==0>
    CREATE TABLE  `${tableName}`(
    <#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign tablehead=prop.@colComment?trim><#assign testdata=prop.@colComment?trim>
      <#if type!="Sysdict" && type!="ManyToMany">
        <#assign isNullVal="  not null">
        <#if param=="null"><#assign isNullVal=""></#if>
        <#if name=="id">
            `id`  bigint  not null auto_increment,
        <#elseif type=="Boolean">
            `${colName}`  boolean${isNullVal},
        <#elseif type=="Integer">
            `${colName}`  int${isNullVal},
        <#elseif type=="Long">
            `${colName}`  bigint${isNullVal},
        <#elseif type=="Double">
            `${colName}`  double${isNullVal},
        <#elseif type=="String">
           <#if dbType=="Text">
            `${colName}`  text${isNullVal},
           <#elseif dbType=="">
            `${colName}`  varchar(255)${isNullVal},
           <#else>
            `${colName}`  ${dbType}${isNullVal},
           </#if>
        <#elseif type=="Date" && dbType=="Timestamp">
            `${colName}`  Timestamp  not null default current_timestamp,
        <#else>
            `${colName}`  ${dbType}${isNullVal},
        </#if>
      </#if>
      <#if type=="Sysdict">
            `${colName}`  bigint  not null,
      </#if>
    </#list>
            primary key (id)
    );


</#if>
</#if>
</#list>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tbComment=table.@tbComment?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className=="Myuser" || className=="Role" || className=="Permission" >
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount gt 0>
    CREATE TABLE  `${tableName}`(
 <#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign tablehead=prop.@colComment?trim><#assign testdata=prop.@colComment?trim>
   <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict">
        <#assign isNullVal="  not null">
        <#if param=="null"><#assign isNullVal=""></#if>
        <#if name=="id">
            `id`  bigint  auto_increment,
        <#elseif type=="Boolean">
            `${colName}`  boolean${isNullVal},
        <#elseif type=="Integer">
            `${colName}`  int${isNullVal},
        <#elseif type=="Long">
            `${colName}`  bigint${isNullVal},
        <#elseif type=="Double">
            `${colName}`  double${isNullVal},
        <#elseif type=="String">
           <#if dbType=="Text">
            `${colName}`  text${isNullVal},
           <#elseif dbType=="">
            `${colName}`  varchar(255)${isNullVal},
           <#else>
            `${colName}`  ${dbType}${isNullVal},
           </#if>
        <#elseif type=="Date" && dbType=="Timestamp">
            `${colName}`  Timestamp  not null default current_timestamp,
        <#else>
            `${colName}`  ${dbType}${isNullVal},
        </#if>
   </#if>
   <#if type=="ForeignKey">
        <#if param=="Department">
            `${colName}`  bigint default 1,
        <#else>
            `${colName}`  bigint  not null,
        </#if>
   </#if>
   <#if type=="Sysdict">
            `${colName}`  bigint  not null,
   </#if>
 </#list>
            primary key (id)
    );


</#if>
</#if>
</#list>


<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop >
<#if className=="Myuser" || className=="Role" || className=="Permission" >
<#list tableProp as prop><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign tableName2=table2.@tableName?trim >
    <#if className2==param>
    CREATE TABLE  `${tableName}_${param}`(
            `${className?lower_case}_id`  bigint  not null,
            `${param?lower_case}_id`  bigint  not null,
            primary key (${className?lower_case}_id, ${param?lower_case}_id)
    );


    </#if>
    </#list>
</#if>
</#list>
</#if>
</#list>


<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tbComment=table.@tbComment?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Sysdict" && className!="Syslog" && className!="Uploadfile">
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount==0>
    CREATE TABLE  `${tableName}`(
    <#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign tablehead=prop.@colComment?trim><#assign testdata=prop.@colComment?trim>
      <#if type!="Sysdict" && type!="ManyToMany">
        <#assign isNullVal="  not null">
        <#if param=="null"><#assign isNullVal=""></#if>
        <#if name=="id">
            `id`  bigint  auto_increment,
        <#elseif type=="Boolean">
            `${colName}`  boolean${isNullVal},
        <#elseif type=="Integer">
            `${colName}`  int${isNullVal},
        <#elseif type=="Long">
            `${colName}`  bigint${isNullVal},
        <#elseif type=="Double">
            `${colName}`  double${isNullVal},
        <#elseif type=="String">
           <#if dbType=="Text">
            `${colName}`  text${isNullVal},
           <#elseif dbType=="">
            `${colName}`  varchar(255)${isNullVal},
           <#else>
            `${colName}`  ${dbType}${isNullVal},
           </#if>
        <#elseif type=="Date" && dbType=="Timestamp">
            `${colName}`  Timestamp  not null default current_timestamp,
        <#else>
            `${colName}`  ${dbType}${isNullVal},
        </#if>
      </#if>
      <#if type=="Sysdict">
            `${colName}`  bigint  not null,
      </#if>
    </#list>
            primary key (id)
    );


</#if>
</#if>
</#list>


<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tbComment=table.@tbComment?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Sysdict" && className!="Syslog" && className!="Uploadfile">
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount gt 0>
    CREATE TABLE  `${tableName}`(
 <#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign tablehead=prop.@colComment?trim><#assign testdata=prop.@colComment?trim>
   <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict">
        <#assign isNullVal="  not null">
        <#if param=="null"><#assign isNullVal=""></#if>
        <#if name=="id">
            `id`  bigint  auto_increment,
        <#elseif type=="Boolean">
            `${colName}`  boolean${isNullVal},
        <#elseif type=="Integer">
            `${colName}`  int${isNullVal},
        <#elseif type=="Long">
            `${colName}`  bigint${isNullVal},
        <#elseif type=="Double">
            `${colName}`  double${isNullVal},
        <#elseif type=="String">
           <#if dbType=="Text">
            `${colName}`  text${isNullVal},
           <#elseif dbType=="">
            `${colName}`  varchar(255)${isNullVal},
           <#else>
            `${colName}`  ${dbType}${isNullVal},
           </#if>
        <#elseif type=="Date" && dbType=="Timestamp">
            `${colName}`  Timestamp  not null default current_timestamp,
        <#else>
            `${colName}`  ${dbType}${isNullVal},
        </#if>
   </#if>
   <#if type=="ForeignKey">
        <#if param==className>
            `${colName}`  bigint,
        <#else>
            `${colName}`  bigint  not null,
        </#if>
   </#if>
   <#if type=="Sysdict">
            `${colName}`  bigint  not null,
   </#if>
 </#list>
            primary key (id)
    );


</#if>
</#if>
</#list>


<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop >
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Sysdict" && className!="Syslog" && className!="Uploadfile">
<#list tableProp as prop><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign tableName2=table2.@tableName?trim >
    <#if className2==param>
    CREATE TABLE  `${tableName}_${param}`(
            `${className?lower_case}_id`  bigint  not null,
            `${param?lower_case}_id`  bigint  not null,
            primary key (${className?lower_case}_id, ${param?lower_case}_id)
    );


    </#if>
    </#list>
</#if>
</#list>
</#if>
</#list>


<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className=="Myuser" || className=="Role" || className=="Permission" >
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount==0>
<#assign i=0>
<#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#assign i=i+1>
  <#if type=="Sysdict">
  </#if>
</#list>
</#if>
</#if>
</#list>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className=="Myuser" || className=="Role" || className=="Permission" >
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount gt 0>
<#assign i=0>
<#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign i=i+1>
  <#if type=="ForeignKey">
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign tableName2=table2.@tableName?trim >
    <#if className2==param>
    </#if>
    </#list>
  </#if>
  <#if type=="Sysdict">
  </#if>
</#list>
</#if>
</#if>
</#list>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop >
<#if className=="Myuser" || className=="Role" || className=="Permission" >
<#list tableProp as prop><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign tableName2=table2.@tableName?trim >
    <#if className2==param>
    Alter TABLE ${tableName}_${param} ADD constraint fk${className}${param}1 foreign key(${className?lower_case}_id) references ${tableName}(id);
    Alter TABLE ${tableName}_${param} ADD constraint fk${className}${param}2 foreign key(${param?lower_case}_id) references ${tableName2}(id);

    </#if>
    </#list>
</#if>
</#list>
</#if>
</#list>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Sysdict" && className!="Syslog" && className!="Uploadfile">
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount==0>
<#assign i=0>
<#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#assign i=i+1>
  <#if type=="Sysdict">
  </#if>
</#list>
</#if>
</#if>
</#list>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop ><#assign fkCount=0>
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Sysdict" && className!="Syslog" && className!="Uploadfile">
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#if fkCount gt 0>
<#assign i=0>
<#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim><#assign i=i+1>
  <#if type=="ForeignKey">
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign tableName2=table2.@tableName?trim >
    <#if className2==param>
    Alter TABLE ${tableName} ADD constraint fk${className}1${i?c} foreign key(${colName}) references ${tableName2}(id);
    </#if>
    </#list>
  </#if>
  <#if type=="Sysdict">
  </#if>
</#list>
</#if>
</#if>
</#list>

<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop >
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Sysdict" && className!="Syslog" && className!="Uploadfile">
<#list tableProp as prop><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign tableName2=table2.@tableName?trim >
    <#if className2==param>
    Alter TABLE ${tableName}_${param} ADD constraint fk${className}${param}1 foreign key(${className?lower_case}_id) references ${tableName}(id);
    Alter TABLE ${tableName}_${param} ADD constraint fk${className}${param}2 foreign key(${param?lower_case}_id) references ${tableName2}(id);

    </#if>
    </#list>
</#if>
</#list>
</#if>
</#list>


<#assign arrys=['省市','北京','天津','河北','山西','内蒙古','辽宁','吉林','黑龙江','上海','江苏','浙江','安徽','福建','江西','山东','河南','湖北','湖南','广东','广西','海南','重庆','四川','贵州','云南','西藏','陕西','甘肃','青海','宁夏','新疆','台湾','香港','澳门'] />
<#assign tpID=1100><#assign i=0>
<#list arrys as arry><#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT  INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['性别','男','女'] />
<#assign tpID=1200><#assign i=0>
<#list arrys as arry><#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT  INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['民族','汉族','蒙古族','回族','藏族','维吾尔族','苗族','彝族','壮族','布依族','朝鲜族','满族','侗族','瑶族','白族','土家族','哈尼族','哈萨克族','傣族','黎族','傈僳族','佤族','畲族','高山族','拉祜族','水族','东乡族','纳西族','景颇族','柯尔克孜族','土族','达斡尔族','仫佬族','羌族','布朗族','撒拉族','毛南族','仡佬族','锡伯族','阿昌族','普米族','塔吉克族','怒族','乌孜别克族','俄罗斯族','鄂温克族','德昂族','保安族','裕固族','京族','塔塔尔族','独龙族','鄂伦春族','赫哲族','门巴族','珞巴族','基诺族'] />
<#assign tpID=1300><#assign i=0>
<#list arrys as arry><#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT  INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['学历','小学','初中','高中','大专','本科','硕士研究生','博士研究生'] />
<#assign tpID=1400><#assign i=0>
<#list arrys as arry><#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT  INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['学位','学士学位','硕士学位','博士学位'] />
<#assign tpID=1500><#assign i=0>
<#list arrys as arry><#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT  INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['职称','高级职称','中级职称','初级职称'] />
<#assign tpID=1600><#assign i=0>
<#list arrys as arry><#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT  INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>


<#assign arrys=['项目级别','重点','主要','一般'] />
<#assign tpID=9100>
<#assign i=0>
<#list arrys as arry>  
<#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['确认状态','未确认','通过','未通过'] />
<#assign tpID=9200>
<#assign i=0>
<#list arrys as arry>  
<#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>

<#assign arrys=['问题状态','未开始','解决中','已完成'] />
<#assign tpID=9300>
<#assign i=0>
<#list arrys as arry>  
<#assign typeId=(tpID+i)?c><#assign i=i+1>
    INSERT INTO Sysdict(id, code, name, enabled) VALUES(${typeId}, ${typeId}, '${arry}', 1);
</#list>



    INSERT INTO Syslog(operation, tableName, objctId, objctValue, operateBy, ip) VALUES('[init]', '[init]', 0, '[init]', '[init]', '0.0.0.0');


<#assign id=1>
<#list 101..102 as i >
    INSERT INTO Area(id, code, name, enabled) VALUES(${id?c}, '${i?c}', '领域${id?c}', 1);
    <#list 101..103 as j ><#assign id01=i*1000+j><#assign cid01=id01?c><#assign id=id+1>
    INSERT INTO Area(id, code, name, enabled) VALUES(${id?c}, '${cid01}', '领域${id?c}', 1);
    <#list 101..102 as k ><#assign id02=id01*1000+k><#assign cid02=id02?c><#assign id=id+1>
    INSERT INTO Area(id, code, name, enabled) VALUES(${id?c}, '${cid02}', '领域${id?c}', 1);
    <#list 101..103 as m ><#assign id03=id02*1000+m><#assign cid03=id03?c><#assign id=id+1>
    INSERT INTO Area(id, code, name, enabled) VALUES(${id?c}, '${cid03}', '领域${id?c}', 1);
    </#list>
    </#list>
    </#list>
    <#assign id=id+1>

</#list>

    INSERT INTO Department(id, code, name, enabled) VALUES(1, '1', '无', 1);
<#assign id=1>
<#list 101..103 as i >
    INSERT INTO Department(id, code, name, enabled) VALUES(${(id+1)?c}, '${i?c}', '部门${id?c}', 1);
    <#list 101..103 as j ><#assign id01=(i*1000+j)><#assign cid01=id01?c><#assign id=id+1>
    INSERT INTO Department(id, code, name, enabled) VALUES(${(id+1)?c}, '${cid01}', '部门${id?c}', 1);
    <#list 101..102 as k ><#assign id02=(id01*1000+k)><#assign cid02=id02?c><#assign id=id+1>
    INSERT INTO Department(id, code, name, enabled) VALUES(${(id+1)?c}, '${cid02}', '部门${id?c}', 1);
    <#list 101..103 as m ><#assign id03=(id02*1000+m)><#assign cid03=id03?c><#assign id=id+1>
    INSERT INTO Department(id, code, name, enabled) VALUES(${(id+1)?c}, '${cid03}', '部门${id?c}', 1);
    </#list>
    </#list>
    </#list>
    <#assign id=id+1>

</#list>


    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(1, 'admin',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);
    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(2, 'test1',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);
    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(3, 'test2',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);
    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(4, 'test3',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);
    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(5, 'test4',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);
    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(6, 'test5',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);

    INSERT INTO Role(id, rolename)  VALUES(1, 'AdminRole');
    INSERT INTO Role(id, rolename)  VALUES(2, 'MemberRole');
    INSERT INTO Role(id, rolename)  VALUES(3, 'ObjShowRole');
    INSERT INTO Role(id, rolename)  VALUES(4, 'ObjAdminRole');

<#assign roleIdCount=4>
<#list doc.root.table as table><#assign className=table.@objctName?trim>
  <#if className!="Myuser" && className!="Role" && className!="Permission" >
    <#assign roleIdCount=roleIdCount+1>
    INSERT INTO Role(id, rolename)  VALUES(${roleIdCount}, '${className}ShowRole');
    <#assign roleIdCount=roleIdCount+1>
    INSERT INTO Role(id, rolename)  VALUES(${roleIdCount}, '${className}AdminRole');
  </#if>
</#list>

    INSERT INTO Myuser_Role(myuser_id, role_id)  VALUES(1, 1);
    INSERT INTO Myuser_Role(myuser_id, role_id)  VALUES(2, 2);
    INSERT INTO Myuser_Role(myuser_id, role_id)  VALUES(3, 3);
    INSERT INTO Myuser_Role(myuser_id, role_id)  VALUES(4, 4);
    INSERT INTO Myuser_Role(myuser_id, role_id)  VALUES(5, 2);
    INSERT INTO Myuser_Role(myuser_id, role_id)  VALUES(6, 2);

    INSERT INTO Permission(id, perm)  VALUES(1, 'Admin');
    INSERT INTO Permission(id, perm)  VALUES(2, 'Member');
    INSERT INTO Permission(id, perm)  VALUES(3, 'ObjShow');
    INSERT INTO Permission(id, perm)  VALUES(4, 'ObjAdmin');

<#assign permIdCount=4>
<#list doc.root.table as table><#assign className=table.@objctName?trim>
  <#if className!="Myuser" && className!="Role" && className!="Permission" >
    <#assign permIdCount=permIdCount+1>
    INSERT INTO Permission(id, perm)  VALUES(${permIdCount}, '${className}Show');
    <#assign permIdCount=permIdCount+1>
    INSERT INTO Permission(id, perm)  VALUES(${permIdCount}, '${className}Admin');
  </#if>
</#list>


    INSERT INTO Role_Permission(role_id, permission_id)  VALUES(1, 1);
    INSERT INTO Role_Permission(role_id, permission_id)  VALUES(2, 2);
    INSERT INTO Role_Permission(role_id, permission_id)  VALUES(3, 3);
    INSERT INTO Role_Permission(role_id, permission_id)  VALUES(4, 4);

<#assign IdCount=4>
<#list doc.root.table as table><#assign className=table.@objctName?trim>
  <#if className!="Myuser" && className!="Role" && className!="Permission" >
    <#assign IdCount=IdCount+1>
    INSERT INTO Role_Permission(role_id, permission_id)  VALUES(${IdCount}, ${IdCount});
    <#assign IdCount=IdCount+1>
    INSERT INTO Role_Permission(role_id, permission_id)  VALUES(${IdCount}, ${IdCount});
  </#if>
</#list>


<#assign intBigTestData=totalTestData?number>
<#assign intRefTableData=5>


<#if intRefTableData gt 7>
<#list 7..intRefTableData as i ><#assign i=i+1>
    INSERT INTO Myuser(id, username, password, createdtime, enabled) VALUES(${i}, 'test${i-1}',      '96e79218965eb72c92a549dd5a330112', '2018-09-09 23:59:59', 1);
</#list>
</#if>


<#list doc.root.table as table><#assign tableName=table.@tableName?trim ><#assign className=table.@objctName?trim ><#assign classProp=table.prop ><#assign tableProp=table.prop >
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Syslog" && className!="Sysdict" && className!="Uploadfile">
<#assign fkCount=0><#assign mmCount=0><#assign m2mCount=0>
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ManyToMany"><#assign mmCount=mmCount+1><#assign m2mCount=m2mCount+1></#if></#list>
<#assign fk2Count=0><#assign mm2Count=0>
<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list  classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ForeignKey" && param2==className ><#assign fk2Count=fk2Count+1></#if>
<#if type2=="ManyToMany" && param2==className ><#assign mm2Count=mm2Count+1></#if>
</#list>
</#list>
<#if fkCount==0 && mmCount==0>
<#assign id=0>
<#if fk2Count==0 && mm2Count==0>
<#list 1..intBigTestData as i ><#assign id=id+1>
    INSERT  INTO ${tableName} ( <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if></#if><#if type=="ForeignKey" || type=="Sysdict" ><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#list> ) VALUES(${id?c}, <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign testdata=prop.@colComment?trim><#assign param=prop.@param?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict" && name!="id" ><#if type=="String" ><#if size gte 1>'${testdata}${i?c}', <#else>'${testdata}${i?c}'</#if></#if><#if type=="Boolean" ><#if size gte 1>1, <#else>1</#if></#if><#if type=="Integer"><#if size gte 1>${id+100}, <#else>${id+100}</#if></#if><#if type=="Long"><#if size gte 1>${id+99900}, <#else>${id+99900}</#if></#if><#if type=="Double"><#if size gte 1>${id+101.01234}, <#else>${id+101.01234}</#if></#if><#if type=="Date" && dbType=="Date"><#if size gte 1>'2018-03-01', <#else>'2018-03-01'</#if></#if><#if type=="Date" && dbType=="DateTime"><#if size gte 1>'2018-03-01 11:11:11', <#else>'2018-03-01 11:11:11'</#if></#if><#if type=="Date" && dbType=="Timestamp"><#if size gte 1>'2016-09-09 23:59:59', <#else>'2016-09-09 23:59:59'</#if></#if></#if><#if type=="Sysdict" ><#assign typeId=param?number+1><#if size gte 1>${typeId?c}, <#else>${typeId?c}</#if></#if><#if type=="ForeignKey" ><#if param!=className><#if size gte 1>${id%5+1}, <#else>${id%5+1}</#if><#else><#if id==1><#if size gte 1>null, <#else>null</#if><#else><#if size gte 1>${(id-2)%5+1}, <#else>${(id-2)%5+1}</#if></#if></#if></#if></#list> );
</#list>
<#else>
<#list 1..intRefTableData as i ><#assign id=id+1>
    INSERT  INTO ${tableName} ( <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if></#if><#if type=="ForeignKey" || type=="Sysdict" ><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#list> ) VALUES(${id?c}, <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign testdata=prop.@colComment?trim><#assign param=prop.@param?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict" && name!="id" ><#if type=="String" ><#if size gte 1>'${testdata}${i?c}', <#else>'${testdata}${i?c}'</#if></#if><#if type=="Boolean" ><#if size gte 1>1, <#else>1</#if></#if><#if type=="Integer"><#if size gte 1>${id+100}, <#else>${id+100}</#if></#if><#if type=="Long"><#if size gte 1>${id+99900}, <#else>${id+99900}</#if></#if><#if type=="Double"><#if size gte 1>${id+101.01234}, <#else>${id+101.01234}</#if></#if><#if type=="Date" && dbType=="Date"><#if size gte 1>'2018-03-01', <#else>'2018-03-01'</#if></#if><#if type=="Date" && dbType=="DateTime"><#if size gte 1>'2018-03-01 11:11:11', <#else>'2018-03-01 11:11:11'</#if></#if><#if type=="Date" && dbType=="Timestamp"><#if size gte 1>'2016-09-09 23:59:59', <#else>'2016-09-09 23:59:59'</#if></#if></#if><#if type=="Sysdict" ><#assign typeId=param?number+1><#if size gte 1>${typeId?c}, <#else>${typeId?c}</#if></#if><#if type=="ForeignKey" ><#if param!=className><#if size gte 1>${id%5+1}, <#else>${id%5+1}</#if><#else><#if id==1><#if size gte 1>null, <#else>null</#if><#else><#if size gte 1>${(id-2)%5+1}, <#else>${(id-2)%5+1}</#if></#if></#if></#if></#list> );
</#list>
</#if>

<#else>
</#if>

</#if>
</#list>


<#list doc.root.table as table><#assign tableName=table.@tableName?trim ><#assign className=table.@objctName?trim ><#assign classProp=table.prop ><#assign tableProp=table.prop >
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Syslog" && className!="Sysdict" && className!="Uploadfile">
<#assign fkCount=0><#assign mmCount=0><#assign m2mCount=0>
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ManyToMany"><#assign mmCount=mmCount+1><#assign m2mCount=m2mCount+1></#if></#list>
<#assign fk2Count=0><#assign mm2Count=0>
<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list  classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ForeignKey" && param2==className ><#assign fk2Count=fk2Count+1></#if>
<#if type2=="ManyToMany" && param2==className ><#assign mm2Count=mm2Count+1></#if>
</#list>
</#list>
<#if fkCount==0 && mmCount==0>
<#else>
<#assign id=0>
<#if fk2Count==0 && mm2Count==0>
<#else>
<#list 1..intRefTableData as i ><#assign id=id+1>
    INSERT  INTO ${tableName} ( <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if></#if><#if type=="ForeignKey" || type=="Sysdict" ><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#list> ) VALUES(${id?c}, <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign testdata=prop.@colComment?trim><#assign param=prop.@param?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict" && name!="id" ><#if type=="String" ><#if size gte 1>'${testdata}${i?c}', <#else>'${testdata}${i?c}'</#if></#if><#if type=="Boolean" ><#if size gte 1>1, <#else>1</#if></#if><#if type=="Integer"><#if size gte 1>${id+100}, <#else>${id+100}</#if></#if><#if type=="Long"><#if size gte 1>${id+99900}, <#else>${id+99900}</#if></#if><#if type=="Double"><#if size gte 1>${id+101.01234}, <#else>${id+101.01234}</#if></#if><#if type=="Date" && dbType=="Date"><#if size gte 1>'2018-03-01', <#else>'2018-03-01'</#if></#if><#if type=="Date" && dbType=="DateTime"><#if size gte 1>'2018-03-01 11:11:11', <#else>'2018-03-01 11:11:11'</#if></#if><#if type=="Date" && dbType=="Timestamp"><#if size gte 1>'2016-09-09 23:59:59', <#else>'2016-09-09 23:59:59'</#if></#if></#if><#if type=="Sysdict" ><#assign typeId=param?number+1><#if size gte 1>${typeId?c}, <#else>${typeId?c}</#if></#if><#if type=="ForeignKey" ><#if param!=className><#if size gte 1>${id%5+1}, <#else>${id%5+1}</#if><#else><#if id==1><#if size gte 1>null, <#else>null</#if><#else><#if size gte 1>${(id-2)%5+1}, <#else>${(id-2)%5+1}</#if></#if></#if></#if></#list> );
</#list>

</#if>
</#if>

</#if>
</#list>




<#list doc.root.table as table><#assign tableName=table.@tableName?trim ><#assign className=table.@objctName?trim ><#assign classProp=table.prop ><#assign tableProp=table.prop >
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Syslog" && className!="Sysdict" && className!="Uploadfile">
<#assign fkCount=0><#assign mmCount=0><#assign m2mCount=0>
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if></#list>
<#list tableProp as prop><#assign type=prop.@type?trim><#if type=="ManyToMany"><#assign mmCount=mmCount+1><#assign m2mCount=m2mCount+1></#if></#list>
<#assign fk2Count=0><#assign mm2Count=0>
<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list  classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ForeignKey" && param2==className ><#assign fk2Count=fk2Count+1></#if>
<#if type2=="ManyToMany" && param2==className ><#assign mm2Count=mm2Count+1></#if>
</#list>
</#list>
<#if fkCount==0 && mmCount==0>
<#else>
<#assign id=0>
<#if fk2Count==0 && mm2Count==0>
<#list 1..intBigTestData as i ><#assign id=id+1>
    INSERT  INTO ${tableName} ( <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if></#if><#if type=="ForeignKey" || type=="Sysdict" ><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#list> ) VALUES(${id?c}, <#assign size=tableProp?size><#assign size=size-m2mCount><#list tableProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign testdata=prop.@colComment?trim><#assign param=prop.@param?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict" && name!="id" ><#if type=="String" ><#if size gte 1>'${testdata}${i?c}', <#else>'${testdata}${i?c}'</#if></#if><#if type=="Boolean" ><#if size gte 1>1, <#else>1</#if></#if><#if type=="Integer"><#if size gte 1>${id+100}, <#else>${id+100}</#if></#if><#if type=="Long"><#if size gte 1>${id+99900}, <#else>${id+99900}</#if></#if><#if type=="Double"><#if size gte 1>${id+101.01234}, <#else>${id+101.01234}</#if></#if><#if type=="Date" && dbType=="Date"><#if size gte 1>'2018-03-01', <#else>'2018-03-01'</#if></#if><#if type=="Date" && dbType=="DateTime"><#if size gte 1>'2018-03-01 11:11:11', <#else>'2018-03-01 11:11:11'</#if></#if><#if type=="Date" && dbType=="Timestamp"><#if size gte 1>'2016-09-09 23:59:59', <#else>'2016-09-09 23:59:59'</#if></#if></#if><#if type=="Sysdict" ><#assign typeId=param?number+1><#if size gte 1>${typeId?c}, <#else>${typeId?c}</#if></#if><#if type=="ForeignKey" ><#if param!=className><#if size gte 1>${id%5+1}, <#else>${id%5+1}</#if><#else><#if id==1><#if size gte 1>null, <#else>null</#if><#else><#if size gte 1>${(id-2)%5+1}, <#else>${(id-2)%5+1}</#if></#if></#if></#if></#list> );
</#list>
<#else>
</#if>
</#if>

</#if>
</#list>



<#list doc.root.table as table><#assign className=table.@objctName?trim ><#assign tableName=table.@tableName?trim ><#assign tableProp=table.prop ><#assign m2mCount=0>
<#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Area" && className!="Department" && className!="Syslog" && className!="Sysdict" && className!="Uploadfile" >
<#list tableProp as prop><#assign type=prop.@type?trim >
<#if type=="ManyToMany" ><#assign m2mCount=m2mCount+1></#if>
</#list>
<#if m2mCount gt 0>
<#list tableProp as prop><#assign name=prop.@name?trim ><#assign type=prop.@type?trim ><#assign param=prop.@param?trim >
<#if type=="ManyToMany" ><#assign id=0>
<#list 1..intRefTableData as i ><#assign id=id+1>
    INSERT  INTO ${tableName}_${param} (${className?lower_case}_id, ${param?lower_case}_id ) VALUES(${i?c}, ${i?c});
</#list>
</#if>
</#list>
</#if>
</#if>
</#list>



</#if>

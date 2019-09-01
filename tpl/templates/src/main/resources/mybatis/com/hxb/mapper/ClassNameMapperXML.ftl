<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name=className + "Mapper.xml" />
<#assign classProp=table.prop>
<#---->
<#---->
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${pkgName}.mapper.${className}Mapper">

<#if noCopyright!="true">
<#include "/include/copyright-xml.ftl">
</#if>

    <!--cache eviction="LRU" flushInterval="60000" size="1024" readOnly="true" /--> 

    <resultMap  id="${className}Result"  type="${className}">
    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim>
       <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" >
          <#if name=="id">
            <id  property="id"  column="${colName}"/>
          <#else>
            <result  property="${name}"  column="${colName}"/>
          </#if>
       </#if>
       <#if type=="ForeignKey">
            <result  property="${name}Id"  column="${colName}"/>
       </#if>
       <#if type=="Sysdict">
            <result  property="${name}Id"  column="${colName}"/>
       </#if>
    </#list>
    </resultMap>

    <resultMap  id="${className}WithObjectResult"  type="${className}">
    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim>
        <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" >
          <#if name=="id">
            <id  property="id"  column="${colName}"/>
          <#else>
            <result  property="${name}"  column="${colName}"/>
          </#if>
        </#if>
        <#if type=="ForeignKey">
            <result  property="${name}Id"  column="${colName}"/>
        </#if>
        <#if type=="Sysdict">
            <result  property="${name}Id"  column="${colName}"/>
        </#if>
    </#list>

    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim>
        <#if type=="ForeignKey">
            <association  property="${name}"  column="${colName}"  select="${pkgName}.mapper.${param}Mapper.find${param}ById" />
        </#if>
    </#list>
    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim>
        <#if type=="Sysdict">
            <association  property="${name}"  column="${colName}"  select="${pkgName}.mapper.SysdictMapper.findSysdictById" />
        </#if>
    </#list>
    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim>
        <#if type=="ManyToMany">
            <collection  property="${name}"  column="id"  ofType="${param}"  select="${pkgName}.mapper.${param}Mapper.find${param}By${className}Id" />
        </#if>
    </#list>
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
    <#list   classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
        <#if type2=="ForeignKey" && param2==className >
            <collection  property="${className2?lower_case}s"  column="id"  ofType="${className2}"  select="${pkgName}.mapper.${className2}Mapper.find${className2}By${className}Id" />
        </#if>
    </#list>
    </#list>
    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
      <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
         <#if type2=="ManyToMany" && param2==className >
            <collection  property="${className2?lower_case}s"  column="id"  ofType="${className2}"  select="${pkgName}.mapper.${className2}Mapper.find${className2}By${className}Id" />
         </#if>
      </#list>
    </#list>

    </resultMap>

<#assign m2mCount=0><#assign strCount=0><#assign fkCount=0>
<#list classProp as prop><#assign type=prop.@type?trim>
    <#if type=="ManyToMany"><#assign m2mCount=m2mCount+1></#if>
    <#if type=="String"><#assign strCount=strCount+1></#if>
    <#if type=="ForeignKey"><#assign fkCount=fkCount+1></#if>
</#list>

<#if className="Sysdict">
    <select  id="findSysdictByTypeId"  parameterType="long"  resultMap="SysdictResult">
        SELECT id, code, name, enabled  FROM  Sysdict  WHERE  <![CDATA[ id > ${sharp}{id} AND id <= (${sharp}{id}+99)  ORDER BY id]]>
    </select>

    <select  id="findEnabledSysdictByTypeId"  parameterType="long"  resultMap="SysdictResult">
        SELECT id, code, name, enabled  FROM  Sysdict  WHERE  <![CDATA[ enabled=1 AND id > ${sharp}{id} AND id <= (${sharp}{id}+99)  ORDER BY id]]>
    </select>

    <select  id="findSysdictType"  resultMap="SysdictResult">
        SELECT id, code, name, enabled  FROM  Sysdict  WHERE  <![CDATA[ mod(id,100)=0  ORDER BY id]]>
    </select>

    <select  id="findEnabledSysdictType"  resultMap="SysdictResult">
        SELECT id, code, name, enabled  FROM  Sysdict  WHERE  <![CDATA[ enabled=1 AND mod(id,100)=0  ORDER BY id]]>
    </select>
</#if>

    <select  id="find${className}ById"  parameterType="long"  resultMap="${className}Result">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  id=${sharp}{id}<#-- 通过井号变量sharp生成一个#号 -->
    </select>

<#if className="Myuser">
    <select  id="findMyuserByUserName"  parameterType="String"  resultMap="MyuserResult">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  Myuser  WHERE  username=${sharp}{username}
    </select>
</#if>

    <select  id="find${className}WithObjectById"  parameterType="long"  resultMap="${className}WithObjectResult">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  id=${sharp}{id}<#-- 通过井号变量sharp生成一个#号 -->
    </select>

    <select  id="findAll${className}"  resultMap="${className}Result">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}<#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
    </select>
    <#assign hasEnabled="false">
    <#list classProp as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim>
        <#if name2=="enabled" && type2=="Boolean"><#assign hasEnabled="true"></#if>
    </#list>
    <select  id="findEnabled${className}"  resultMap="${className}Result">
      <#if hasEnabled=="true">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  enabled=1 <#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
      <#else>
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName} <#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
      </#if>
    </select>

    <select  id="findAll${className}WithObject"  resultMap="${className}WithObjectResult">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}<#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
    </select>
    <select  id="findEnabled${className}WithObject"  resultMap="${className}WithObjectResult">
      <#if hasEnabled=="true">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  enabled=1 <#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
      <#else>
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName} <#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
      </#if>
    </select>

    <select  id="search${className}ByKey"  parameterType="String"  resultMap="${className}WithObjectResult">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type!="ManyToMany"><#assign size=size-1></#if><#if type!="ManyToMany" ><#if type!="ForeignKey" && type!="Sysdict"><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  <#assign size=strCount><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if type=="String" && size gte 1><#assign size=0>${colName}  LIKE CONCAT(CONCAT('%', ${sharp}{${colName}, jdbcType=VARCHAR}),'%')</#if></#list><#if className=="Area" || className=="Department" > ORDER BY code <#elseif className=="Myuser" || className=="Role" || className=="Permission" || className=="Sysdict" > ORDER BY id <#else> ORDER BY id DESC </#if>
    </select>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colName=prop.@colName?trim>
  <#if type=="ForeignKey">
    <select  id="find${className}By${param}Id"  parameterType="long"  resultMap="${className}Result">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign colName2=prop2.@colName?trim><#if type2!="ManyToMany" ><#assign size=size-1><#if type2!="ForeignKey" && type2!="Sysdict" ><#if size gte 1>${colName2}, <#else>${colName2}</#if><#else><#if size gte 1>${colName2}, <#else>${colName2}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  ${colName}=${sharp}{id}<#-- 通过井号变量sharp生成一个#号 -->
    </select>
    <select  id="find${className}WithObjectBy${param}Id"  parameterType="long"  resultMap="${className}WithObjectResult">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign colName2=prop2.@colName?trim><#if type2!="ManyToMany" ><#assign size=size-1><#if type2!="ForeignKey" && type2!="Sysdict" ><#if size gte 1>${colName2}, <#else>${colName2}</#if><#else><#if size gte 1>${colName2}, <#else>${colName2}</#if></#if></#if></#list>  FROM  ${tableName}  WHERE  ${colName}=${sharp}{id}<#-- 通过井号变量sharp生成一个#号 -->
    </select>
  </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ManyToMany">
    <select  id="find${className}By${param}Id"  parameterType="long"  resultMap="${className}Result">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign colName2=prop2.@colName?trim><#if type2!="ManyToMany" ><#assign size=size-1><#if type2!="ForeignKey" && type2!="Sysdict" ><#if size gte 1>a.${colName2}, <#else>a.${colName2}</#if><#else><#if size gte 1>a.${colName2}, <#else>a.${colName2}</#if></#if></#if></#list>  FROM ${tableName} a, ${tableName}_${param} b  WHERE  b.${className?lower_case}_id=a.id  AND  b.${param?lower_case}_id=${sharp}{id}
    </select>
  </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign tableName2=table2.@tableName?trim><#assign classProp2=table2.prop>
<#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
  <#if type2=="ManyToMany" && param2==className >
    <select  id="find${className}By${className2}Id"  parameterType="long"  resultMap="${className}Result">
        SELECT <#assign size=classProp?size><#assign size=size-m2mCount><#list classProp as prop3><#assign name3=prop3.@name?trim><#assign type3=prop3.@type?trim><#assign colName3=prop3.@colName?trim><#if type3!="ManyToMany" ><#assign size=size-1><#if type3!="ForeignKey" && type3!="Sysdict" ><#if size gte 1>a.${colName3}, <#else>a.${colName3}</#if><#else><#if size gte 1>a.${colName3}, <#else>a.${colName3}</#if></#if></#if></#list>  FROM ${tableName} a, ${tableName2}_${className} b  WHERE  b.${className?lower_case}_id=a.id  AND  b.${className2?lower_case}_id=${sharp}{id}
    </select>
  </#if>
</#list>
</#list>

<#assign m2mCount=0>
<#list classProp as prop><#assign type=prop.@type?trim>
    <#if type=="ManyToMany"><#assign m2mCount=m2mCount+1></#if>
</#list>
  <#if className=="Sysdict">
    <insert  id="insert${className}"  parameterType="${className}"  useGeneratedKeys="true"  keyProperty="id">
        INSERT INTO ${tableName} ( id, <#assign size=classProp?size><#assign size=size-m2mCount-1><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if name!="id" && type!="ManyToMany" ><#assign size=size-1><#if type!="ForeignKey" && type!="Sysdict" ><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list> )  VALUES ( ${sharp}{id}, <#assign size=classProp?size><#assign size=size-m2mCount-1><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if name!="id" && type!="ManyToMany" ><#assign size=size-1><#if type!="ForeignKey" && type!="Sysdict" ><#if size gte 1>${sharp}{${name}}, <#else>${sharp}{${name}}</#if><#else><#if size gte 1>${sharp}{${name}Id}, <#else>${sharp}{${name}Id}</#if></#if></#if></#list> )
    </insert>
  <#else>
    <insert  id="insert${className}"  parameterType="${className}"  useGeneratedKeys="true"  keyProperty="id">
        INSERT INTO ${tableName} ( <#assign size=classProp?size><#assign size=size-m2mCount-1><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if name!="id" && type!="ManyToMany" ><#assign size=size-1><#if type!="ForeignKey" && type!="Sysdict" ><#if size gte 1>${colName}, <#else>${colName}</#if><#else><#if size gte 1>${colName}, <#else>${colName}</#if></#if></#if></#list> )  VALUES ( <#assign size=classProp?size><#assign size=size-m2mCount-1><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if name!="id" && type!="ManyToMany" ><#assign size=size-1><#if type!="ForeignKey" && type!="Sysdict" ><#if size gte 1>${sharp}{${name}}, <#else>${sharp}{${name}}</#if><#else><#if size gte 1>${sharp}{${name}Id}, <#else>${sharp}{${name}Id}</#if></#if></#if></#list> )
    </insert>
  </#if>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    <insert  id="insert${className}${param}"  useGeneratedKeys="true"  keyColumn="GENERATED_KEY">
        INSERT INTO ${tableName}_${param} ( ${className?lower_case}_id, ${param?lower_case}_id ) VALUES ( ${sharp}{param1.id}, ${sharp}{param2.id} )
    </insert>
</#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign tableName2=table2.@tableName?trim><#assign classProp2=table2.prop>
<#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ManyToMany" && param2==className >
    <insert id="insert${className2}${className}" useGeneratedKeys="true" keyColumn="GENERATED_KEY">
        INSERT INTO ${tableName2}_${className} ( ${className2?lower_case}_id, ${className?lower_case}_id ) VALUES ( ${sharp}{param1.id}, ${sharp}{param2.id} )
    </insert>
</#if>
</#list>
</#list>

<#assign m2mCount=0>
<#list classProp as prop><#assign type=prop.@type?trim>
    <#if type=="ManyToMany"><#assign m2mCount=m2mCount+1></#if>
</#list>
<#if dataBaseName=="oracle">
    <update  id="update${className}"  parameterType="${className}">
        UPDATE ${tableName} SET <#assign size=classProp?size><#assign size=size-m2mCount-1><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign colName=prop.@colName?trim><#if name!="id" && type!="ManyToMany" ><#assign size=size-1><#if type!="ForeignKey" && type!="Sysdict" ><#if size gte 1>${colName}=${sharp}{${name}<#if type=="String">,jdbcType=VARCHAR</#if><#if dbType="Date" || dbType="DateTime">,jdbcType=DATE</#if><#if dbType="Timestamp">,jdbcType=TIMESTAMP</#if><#if type=="Boolean" || type=="Double" || type=="Integer" || type=="Long" || type=="Sysdict">,jdbcType=DOUBLE</#if>}, <#else>${colName}=${sharp}{${name}<#if type=="String">,jdbcType=VARCHAR</#if><#if dbType="Date" || dbType="DateTime">,jdbcType=DATE</#if><#if dbType="Timestamp">,jdbcType=TIMESTAMP</#if><#if type=="Boolean" || type=="Double" || type=="Integer" || type=="Long" || type=="Sysdict">,jdbcType=DOUBLE</#if>}</#if><#else><#if size gte 1>${colName}=${sharp}{${name}Id,jdbcType=DOUBLE}, <#else>${colName}=${sharp}{${name}Id,jdbcType=DOUBLE}</#if></#if></#if></#list>  WHERE id=${sharp}{id}
    </update>
<#else>
    <update  id="update${className}"  parameterType="${className}">
        UPDATE ${tableName} SET <#assign size=classProp?size><#assign size=size-m2mCount-1><#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#if name!="id" && type!="ManyToMany" ><#assign size=size-1><#if type!="ForeignKey" && type!="Sysdict" ><#if size gte 1>${colName}=${sharp}{${name}}, <#else>${colName}=${sharp}{${name}}</#if><#else><#if size gte 1>${colName}=${sharp}{${name}Id}, <#else>${colName}=${sharp}{${name}Id}</#if></#if></#if></#list>  WHERE id=${sharp}{id}
    </update>
</#if>

    <delete  id="delete${className}ById"  parameterType="long">
        DELETE FROM ${tableName} WHERE  id=${sharp}{id}
    </delete>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    <delete id="delete${className}${param}By${className}Id" parameterType="long">
        DELETE FROM ${tableName}_${param}  WHERE  ${className?lower_case}_id=${sharp}{id}
    </delete>
</#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign tableName2=table2.@tableName?trim><#assign classProp2=table2.prop>
<#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
  <#if type2=="ManyToMany" && param2==className >
    <delete  id="delete${className2}${className}By${className}Id"  parameterType="long">
        DELETE FROM ${tableName2}_${className} WHERE  ${className?lower_case}_id=${sharp}{id}
    </delete>
  </#if>
</#list>
</#list>

</mapper>

</#list>


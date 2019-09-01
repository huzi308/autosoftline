<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name=className + "Service.java" />
<#assign classProp=table.prop>
<#---->
<#---->
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.service;

import java.util.List;
import ${pkgName}.model.*;

public interface ${className}Service {

<#if className=="Sysdict">
        public List<Sysdict> findSysdictByTypeId(Long typeId);
        public List<Sysdict> findEnabledSysdictByTypeId(Long typeId);

        public List<Sysdict> findSysdictType();
        public List<Sysdict> findEnabledSysdictType();

</#if>


        public ${className} find${className}ById(Long id);
<#if className="Myuser">
        public Myuser findMyuserByUserName(String username);
</#if>
        public ${className} find${className}WithObjectById(Long id);

        public List<${className}> findAll${className}();
        public List<${className}> findEnabled${className}();

        public List<${className}> findAll${className}WithObject();
        public List<${className}> findEnabled${className}WithObject();

        public List<${className}> search${className}ByKey(String strKey);

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ForeignKey">
        public List<${className}> find${className}By${param}Id(Long id);
        public List<${className}> find${className}WithObjectBy${param}Id(Long id);
    </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        public List<${className}> find${className}By${param}Id(Long id);
    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list   classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        public List<${className}> find${className}By${className2}Id(Long id);
    </#if>
  </#list>
</#list>

        public int insert(${className} ${classNameLower});
        public int insert${className}(${className} ${classNameLower});

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        public int  insert${className}${param}(${className} ${className?lower_case}, ${param} ${param?lower_case}); 
    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        public int insert${className2}${className}(${className2} ${className2?lower_case}, ${className} ${className?lower_case}); 
    </#if>
  </#list>
</#list>


        public int update(${className} ${classNameLower});
        public int update${className}(${className} ${classNameLower});

        public int delete(long id);
        public int delete${className}ById(Long id);

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        public int delete${className}${param}By${className}Id(Long id);

    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        public int delete${className2}${className}By${className}Id(Long id);

    </#if>
  </#list>
</#list>

}

</#list>


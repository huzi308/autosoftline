<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name=className + "Mapper.java" />
<#assign classProp=table.prop>
<#---->
<#---->
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.mapper;

import java.util.List;
import ${pkgName}.model.*;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ${className}Mapper {

<#if className="Sysdict">
        List<Sysdict> findSysdictByTypeId(Long typeId);
        List<Sysdict> findEnabledSysdictByTypeId(Long typeId);

        List<Sysdict> findSysdictType();
        List<Sysdict> findEnabledSysdictType();
</#if>

        ${className} find${className}ById(Long id);
<#if className="Myuser">
        Myuser findMyuserByUserName(String username);
</#if>
        ${className} find${className}WithObjectById(Long id);

        List<${className}> findAll${className}(); 
        List<${className}> findEnabled${className}(); 

        List<${className}> findAll${className}WithObject();
        List<${className}> findEnabled${className}WithObject();

        List<${className}> search${className}ByKey(String strKey);

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ForeignKey">
        List<${className}> find${className}By${param}Id(Long id);

        List<${className}> find${className}WithObjectBy${param}Id(Long id);
    </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        List<${className}> find${className}By${param}Id(Long id);
    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list  classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        List<${className}> find${className}By${className2}Id(Long id);
    </#if>
  </#list>
</#list>

        int insert${className}(${className} ${className?lower_case}); 

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        int insert${className}${param}(${className} ${className?lower_case}, ${param} ${param?lower_case}); 
    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign tableName2=table2.@tableName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        int insert${className2}${className}(${className2} ${className2?lower_case}, ${className} ${className?lower_case}); 
    </#if>
  </#list>
</#list>

        int update${className}(${className} ${className?lower_case}); 

        int delete${className}ById(Long id); 

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        int delete${className}${param}By${className}Id(Long id); 
    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        int delete${className2}${className}By${className}Id(Long id); 
    </#if>
  </#list>
</#list>

}

</#list>


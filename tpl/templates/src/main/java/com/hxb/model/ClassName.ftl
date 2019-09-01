<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name=className + ".java" />
<#assign classProp=table.prop>
<#---->
<#---->
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.model;

import java.util.List;

import javax.validation.constraints.*;
import org.hibernate.validator.constraints.*; 

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

<#assign hasDateProperty=0>
<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim>
<#if type=="Date"><#assign hasDateProperty=1></#if>
</#list>
<#if hasDateProperty==1>
import java.util.Date;
import java.text.SimpleDateFormat;
import org.springframework.format.annotation.DateTimeFormat;
</#if>

public class ${className} implements java.io.Serializable{

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim>
<#if name=="id">
    private  Long  id;  //主键ID
</#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign colComment=prop.@colComment?trim>
<#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" && name!="id">
<#if param=="" && type=="String">
    @NotBlank(message="不能为空！")
<#elseif param=="" && type!="String"  >
    @NotNull(message="不能为空！")
</#if>
<#if dbType=="Date">
    @DateTimeFormat(pattern="yyyy-MM-dd")
<#elseif  dbType=="DateTime" || dbType=="Timestamp">
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
</#if>
<#if className=="Myuser" && name=="username">
    @Pattern(regexp="^[a-zA-Z_]\\w{4,19}$",message="必须以字母下划线开头，可由字母数字下划线组成")
    @Length(min=1,max=16,message="必须在1-16个字符之间")
</#if>
<#if className=="Area" || className=="Department">
  <#if name=="code">
    @Pattern(regexp="^[0-9]*$", message="必须为数字！")
  </#if>
</#if>
<#if className=="Sysdict">
  <#if name=="code">
    @Range(min=1000, max=9999)
  </#if>
</#if>
    private  ${type}  ${name};  //${colComment}

</#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ForeignKey">
    @NotNull(message="不能为空！")
    private  Long ${name}Id;
    private  ${param}  ${name};

</#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim>
<#if type=="Sysdict">
    @NotNull(message="不能为空！")
    private  Long ${name}Id;
    private  Sysdict  ${name};

</#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
    private  List<${param}> ${name};
    private  Long[] ${param?lower_case}Ids;

</#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign tableName2=table2.@tableName?trim><#assign classProp2=table2.prop>
<#list  classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ForeignKey" && param2==className >
    private  List<${className2}> ${className2?lower_case}s;

</#if>
</#list>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ManyToMany" && param2==className>
    private  List<${className2}> ${className2?lower_case}s;
    private  Long[] ${className2?lower_case}Ids;

</#if>
</#list>
</#list>

    public ${className}() {
    }

    //属性的getter/setter方法

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim><#assign colComment=prop.@colComment?trim>
  <#if name=="id">
    //主键ID
    public  Long  getId(){
        return this.id;
    }
    public  void  setId(Long id){
        this.id=id;
    }

  </#if>
  <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" && name!="id">
    //${colComment}
    public  ${type}  get${name?cap_first}(){
        return this.${name};
    }
    public  void  set${name?cap_first}(${type} ${name}){
        this.${name}=${name};
    }

  </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ForeignKey">
    public  ${param}  get${name?cap_first}(){
        return this.${name};
    }
    public  void  set${name?cap_first}(${param} ${name}){
        this.${name}=${name};
    }
    public  Long  get${name?cap_first}Id(){
        return this.${name}Id;
    }
    public  void  set${name?cap_first}Id(Long ${name}Id){
        this.${name}Id=${name}Id;
    }

  </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="Sysdict">
    public  Sysdict  get${name?cap_first}(){
        return this.${name};
    }
    public  void  set${name?cap_first}(Sysdict ${name}){
        this.${name}=${name};
    }
    public  Long  get${name?cap_first}Id(){
        return this.${name}Id;
    }
    public  void  set${name?cap_first}Id(Long ${name}Id){
        this.${name}Id=${name}Id;
    }

  </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ManyToMany">
    public  List<${param}>  get${name?cap_first}(){
        return this.${name};
    }
    public  void  set${name?cap_first}(List<${param}> ${name}){
        this.${name}=${name};
    }

    public  Long[]  get${param}Ids(){
        return this.${param?lower_case}Ids;
    }
    public  void  set${param}Ids(Long[] ${param?lower_case}Ids){
        this.${param?lower_case}Ids=${param?lower_case}Ids;
    }

  </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list   classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ForeignKey" && param2==className >
    public  List<${className2?cap_first}>  get${className2?cap_first}s(){
        return this.${className2?lower_case}s;
    }
    public  void  set${className2?cap_first}s(List<${className2?cap_first}> ${className2?lower_case}s){
        this.${className2?lower_case}s=${className2?lower_case}s;
    }

</#if>
</#list>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list  classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
<#if type2=="ManyToMany" && param2==className >
    public  List<${className2?cap_first}>  get${className2?cap_first}s(){
        return this.${className2?lower_case}s;
    }
    public  void  set${className2?cap_first}s(List<${className2?cap_first}> ${className2?lower_case}s){
        this.${className2?lower_case}s=${className2?lower_case}s;
    }

    public  Long[]  get${className2?cap_first}Ids(){
        return this.${className2?lower_case}Ids;
    }
    public  void  set${className2?cap_first}Ids(Long[] ${className2?lower_case}Ids){
        this.${className2?lower_case}Ids=${className2?lower_case}Ids;
    }

</#if>
</#list>
</#list>



    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
   <#assign intCount=0>
   <#list classProp as prop><#assign type=prop.@type?trim>
    <#if type!="ManyToMany"><#assign intCount=intCount+1></#if>
   </#list>
   <#list classProp as prop><#assign type=prop.@type?trim><#assign name=prop.@name?trim><#assign dbType=prop.@dbType?trim>
   <#if type!="ManyToMany">
    <#if intCount gt 1>
      <#if type=="ForeignKey" || type=="Sysdict" >
            .append( "${name}Id", get${name?cap_first}Id() )
      <#else>
          <#if  dbType=="Date">
            .append( "${name}", get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd")).format( get${name?cap_first}() ) )
          <#elseif  dbType=="DateTime" || dbType=="Timestamp">
            .append( "${name}", get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format( get${name?cap_first}() ) )
          <#elseif  name=="password">
            .append( "${name}", "*" )
          <#else>
            .append( "${name}", get${name?cap_first}() )
          </#if>
      </#if>
    <#else>
       <#if type=="ForeignKey" || type=="Sysdict" >
            .append( "${name}Id", get${name?cap_first}Id() )
       <#else>
          <#if  dbType=="Date">
            .append( "${name}", get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd")).format( get${name?cap_first}() ) )
          <#elseif  dbType=="DateTime" || dbType=="Timestamp">
            .append( "${name}", get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format( get${name?cap_first}() ) )
          <#elseif  name=="password">
            .append( "${name}", "*" )
          <#else>
            .append( "${name}", get${name?cap_first}() )
          </#if>
       </#if>
    </#if>
    <#assign intCount=intCount-1>
   </#if>
   </#list>
            .toString();
    }

}


</#list>


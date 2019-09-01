<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name=className + "ServiceImpl.java" />
<#assign classProp=table.prop>
<#---->
<#---->
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import ${pkgName}.model.*;
import ${pkgName}.mapper.*;
import ${pkgName}.service.*;

import java.util.List;
import java.util.ArrayList;

import java.util.Set;
import java.util.HashSet;

import com.github.pagehelper.Page;

<#assign implExt="">
<#if className="Myuser"><#assign implExt=", UserDetailsService">
import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
</#if>

@Service
@Transactional(readOnly = true)
public  class ${className}ServiceImpl implements ${className}Service${implExt} {

    @Autowired 
    private ${className}Mapper ${classNameLower}Mapper;

<#if className="Myuser">
    @Autowired 
    private RoleMapper roleMapper;

    @Autowired 
    private PermissionMapper permissionMapper;

</#if>

<#if className="Sysdict">
    public List<Sysdict> findSysdictByTypeId(Long typeId){
        return sysdictMapper.findSysdictByTypeId(typeId);
    }

    public List<Sysdict> findEnabledSysdictByTypeId(Long typeId){
        return sysdictMapper.findEnabledSysdictByTypeId(typeId);
    }

    public List<Sysdict> findSysdictType(){
        return sysdictMapper.findSysdictType();
    }

    public List<Sysdict> findEnabledSysdictType(){
        return sysdictMapper.findEnabledSysdictType();
    }
</#if>

<#if className="Myuser">
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        Myuser user = myuserMapper.findMyuserByUserName(username);

        if (user!=null){

            //System.out.println("user.id="+user.getId());
            //System.out.println("user.name="+user.getUsername());
            //System.out.println("user.password="+user.getPassword());

            Set<GrantedAuthority> gauSet = new HashSet<GrantedAuthority>();

            gauSet.addAll(loadGroupAuthorities(user.getId()));

            List<GrantedAuthority> gauList = new ArrayList<GrantedAuthority>(gauSet);

            if (gauList.size() == 0) {
                throw new UsernameNotFoundException("User has no GrantedAuthority");
            }

            return  new  org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), true, true, true, true, gauList);
        }
        else{
            throw new UsernameNotFoundException(username + " does not exist!");
        }

    }


    protected List<GrantedAuthority> loadGroupAuthorities(Long userId) {

        List<Role> roleList = roleMapper.findRoleByMyuserId(userId);

        List<GrantedAuthority> gauList = new ArrayList<GrantedAuthority>();

        for (Role role : roleList){
            List<Permission> permList = permissionMapper.findPermissionByRoleId(role.getId());
            for (Permission perm : permList){
                GrantedAuthority gau = new SimpleGrantedAuthority( "ROLE_" + perm.getPerm() );
                gauList.add(gau);
            }
        }
        return gauList;
    }

</#if>


    public ${className} find${className}ById(Long id){
        return ${classNameLower}Mapper.find${className}ById(id);
    }

<#if className="Myuser">
    public Myuser findMyuserByUserName(String username){
        return myuserMapper.findMyuserByUserName(username);
    }
</#if>

    public ${className} find${className}WithObjectById(Long id){
        return ${classNameLower}Mapper.find${className}WithObjectById(id);
    }

    public List<${className}> findAll${className}(){
        return ${classNameLower}Mapper.findAll${className}();
    }
    public List<${className}> findEnabled${className}(){
        return ${classNameLower}Mapper.findEnabled${className}();
    }

    public List<${className}> findAll${className}WithObject(){
        return ${classNameLower}Mapper.findAll${className}WithObject();
    }
    public List<${className}> findEnabled${className}WithObject(){
        return ${classNameLower}Mapper.findEnabled${className}WithObject();
    }

    public List<${className}> search${className}ByKey(String strKey){
        return ${classNameLower}Mapper.search${className}ByKey(strKey);
    }


<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ForeignKey">
    public List<${className}> find${className}By${param}Id(Long id){
        return ${classNameLower}Mapper.find${className}By${param}Id(id);
    }

    public List<${className}> find${className}WithObjectBy${param}Id(Long id){
        return ${classNameLower}Mapper.find${className}WithObjectBy${param}Id(id);
    }

  </#if>
</#list>


<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ManyToMany">
    public List<${className}> find${className}By${param}Id(Long id){
        return ${classNameLower}Mapper.find${className}By${param}Id(id);
    }

  </#if>
</#list>


<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list   classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
  <#if type2=="ManyToMany" && param2==className >
    public List<${className}> find${className}By${className2}Id(Long id){
        return ${classNameLower}Mapper.find${className}By${className2}Id(id);
    }

  </#if>
</#list>
</#list>


    @Transactional
    public int insert(${className} ${classNameLower}){
        return ${classNameLower}Mapper.insert${className}(${classNameLower});
    }
    @Transactional
    public int insert${className}(${className} ${classNameLower}){
        return ${classNameLower}Mapper.insert${className}(${classNameLower});
    }

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ManyToMany">
    @Transactional
    public int  insert${className}${param}(${className} ${className?lower_case}, ${param} ${param?lower_case}){
        return ${classNameLower}Mapper.insert${className}${param}( ${className?lower_case},  ${param?lower_case} );
    }

  </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
  <#if type2=="ManyToMany" && param2==className >
    @Transactional
    public int insert${className2}${className}(${className2} ${className2?lower_case}, ${className} ${className?lower_case}){
        return ${classNameLower}Mapper.insert${className2}${className}( ${className2?lower_case},  ${className?lower_case} );
    }

  </#if>
</#list>
</#list>


    @Transactional
    public int update(${className} ${classNameLower}){
        return ${classNameLower}Mapper.update${className}(${classNameLower});
    }
    @Transactional
    public int update${className}(${className} ${classNameLower}){
        return ${classNameLower}Mapper.update${className}(${classNameLower});
    }


    @Transactional
    public int delete(long id){
        return ${classNameLower}Mapper.delete${className}ById(id);
    }
    @Transactional
    public int delete${className}ById(Long id){
        return ${classNameLower}Mapper.delete${className}ById(id);
    }

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ManyToMany">
    @Transactional
    public int delete${className}${param}By${className}Id(Long id){
        return ${classNameLower}Mapper.delete${className}${param}By${className}Id(id);
    }

  </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
<#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
  <#if type2=="ManyToMany" && param2==className >
    @Transactional
    public int delete${className2}${className}By${className}Id(Long id){
        return ${classNameLower}Mapper.delete${className2}${className}By${className}Id(id);
    }

  </#if>
</#list>
</#list>

}

</#list>


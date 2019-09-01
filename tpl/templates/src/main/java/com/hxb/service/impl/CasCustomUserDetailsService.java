<#include "/include/parameters.ftl">
<#if isCasClient!="true">
<@pp.dropOutputFile />
</#if>
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.service.impl;

import java.util.Set;
import java.util.HashSet;

import java.util.List;
import java.util.ArrayList;

import ${pkgName}.model.*;
import ${pkgName}.mapper.*;
import ${pkgName}.service.*;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.userdetails.AuthenticationUserDetailsService;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

import org.springframework.security.cas.authentication.CasAssertionAuthenticationToken;


public class CasCustomUserDetailsService implements AuthenticationUserDetailsService<CasAssertionAuthenticationToken> {

    @Autowired 
    private MyuserMapper myuserMapper;

    @Autowired 
    private RoleMapper roleMapper;

    @Autowired 
    private PermissionMapper permissionMapper;


    @Override
    public UserDetails loadUserDetails(CasAssertionAuthenticationToken token) throws UsernameNotFoundException {

        String username=token.getName();

        Myuser user = myuserMapper.findMyuserByUserName(username);

        if (user==null){

            //如果认证中心的用户在本地库中不存在，则在本地库中插入该用户
            Myuser newUser = new Myuser();
            Role   role = new Role();

            newUser.setUsername(username);
            newUser.setPassword("user-from-CAS");
            newUser.setEnabled(true);
            newUser.setDeptId(1L);

            myuserMapper.insertMyuser(newUser);

            user = myuserMapper.findMyuserByUserName(username);

            role.setId(2L); //赋予该用户Member角色

            myuserMapper.insertMyuserRole(user, role);
        }

        //System.out.println("user.id="+user.getId());
        //System.out.println("user.name="+user.getUsername());
        //System.out.println("user.password="+user.getPassword());
        //System.out.println("user.roles="+user.getRoles());

        Set<GrantedAuthority> gauSet = new HashSet<GrantedAuthority>();

        gauSet.addAll(loadGroupAuthorities(user.getId()));

        List<GrantedAuthority> gauList = new ArrayList<GrantedAuthority>(gauSet);

        if (gauList.size() == 0) {
            throw new UsernameNotFoundException("User has no GrantedAuthority");
        }

        return  new  org.springframework.security.core.userdetails.User(user.getUsername(), user.getPassword(), true, true, true, true, gauList);

    }


    //获取用户的全部权限（通过用户Id获取该用户的全部Role角色，通过Role角色获取其Permission权限）
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

}

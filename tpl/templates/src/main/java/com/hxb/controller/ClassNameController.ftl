<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name=className + "Controller.java" />
<#assign classProp=table.prop>
<#---->
<#---->
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.controller;

import ${pkgName}.model.*;
import ${pkgName}.service.*;

import ${pkgName}.common.utils.DateUtils;
import ${pkgName}.common.utils.StringUtils;

import java.util.UUID;

import java.util.Date;
import java.text.SimpleDateFormat;

import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;

import java.util.Map;
import java.util.HashMap;

import com.github.pagehelper.PageInfo;
import com.github.pagehelper.PageHelper;

import javax.validation.Valid;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import org.springframework.stereotype.Controller;

import org.springframework.validation.BindingResult;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;

import org.springframework.web.servlet.support.RequestContext;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.annotation.Autowired;


import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import org.springframework.security.access.annotation.Secured;


<#if className=="Myuser" && isCasClient!="true">
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;

import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;

</#if>

import java.io.File;

<#if className=="Uploadfile">
import java.io.FileOutputStream;
import org.springframework.web.multipart.MultipartFile;

</#if>
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

<#if isExcelExport=="true" || isWordExport=="true">
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.hssf.usermodel.*;

import org.apache.poi.ss.util.*;
import org.apache.poi.ss.usermodel.*;

import org.apache.poi.xwpf.usermodel.*;
import org.apache.poi.xwpf.model.XWPFHeaderFooterPolicy;

import org.openxmlformats.schemas.wordprocessingml.x2006.main.*;

import java.io.Writer;

import java.math.BigInteger;

import java.io.IOException;

import java.io.FileInputStream;
import java.io.FileOutputStream;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;

import java.io.BufferedWriter;

import java.io.OutputStreamWriter;

import freemarker.template.Template;
import freemarker.template.Configuration;
import freemarker.template.TemplateException;

</#if>



@Controller
@RequestMapping("/${classNameLower}")
public class ${className}Controller {

<#if className=="Myuser" && isCasClient!="true">
    @Autowired
    protected  AuthenticationManager  authenticationManager;

</#if>
<#if className=="Uploadfile">
    @Value("${dollar}{my.fileupload.root}")
    private  String  fileUploadPathRoot;

</#if>
    @Value("${dollar}{my.page.size}")
    private  Integer  pageSize;

    @Value("${dollar}{my.write.syslog}")
    private  Boolean  bWriteSyslog;

    private  String  save;
    private  String  strUUID;
    private  String  errorMsg;

    private  String  submitToken;
    private  String  serverToken;
    private  Boolean isTokenEqual;

    private  ${className}  ${classNameLower}_old;

<#if className!="Syslog">
    @Autowired
    private  SyslogService  syslogService;

</#if>
    @Autowired
    private  ${className}Service  ${classNameLower}Service;


<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ForeignKey" && param!=className>
    @Autowired
    private ${param}Service ${param?lower_case}Service;
  </#if>
</#list>

<#assign size=classProp?size>
<#list classProp as prop><#assign type=prop.@type?trim>
  <#if type=="Sysdict" && size gte 1><#assign size=0>
    @Autowired
    private SysdictService sysdictService;
  </#if>
  <#assign size=size-1>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
  <#if type=="ManyToMany">
    @Autowired
    private ${param}Service ${param?lower_case}Service;
  </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
    @Autowired
    private ${className2}Service ${className2?lower_case}Service;
    </#if>
  </#list>
</#list>


<#if hasJsonAPI=="true">

    //处理Json的 GET 请求: 查询全部${className}对象并以JSON格式返回给请求端
    @RequestMapping(value="/json/${classNameLower}", method=RequestMethod.GET)
    public ResponseEntity<List<${className}>> jsonGetAllObject(){

        List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}();
        //List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}WithObject();

        if(${classNameLower}List.isEmpty()){
            return new ResponseEntity<List<${className}>>(HttpStatus.NO_CONTENT);//You may decide to return HttpStatus.NOT_FOUND
        }  
        return new ResponseEntity<List<${className}>>(${classNameLower}List, HttpStatus.OK);

    }

    //处理Json的 GET 请求: 查询id指定的对象并以JSON格式返回给请求端
    @RequestMapping(value="/json/${classNameLower}/{id}", method=RequestMethod.GET)
    public ResponseEntity<${className}> jsonGetOneObject(@PathVariable("id") Long id){

        ${className} ${classNameLower} = new ${className}();
        ${classNameLower} = null;

        if (id>0){ 
            ${classNameLower} = ${classNameLower}Service.find${className}ById(id);
            //${classNameLower} = ${classNameLower}Service.find${className}WithObjectById(id);
            if (${classNameLower}==null){
                return new ResponseEntity<${className}>(HttpStatus.NOT_FOUND);
            }
            else{
                return new ResponseEntity<${className}>(${classNameLower}, HttpStatus.OK);
            }
        }
        else{
                return new ResponseEntity<${className}>(HttpStatus.BAD_REQUEST);
        }

    }


    //处理Json的 POST 请求: 请求端以JSON格式提交数据，接收JSON格式数据后在数据库中新增一条${className}对象数据（POST: 新增）
    @RequestMapping(value={"/json/${classNameLower}"}, method=RequestMethod.POST)
    public ResponseEntity<String> jsonInsertObject(@RequestBody ${className} ${classNameLower}){

        if(${classNameLower}Service.insert${className}(${classNameLower})>0){
            return new ResponseEntity<String>(HttpStatus.CREATED);
        }
        else{
            return new ResponseEntity<String>(HttpStatus.EXPECTATION_FAILED);
        }

    }


    //处理Json的 PUT 请求: 请求端以JSON格式提交数据，接收JSON格式数据后在数据库中更新${className}对象数据（PUT: 覆盖，全部更新）
    @RequestMapping(value={"/json/${classNameLower}"}, method=RequestMethod.PUT)
    public ResponseEntity<${className}> jsonUpdateObject(@RequestBody ${className} ${classNameLower}){

        if(${classNameLower}Service.update${className}(${classNameLower})>0){
            return new ResponseEntity<${className}>(${classNameLower}, HttpStatus.OK);
        }
        else{
            return new ResponseEntity<${className}>(HttpStatus.EXPECTATION_FAILED);
        }

    }

    //处理Json的 PATCH 请求: 请求端以JSON格式提交数据，接收JSON格式数据后在数据库中更新${className}对象数据（PATCH: 更新部分信息）
    @RequestMapping(value={"/json/${classNameLower}"}, method=RequestMethod.PATCH)
    public ResponseEntity<${className}> jsonPatchUpdateObject(@RequestBody ${className} ${classNameLower}){

        if(${classNameLower}Service.update${className}(${classNameLower})>0){
            return new ResponseEntity<${className}>(${classNameLower}, HttpStatus.OK);
        }
        else{
            return new ResponseEntity<${className}>(HttpStatus.EXPECTATION_FAILED);
        }

    }


    //处理Json的 DELETE 请求: 删除id指定的对象数据
    @RequestMapping(value={"/json/${classNameLower}/{id}"}, method=RequestMethod.DELETE)
    public ResponseEntity<${className}> jsonDeleteObject(@PathVariable("id") Long id){

        if (id>0){

            if (${classNameLower}Service.delete${className}ById(id)>0){
                return new ResponseEntity<${className}>(HttpStatus.OK);
            }
            else{
                return new ResponseEntity<${className}>(HttpStatus.EXPECTATION_FAILED);
            }
        }
        else{
            return new ResponseEntity<${className}>(HttpStatus.BAD_REQUEST);
        }

    }

</#if>


    @RequestMapping(value="/search", method=RequestMethod.POST)
    public String search(HttpServletRequest request, Model model){

        // 界面输入的字符串（关键词）
        String strKey=request.getParameter("strKey");

        // 采用PageHelper插件实现分页（在application.properties中配置PageHelper插件）
        PageHelper.startPage(1, 500);

        // 调用Service方法，查询${className}对象集合（包含该对象的关联对象，存在N+1性能问题，通过配置myBatis的延迟加载策略来解决N+1性能问题！）
        List<${className}> ${classNameLower}List=${classNameLower}Service.search${className}ByKey( strKey.trim() );

        //用PageInfo对查询的结果集${classNameLower}List进行包装，在页面上通过page.list可访问该查询结果集
        PageInfo<${className}> page=new PageInfo<${className}>(${classNameLower}List);

        model.addAttribute("strKey", strKey);
        model.addAttribute("page", page);
        model.addAttribute("errorMsg", errorMsg);
        errorMsg="";

        return "${className}/${className}List";
    }



    @RequestMapping(value="/list", method=RequestMethod.GET)
    public String list(@RequestParam(value="pageNum", defaultValue="1") Integer pageNum, Model model){

        // 采用PageHelper插件实现分页（在application.properties中配置PageHelper插件）
        PageHelper.startPage(pageNum, pageSize);

        // 调用Service方法，查询${className}对象集合（包含该对象的关联对象，存在N+1性能问题，通过配置myBatis的延迟加载策略来解决N+1性能问题！）
        List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}WithObject();
        //List<${className}> ${classNameLower}List=${classNameLower}Service.findEnabled${className}WithObject();

        //用PageInfo对查询的结果集${classNameLower}List进行包装，在页面上通过page.list可访问该查询结果集
        PageInfo<${className}> page=new PageInfo<${className}>(${classNameLower}List);

        model.addAttribute("page", page);
        model.addAttribute("errorMsg", errorMsg);
        errorMsg="";

        return "${className}/${className}List";
    }



    @RequestMapping(value="/detail", method=RequestMethod.GET)
    public String detail(Model model,Long id) {
        ${className} ${classNameLower}=${classNameLower}Service.find${className}WithObjectById(id);
        model.addAttribute("${classNameLower}", ${classNameLower});
        return "${className}/${className}Detail";
    }



<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign colName=prop.@colName?trim><#assign param=prop.@param?trim>
  <#if type=="ForeignKey">
    @RequestMapping(value="/${param?lower_case}", method=RequestMethod.GET)
    public String findBy${param}Id(Long id, Model model){
        PageHelper.startPage(1, 500);
        List<${className}> ${classNameLower}List = ${classNameLower}Service.find${className}WithObjectBy${param}Id(id);
        PageInfo<${className}> page=new PageInfo<${className}>(${classNameLower}List);
        model.addAttribute("page", page);
        return "${className}/${className}List";
    }

  </#if>
</#list>





    @RequestMapping(value="/insert", method={RequestMethod.GET, RequestMethod.POST})  //新增加一条记录
    @Secured({"ROLE_Admin", "ROLE_ObjAdmin", "ROLE_${className}Admin"})
    public String insertObject(@Valid @ModelAttribute("${classNameLower}") ${className} ${classNameLower}, BindingResult result, Model model, HttpServletRequest request) {

        save=request.getParameter("save");
        submitToken = request.getParameter("submitToken");
        serverToken = (String)request.getSession().getAttribute("serverToken");
        //System.out.println("submitToken="+submitToken);
        //System.out.println("serverToken="+serverToken);

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ForeignKey">
        List<${param}> ${name}List=${param?lower_case}Service.findEnabled${param}();
        model.addAttribute("${name}List", ${name}List);

</#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="Sysdict">
        List<Sysdict> ${name}List=sysdictService.findEnabledSysdictByTypeId(new Long(${param})); //只查找出（有效的/enabled=1）的记录
        model.addAttribute("${name}List", ${name}List);

    </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
<#if type=="ManyToMany">
        List<${param}> ${param?lower_case}List=${param?lower_case}Service.findEnabled${param}();
        model.addAttribute("${param?lower_case}List", ${param?lower_case}List);

</#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        List<${className2}> ${className2?lower_case}List=${className2?lower_case}Service.findEnabled${className2}();
        model.addAttribute("${className2?lower_case}List", ${className2?lower_case}List);

    </#if>
  </#list>
</#list>
        // 防止表单重复提交
        isTokenEqual = false;
        if ((submitToken!=null) && (serverToken!=null)){
            if (submitToken.equals(serverToken)){
                isTokenEqual = true;
            }
        }

        if ("Yes".equals(save)){ //提交保存
            if(isTokenEqual){
                if(result.hasErrors()){ //提交的数据有效性验证没有通过，返回界面重新修改数据

                    strUUID = UUID.randomUUID().toString();
                    //System.out.println("2.数据有效性验证没有通过，重新输入:strUUID="+strUUID);

                    request.getSession().setAttribute("serverToken", ""+strUUID);
                    model.addAttribute("submitToken", ""+strUUID);

                    errorMsg="数据有效性验证失败！";
                    model.addAttribute("errorMsg", errorMsg);

                    model.addAttribute( "${classNameLower}", ${classNameLower} );  //已经录入的数据在返回原界面时自动填充
                    return "${className}/${className}Add";
                }
                else{
                    //System.out.println("3.数据有效性验证已经通过，准备保存，先清除Session中的serverToken");
                    request.getSession().removeAttribute("serverToken");
                    //serverToken = (String)request.getSession().getAttribute("serverToken");
                    //System.out.println("serverToken="+serverToken);

                <#if className=="Sysdict" >
                    ${classNameLower}.setId( ${classNameLower}.getCode() );
                </#if>
                <#if className=="Area" || className=="Department">
                    ${classNameLower}.setId( Long.parseLong(${classNameLower}.getCode()) );
                </#if>
                    <#--提交的数据有效性验证通过，执行保存操作-->
                    if (${classNameLower}Service.insert(${classNameLower})>0){

                    <#if className!="Syslog">
                        Syslog syslog=new Syslog();
                        if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false

                            //为Insert操作记录系统日志
                            syslog.setOperation("Insert");
                            syslog.setTableName("${tableName}");
                            syslog.setObjctId(${classNameLower}.getId());
                            syslog.setOperateBy(request.getUserPrincipal().getName());
                            syslog.setIp(request.getRemoteAddr());
                            syslog.setOperateTime(new Date());

                            syslog.setObjctValue(${classNameLower}.toString());
                            syslogService.insert(syslog);
                        }
                    </#if>


                <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
                    <#if type=="ManyToMany">
                        
                        Long ${param?lower_case}Ids[]=${classNameLower}.get${param}Ids();
                        
                        if (!(${param?lower_case}Ids==null || ${param?lower_case}Ids.length==0)){
                        
                            ${param} ${param?lower_case}=new ${param}();

                        <#if className!="Syslog">
                            if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                                <#-- 为insert操作记录系统日志 -->
                                syslog.setOperation("Insert");
                                syslog.setTableName("${tableName}_${param}");
                                syslog.setObjctId(0L);
                                syslog.setOperateBy(request.getUserPrincipal().getName());
                                syslog.setIp(request.getRemoteAddr());
                                syslog.setOperateTime(new Date());
                            }

                            String val01="";
                            
                            for(int i=0; i<${param?lower_case}Ids.length; i++)
                            {
                                ${param?lower_case}.setId(${param?lower_case}Ids[i]);
                                ${classNameLower}Service.insert${className}${param}(${classNameLower}, ${param?lower_case});
                                val01 += "["+${classNameLower}.getId().toString()+", "+${param?lower_case}.getId().toString()+"], ";
                            }

                            if (bWriteSyslog){
                                syslog.setObjctValue(val01);
                                syslogService.insertSyslog(syslog);
                            }
                        </#if>
                        }
                    </#if>
                </#list>

            <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign tableName2=table2.@tableName?trim><#assign classProp2=table2.prop>
                <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                    <#if type2=="ManyToMany" && param2==className >

                        Long ${className2?lower_case}Ids[]=${classNameLower}.get${className2}Ids();

                        if (!(${className2?lower_case}Ids==null || ${className2?lower_case}Ids.length==0)){

                            ${className2} ${className2?lower_case}=new ${className2}();

                        <#if className!="Syslog">
                            if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                                <#-- 为insert操作记录系统日志 -->
                                syslog.setOperation("Insert");
                                syslog.setTableName("${tableName2}_${className}");
                                syslog.setObjctId(0L);
                                syslog.setOperateBy(request.getUserPrincipal().getName());
                                syslog.setIp(request.getRemoteAddr());
                                syslog.setOperateTime(new Date());
                            }

                            String val02="";

                            for(int i=0; i<${className2?lower_case}Ids.length; i++)
                            {
                                ${className2?lower_case}.setId(${className2?lower_case}Ids[i]);
                                ${classNameLower}Service.insert${className2}${className}(${className2?lower_case}, ${classNameLower});
                                val02 += "["+${className2?lower_case}.getId().toString()+", "+${classNameLower}.getId().toString()+"], ";
                            }

                            if (bWriteSyslog){
                                syslog.setObjctValue(val02);
                                syslogService.insertSyslog(syslog);
                            }
                        </#if>
                        }
                    </#if>
                </#list>
            </#list>
                        errorMsg="新增${className} [id=" + ${classNameLower}.getId() + "] 成功！";
                    }
                    else{
                        errorMsg="新增加数据失败！";
                    }
                }
            }
            else{
                errorMsg = errorMsg + " 存在表单重复提交！";
                //System.out.println("insert-存在表单重复提交！");
            }

            return "redirect:/${classNameLower}/list";
        }
        else{
            //System.out.println("1-新增加记录");
            model.addAttribute("errorMsg", errorMsg);

            strUUID = UUID.randomUUID().toString();
            //System.out.println("1.新增:strUUID="+strUUID);

            request.getSession().setAttribute("serverToken", ""+strUUID);
            model.addAttribute("submitToken", ""+strUUID);

            //用新建的空对象${className}清空Edit页面的各个输入项
            ${className} ${classNameLower}2=new ${className}();
            model.addAttribute("${classNameLower}", ${classNameLower}2);

            return "${className}/${className}Add";
        }

    }








    @RequestMapping(value="/update", method={RequestMethod.GET, RequestMethod.POST})  //根据指定的记录id修改更新一条记录
    @Secured({"ROLE_Admin", "ROLE_ObjAdmin", "ROLE_${className}Admin"})
    public String updateObject(Long id, @Valid @ModelAttribute("${classNameLower}") ${className} ${classNameLower}, BindingResult result, Model model, HttpServletRequest request) {

        save=request.getParameter("save");
        submitToken = request.getParameter("submitToken");
        serverToken = (String)request.getSession().getAttribute("serverToken");

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ForeignKey">
        List<${param}> ${name}List=${param?lower_case}Service.findAll${param}();
        model.addAttribute("${name}List", ${name}List);

    </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="Sysdict">
        List<Sysdict> ${name}List=sysdictService.findSysdictByTypeId(new Long(${param}));
        model.addAttribute("${name}List", ${name}List);

    </#if>
</#list>

<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
        List<${param}> ${param?lower_case}List=${param?lower_case}Service.findAll${param}();
        model.addAttribute("${param?lower_case}List", ${param?lower_case}List);

    </#if>
</#list>

<#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className >
        List<${className2}> ${className2?lower_case}List=${className2?lower_case}Service.findAll${className2}();
        model.addAttribute("${className2?lower_case}List", ${className2?lower_case}List);

    </#if>
  </#list>
</#list>
        // 防止表单重复提交
        isTokenEqual = false;
        if ((submitToken!=null) && (serverToken!=null)){
            if (submitToken.equals(serverToken)){
                isTokenEqual = true;
            }
        }

        if ("Yes".equals(save)){ //提交保存
            if(isTokenEqual){
                if(result.hasErrors()){ //提交的数据有效性验证没有通过，返回界面重新修改数据

                    /*
                    System.out.println("2-数据有效性验证没有通过");
                    List<ObjectError> ls=result.getAllErrors();
                    for (int i = 0; i < ls.size(); i++) {
                        System.out.println("hxb-error: "+ls.get(i));
                    }
                    */

                    strUUID = UUID.randomUUID().toString();
                    //System.out.println("2.数据有效性验证没有通过，重新输入:strUUID="+strUUID);

                    request.getSession().setAttribute("serverToken", ""+strUUID);
                    model.addAttribute("submitToken", ""+strUUID);

                    errorMsg="数据有效性验证未通过！";
                    model.addAttribute("errorMsg", errorMsg);

                    model.addAttribute( "${classNameLower}", ${classNameLower} );  //已经录入的数据在返回原界面时自动填充
                    return "${className}/${className}Edit";
                }

                int  countDelete=0;

                ${className} ${classNameLower}_old = ${classNameLower}Service.find${className}ById(${classNameLower}.getId());

                <#if className!="Syslog">
                Syslog syslog=new Syslog();
                </#if>

                    <#--提交的数据有效性验证通过，执行保存操作-->
                if (${classNameLower}Service.update(${classNameLower})>0){

                  <#if className!="Syslog">
                    if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                        //为Update操作记录系统日志
                        syslog.setOperation("Update");
                        syslog.setTableName("${tableName}");
                        syslog.setObjctId(${classNameLower}.getId());
                        syslog.setOperateBy(request.getUserPrincipal().getName());
                        syslog.setIp(request.getRemoteAddr());
                        syslog.setOperateTime(new Date());

                        syslog.setObjctValue("修改前：" + ${classNameLower}_old.toString() + "<br>修改后：" + ${classNameLower}.toString());
                        syslogService.insert(syslog);
                    }
                  </#if>

                    errorMsg="更新${className} [id=" + id + "] 成功！";

            <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
                <#if type=="ManyToMany">
                    countDelete=${classNameLower}Service.delete${className}${param}By${className}Id( ${classNameLower}.getId() );

                  <#if className!="Syslog">
                    if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                        //为delete操作记录系统日志
                        syslog.setOperation("Delete");
                        syslog.setTableName("${tableName}_${param}");
                        syslog.setObjctId(0L);
                        syslog.setObjctValue("[${classNameLower}_id="+${classNameLower}.getId().toString()+", ${param?lower_case}_id=* ]");
                        syslog.setOperateBy(request.getUserPrincipal().getName());
                        syslog.setIp(request.getRemoteAddr());
                        syslog.setOperateTime(new Date());

                        syslogService.insertSyslog(syslog);
                    }
                  </#if>

                    Long ${param?lower_case}Ids[]=${classNameLower}.get${param}Ids();
                    
                    if (!(${param?lower_case}Ids==null || ${param?lower_case}Ids.length==0)){
                    
                        ${param} ${param?lower_case}=new ${param}();

                    <#if className!="Syslog">
                        if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                           //为insert操作记录系统日志
                            syslog.setOperation("Insert");
                            syslog.setTableName("${tableName}_${param}");
                            syslog.setObjctId(0L);
                            syslog.setOperateBy(request.getUserPrincipal().getName());
                            syslog.setIp(request.getRemoteAddr());
                            syslog.setOperateTime(new Date());
                        }

                        String val01="";

                        for(int i=0; i<${param?lower_case}Ids.length; i++)
                        {
                            ${param?lower_case}.setId(${param?lower_case}Ids[i]);
                            ${classNameLower}Service.insert${className}${param}(${classNameLower}, ${param?lower_case});
                            val01 += "["+${classNameLower}.getId().toString()+", "+${param?lower_case}.getId().toString()+"], ";
                        }

                        if (bWriteSyslog){
                            syslog.setObjctValue(val01);
                            syslogService.insertSyslog(syslog);
                        }
                    </#if>
                    }
                </#if>
            </#list>

        <#list doc.root.table as table2><#assign tableName2=table2.@tableName?trim><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
            <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                <#if type2=="ManyToMany" && param2==className >

                    // 此处对ManyToMany中间表的简单处理方法（先delete再insert，未变的记录被删除并又重新插入了）可以改进为（保留未变的记录，只删除不要的记录，增加新记录）
                    countDelete=${classNameLower}Service.delete${className2}${className}By${className}Id( ${classNameLower}.getId() );

                  <#if className!="Syslog">
                    if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                        //为delete操作记录系统日志
                        syslog.setOperation("Delete");
                        syslog.setTableName("${tableName2}_${className}");
                        syslog.setObjctId(0L);
                        //syslog.setObjctValue("[${classNameLower}_id="+${classNameLower}.getId().toString()+", ${className2?lower_case}_id=* ]");
                        syslog.setObjctValue("[${className2?lower_case}_id=*, ${classNameLower}_id="+${classNameLower}.getId().toString()+"]");
                        syslog.setOperateBy(request.getUserPrincipal().getName());
                        syslog.setIp(request.getRemoteAddr());
                        syslog.setOperateTime(new Date());

                        syslogService.insertSyslog(syslog);
                    }
                  </#if>
                    
                    Long ${className2?lower_case}Ids[]=${classNameLower}.get${className2}Ids();
                    
                    if (!(${className2?lower_case}Ids==null || ${className2?lower_case}Ids.length==0)){
                    
                        ${className2} ${className2?lower_case}=new ${className2}();
                    
                    <#if className!="Syslog">
                        if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                            //为insert操作记录系统日志
                            syslog.setOperation("Insert");
                            syslog.setTableName("${tableName2}_${className}");
                            syslog.setObjctId(0L);
                            syslog.setOperateBy(request.getUserPrincipal().getName());
                            syslog.setIp(request.getRemoteAddr());
                            syslog.setOperateTime(new Date());
                        }

                        String val02="";

                        for(int i=0; i<${className2?lower_case}Ids.length; i++)
                        {
                            ${className2?lower_case}.setId(${className2?lower_case}Ids[i]);
                            ${classNameLower}Service.insert${className2}${className}(${className2?lower_case}, ${classNameLower});
                            val02 += "["+${className2?lower_case}.getId().toString()+", "+${classNameLower}.getId().toString()+"], ";
                        }
                        
                        if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                            syslog.setObjctValue(val02);
                            syslogService.insertSyslog(syslog);
                        }
                    </#if>
                    }
                </#if>
            </#list>
        </#list>

                }
                else{
                    errorMsg="更新数据失败！";
                }
            }
            else{
                errorMsg = errorMsg +" 存在表单重复提交！";
                //System.out.println("update-存在表单重复提交！");
            }

            return "redirect:/${classNameLower}/list";

        }
        else{

            ${classNameLower}=${classNameLower}Service.find${className}WithObjectById(id);
            ${classNameLower}_old = ${classNameLower};

    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
    <#if type=="ManyToMany">
            int count${param}=0;
            Long[] ${param?lower_case}Ids = new Long[${classNameLower}.get${name?cap_first}().size()];
            Iterator<${param}> it${param}=${classNameLower}.get${name?cap_first}().iterator();
            while(it${param}.hasNext()){
                ${param} tmp${param}=(${param})it${param}.next();
                ${param?lower_case}Ids[count${param}] = tmp${param}.getId();
                count${param}++;
            }
            ${classNameLower}.set${param}Ids(${param?lower_case}Ids);

    </#if>
    </#list>

    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
    <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
    <#if type2=="ManyToMany" && param2==className>
            int count${className2}=0;
            Long[] ${className2?lower_case}Ids = new Long[${classNameLower}.get${className2?cap_first}s().size()];
            Iterator<${className2}> it${className2}=${classNameLower}.get${className2?cap_first}s().iterator();
            while(it${className2}.hasNext()){
                ${className2} tmp${className2}=(${className2})it${className2}.next();
                ${className2?lower_case}Ids[count${className2}] = tmp${className2}.getId();
                count${className2}++;
            }
            ${classNameLower}.set${className2}Ids(${className2?lower_case}Ids);

    </#if>
    </#list>
    </#list>
            strUUID = UUID.randomUUID().toString();
            //System.out.println("1.修改:strUUID="+strUUID);

            request.getSession().setAttribute("serverToken", ""+strUUID);
            model.addAttribute("submitToken", ""+strUUID);

            model.addAttribute("${classNameLower}", ${classNameLower});

            return "${className}/${className}Edit";
        }

    }









    @RequestMapping(value="/delete", method=RequestMethod.GET)
    @Secured({"ROLE_Admin", "ROLE_ObjAdmin", "ROLE_${className}Admin"})
    public String delete(Long id, Model model, HttpServletRequest request) {

        //判断能否删除，再执行删除操作
        String   strMsg="";
        String   strObjId="";

        Boolean  canDeleteObject=true;

        // 防止提供非法的id值
        if ( id>0){

            ${className} ${classNameLower}=${classNameLower}Service.find${className}WithObjectById(id);

            if (null!=${classNameLower}){ 
                // 如果${classNameLower}不为空
        <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
            <#if type=="ManyToMany" >
                if (${classNameLower}.get${name?cap_first}().size()>0){
                    //${className}的ManyToMany关联到${param}，${className}.${name}非空，不能执行删除操作

                    strMsg="存在关联${className}_${param}[";

                    Iterator<${param}> it=${classNameLower}.get${name?cap_first}().iterator();
                
                    while(it.hasNext()){
                        ${param} tmpObj1=(${param})it.next();
                        strMsg += "${param?lower_case}_id=" + tmpObj1.getId() + "; ";
                    }

                    strMsg += "]<br/>";

                    strObjId="不能删除${className}[id=" + ${classNameLower}.getId() + "]的记录！";

                    errorMsg = errorMsg + strObjId + strMsg;

                    canDeleteObject=false;
                }
            </#if>
        </#list>

    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
        <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
            <#if type2=="ForeignKey" && param2==className >
                if (${classNameLower}.get${className2}s().size()>0){
                    strMsg="存在关联${className2}[";

                    Iterator<${className2}> it=${classNameLower}.get${className2}s().iterator();

                    while(it.hasNext()){
                        ${className2} tmpObj2=(${className2})it.next();
                        strMsg += " ${className?lower_case}_id=" + tmpObj2.getId() + "; ";
                    }

                    strMsg += "]<br/>";
                    strObjId="不能删除${className}[id=" + ${classNameLower}.getId() + "]的记录！";

                    errorMsg = errorMsg + strObjId + strMsg;

                    canDeleteObject=false;
                }
            </#if>
        </#list>
    </#list>


    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop>
        <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
            <#if type2=="ManyToMany" && param2==className >
                if (${classNameLower}.get${className2}s().size()>0){
                    strMsg="存在关联${className2}_${className}[";

                    Iterator<${className2}> it=${classNameLower}.get${className2}s().iterator();
                
                    while(it.hasNext()){
                        ${className2} tmpObj3=(${className2})it.next();
                        strMsg += "${className2?lower_case}_id=" + tmpObj3.getId() + "; ";
                    }
                
                    strMsg += "]<br/>";
                    strObjId="不能删除${className}[id=" + ${classNameLower}.getId() + "]的记录！";

                    errorMsg = errorMsg + strObjId + strMsg;

                    canDeleteObject=false;
                }
            </#if>
        </#list>
    </#list>

                if (canDeleteObject){
                    //${className}没有关联对象，或者有关联对象但关联数据为空，可以执行删除操作
                    ${classNameLower}Service.delete(id);

                <#if className!="Syslog">
                    if (bWriteSyslog){ //是否记录操作日志，可在application.properties中配置：my.write.syslog=true 或 false
                        //为delete操作记录系统日志
                        Syslog syslog=new Syslog();

                        syslog.setOperation("Delete");
                        syslog.setTableName("${tableName}");
                        syslog.setObjctId(id);
                        syslog.setObjctValue(${classNameLower}.toString());
                        syslog.setOperateBy(request.getUserPrincipal().getName());
                        syslog.setIp(request.getRemoteAddr());
                        syslog.setOperateTime(new Date());

                        syslogService.insert(syslog);
                    }
                </#if>

                    errorMsg="删除记录${className}[id=" + ${classNameLower}.getId() + "]成功！";
                }

            }
            else{
                // 如果${classNameLower}为空
                errorMsg="未找到${className} [id=" + id + "] 的记录！";
            }
        }
        else{
            errorMsg="提供的${className} [id=" + id + "] 非法！";
        }

        return "redirect:/${classNameLower}/list";

    }


<#-- 类 Myuser 的个性化定制 -->
<#if className=="Myuser" && isCasClient!="true">


    //当前登录用户详细信息
    @RequestMapping(value="/myDetail", method=RequestMethod.GET)
    public String MyDetail(Model model, HttpServletRequest request) {
        Myuser user=myuserService.findMyuserByUserName(request.getUserPrincipal().getName());
        Myuser myuser=null;
        if (null!=user){
            myuser=myuserService.findMyuserWithObjectById(user.getId());
        }
        model.addAttribute("myuser", myuser);
        return "Myuser/MyDetails";
    }


    //用户修改自己的密码
    @RequestMapping(value="/changePassword")
    public String ChangePassword(Model model, HttpServletRequest request){

        String username=request.getParameter("username");

        String password;
        String password1=request.getParameter("password1");
        String password2=request.getParameter("password2");

        //System.out.println("username="+username);
        //System.out.println("password1="+password1);
        //System.out.println("password2="+password2);

        if ( (null==username || "".equals(username) )  && (null==password1 || "".equals(password1) ) && (null==password2 || "".equals(password2) ) ){

            model.addAttribute("username", request.getUserPrincipal().getName());

            return "Myuser/ChangePassword";

        }else{

            String  strMessage="";

            if (null==username || "".equals(username) ){
                strMessage="用户名不能为空！";
            }

            if (!( password1.equals(password2) )){
                strMessage="密码不一致！";
            }

            if ( "".equals(strMessage) ){

                username=username.trim();
                password=password1.trim();

                String md5pwd = new Md5PasswordEncoder().encodePassword(password, "");

                Myuser myuser=myuserService.findMyuserByUserName(username);

                myuser.setPassword(md5pwd);

                myuserService.updateMyuser(myuser);

                //为changePWD操作记录系统日志
                Syslog syslog=new Syslog();

                syslog.setOperation("Update");
                syslog.setTableName("Myuser");
                syslog.setObjctId(myuser.getId());
                syslog.setObjctValue( username + "修改自己的密码" );
                syslog.setOperateBy(request.getUserPrincipal().getName());
                syslog.setIp(request.getRemoteAddr());
                syslog.setOperateTime(new Date());

                syslogService.insertSyslog(syslog);

                strMessage="修改密码成功！";
                model.addAttribute("strMessage", strMessage);

                model.addAttribute("username", username);

                return "Myuser/ChangePassword";

            }else{

                model.addAttribute("strMessage", strMessage);
                model.addAttribute("username", username);
                model.addAttribute("password1", password1);
                model.addAttribute("password2", password2);

                return "Myuser/ChangePassword";
            }
        }

    }


    // 管理员对任意用户的密码进行重新设置（密码重置）
    @RequestMapping(value="/resetPassword")
    public String ResetPassword(Model model, HttpServletRequest request){

        String username=request.getParameter("username");

        String password;
        String password1=request.getParameter("password1");
        String password2=request.getParameter("password2");

        //System.out.println("username="+username);
        //System.out.println("password1="+password1);
        //System.out.println("password2="+password2);

        if ( (null==username || "".equals(username) )  && (null==password1 || "".equals(password1) ) && (null==password2 || "".equals(password2) ) ){
            return "Myuser/ResetPassword";
        }else{

            String  strMessage="";

            if (null==username || "".equals(username) ){
                strMessage="用户名不能为空！";
            }

            if (!( password1.equals(password2) )){
                strMessage="密码不一致！";
            }

            if ( "".equals(strMessage) ){

                username=username.trim();
                password=password1.trim();

                String md5pwd = new Md5PasswordEncoder().encodePassword(password, "");

                Myuser myuser=myuserService.findMyuserByUserName(username);

                myuser.setPassword(md5pwd);

                myuserService.updateMyuser(myuser);

                //为changePWD操作记录系统日志
                Syslog syslog=new Syslog();

                syslog.setOperation("Update");
                syslog.setTableName("Myuser");
                syslog.setObjctId(myuser.getId());
                syslog.setObjctValue( username + "修改自己的密码" );
                syslog.setOperateBy(request.getUserPrincipal().getName());
                syslog.setIp(request.getRemoteAddr());
                syslog.setOperateTime(new Date());

                syslogService.insertSyslog(syslog);

                strMessage="修改密码成功！";
                model.addAttribute("strMessage", strMessage);

                model.addAttribute("username", username);

                return "Myuser/ResetPassword";

            }else{

                model.addAttribute("strMessage", strMessage);
                model.addAttribute("username", username);
                model.addAttribute("password1", password1);
                model.addAttribute("password2", password2);

                return "Myuser/ResetPassword";
            }
        }

    }


<#if hasRegister=="true"><#-- 是否提供注册功能 -->
    @RequestMapping("/register")
    public String register(Model model, HttpServletRequest request) {

        save=request.getParameter("save");
        //System.out.println("save="+save);

        if ("Yes".equals(save)){ //提交保存

            String password;
            String username=request.getParameter("username");
            String password1=request.getParameter("password1");
            String password2=request.getParameter("password2");
            String agreement=request.getParameter("agreement");

            //System.out.println("username,password,password2 = " + username + "," + password + "," + password2);
            //System.out.println("agreement = " + agreement);

            if ( (null==username || "".equals(username) )  && (null==password1 || "".equals(password1) ) && (null==password2 || "".equals(password2) ) ){

                return "Myuser/Register";

            }else{

                String  strMessage="";

                if (null==agreement || "".equals(agreement) ){
                    strMessage="必须同意注册协议条款才能注册！";
                }

                if (null==username || "".equals(username) ){
                    strMessage="用户名不能为空！";
                }

                if (!( password1.equals(password2) )){
                    strMessage="密码不一致！";
                }

                if (null!=myuserService.findMyuserByUserName(username)){
                    strMessage="该用户名已经注册，请更换一个！";
                }

                if ( "".equals(strMessage) ){

                    username=username.trim();
                    password=password1.trim();

                    String md5pwd = new Md5PasswordEncoder().encodePassword(password, "");
                    //System.out.println("md5pwd = " + md5pwd);

                    Myuser myuser=new Myuser();
                    Role role=new Role();

                    myuser.setUsername(username);
                    myuser.setPassword(md5pwd);
                    myuser.setEnabled(true);
                    myuser.setCreatedtime(new Date());

                    myuser.setDeptId(1L);

                    role.setId(2L);

                    myuserService.insertMyuser(myuser);
                    myuserService.insertMyuserRole(myuser, role);

                    UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(username, md5pwd);
                    //System.out.println("token = " + token);

                    try{
                        token.setDetails(new WebAuthenticationDetails(request));
                        Authentication authenticatedUser = authenticationManager.authenticate(token);

                        SecurityContextHolder.getContext().setAuthentication(authenticatedUser);

                        request.getSession().setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, SecurityContextHolder.getContext());
                    }
                    catch( AuthenticationException e ){
                        strMessage="Authentication failed: " + e.getMessage();

                        model.addAttribute("errorMsg", strMessage);

                        return "Myuser/Register";
                    }

                    //为register操作记录系统日志
                    Syslog syslog=new Syslog();

                    syslog.setOperation("Insert");
                    syslog.setTableName("Myuser");
                    syslog.setObjctId(myuser.getId());
                    syslog.setObjctValue(myuser.toString());
                    syslog.setOperateBy("Register");
                    syslog.setIp(request.getRemoteAddr());
                    syslog.setOperateTime(new Date());

                    syslogService.insertSyslog(syslog);

                    return "redirect:/";

                }else{

                    model.addAttribute("errorMsg", strMessage);
                    model.addAttribute("username", username);
                    model.addAttribute("password1", password1);
                    model.addAttribute("password2", password2);

                    return "Myuser/Register";
                }
            }

        }
        else{
            return "Myuser/Register";
        }

    }
</#if>

</#if>


<#if isExcelExport=="true"><#--是否增加Excel导出功能-->
<#-- 处理Excel导出 -->

    @RequestMapping(value="/excelExport")
    public String excelExport(${className} ${classNameLower}, HttpServletRequest request, HttpServletResponse response, Model model)  throws Exception {

        String  filename = "${className}Data"+DateUtils.getDate("yyyyMMddHHmmss")+".xls";
        File    myfile   = new File(filename);

        //1.创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();

        //2.在建立的工作簿中添加一个sheet，对应Excel文件中的工作簿，并设置工作簿名称
        HSSFSheet sheet = wb.createSheet("测试Sheet页");


        //处理测试数据：保存到sheet1页

        //3.第2-3行第2-4列合并
        CellRangeAddress region1 = new CellRangeAddress(1, 2, (short)1, (short)3);  //CellRangeAddress(fromRow, toRow, fromCol, toCol)
        HSSFRow row1 = sheet.createRow(1); //实际是第2行
        row1.createCell(1).setCellValue("第2-3行第2-4列合并");

        //4.把合并区域添加到工作簿中
        sheet.addMergedRegion(region1);

        //5.设置合并单元格的边框样式，用RegionUtil这个工具类

        //5.1设置合并单元格的边框
        RegionUtil.setBorderBottom(BorderStyle.THIN, region1, sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN, region1, sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN, region1, sheet);
        RegionUtil.setBorderTop(BorderStyle.THIN, region1, sheet);

        //5.2设置合并单元格边框的颜色
        RegionUtil.setBottomBorderColor(12, region1, sheet);
        RegionUtil.setLeftBorderColor(12, region1, sheet);
        RegionUtil.setRightBorderColor(12, region1, sheet);
        RegionUtil.setTopBorderColor(12, region1, sheet);

        //6.创建单元格（单个cell）样式
        HSSFCellStyle cellStyle = wb.createCellStyle();

        Font fontStyle = wb.createFont();  //创建字体样式对象
        fontStyle.setBold(true);  //字体加粗
        fontStyle.setFontHeightInPoints((short) 12);  //字体大小

        //6.1 将字体样式添加到单元格样式中
        cellStyle.setFont(fontStyle);

        //6.2 单元格样式-->水平居中
        cellStyle.setAlignment(HorizontalAlignment.CENTER);

        //6.3 单元格样式-->垂直居中
        cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);

        //6.4 单元格边框样式
        cellStyle.setBorderBottom(BorderStyle.THIN);
        cellStyle.setBorderLeft(BorderStyle.THIN);
        cellStyle.setBorderRight(BorderStyle.THIN);
        cellStyle.setBorderTop(BorderStyle.THIN);

        //6.4 单元格边框的颜色
        cellStyle.setLeftBorderColor((short)12);
        cellStyle.setBottomBorderColor((short)12);
        cellStyle.setRightBorderColor((short)12);
        cellStyle.setTopBorderColor((short)12);

        //7.为指定的单元格cell设置样式
        CellUtil.getCell(row1,1).setCellStyle(cellStyle);


        //第2-4行第6-10列合并
        CellRangeAddress region2 = new CellRangeAddress(1, 3, (short)5, (short)9);
        sheet.addMergedRegion(region2);
        row1.createCell(5).setCellValue("第2-4行第6-10列合并");

        RegionUtil.setBorderBottom(BorderStyle.DASHED,region2,sheet);
        RegionUtil.setBorderLeft(BorderStyle.DASHED,region2,sheet);
        RegionUtil.setBorderRight(BorderStyle.DASHED,region2,sheet);
        RegionUtil.setBorderTop(BorderStyle.DASHED,region2,sheet);

        RegionUtil.setBottomBorderColor(50,region2,sheet);
        RegionUtil.setLeftBorderColor(50,region2,sheet);
        RegionUtil.setRightBorderColor(50,region2,sheet);
        RegionUtil.setTopBorderColor(50,region2,sheet);

        HSSFCellStyle cellStyle1 = wb.createCellStyle();

        Font fontStyle1 = wb.createFont();
        fontStyle1.setBold(true);
        fontStyle1.setFontHeightInPoints((short) 12);

        // 将字体样式添加到单元格样式中
        cellStyle1.setFont(fontStyle1);

        // 单元格样式-->水平居中
        cellStyle1.setAlignment(HorizontalAlignment.CENTER);

        // 单元格样式-->垂直居中
        cellStyle1.setVerticalAlignment(VerticalAlignment.CENTER);

        //单元格样式边框
        cellStyle1.setBorderBottom(BorderStyle.DASHED);
        cellStyle1.setBorderLeft(BorderStyle.DASHED);
        cellStyle1.setBorderRight(BorderStyle.DASHED);
        cellStyle1.setBorderTop(BorderStyle.DASHED);

        //单元格样式边框颜色
        cellStyle1.setLeftBorderColor((short)50);
        cellStyle1.setBottomBorderColor((short)50);
        cellStyle1.setRightBorderColor((short)50);
        cellStyle1.setTopBorderColor((short)50);

        //得到坐标（1,5）【Excel中（2,6）】这个单元格cell对象，设置样式
        //注意：这儿两个合并区域的单元起始在同一行，都是第2行开始，故不能再创建Row 这个对象，否则前一个单元区域的值会失效。
        CellUtil.getCell(row1,5).setCellStyle(cellStyle1);

        //第6-9行2-4列合并
        CellRangeAddress region3 = new CellRangeAddress(5, 8, (short) 1, (short) 3);
        sheet.addMergedRegion(region3);
        HSSFRow row2 = sheet.createRow(5);
        row2.createCell(1).setCellValue("第6-9行2-4列合并");

        RegionUtil.setBorderBottom(BorderStyle.THIN,region3,sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN,region3,sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN,region3,sheet);
        RegionUtil.setBorderTop(BorderStyle.THIN,region3,sheet);

        RegionUtil.setBottomBorderColor(12,region3,sheet);
        RegionUtil.setLeftBorderColor(12,region3,sheet);
        RegionUtil.setRightBorderColor(12,region3,sheet);
        RegionUtil.setTopBorderColor(12,region3,sheet);

        //单个单元格的样式我不想再写，可以服用第一次创建的单元格样式cellStyle,，可抽取成工具类
        //注意：该合并的单元区设置的边框样式必须和第一次设置单元格的样式保持一致
        CellUtil.getCell(row2,1).setCellStyle(cellStyle);


        //第7-12行7-9列合并
        CellRangeAddress region4 = new CellRangeAddress(6, 11, (short) 6, (short) 8);
        sheet.addMergedRegion(region4);
        HSSFRow row3 = sheet.createRow(6);
        row3.createCell(6).setCellValue("第7-12行7-9列合并");

        RegionUtil.setBorderBottom(BorderStyle.THIN,region4,sheet);
        RegionUtil.setBorderLeft(BorderStyle.THIN,region4,sheet);
        RegionUtil.setBorderRight(BorderStyle.THIN,region4,sheet);
        RegionUtil.setBorderTop(BorderStyle.THIN,region4,sheet);

        RegionUtil.setBottomBorderColor(12,region4,sheet);
        RegionUtil.setLeftBorderColor(12,region4,sheet);
        RegionUtil.setRightBorderColor(12,region4,sheet);
        RegionUtil.setTopBorderColor(12,region4,sheet);

        //第三个  第四个合并的单元区域起始行不在同一列，所以必须创建新的Row
        CellUtil.getCell(row3,6).setCellStyle(cellStyle);

        //第一步 ：暂时注释一下两行代码，我们看看效果
        //第二步：放开下面两行代码，再看看效果
        //造成原因：第四个区域单元格合并造，设置的样式是（7,7）这个坐标的单元格样式。这就造成第三个合并单元格7的行样式失效
        //为了解决这个问题，还要单独的为这两个（7,2）与（7,4）单元格设置和第三个合并单元区域相同的样式

        CellUtil.getCell(row3,1).setCellStyle(cellStyle);
        CellUtil.getCell(row3,3).setCellStyle(cellStyle);


        //如果需要多个Sheet页，则继续创建即可
        HSSFSheet sheet2 = wb.createSheet("导出的${className}数据页");

        //处理业务数据：保存到sheet2页
        List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}WithObject();

        int currRow=0;
        HSSFRow row;
        row = sheet2.createRow(currRow++);

<#assign i=0>
<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign tablehead=prop.@colComment?trim>
    <#if type!="ManyToMany">
        row.createCell(${i}).setCellValue("${tablehead}");
        <#if name=="id">
        sheet2.setColumnWidth(${i}, 256*8);
        <#else>
        sheet2.setColumnWidth(${i}, 256*30);
        </#if>

        <#assign i=i+1>
    </#if>
</#list>

        Iterator it=${classNameLower}List.iterator();
        while(it.hasNext()){

            ${className} Objct=(${className})it.next();

            row = sheet2.createRow(currRow++);

<#assign i=0>
<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim>
    <#if type!="ManyToMany">
        <#if type=="Sysdict">
            row.createCell(${i}).setCellValue( Objct.get${name?cap_first}()==null?null:Objct.get${name?cap_first}().getName() );
        <#elseif type=="ForeignKey">
            <#assign strName="id">
            <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign classProp2=table2.prop >
                <#if className2==param><#assign size=classProp2?size>
                    <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                        <#if type2=="String" && size gte 1>
                            <#assign strName=name2><#assign size=0> <#-- 找出第一个String类型的属性名，用于界面显示（用该strName代表该对象） -->
                        </#if>
                        <#assign size=size-1>
                    </#list>
                </#if>
            </#list>
            row.createCell(${i}).setCellValue( Objct.get${name?cap_first}()==null?null:Objct.get${name?cap_first}().get${strName?cap_first}() );
        <#elseif  dbType=="Date">
            row.createCell(${i}).setCellValue( Objct.get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd")).format(  Objct.get${name?cap_first}() ) );
        <#elseif  dbType=="DateTime" || dbType=="Timestamp">
            row.createCell(${i}).setCellValue( Objct.get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(  Objct.get${name?cap_first}() ) );
        <#else>
            row.createCell(${i}).setCellValue( Objct.get${name?cap_first}() );
        </#if>
        <#assign i=i+1>
    </#if>
</#list>
        }

        FileOutputStream out = new FileOutputStream(myfile);
        try {
            wb.write(out);
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=utf-8");

        try {
            long fileLength = myfile.length();
            response.setContentType("application/msexcel");
            response.setHeader("Content-disposition", "attachment; filename=" + filename);
            response.setHeader("Content-Length", String.valueOf(fileLength));
            bis = new BufferedInputStream(new FileInputStream(myfile));
            bos = new BufferedOutputStream(response.getOutputStream());
            byte[] buff = new byte[2048];
            int bytesRead;
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (bis != null)
                bis.close();
            if (bos != null)
                bos.close();
        }

        return null;

    }

</#if>

<#if isWordExport=="true"><#--是否增加Word导出功能-->
<#-- 处理Word导出 -->

    public static CTTcPr getCellCTTcPr(XWPFTableCell cell) {
        CTTc cttc = cell.getCTTc();
        CTTcPr tcPr = cttc.isSetTcPr() ? cttc.getTcPr() : cttc.addNewTcPr();
        return tcPr;
    }

    //Word横向合并单元格
    public static void mergeCellsHorizontal(XWPFTable table, int row, int fromCol, int toCol){
        for (int colIndex = fromCol; colIndex <= toCol; colIndex++) {
            XWPFTableCell cell = table.getRow(row).getCell(colIndex);
            if (colIndex == fromCol) {
                getCellCTTcPr(cell).addNewHMerge().setVal(STMerge.RESTART);
            }else{
                getCellCTTcPr(cell).addNewHMerge().setVal(STMerge.CONTINUE);
            }
        }
    }

    //Word纵向合并单元格
    public static void mergeCellsVertically(XWPFTable table, int col, int fromRow, int toRow) {
        for (int rowIndex = fromRow; rowIndex <= toRow; rowIndex++) {
            XWPFTableCell cell = table.getRow(rowIndex).getCell(col);
            if (rowIndex == fromRow) {
                getCellCTTcPr(cell).addNewVMerge().setVal(STMerge.RESTART);
            }else{
                getCellCTTcPr(cell).addNewVMerge().setVal(STMerge.CONTINUE);
            }
        }
    }

    //Word设置列宽和垂直对齐方式 
    public void setCellWidthAndVAlign(XWPFTableCell cell, String width, STVerticalJc.Enum typeEnum, STJc.Enum vAlign) {
        CTTc cttc = cell.getCTTc();
        CTTcPr cellPr = getCellCTTcPr(cell);
        cellPr.addNewVAlign().setVal(typeEnum);
        cttc.getPList().get(0).addNewPPr().addNewJc().setVal(vAlign);
        CTTblWidth tblWidth = cellPr.isSetTcW() ? cellPr.getTcW() : cellPr.addNewTcW();
        if(!StringUtils.isEmpty(width)){
            tblWidth.setW(new BigInteger(width));
            tblWidth.setType(STTblWidth.DXA);
        }
    }


    @RequestMapping(value="/wordExport1")
    public String wordExport1(${className} ${classNameLower}, HttpServletRequest request, HttpServletResponse response) throws Exception {

        String  filename = "${className}Data"+DateUtils.getDate("yyyyMMddHHmmss")+".doc";
        File    myfile = new File(filename);

        //Blank Document
        XWPFDocument document= new XWPFDocument();

        CTSectPr sectPr = document.getDocument().getBody().addNewSectPr();
        CTPageSz pgSz = sectPr.addNewPgSz();

        //通过pgSz设置宽度/高度 和纸张方向
        //设置横板
        pgSz.setW(BigInteger.valueOf(15840));
        pgSz.setH(BigInteger.valueOf(11907));
        //pgSz.setW(BigInteger.valueOf(24000));
        //pgSz.setH(BigInteger.valueOf(12000));
        pgSz.setOrient(STPageOrientation.LANDSCAPE);

        //设置竖版
        //pgSz.setH(BigInteger.valueOf(15840));
        //pgSz.setW(BigInteger.valueOf(11907));
        //pgSz.setOrient(STPageOrientation.PORTRAIT);


        //新建一个段落
        XWPFParagraph paragraph = document.createParagraph();

        //设置段落的对齐方式
        paragraph.setAlignment(ParagraphAlignment.CENTER);

        //设置下边框
        paragraph.setBorderBottom(Borders.DOUBLE);   // Borders取值: DOUBLE | BASIC_BLACK_DASHES | 

        //设置左边框
        paragraph.setBorderLeft(Borders.DOUBLE);

        //设置右边框
        paragraph.setBorderRight(Borders.DOUBLE);

        //设置上边框
        paragraph.setBorderTop(Borders.DOUBLE);

        //创建段落文本
        XWPFRun run=paragraph.createRun();

        run.setText("这是自动插入的文字！");
        run.setBold(true);
        run.setFontFamily("仿宋");
        run.setFontSize(13);
        run.setColor("FF0000");

        document.createParagraph();
        document.createParagraph();

        XWPFTable table;

        //固定Word表格
        table = document.createTable(7, 10); //createTable(row, col)
        table.setCellMargins(100, 200, 100, 200);  //setCellMargins(top, left, bottom, right)

        mergeCellsHorizontal(table, 0, 1, 4);  //合并第0行第1-4列
        mergeCellsHorizontal(table, 3, 2, 8);  //合并第3行第2-8列

        mergeCellsVertically(table, 5, 1, 2);  //合并第5列第1-2行

        for (int row=0; row<7; row++) {
            for (int col=0; col<10; col++) {
                table.getRow(row).getTableCells().get(col).setText( "(" + row + ", " + col + ")" );
            }
        }

        document.createParagraph();
        document.createParagraph();

        //动态Word表格
        table = document.createTable();
        table.setCellMargins(100, 200, 100, 200);

        List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}WithObject();

        //表格第0行
        XWPFTableCell cell;
<#assign i=0>
<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign tablehead=prop.@colComment?trim>
  <#if type!="ManyToMany">
      <#if i==0>
        cell = table.getRow(0).getCell(0);
        cell.setText("${tablehead}");  //列0
        setCellWidthAndVAlign(cell, "1024", STVerticalJc.CENTER, STJc.CENTER);

      <#else>
        cell = table.getRow(0).addNewTableCell();
        cell.setText("${tablehead}");  //列${i}
        setCellWidthAndVAlign(cell, "2048", STVerticalJc.CENTER, STJc.CENTER);

      </#if>
      <#assign i=i+1>
  </#if>
</#list>

        Iterator it=${classNameLower}List.iterator();

        while(it.hasNext()){

            XWPFTableRow tableRow = table.createRow();

            ${className} Objct=(${className})it.next();

<#assign i=0>
<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim>
    <#if type!="ManyToMany">
            cell = tableRow.getCell(${i});
        <#if type=="Sysdict">
            cell.setText(Objct.get${name?cap_first}()==null?null:Objct.get${name?cap_first}().getName());
        <#elseif type=="ForeignKey">
            <#assign strName="id">
            <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign classProp2=table2.prop >
                <#if className2==param><#assign size=classProp2?size>
                    <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                        <#if type2=="String" && size gte 1>
                            <#assign strName=name2><#assign size=0> <#-- 找出第一个String类型的属性名，用于界面显示（用该strName代表该对象） -->
                        </#if>
                        <#assign size=size-1>
                    </#list>
                </#if>
            </#list>
            cell.setText(Objct.get${name?cap_first}()==null?null:Objct.get${name?cap_first}().get${strName?cap_first}());
        <#elseif  dbType=="Date">
            cell.setText(Objct.get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd")).format(  Objct.get${name?cap_first}() ));
        <#elseif  dbType=="DateTime" || dbType=="Timestamp">
            cell.setText(Objct.get${name?cap_first}()==null?null:(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(  Objct.get${name?cap_first}() ));
        <#elseif  type=="String">
            cell.setText(Objct.get${name?cap_first}());
        <#else>
            cell.setText(Objct.get${name?cap_first}()==null?null:Objct.get${name?cap_first}().toString());
        </#if>
            setCellWidthAndVAlign(cell, "", STVerticalJc.CENTER, STJc.CENTER);

        <#assign i=i+1>
    </#if>
</#list>

        }

        FileOutputStream out = new FileOutputStream(myfile);

        try {
            document.write(out);
            out.close();
        }
        catch (Exception e){
            e.printStackTrace();
        }

        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");

        BufferedInputStream bis = null;
        BufferedOutputStream bos = null;

        try {
            long fileLength = myfile.length();
            response.setContentType("application/msword");
            response.setHeader("Content-disposition", "attachment; filename=" + filename);
            response.setHeader("Content-Length", String.valueOf(fileLength));
            bis = new BufferedInputStream(new FileInputStream(myfile));
            bos = new BufferedOutputStream(response.getOutputStream());
            byte[] buff = new byte[2048];
            int bytesRead;
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (bis != null)
                bis.close();
            if (bos != null)
                bos.close();
        }

        return null;

    }



    @RequestMapping(value="/wordExport2")
    public String wordExport2(HttpServletRequest request, HttpServletResponse response) throws IOException{
         
        Map<String,Object> dataMap = new HashMap<String, Object>();

        dataMap.put("title", "${className}标题");

        Date date = new Date();
        SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        String dt=dateFormat.format(date);
        dataMap.put("createdtime",dt);

        List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}WithObject();

        // 数据列表objList
        dataMap.put("objList", ${classNameLower}List);


        Configuration config = new Configuration();
        config.setDefaultEncoding("utf-8");

        //模板位置：resources/word_tpl/*.xml
        config.setClassForTemplateLoading(this.getClass(), "/word_tpl");

        Template tpl = null;

        String  filename = "${className}Data"+DateUtils.getDate("yyyyMMddHHmmss")+".doc";
        File  myfile = new File(filename);

        try {
            // 获取Word模板
            tpl = config.getTemplate("word_tpl_xxx.xml");
            tpl.setEncoding("UTF-8");

            Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(myfile),"UTF-8"));

            tpl.process(dataMap, out);
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (TemplateException e) {
            e.printStackTrace();
        }

        response.setContentType("text/html;charset=utf-8");
        request.setCharacterEncoding("UTF-8");
        java.io.BufferedInputStream bis = null;
        java.io.BufferedOutputStream bos = null;

        try {
            long fileLength = myfile.length();
            response.setContentType("application/msword");
            response.setHeader("Content-disposition", "attachment; filename=" + filename);
            response.setHeader("Content-Length", String.valueOf(fileLength));
            bis = new BufferedInputStream(new FileInputStream(myfile));
            bos = new BufferedOutputStream(response.getOutputStream());
            byte[] buff = new byte[2048];
            int bytesRead;
            while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
                bos.write(buff, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (bis != null)
                bis.close();
            if (bos != null)
                bos.close();
        }
        return null;
    }

</#if>



<#-- Tree个性化定制-->
<#if className=="Area" || className=="Department">

    //处理RESTful API的 POST 请求: 请求端以JSON格式提交数据，接收JSON格式数据后在数据库中新增一条${className}对象数据（POST: 新增）
    @RequestMapping(value={"/json"}, method=RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> jsonInsertOne(@RequestBody ${className} ${classNameLower}){

        if( ${classNameLower}Service.insert(${classNameLower}) > 0 ){
            return new ResponseEntity<String>(HttpStatus.CREATED);
        }
        else{
            return new ResponseEntity<String>(HttpStatus.EXPECTATION_FAILED);
        }

    }

    @RequestMapping(value="/tree")
    public String getTree(Model model){

        List<${className}> ${classNameLower}List=${classNameLower}Service.findAll${className}();

        TreeNode treeNode=null;
        List<TreeNode> treeNodeList=new ArrayList<TreeNode>();

        int count=${classNameLower}List.size();

        String target="treeWin";
        String url="/${classNameLower}/detail?id=";

        Iterator it=${classNameLower}List.iterator();

        while(it.hasNext()){
            ${className} tmpObj=(${className})it.next();
            long lcode=Long.parseLong(tmpObj.getCode());
            if (lcode==1){
                count--;
            }else{
                if (count>1){
                    if (lcode<1000){
                        treeNode=new TreeNode(lcode, lcode/1000, tmpObj.getName(), url+tmpObj.getId(), target, true);
                    }else{
                        treeNode=new TreeNode(lcode, lcode/1000, tmpObj.getName(), url+tmpObj.getId(), target, false);
                    }
                }
                else{
                    treeNode=new TreeNode(lcode, lcode/1000, tmpObj.getName(), url+tmpObj.getId(), target, false);
                }

                treeNodeList.add(treeNode);
                count--;
            }
        }

        model.addAttribute("treeData", treeNodeList);

        return "${className}/${className}Tree";
    }

</#if>


<#-- 类Uploadfile的个性化定制 -->
<#if className=="Uploadfile">

    //处理文件上传
    @RequestMapping(value="/upload", method = RequestMethod.POST)
    public String UploadFile(@RequestParam("file")MultipartFile file, HttpServletRequest request){

        String contentType = file.getContentType();
        String fileName = file.getOriginalFilename();

        String userName = request.getUserPrincipal().getName();

        Long   fileSize = file.getSize();

        //System.out.println("fileName = " + fileName);
        //System.out.println("contentType = " + contentType);

        Date date=new Date();
        SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");

        String filePath = "/uploadfiles/" + df.format(date) + "/" + userName + "/";

        String fileFullPath = fileUploadPathRoot + filePath;

        System.out.println("fileUploadPath = " + fileFullPath);

        try{

            File targetFile = new File(fileFullPath);

            if(!targetFile.exists()){
                targetFile.mkdirs();
            }

            FileOutputStream out = new FileOutputStream(fileFullPath+fileName);

            out.write( file.getBytes() );
            out.flush();
            out.close();

            errorMsg="上传文件 [" + fileName + "] 成功！";

        }catch (Exception e){
            errorMsg="上传失败！原因：" + e.getMessage();
        }

        <#-- insert操作Uploadfile表 -->
        Uploadfile uploadfile=new Uploadfile();

        uploadfile.setFilename(fileName);
        uploadfile.setPath(filePath);
        uploadfile.setFilesize(fileSize);
        uploadfile.setUploadtime(new Date());
        uploadfile.setUsername(userName);
        uploadfile.setDownloadsum(0);

        if ((uploadfileService.insert(uploadfile))>0){

            Syslog syslog=new Syslog();

            //为Insert操作记录系统日志
            syslog.setOperation("Insert");
            syslog.setTableName("Uploadfile");
            syslog.setObjctId(uploadfile.getId());
            syslog.setOperateBy(userName);
            syslog.setIp(request.getRemoteAddr());
            syslog.setOperateTime(new Date());

            syslog.setObjctValue(uploadfile.toString());
            syslogService.insert(syslog);
        }

        return "redirect:/${classNameLower}/list";
    }
</#if>



<#-- 类XXX的个性化定制 -->
<#if className=="XXX">

</#if>

}

</#list>


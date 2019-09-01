<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name="../"+className+"/"+className+"Detail.html" />
<#assign classProp=table.prop>
<#---->
<#---->
<#if noCopyright!="true">
<#include "/include/copyright-xml.ftl">
</#if>
<!DOCTYPE html>
<HTML xmlns="http://www.w3.org/1999/xhtml"
      xmlns:th="http://www.thymeleaf.org"
      xmlns:sec="http://www.thymeleaf.org/thymeleaf-extras-springsecurity4">
<HEAD>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<TITLE>${className}Detail</TITLE>
<div th:include="fragment/header :: jscss"></div>
</HEAD>

<BODY>

<DIV class="navbar navbar-default" id="navbar" th:include="fragment/topNavbar :: top">
</DIV><!-- /.navbar -->

<DIV class="main-container" id="main-container">

    <script type="text/javascript">
        try{ace.settings.check('main-container' , 'fixed')}catch(e){}
    </script>

    <DIV class="main-container-inner">

        <a class="menu-toggler" id="menu-toggler" href="#">
            <span class="menu-text"></span>
        </a>

        <DIV class="sidebar" id="sidebar">

            <script type="text/javascript">
                try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
            </script>

            <div class="sidebar-shortcuts" id="sidebar-shortcuts">
                <div class="sidebar-shortcuts-large" id="sidebar-shortcuts-large">
                    <button class="btn btn-success"><i class="icon-signal"></i></button>
                    <button class="btn btn-info"><i class="icon-pencil"></i></button>
                    <button class="btn btn-warning"><i class="icon-group"></i></button>
                    <button class="btn btn-danger"><i class="icon-cogs"></i></button>
                </div>

                <div class="sidebar-shortcuts-mini" id="sidebar-shortcuts-mini">
                    <span class="btn btn-success"></span>
                    <span class="btn btn-info"></span>
                    <span class="btn btn-warning"></span>
                    <span class="btn btn-danger"></span>
                </div>
            </div><!-- #sidebar-shortcuts -->

            <ul class="nav nav-list">

                <li>
                    <a th:href="@{/}"><i class="icon-home green"></i><span class="menu-text"> 首页 </span></a>
                </li>

            <#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Syslog" && className!="Department" && className!="Area" && className!="Uploadfile">
                <li class="active open">
            <#else>
                <li>
            </#if>
                    <a href="#" class="dropdown-toggle"><i class="icon-list"></i><span class="menu-text"> 业务对象管理 </span><b class="arrow icon-angle-down"></b></a>
                    <ul class="submenu">
            <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign classNameLower2=className2?lower_case >
                <#if className2!="Myuser" && className2!="Role" && className2!="Permission" && className2!="Syslog" && className2!="Sysdict" && className2!="Department" && className2!="Area" && className2!="Uploadfile">
                    <#if className2==className>
                        <li  class="active">
                    <#else>
                        <li>
                    </#if>
                            <a th:href="@{/${classNameLower2}/list}">
                                <i class="icon-double-angle-right"></i><i class="icon-list blue"></i> ${className2}列表
                            </a>
                        </li>
                </#if>
            </#list>
                    </ul>
                </li>

    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign classNameLower2=className2?lower_case >
        <#if className2=="Myuser" || className2=="Role" || className2=="Permission" || className2=="Syslog" || className2=="Sysdict" || className2=="Department" || className2=="Area">
            <#if className2==className>
                <li sec:authorize="hasAnyRole('ROLE_Admin','ROLE_ObjAdmin','ROLE_${className2}Admin')"  class="active">
            <#else>
                <li sec:authorize="hasAnyRole('ROLE_Admin','ROLE_ObjAdmin','ROLE_${className2}Admin')">
            </#if>
                    <a th:href="@{/${classNameLower2}/list}">
                        <i class="icon-book blue"></i><span class="menu-text">${className2}管理</span>
                    </a>
                </li>
        </#if>
    </#list>
            <#if dataBaseName!="h2">
                <li sec:authorize="hasRole('ROLE_Admin')">
                    <a th:href="@{/druid}" target="WinDruid">
                        <i class="icon-bar-chart blue"></i><span class="menu-text">数据库监控</span>
                    </a>
                </li>
            </#if>
            <#if isCasClient!="true" >
                <li>
                    <a th:href="@{/myuser/changePassword}">
                        <i class="icon-key blue"></i><span class="menu-text">修改密码</span>
                    </a>
                </li>
                <li sec:authorize="hasRole('ROLE_Admin')">
                    <a th:href="@{/myuser/resetPassword}">
                        <i class="icon-unlock blue"></i><span class="menu-text">重置密码</span>
                    </a>
                </li>
            </#if>
            <#if className=="Uploadfile">
                <li class="active">
            <#else>
                <li>
            </#if>
                    <a th:href="@{/uploadfile/list}" target="WinUpload">
                        <i class="icon-upload blue"></i><span class="menu-text">文件上传</span>
                    </a>
                </li>
                <li>
                    <a th:href="@{/logout}">
                        <i class="icon-off red"></i><span class="menu-text">退出</span>
                    </a>
                </li>

            </ul><!-- /.nav-list -->

            <div class="sidebar-collapse" id="sidebar-collapse">
                <i class="icon-double-angle-left red" data-icon1="icon-double-angle-left red" data-icon2="icon-double-angle-right red"></i>
            </div>

            <script type="text/javascript">
                try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
            </script>

        </DIV>


        <div class="main-content">

            <div class="breadcrumbs" id="breadcrumbs">
                <script type="text/javascript">
                    try{ace.settings.check('breadcrumbs' , 'fixed')}catch(e){}
                </script>

                <ul class="breadcrumb">
                    <li>
                        <i class="icon-home home-icon green"></i>
                        <a href="/">首页</a>
                    </li>
                    <li>${className}</li>
                </ul><!-- .breadcrumb -->

                <div class="nav-search" id="nav-search">
                    <form class="form-search">
                        <span class="input-icon">
                            <input type="text" placeholder="Search ..." class="nav-search-input" id="nav-search-input" autocomplete="off" />
                            <i class="icon-search nav-search-icon"></i>
                        </span>
                    </form>
                </div><!-- #nav-search -->
            </div>

            <div class="page-content">
                <div class="row">
                    <div class="col-xs-12">
                    <!-- PAGE CONTENT BEGINS -->

                        <UL id="myTab" class="nav nav-tabs">
                            <li>
                                <a th:href="@{/${classNameLower}/list}"><i class="icon-list green"></i> ${className}列表</a>
                            </li>
                            <li class="active">
                                <a href="#tab_id01"  data-toggle="tab"><i class="icon-edit blue"></i>详细信息</a>
                            </li>
                        </UL>

                        <DIV id="myTabContent" class="tab-content">

                            <DIV id="tab_id01" class="tab-pane fade in active">

                                <DIV class="row">


                                    <div class="col-md-1"></div>

                                    <div class="col-md-10" style="border:1px dashed #f0f0f0">


                                        <BR/>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <TD align="center" colspan="2">
                                                    【<font color="red"><b>当前对象是：${className}</b></font>】
                                                </TD>
                                            </TR>
                                        <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign tablehead=prop.@colComment?trim>
                                          <#if type!="ManyToMany" && type!="ForeignKey" && type!="Sysdict">
                                            <TR>
                                                <TD align="right">${tablehead}:</TD>
                                            <#if  dbType=="Date">
                                                <TD th:text="${dollar}{${classNameLower}.${name}}?${dollar}{#dates.format(${classNameLower}.${name}, 'yyyy-MM-dd')}:null">${classNameLower}.${name}</TD>
                                            <#elseif  dbType=="DateTime" || dbType=="Timestamp">
                                                <TD th:text="${dollar}{${classNameLower}.${name}}?${dollar}{#dates.format(${classNameLower}.${name}, 'yyyy-MM-dd HH:mm:ss')}:null">${classNameLower}.${name}</TD>
                                            <#elseif className=="Syslog" && name=="objctValue">
                                                <TD th:utext="${dollar}{${classNameLower}.${name}}">${classNameLower}.${name}</TD>
                                            <#elseif className=="Myuser" && name=="password">
                                                <TD>******</TD>
                                            <#elseif type=="Boolean">
                                                <#if name=="enabled">
                                                <TD th:text="${dollar}{${classNameLower}.${name}} ? 启用 : 禁用">${classNameLower}.${name}</TD>
                                                <#else>
                                                <TD th:text="${dollar}{${classNameLower}.${name}} ? 是 : 否">${classNameLower}.${name}</TD>
                                                </#if>
                                            <#else>
                                                <TD th:text="${dollar}{${classNameLower}.${name}}">${classNameLower}.${name}</TD>
                                            </#if>
                                            </TR>
                                          </#if>
                                          <#if type=="Sysdict">
                                            <TR>
                                                <TD align="right">${tablehead}:</TD>
                                                <TD th:text="${dollar}{${classNameLower}?.${name}?.name}">${classNameLower}.${name}.name</TD>
                                            </TR>
                                          </#if>
                                          <#if type=="ForeignKey" >
                                            <#assign strName="id">
                                            <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign classProp2=table2.prop >
                                                <#if className2==param><#assign size=classProp2?size>
                                                    <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                                                        <#if type2=="String" && size gte 1>
                                                            <#assign strName=name2><#assign size=0>
                                                        </#if>
                                                        <#assign size=size-1>
                                                    </#list>
                                                </#if>
                                            </#list>
                                            <TR>
                                                <TD align="right">${tablehead}:</TD>
                                                <TD th:text="${dollar}{${classNameLower}?.${name}?.${strName}}">${classNameLower}.${name}.${strName}</TD>
                                            </TR>
                                          </#if>
                                        </#list>

                                        </TABLE>

                        <#list classProp as prop><#assign name=prop.@name?trim?lower_case><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
                            <#if type=="ForeignKey">
                                <#list doc.root.table as table2><#assign objctName2=table2.@objctName?trim>
                                    <#if param==objctName2 && objctName2!=className>
                                        <BR/><BR/>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <TD>【<font color="red">${className}.${name}</font>】通过ForeignKey主动引用了[<font color="blue">${objctName2}</font>]，<font color="red">${className}.${name}</font> 对象信息如下：</TD>
                                            </TR>
                                        </TABLE>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <#list table2.prop as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim><#assign tablehead2=prop2.@colComment?trim>
                                                    <#--${className}.${name}.[${name2}]-->
                                                    <#if type2!="ForeignKey" && type2!="ManyToMany" && type2!="Sysdict" >
                                                        <TH>${tablehead2}</TH>
                                                    </#if>
                                                </#list>
                                            </TR>
                                            <TR>
                                                <#list table2.prop as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign dbType2=prop2.@dbType?trim><#assign param2=prop2.@param?trim>
                                                    <#if type2!="ForeignKey" && type2!="ManyToMany" && type2!="Sysdict">
                                                        <#if  dbType2=="Date">
                                                            <TD th:text="${dollar}{${classNameLower}.${name}.${name2}}?${dollar}{#dates.format(${classNameLower}.${name}.${name2}, 'yyyy-MM-dd')}:null">${classNameLower}.${name}.${name2}</TD>
                                                        <#elseif  dbType2=="DateTime" || dbType2=="Timestamp">
                                                            <TD th:text="${dollar}{${classNameLower}.${name}.${name2}}?${dollar}{#dates.format(${classNameLower}.${name}.${name2}, 'yyyy-MM-dd HH:mm:ss')}:null">${classNameLower}.${name}.${name2}</TD>
                                                        <#else>
                                                            <TD th:text="${dollar}{${classNameLower}.${name}.${name2}}">${classNameLower}.${name}.${name2}</TD>
                                                        </#if>
                                                    </#if>
                                                </#list>
                                            </TR>
                                        </TABLE>
                                    </#if>
                                </#list>
                            </#if>
                        </#list>

                        <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign param=prop.@param?trim>
                            <#if type=="ManyToMany">
                                <#list doc.root.table as table2><#assign objctName2=table2.@objctName?trim>
                                    <#if param==objctName2>
                                        <BR/><BR/>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <TD>【<font color="red">${className}.${name}</font>】通过ManyToMany主动关联了[<font color="blue">${objctName2}</font>]，<font color="red">${className}.${name}</font> 对象信息如下：</TD>
                                            </TR>
                                        </TABLE>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <#list table2.prop as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim><#assign tablehead2=prop2.@colComment?trim>
                                                    <#--${className}.${name}.[${name2}]-->
                                                    <#if type2!="ForeignKey" && type2!="ManyToMany" && type2!="Sysdict">
                                                        <TH>${tablehead2}</TH>
                                                    </#if>
                                                </#list>
                                            </TR>
                                            <TR  th:each="${objctName2?lower_case} : ${dollar}{${className?lower_case}.${name}}">
                                                <#list table2.prop as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign dbType2=prop2.@dbType?trim><#assign param2=prop2.@param?trim>
                                                    <#if type2!="ForeignKey" && type2!="ManyToMany" && type2!="Sysdict">
                                                        <#if  dbType2=="Date">
                                                            <TD th:text="${dollar}{${objctName2?lower_case}.${name2}}?${dollar}{#dates.format(${objctName2?lower_case}.${name2}, 'yyyy-MM-dd')}:null">${objctName2?lower_case}.${name2}</TD>
                                                        <#elseif  dbType2=="DateTime" || dbType2=="Timestamp">
                                                            <TD th:text="${dollar}{${objctName2?lower_case}.${name2}}?${dollar}{#dates.format(${objctName2?lower_case}.${name2}, 'yyyy-MM-dd HH:mm:ss')}:null">${objctName2?lower_case}.${name2}</TD>
                                                        <#else>
                                                            <TD th:text="${dollar}{${objctName2?lower_case}.${name2}}">${objctName2?lower_case}.${name2}</TD>
                                                        </#if>
                                                    </#if>
                                                </#list>
                                            </TR>
                                        </TABLE>
                                    </#if>
                                </#list>
                            </#if>
                        </#list>

                        <#list doc.root.table as table2><#assign objctName2=table2.@objctName?trim><#assign classProp2=table2.prop>
                            <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                                <#if type2=="ForeignKey" && param2==className && objctName2!=className >
                                        <BR/><BR/>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <TD>【<font color="red">${className}</font>】被<font color="blue">${objctName2}.${name2}</font> 通过ForeignKey关联了， <font color="red">${className}.${objctName2?lower_case}s</font> 如下：</TD>
                                            </TR>
                                        </TABLE>
                                    <#list doc.root.table as table3><#assign objctName3=table3.@objctName?trim><#assign classProp3=table3.prop>
                                    <#if objctName3==objctName2>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <#list classProp3 as prop3><#assign name3=prop3.@name?trim><#assign type3=prop3.@type?trim><#assign param3=prop3.@param?trim><#assign tablehead3=prop3.@colComment?trim>
                                                    <#--${className}.${objctName2?lower_case}s.[${name3}]-->
                                                    <#if type3!="ForeignKey" && type3!="ManyToMany" && type3!="Sysdict">
                                                        <TH>${tablehead3}</TH>
                                                    </#if>
                                                </#list>
                                            </TR>
                                            <TR  th:each="${objctName2?lower_case} : ${dollar}{${className?lower_case}.${objctName2?lower_case}s}">
                                                <#list classProp3 as prop3><#assign name3=prop3.@name?trim><#assign type3=prop3.@type?trim><#assign dbType3=prop3.@dbType?trim><#assign param3=prop3.@param?trim>
                                                    <#if type3!="ForeignKey" && type3!="ManyToMany" && type3!="Sysdict">
                                                        <#if  dbType3=="Date">
                                                            <TD th:text="${dollar}{${objctName2?lower_case}.${name3}}?${dollar}{#dates.format(${objctName2?lower_case}.${name3}, 'yyyy-MM-dd')}:null">${objctName2?lower_case}.${name3}</TD>
                                                        <#elseif  dbType3=="DateTime" || dbType3=="Timestamp">
                                                            <TD th:text="${dollar}{${objctName2?lower_case}.${name3}}?${dollar}{#dates.format(${objctName2?lower_case}.${name3}, 'yyyy-MM-dd HH:mm:ss')}:null">${objctName2?lower_case}.${name3}</TD>
                                                        <#else>
                                                            <TD th:text="${dollar}{${objctName2?lower_case}.${name3}}">${objctName2?lower_case}.${name3}</TD>
                                                        </#if>
                                                    </#if>
                                                </#list>
                                            </TR>
                                        </TABLE>
                                    </#if>
                                    </#list>
                                </#if>
                            </#list>
                        </#list>

                        <#list doc.root.table as table2><#assign objctName2=table2.@objctName?trim><#assign classProp2=table2.prop>
                            <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                                <#if type2=="ManyToMany" && param2==className >
                                        <BR/><BR/>
                                        <TABLE  class="table table-striped  table-bordered  table-hover">
                                            <TR>
                                                <TD>【<font color="red">${className}</font>】被${objctName2}.${name2}通过ManyToMany关联了，<font color="red">${className}.${objctName2?lower_case}s</font>信息如下：</TD>
                                            </TR>
                                        </TABLE>
                                    <#list doc.root.table as table3><#assign objctName3=table3.@objctName?trim><#assign classProp3=table3.prop>
                                        <#if objctName3==objctName2>
                                            <TABLE  class="table table-striped  table-bordered  table-hover">
                                                <TR>
                                                    <#list classProp3 as prop3><#assign name3=prop3.@name?trim><#assign type3=prop3.@type?trim><#assign param3=prop3.@param?trim><#assign tablehead3=prop3.@colComment?trim>
                                                        <#--${className}.${objctName2?lower_case}s.[${name3}]-->
                                                        <#if type3!="ForeignKey" && type3!="ManyToMany" && type3!="Sysdict">
                                                            <TH>${tablehead3}</TH>
                                                        </#if>
                                                    </#list>
                                                </TR>
                                                <TR  th:each="${objctName2?lower_case} : ${dollar}{${className?lower_case}.${objctName2?lower_case}s}">
                                                    <#list classProp3 as prop3><#assign name3=prop3.@name?trim><#assign type3=prop3.@type?trim><#assign dbType3=prop3.@dbType?trim><#assign param3=prop3.@param?trim>
                                                        <#if type3!="ForeignKey" && type3!="ManyToMany" && type3!="Sysdict">
                                                            <#if dbType3=="Date">
                                                                <TD th:text="${dollar}{${objctName2?lower_case}.${name3}}?${dollar}{#dates.format(${objctName2?lower_case}.${name3}, 'yyyy-MM-dd')}:null">${objctName2?lower_case}.${name3}</TD>
                                                            <#elseif  dbType3=="DateTime" || dbType3=="Timestamp">
                                                                <TD th:text="${dollar}{${objctName2?lower_case}.${name3}}?${dollar}{#dates.format(${objctName2?lower_case}.${name3}, 'yyyy-MM-dd HH:mm:ss')}:null">${objctName2?lower_case}.${name3}</TD>
                                                            <#else>
                                                                <TD th:text="${dollar}{${objctName2?lower_case}.${name3}}">${objctName2?lower_case}.${name3}</TD>
                                                            </#if>
                                                        </#if>
                                                    </#list>
                                                </TR>
                                            </TABLE>
                                        </#if>
                                    </#list>
                                </#if>
                            </#list>
                        </#list>


                                    </div>

                                    <div class="col-md-1"></div>


                                </DIV><!-- /.row -->

                            </DIV><!-- /.tab-pane -->
                            
                        </DIV><!-- /.tab-content -->

                    <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col-xs-12 -->
                </div><!-- /.row -->
            </div><!-- /.page-content -->

        </div><!-- /.main-content -->

    </DIV><!-- /.main-container-inner -->

    <a href="#" id="btn-scroll-up" class="btn-scroll-up btn btn-sm btn-inverse">
        <i class="icon-double-angle-up icon-only bigger-110"></i>
    </a>

</DIV><!-- /.main-container -->

<div th:include="fragment/footer :: js"></div>


</BODY>
</HTML>

</#list>


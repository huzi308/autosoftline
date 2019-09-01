<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name="../"+className+"/"+className+"List.html" />
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

<TITLE>${className}List</TITLE>

<#if className=="Uploadfile">
<link rel="stylesheet" th:href="@{/assets/css/dropzone.css}" />
</#if>

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

            <#if className!="Myuser" && className!="Role" && className!="Permission" && className!="Syslog" && className!="Sysdict" && className!="Department" && className!="Area" && className!="Uploadfile">
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
                <#if className=="Area" || className=="Department">
                    <li><A th:href="@{/${classNameLower}/tree}" target="treeWin">【${className}-Tree】</A></li>
                </#if>
                <#if isExcelExport=="true">
                    <li>
                        <A th:href="@{/${classNameLower}/excelExport}">【Excel导出】</A>
                    </li>
                </#if>
                <#if isWordExport=="true">
                    <li>
                        <A th:href="@{/${classNameLower}/wordExport1}">【Word导出1】</A>
                    </li>
                    <li>
                        <A th:href="@{/${classNameLower}/wordExport2}">【Word导出2】</A>
                    </li>
                </#if>
                </ul><!-- .breadcrumb -->

                <div class="nav-search" id="nav-search">
                    <form class="form-search" id="searchForm" name="searchForm" th:action="@{/${classNameLower}/search}" method="post">
                        <span class="input-icon">
                            <input type="text" class="nav-search-input" name="strKey" th:value="${dollar}{strKey}" placeholder="Serach..." />
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
                            <li class="active">
                                <a href="#tab_id01" data-toggle="tab"><i class="icon-list green"></i> ${className}列表</a>
                            </li>
                          <#if className!="Syslog" && className!="Sysdict" && className!="Uploadfile">
                            <li sec:authorize="hasAnyRole('ROLE_Admin','ROLE_ObjAdmin','ROLE_${className}Admin')">
                                <a th:href="@{/${classNameLower}/insert}"><i class="icon-plus blue"></i>新增</a>
                            </li>
                          </#if>
                        </UL>

                        <DIV id="myTabContent" class="tab-content">

                            <DIV id="tab_id01" class="tab-pane fade in active">

                                <DIV class="table-responsive">

                                    <TABLE  align="center" border="0">
                                        <TR><TD><font color="red" th:utext="${dollar}{errorMsg}"></font></TD></TR>
                                    </TABLE>

                                    <TABLE class="table table-striped  table-bordered table-hover" style="word-break:break-all; word-wrap:break-all;">
                                    <THEAD>
                                        <TR>
                                        <#if className=="Sysdict">
                                            <TH style="width:80px;">ID</TH>
                                        <#else>
                                            <TH style="width:40px;">ID</TH>
                                        </#if>
                                <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign tablehead=prop.@colComment?trim>
                                  <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" >
                                    <#if name!="id">
                                        <#if className=="Syslog">
                                            <#if  name=="operation">
                                               <TH style="width:60px;">${tablehead}</TH>
                                            <#elseif name=="tableName">
                                               <TH style="width:100px;">${tablehead}</TH>
                                            <#elseif name=="objctId">
                                               <TH style="width:60px;">${tablehead}</TH>
                                            <#elseif name=="objctValue">
                                               <TH>${tablehead}</TH>
                                            <#elseif name=="operateBy">
                                               <TH style="width:60px;">${tablehead}</TH>
                                            <#elseif name=="ip">
                                               <TH style="width:80px;">${tablehead}</TH>
                                            <#elseif name=="operateTime">
                                               <TH style="width:90px;">${tablehead}</TH>
                                            <#else>
                                               <TH>${tablehead}</TH>
                                            </#if>
                                        <#elseif className=="Uploadfile">
                                            <#if  name=="path">
                                               <TH>${tablehead} &nbsp; <a href="/uploadfile/list">[刷新]</a></TH>
                                            <#else>
                                               <TH>${tablehead}</TH>
                                            </#if>
                                        <#else>
                                            <TH>${tablehead}</TH>
                                        </#if>
                                    </#if>
                                  </#if>
                                  <#if type=="ForeignKey" || type=="Sysdict" >
                                            <TH>${tablehead}</TH>
                                  </#if>
                                </#list>
                                        <#if className!="Syslog" && className!="Sysdict" && className!="Uploadfile">
                                            <TH style="width:100px;">
                                                <A  sec:authorize="hasAnyRole('ROLE_Admin','ROLE_ObjAdmin','ROLE_${className}Admin')"  th:href="@{/${classNameLower}/insert}" title="新增"><i class="icon-plus blue"></i>新增</A>
                                        <#else>
                                            <TH style="width:40px;">
                                        </#if>
                                            </TH>
                                        </TR>
                                    </THEAD>
                                    <TBODY>
                                        <TR  th:each="${classNameLower} : ${dollar}{page.list}">
                                            <TD th:text="${dollar}{${classNameLower}.id}">${classNameLower}.id</TD>
                                    <#assign linkCount=1>
                                    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim>
                                    <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" >
                                      <#if name!="id">
                                        <#if dbType=="Date">
                                            <TD th:text="${dollar}{${classNameLower}.${name}}?${dollar}{#dates.format(${classNameLower}.${name}, 'yyyy-MM-dd')}:null">${classNameLower}.${name}</TD>
                                        <#elseif  dbType=="DateTime" || dbType=="Timestamp">
                                            <TD th:text="${dollar}{${classNameLower}.${name}}?${dollar}{#dates.format(${classNameLower}.${name}, 'yyyy-MM-dd HH:mm:ss')}:null">${classNameLower}.${name}</TD>
                                        <#elseif type=="String" && linkCount==1><#assign linkCount=0>
                                            <TD>
                                                <span th:text="${dollar}{${classNameLower}.${name}}">${classNameLower}.${name}</span>
                                                <#list doc.root.table as table2><#assign className2=table2.@objctName?trim ><#assign classProp2=table2.prop >
                                                  <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                                                    <#if className2!=className && type2=="ForeignKey" && param2==className>
                                                    [<A th:href="@{/${className2?lower_case}/${classNameLower}(id=${dollar}{${classNameLower}.id})}" target="fk${className2}List">${className2}List</A>]
                                                    </#if>
                                                  </#list>
                                                </#list>
                                            </TD>
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
                                      </#if>
                                    </#if>
                                    <#if type=="ForeignKey">
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
                                            <TD th:text="${dollar}{${classNameLower}?.${name}?.${strName}}">${classNameLower}.${name}.${strName}</TD>
                                    </#if>
                                    <#if type=="Sysdict" >
                                            <TD th:text="${dollar}{${classNameLower}?.${name}?.name}">${classNameLower}.${name}.name</TD>
                                    </#if>
                                    </#list>
                                            <TD>
                                                <A th:href="@{/${classNameLower}/detail(id=${dollar}{${classNameLower}.id})}" title="详细信息"><span class="green"><i class="icon-list bigger-120"></i></span></A>
                                              <#if className!="Syslog" && className!="Sysdict" && className!="Uploadfile">
                                                <A  sec:authorize="hasAnyRole('ROLE_Admin','ROLE_ObjAdmin','ROLE_${className}Admin')"  th:href="@{/${classNameLower}/update(id=${dollar}{${classNameLower}.id})}" title="修改"><span class="green"><i class="icon-edit bigger-120"></i></span></A>
                                                <A  sec:authorize="hasAnyRole('ROLE_Admin','ROLE_ObjAdmin','ROLE_${className}Admin')"  th:href="@{/${classNameLower}/delete(id=${dollar}{${classNameLower}.id})}" title="删除"><span class="red"><i class="icon-trash bigger-120"></i></span></A>
                                              </#if>
                                            </TD>
                                        </TR>
                                    </TBODY>
                                    </TABLE>

                                <#if className=="Uploadfile">
                                    <DIV id="dropzone">
                                        <FORM  th:action="@{/${classNameLower}/upload}"  class="dropzone">
                                            <DIV class="fallback">
                                                <INPUT  name="file"  type="file"  multiple="" />
                                            </DIV>
                                        </FORM>
                                    </DIV>
                                </#if>

                                </DIV><!-- /.table-responsive -->

                            </DIV><!-- /.tab-pane -->

                        </DIV><!-- /.tab-content -->

                        <CENTER  th:include="fragment/pageNav :: pagination"></CENTER>

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

<#if className=="Uploadfile">
<script th:src="@{/assets/js/dropzone.min.js}"></script>
<script type="text/javascript">
    jQuery(function($){
        try {
          $(".dropzone").dropzone({
            paramName: "file", // The name that will be used to transfer the file
            maxFilesize: 800, // MB
            addRemoveLinks : false,
            dictDefaultMessage :
            '<span class="bigger-100 bolder"><i class="icon-caret-right red"></i> 可拖放多个文件上传</span> \
            <span class="smaller-60 grey">（或点击选择多个文件上传）</span> <br /> \
            <i class="upload-icon icon-cloud-upload blue icon-3x"></i>',
            dictResponseError: '上传文件出错!',
            //change the previewTemplate to use Bootstrap progress bars
            previewTemplate: "<div class=\"dz-preview dz-file-preview\">\n  <div class=\"dz-details\">\n    <div class=\"dz-filename\"><span data-dz-name></span></div>\n    <div class=\"dz-size\" data-dz-size></div>\n    <img data-dz-thumbnail />\n  </div>\n  <div class=\"progress progress-small progress-striped active\"><div class=\"progress-bar progress-bar-success\" data-dz-uploadprogress></div></div>\n  <div class=\"dz-success-mark\"><span></span></div>\n  <div class=\"dz-error-mark\"><span></span></div>\n  <div class=\"dz-error-message\"><span data-dz-errormessage></span></div>\n</div>"
          });
        } catch(e) {
          alert('Dropzone不支持该浏览器版本！');
        }
    });
</script>
</#if>

</BODY>
</HTML>

</#list>

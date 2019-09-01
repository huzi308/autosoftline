<#include "/include/parameters.ftl">
<@pp.dropOutputFile />
<#list doc.root.table as table>
<#assign tableName=table.@tableName?trim>
<#assign className=table.@objctName?trim>
<#assign classNameLower=className?lower_case >
<@pp.changeOutputFile  name="../"+className+"/"+className+"Add.html" />
<#assign classProp=table.prop>
<#---->
<#---->
<#assign hasDateProperty=0>
<#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim>
  <#if type=="Date"><#assign hasDateProperty=1></#if>
</#list>
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
<TITLE>${className}Add</TITLE>
<div th:include="fragment/header :: jscss"></div>
<#if hasDateProperty==1>
    <link rel="stylesheet"  th:href="@{/assets/css/bootstrap-datetimepicker.min.css}"></link>
</#if>
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
                                <a href="#tab_id01"  data-toggle="tab"><i class="icon-edit blue"></i>新增</a>
                            </li>
                        </UL>

                        <DIV id="myTabContent" class="tab-content">

                            <DIV id="tab_id01" class="tab-pane fade in active">

                                <DIV class="row">
                                    <div class="col-md-2"></div>
                                    <div class="col-md-8" style="border:1px dashed #f0f0f0">

                                        <div class="form-group center">
                                            <font color="red" th:utext="${dollar}{errorMsg}"></font>
                                        </div>

                                        <form  id="insertForm"  name="insertForm"  class="form-horizontal"   th:action="@{/${classNameLower}/insert}" th:object="${dollar}{${classNameLower}}"  method="post">
                                    <#list classProp as prop><#assign name=prop.@name?trim><#assign type=prop.@type?trim><#assign dbType=prop.@dbType?trim><#assign param=prop.@param?trim><#assign tablehead=prop.@colComment?trim>
                                        <#if type!="ForeignKey" && type!="ManyToMany" && type!="Sysdict" >
                                          <#if name!="id">
                                            <div class="form-group">
                                                <label for="${name}" class="col-sm-3 control-label">
                                                <#if param=="">
                                                    <font color="red">${tablehead}*</font>
                                                <#else>
                                                    ${tablehead}
                                                </#if>
                                                </label>
                                            <#if  dbType=="Date">
                                              <#if  param!="null">
                                                <div class="input-group date form_date col-sm-9" data-date="" data-date-format="yyyy-mm-dd" data-link-field="dtp_input_${name}" data-link-format="yyyy-mm-dd">
                                                    <input type="text" class="form-control" name="${name}"  id="${name}" th:value="${dollar}{#dates.format(new java.util.Date().getTime(), 'yyyy-MM-dd')}"/>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                                </div>
                                                <input type="hidden" id="dtp_input_${name}" value="" /><br/>
                                              <#else>
                                                <div class="input-group date form_date col-sm-9" data-date="" data-date-format="yyyy-mm-dd" data-link-field="dtp_input_${name}" data-link-format="yyyy-mm-dd">
                                                    <input type="text" class="form-control" name="${name}"  id="${name}" th:value="null"/>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                                </div>
                                                <input type="hidden" id="dtp_input_${name}" value="null" /><br/>
                                              </#if>
                                            <#elseif  dbType=="DateTime" || dbType=="Timestamp" >
                                              <#if  param!="null">
                                                <div class="input-group date form_datetime col-sm-9" data-date="" data-date-format="yyyy-mm-dd hh:ii:ss" data-link-field="dtp_input_${name}" data-link-format="yyyy-mm-dd hh:ii:ss">
                                                    <input type="text" class="form-control" name="${name}"  id="${name}" th:value="${dollar}{#dates.format(new java.util.Date().getTime(), 'yyyy-MM-dd HH:mm:ss')}"/>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
                                                </div>
                                                <input type="hidden" id="dtp_input_${name}" value="" /><br/>
                                              <#else>
                                                <div class="input-group date form_datetime col-sm-9" data-date="" data-date-format="yyyy-mm-dd hh:ii:ss" data-link-field="dtp_input_${name}" data-link-format="yyyy-mm-dd hh:ii:ss">
                                                    <input type="text" class="form-control" name="${name}"  id="${name}" th:value="null"/>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                                    <span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
                                                </div>
                                                <input type="hidden" id="dtp_input_${name}" value="null" /><br/>
                                              </#if>
                                            <#elseif type=="String" && dbType=="Text">
                                                <div class="col-sm-9">
                                                    <textarea  class="form-control" th:field="*{${name}}" />
                                                    <SPAN th:if="${dollar}{#fields.hasErrors('${name}')} " th:errors="*{${name}}" class="text-danger"></SPAN>
                                                </div>
                                            <#elseif type=="Boolean">
                                                <#if name=="enabled">
                                                <div class="col-sm-9">
                                                    <select th:field="*{${name}}" class="form-control">
                                                        <option value="">--请选择--</option>
                                                        <option value="1">启用</option>
                                                        <option value="0">禁用</option>
                                                    </select>
                                                </div>
                                                <#else>
                                                <div class="col-sm-9">
                                                    <select th:field="*{${name}}" class="form-control">
                                                        <option value="">--请选择--</option>
                                                        <option value="1">是</option>
                                                        <option value="0">否</option>
                                                    </select>
                                                </div>
                                                </#if>
                                             <#else>
                                                <div class="col-sm-9">
                                                    <input type="text" class="form-control" name="${name}"  id="${name}" th:value="*{${name}}" placeholder="${name}"/>
                                                    <SPAN th:if="${dollar}{#fields.hasErrors('${name}')} " th:errors="*{${name}}" class="text-danger"></SPAN>
                                                </div>
                                             </#if>
                                            </div>
                                          </#if>
                                        </#if>
                                        <#if type=="ForeignKey">
                                            <div class="form-group">
                                                <label for="${name}" class="col-sm-3 control-label"><font color="red">${tablehead}*</font></label>
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
                                                <div class="col-sm-9">
                                                    <select th:field="*{${name}Id}" class="form-control">
                                                      <#if param!="Department">
                                                        <option value="">--请选择--</op[tion>
                                                      </#if>
                                                        <option th:each="${name}:${dollar}{${name}List}" th:value="${dollar}{${name}.id}" th:text="${dollar}{${name}.${strName}}"> ${dollar}{${name}.id} </option>
                                                    </select>
                                                    <SPAN th:if="${dollar}{#fields.hasErrors('${name}Id')} " th:errors="*{${name}Id}" class="text-danger"></SPAN>
                                                </div>
                                            </div>
                                        </#if>
                                        <#if type=="Sysdict" >
                                            <div class="form-group">
                                                <label for="${name}" class="col-sm-3 control-label"><font color="red">${tablehead}*</font></label>
                                                <div class="col-sm-9">
                                                    <select th:field="*{${name}Id}" class="form-control">
                                                        <option value="">--请选择--</op[tion>
                                                        <option th:each="${name}:${dollar}{${name}List}" th:value="${dollar}{${name}.id}" th:text="${dollar}{${name}.name}"> ${dollar}{${name}.id} </option>
                                                    </select>
                                                    <SPAN th:if="${dollar}{#fields.hasErrors('${name}Id')} " th:errors="*{${name}Id}" class="text-danger"></SPAN>
                                                </div>
                                            </div>
                                        </#if>
                                        <#if type=="ManyToMany">
                                            <div class="form-group">
                                                <label for="${name}" class="col-sm-3 control-label">${tablehead}</label>
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
                                                <div class="col-sm-9">
                                                    <div th:each="${param?lower_case}:${dollar}{${param?lower_case}List}">
                                                        <input type="checkbox"  th:text="${dollar}{${param?lower_case}.${strName}}" th:field="*{${param?lower_case}Ids}" th:value="${dollar}{${param?lower_case}.id}" />
                                                    </div>
                                                </div>
                                            </div>
                                        </#if>
                                    </#list>

                                    <#list doc.root.table as table2><#assign className2=table2.@objctName?trim><#assign classProp2=table2.prop><#assign size=classProp2?size>
                                      <#list classProp2 as prop2><#assign name2=prop2.@name?trim><#assign type2=prop2.@type?trim><#assign param2=prop2.@param?trim>
                                        <#if type2=="String" && size gte 1>
                                            <#assign strName=name2><#assign size=0>
                                        </#if>
                                        <#if type2=="ManyToMany" && param2==className >
                                            <div class="form-group">
                                                <label for="${className2?lower_case}s" class="col-sm-3 control-label">${className2?lower_case}s</label>
                                                <div class="col-sm-9">
                                                    <div th:each="${className2?lower_case}:${dollar}{${className2?lower_case}List}">
                                                        <input type="checkbox"  th:text="${dollar}{${className2?lower_case}.${strName}}" th:field="*{${className2?lower_case}Ids}" th:value="${dollar}{${className2?lower_case}.id}" />
                                                    </div>
                                                </div>
                                            </div>
                                        </#if>
                                      </#list>
                                    </#list>

                                            <div class="form-group">
                                                <div class="col-sm-offset-4 col-sm-8">
                                                    <input type="hidden" name="save" value="Yes" />
                                                    <input type="hidden" name="submitToken" th:value="${dollar}{submitToken}" />
                                                    <input type="submit" name="saveBtn" value=" 保 存 " class="btn btn-app btn-primary btn-xs radius-4" onClick="document.insertForm.saveBtn.value='正在提交'; document.insertForm.saveBtn.disabled=true; document.insertForm.submit();" /> &nbsp; &nbsp; &nbsp;
                                                    <a href="/${classNameLower}/list" th:href="@{/${classNameLower}/list}" class="btn btn-app btn-primary btn-xs radius-4">返 回</a>
                                                </div>
                                            </div>
                                        </form>

                                    </div>
                                    <div class="col-md-2"></div>




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

<#if hasDateProperty==1>
<script type="text/javascript"  th:src="@{/assets/js/bootstrap-datetimepicker.js}"></script>
<script type="text/javascript"  th:src="@{/assets/js/bootstrap-datetimepicker.zh-CN.js}"></script>
<script type="text/javascript">
    $('.form_datetime').datetimepicker({
        language:  'zh-CN',
        weekStart: 1,
        todayBtn:  1,
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        forceParse: 0
    });
    $('.form_date').datetimepicker({
        language:  'zh-CN',
        weekStart: 1,
        todayBtn:  1,
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        minView: 2,
        forceParse: 0
    });
</script>
</#if>

</BODY>
</HTML>

</#list>


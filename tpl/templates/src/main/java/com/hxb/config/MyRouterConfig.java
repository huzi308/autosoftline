<#include "/include/parameters.ftl">
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.config;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Component
public class MyRouterConfig extends WebMvcConfigurerAdapter{

    //在此配置不需要经过Controller就能直接跳转的url请求
    @Override
    public void addViewControllers(ViewControllerRegistry registry)
    {
        registry.addViewController("/").setViewName("index");
        registry.addViewController("/index").setViewName("index");
        registry.addViewController("/login").setViewName("Login/login");
        registry.addViewController("/logout").setViewName("Login/login");
        registry.addViewController("/denied").setViewName("Login/denied");
    }

}

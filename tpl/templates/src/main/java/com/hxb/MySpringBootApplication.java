<#include "/include/parameters.ftl">
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName};

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class MySpringBootApplication {

    public static void main(String[] args) {
        SpringApplication.run(MySpringBootApplication.class, args);
    }
}

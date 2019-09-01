<#include "/include/parameters.ftl">
<#if isCasClient=="true">
<@pp.dropOutputFile />
</#if>
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.config;

import ${pkgName}.service.impl.MyuserServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

<#if isSessionRedis=="true">
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;

import org.springframework.security.core.session.SessionRegistry;

import org.springframework.session.data.redis.RedisOperationsSessionRepository;
import org.springframework.session.FindByIndexNameSessionRepository;
import org.springframework.session.security.SpringSessionBackedSessionRegistry;
</#if>

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true)
public class MyWebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private MyuserServiceImpl myuserServiceImpl;

    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http.csrf().disable().authorizeRequests()
                .antMatchers("/favicon.ico", "/myuser/register", "/getKaptchaImage**", "/assets/**", "/img/**", "/ztree-3.5.12/**").permitAll()
              <#if dataBaseName!="h2">
                .antMatchers("/druid/**").hasAuthority("ROLE_Admin")
              </#if>
                .anyRequest().authenticated()  //其它任何请求，登录后方可访问
            .and()
                .formLogin().defaultSuccessUrl("/").loginPage("/login").usernameParameter("username").passwordParameter("password").permitAll()
            .and()
                .rememberMe()
            .and()
                .logout().logoutSuccessUrl("/login").permitAll()
            .and()
                .exceptionHandling().accessDeniedPage("/denied")
        <#if hasKaptcha=="true">
            .and()
                 //只对URL="/login"的请求进行拦截，在认证用户名之前认证验证码，如果验证码错误，将不执行用户名和密码的认证
                .addFilterBefore(new KaptchaAuthenticationFilter("/login", "/login?error"), UsernamePasswordAuthenticationFilter.class)
        </#if>
                ;

    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {

        auth.userDetailsService(myuserServiceImpl).passwordEncoder(new PasswordEncoder() {

            @Override
            public String encode(CharSequence rawPassword) {
                String md5pwd = new Md5PasswordEncoder().encodePassword((String)rawPassword, "");
                return md5pwd;
            }

            @Override
            public boolean matches(CharSequence rawPassword, String encodedPassword) {
                String md5pwd = new Md5PasswordEncoder().encodePassword((String)rawPassword, "");
                return encodedPassword.equals(md5pwd);
            }

        });

    }

}

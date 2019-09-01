<#include "/include/parameters.ftl">
<#if hasKaptcha!="true">
<@pp.dropOutputFile />
</#if>
<#if noCopyright!="true">
<#include "/include/copyright-star.ftl">
</#if>
package ${pkgName}.config;

import com.google.code.kaptcha.impl.DefaultKaptcha;
import com.google.code.kaptcha.util.Config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.Properties;


@Configuration
public class KaptchaConfig {

    @Bean(name="captchaProducer")
    public DefaultKaptcha getKaptchaBean(){

        DefaultKaptcha defaultKaptcha=new DefaultKaptcha();

        Properties properties=new Properties();

        properties.setProperty("kaptcha.border", "no");//是否有边框
        //properties.setProperty("kaptcha.border.color", "245,248,249");//图片边框颜色

        properties.setProperty("kaptcha.image.width", "100");//图片宽度
        properties.setProperty("kaptcha.image.height", "32");//图片高度

        properties.setProperty("kaptcha.textproducer.char.string", "123456789");//使用哪些字符生成验证码
        properties.setProperty("kaptcha.textproducer.char.length", "4");//字符个数
        properties.setProperty("kaptcha.textproducer.char.space", "6");//文字间隔

        properties.setProperty("kaptcha.textproducer.font.color", "blue");//字体颜色
        properties.setProperty("kaptcha.textproducer.font.size", "30");//字体大小
        properties.setProperty("kaptcha.textproducer.font.names", "Arial");//字体

        properties.setProperty("kaptcha.noise.color", "gray");//干扰线的颜色

        //properties.setProperty("kaptcha.session.key", "code");//session的key

        Config config=new Config(properties);

        defaultKaptcha.setConfig(config);

        return defaultKaptcha;
    }
}



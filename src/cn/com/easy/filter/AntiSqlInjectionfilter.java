package cn.com.easy.filter;
import java.io.IOException;
import java.util.Enumeration;
 
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
 
public class AntiSqlInjectionfilter implements Filter {
	
	private String badStr = "or |and |exec |execute |insert |select |delete |update |count |mid |master |truncate |drop |declare |union |chr(";
 
    public void destroy() {
       
    }
     
    public void init(FilterConfig arg0) throws ServletException {
    	if(arg0.getInitParameter("BadStr")!=null)
    		badStr = arg0.getInitParameter("BadStr");
    }
     
    public void doFilter(ServletRequest args0, ServletResponse args1,
            FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req=(HttpServletRequest)args0;
        if(req.getRequestURI().contains("/pages/ebuilder/")||req.getRequestURI().contains("/json2ExcelNormal.e")){
        	chain.doFilter(args0,args1);
        	return;
        }
        
         //获得所有请求参数名
        Enumeration<?> params = req.getParameterNames();
        String sql = "";
        while (params.hasMoreElements()) {
            String name = params.nextElement().toString();
            if(!name.toLowerCase().endsWith("sql")&&!"code_table".equalsIgnoreCase(name)){
            	String[] value = req.getParameterValues(name);
            	for (int i = 0; i < value.length; i++) {
            		sql = sql + " " + value[i];
            	}
            }
        }
        //有sql关键字，跳转到error.html
        if (sqlValidate(sql)) {
            throw new IOException("您发送请求中的参数中含有非法字符:"+sql);
        } else {
            chain.doFilter(args0,args1);
        }
    }
     
    //效验
    protected boolean sqlValidate(String str) {
        str = str.toLowerCase();//统一转为小写
        String[] badStrs = badStr.split("\\|");
        for (int i = 0; i < badStrs.length; i++) {
            if (str.indexOf(badStrs[i]) >= 0) {
                return true;
            }
        }
        return false;
    }
}
package cn.com.easy.filter;

import java.io.IOException;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class PageAuthFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub

	}

	@SuppressWarnings("rawtypes")
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		String url = req.getRequestURL().toString();
		String path = req.getContextPath();
		String basePath = req.getScheme()+"://"+req.getServerName()+":"+req.getServerPort()+path+"/";
		url = url.substring(basePath.length());
		HttpSession session = req.getSession();
		Map userInfo = (Map)session.getAttribute("UserInfo");
		if(userInfo!=null){
			Map userMenuMap =(Map)session.getAttribute("userMenu");
			Map allMenuMap = (Map)session.getAttribute("allMenu");
			if(userMenuMap!=null&&allMenuMap!=null){
				if(allMenuMap.containsKey(url)){
					if(userMenuMap.containsKey(url)){
						chain.doFilter(req, res);
					}else{
						response.setContentType("text/html;charset=UTF-8"); 
						response.getWriter().write("<div style='color:#c00'>对不起，您无权访问该页面！</font>");
						return;
					}
				}else{
					chain.doFilter(request, response);
				}
			}
		}else{
			chain.doFilter(request, response);
		}
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}

}

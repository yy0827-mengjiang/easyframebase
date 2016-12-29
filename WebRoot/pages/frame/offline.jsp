<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head> 
  <title>掉线</title>
  <base href="<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"%>">
  <meta http-equiv="pragma" content="no-cache">
  <meta http-equiv="cache-control" content="no-cache">
  <meta http-equiv="expires" content="0">    
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <script type="text/javascript" src="resources/easyResources/scripts/jquery-1.8.3.min.js"></script>
  <script type="text/javascript">
  	$(function(){
  		window.top.location.href = 'index.jsp';
  	});
  </script>
  </head>
  <body>
  <p align="center">您已经掉线，请重新登录。</p>
  </body>
</html>

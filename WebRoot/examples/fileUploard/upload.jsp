<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<e:style value="resources/themes/base/boncBase@links.css"/>
<e:style value="resources/themes/blue/boncBlue.css"/>
</head>
<body>
<div class="exampleWarp">
	<h1 class="titOne">copy标签</h1>
	<h1 class="titThree"> e:copy 复制文件到指定目录或成为指定文件</h1>
	<div class="lable1"><img src="<e:url value="/examples/fileUploard/copy_use.jpg"/>"></div>
	<h1 class="titThree">  e:copy可以用于文件上传，使用时需要设置前台界面和后台服务</h1>
	<div class="lable1">
	<h4> 前台界面如图：</h4>
	<img src="<e:url value="/examples/fileUploard/copy_show.jpg"/>">
	<h4> 后台服务如图：</h4>
	<img src="<e:url value="/examples/fileUploard/copy_action.jpg"/>">
	<h4>例子：</h4>
		<div class="lable2"> 填写 标题、正文、附件1、附件2后，点击保存后，将用copy标签将文件上传到服务器 
		<form action="upload_action.jsp" method="post" enctype="multipart/form-data">
			标 题：
			<input type="text" name="title" size="50">
			<br />
			正 文：
			<textarea name="text" rows="10" cols="60"></textarea>
			<br />
			附件1：
			<input type="file" name="file1">
			<br />
			附件2：
			<input type="file" name="file2">
			<br />
			<input type="submit" value="保存">
		</form>
		 </div>
	</div>
</div>
</body>

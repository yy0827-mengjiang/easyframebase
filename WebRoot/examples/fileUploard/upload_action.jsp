<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:parseRequest/>
<e:copy file="${file1}" tofile="/upload1/${e:getDate('yyyyMMddHHmmss')}${file1.suffix}"/>
<e:copy file="${file2}" todir="/upload2"/>
标 题：${title}<br/>
正 文：${text}<br/>
附件1路径：${file1.path}<br/>
附件1名称：${file1.name}<br/>
附件1后缀：${file1.suffix}<br/>
附件1目录：${file1.directory}<br/>
附件1大小：${file1.size}<br/>
附件1类型：${file1.contentType}<br/>
附件2路径：${file2.path}<br/>
附件2名称：${file2.name}<br/>
附件2后缀：${file2.suffix}<br/>
附件2目录：${file2.directory}<br/>
附件2大小：${file2.size}<br/>
附件2类型：${file2.contentType}<br/>
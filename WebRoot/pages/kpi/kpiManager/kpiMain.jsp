<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ include file="../include/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
    <e:style value="/resources/easyResources/component/easyui/icon.css" />
    <e:style value="/resources/themes/base/boncBase@links.css"/>
    <e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
    
   <e:q4o var="newOneWeek" sql="kpi.view.newOneWeek"/>
   <e:q4o var="newOneMonth" sql="kpi.view.newOneMonth"/>
   <e:q4o var="uptOneWeek" sql="kpi.view.uptOneWeek"/>
   <e:q4o var="uptOneMonth" sql="kpi.view.uptOneMonth"/>
</head>
<body>
    <div class="kpiGuide">
        <div class="kpiBox">
            <ul class="group">
                <li><a href="javascript:void(0)" class="kpiColor01"><strong>本周新增指标</strong><span>${newOneWeek.WEEKCNT }</span></a></li>
                <li><a href="javascript:void(0)" class="kpiColor02"><strong>本月新增指标</strong><span>${newOneMonth.MONTHCNT }</span></a></li>
                <li><a href="javascript:void(0)" class="kpiColor03"><strong>本周变更指标</strong><span>${uptOneWeek.WEEKCNT }</span></a></li>
                <li><a href="javascript:void(0)" class="kpiColor04"><strong>本月变更指标</strong><span>${uptOneMonth.MONTHCNT }</span></a></li>
            </ul>
        </div>
        <div class="kpiBox">
            <p class="kpiHelp">操作流程</p>
        </div>
    </div>
</body>
</html>
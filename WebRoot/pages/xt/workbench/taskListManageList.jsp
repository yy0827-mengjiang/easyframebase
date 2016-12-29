<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:description>10月29日 3:00</e:description>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <meta charset="UTF-8">
    <!--声明以IE最高版本浏览器内核或谷歌浏览器内核进行渲染 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!--声明以360极速模式进行渲染 -->
    <meta name=”renderer” content=”webkit” />
    <title>审计点管理</title>
   	<c:resources type="easyui" style="${ThemeStyle}" />
    <!-- 独立Css层叠样式表 -->
    <e:style value="/pages/xt/resources/themes/base/boncX@links.css"/>
	  <!-- icheck -->
	  <script type="text/javascript">
		  $(function () {
			  $('input.icheckS').iCheck({
				  labelHover : false,
				  cursor : true,
				  checkboxClass : 'icheckbox_square-blue',
				  radioClass : 'iradio_square-blue',
				  increaseArea : '20%'
			  });
		  })

	  </script>
  </head>
  		<e:description>经责领域码表查询</e:description>
  <body>
  <div id="tbar" class="contents-head">
	  <!--高级搜索-->
	  <div class="search-more">
		  <!--排版说明:下面的 li 类名 四行 .fourRow 三列 .threeRow 二列 .twoRow  -->
		  <ul class="group" id="searchList">
			  <li class="fiveRow"><strong>活动名称：</strong><input type="text" style="width:20%" id="" name="" /> <a href="javascript:void(0);" class="easyui-linkbutton" onclick="">查询</a></li>
		  </ul>
	  </div>
	  <!--高级搜索-->
  </div>

  <table id="dg" class="easyui-datagrid" title="" style="width:100%;"
		 data-options="singleSelect:true,collapsible:true,url:'datagrid_data02.json',method:'get',fit:true,pagination:true">
	  <thead>
	  <tr>
		  <th data-options="field:'d1',resizable:false,align:'center'" width="16%">活动名称</th>
		  <th data-options="field:'d2'" width="10%">今日任务量</th>
		  <th data-options="field:'d3',align:'center'" width="7%">今日完成</th>
		  <th data-options="field:'d4',align:'center'" width="7%">今日未完成</th>
		  <th data-options="field:'d5'" width="10%">今日回访率</th>
		  <th data-options="field:'d6',align:'center'" width="10%">累计任务量</th>
		  <th data-options="field:'d7',align:'center'" width="10%">累计完成</th>
		  <th data-options="field:'d8',align:'center'" width="10%">累计未完成</th>
		  <th data-options="field:'d9',align:'center'" width="10%">累计回访率</th>
		  <th data-options="field:'d10',align:'center'" width="10%">累计任务量</th>
	  </tr>
	  </thead>
  </table>
  </body>
</html>

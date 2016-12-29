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
		  function toggleSearch() {
			  if($("#searchList").hasClass("defaut")){
				  $("#searchShow .l-btn-text").text("收缩");
				  $("#searchList").removeClass("defaut");

			  }else{
				  $("#searchList").addClass("defaut");
				  $("#searchShow .l-btn-text").text("更多搜索条件");
			  }

		  }
		  function showSlide(){

				  $("#toolSlide").animate({"right":0},300);

		  }
		  function closeSlide(){

			  	$("#toolSlide").animate({"right":-330},300);;

		  }
	  </script>
  </head>
  		<e:description>经责领域码表查询</e:description>
  <body>
  <div id="tbar" class="contents-head">
	  <!--高级搜索-->
	  <div class="search-more">
		  <!--排版说明:下面的 li 类名 五列 .fiveRow 四行 .fourRow 三列 .threeRow 二列 .twoRow  -->
		  <ul class="group defaut" id="searchList">
			  <li class="twoRow"><strong>活动名称：</strong><input type="text" style="width:70%" id="" name="" /></li>
			  <li><strong>手机号码：</strong>
				  <input type="text" style="width: 40%" id="" name="" /></li>

			  <li><strong>是否欠费：</strong><input type="radio" name="radio1" class="icheckS" checked id=""> 是 <input type="radio" class="icheckS" name="radio1" id=""> 否</li>
			  <li><strong>是否融合： </strong><input type="radio" name="radio2" class="icheckS" checked id=""> 是 <input type="radio" class="icheckS" name="radio2" id=""> 否</li>
			  <li class="twoRow"><strong>欠费金额：</strong><input type="text" style="width: 33%" id="" name="" /> - <input type="text" style="width: 33%" id="" name="" /></li>

			  <li><strong>是否高套餐： </strong><input type="radio" name="radio3" class="icheckS" checked id=""> 是 <input type="radio" name="radio3" id=""> 否</li>
			  <li><strong>协议到期时间： </strong> <input class="easyui-datebox" style="width: 45%" id="" name="update_date"></li>
			  <li><strong>余额： </strong><input type="text" style="width: 45%" id="" name="" /></li>
			  <li><strong>客户类型： </strong><select name="" id=""><option>类型</option></select></li>
			  <li><strong>用户状态： </strong><select name="" id=""><option>类型</option></select></li>
			  <li><strong>是否电子渠道偏好： </strong><input type="radio" name="radio4" class="icheckS" checked id=""> 是 <input type="radio" class="icheckS" name="radio4" id=""> 否</li>
			  <li><strong>合约类型： </strong><select name="" id=""><option>类型</option></select></li>
			  <li><strong>渠道类型：</strong><select name="" id=""><option>类型</option></select></li>
			  <li><strong>是否办理： </strong><input type="radio" name="radio5" class="icheckS" checked id=""> 是 <input type="radio" class="icheckS" name="radio5" id=""> 否</li>
			  <li><strong>是否接触： </strong><input type="radio" name="radio6" class="icheckS" checked id=""> 是 <input type="radio" class="icheckS" name="radio6" id=""> 否</li>
			  <li><strong>接触结果： </strong><select name="" id=""><option>类型</option></select></li>
			  <li><strong>工单结束时间： </strong><input class="easyui-datebox" style="width: 45%" id="" name="update_date"></li>
			  <li><strong>工单产生月份： </strong><input class="easyui-datebox" style="width: 45%" id="" name="update_date"></li>
		  </ul>
		 <p><a href="javascript:void(0);" class="easyui-linkbutton" onclick="">查询</a> <a href="javascript:void(0);" id="searchShow" class="easyui-linkbutton" onclick="toggleSearch()">更多搜索条件</a></p>
	  </div>
	  <!--高级搜索-->
  </div>
  <div class="datagridTool">
	  <h3>回顾历史记录</h3>
	  <a href="#this" class="showTool" onclick="showSlide()"><span>显示右侧菜单</span></a>
  </div>
  <div class="toolSlide" id="toolSlide">
	  <div class="toolHeader">
		  <h3>选择需要显示的字段</h3>
		  <a href="javascript:void(0);" class="easyui-linkbutton" onclick="closeSlide()">确定</a>
	  </div>
	  <div class="toolBody" >
		  <ul>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">工单号</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">欠费月数</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">工单状态</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">ARPU值</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">活动名称</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">手机号码</label></li>
			  <li class="twoRow"><label><input type="checkbox" name=""  class="icheckS" id="">是否电子渠道偏好用户</label></li>
			  <li class="twoRow"><label><input type="checkbox" name=""  class="icheckS" id="">是否高套餐（96元及以上）</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">是否接触</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">是否融合</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">是否办理</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">客户类型</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">接触结果</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">在网时长</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">接触备注</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">价值等级</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">客户姓名</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">产品类型</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">联系电话</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">入网渠道</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">套餐名</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">合约类型</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">用户状态</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">合约名称</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">余额</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">协议到期时间</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">是否欠费</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">工单结束时间</label></li>
			  <li><label><input type="checkbox" name=""  class="icheckS" id="">欠费金额</label></li>
		  </ul>
	  </div>
  </div>
  <table id="dg" class="easyui-datagrid" title="" style="width:100%;"
		 data-options="singleSelect:true,collapsible:true,url:'datagrid_data.json',method:'get',fit:true,pagination:true">
	  <thead>
	  <tr>
		  <th data-options="field:'d1',resizable:false,align:'center'" width="8%">执行</th>
		  <th data-options="field:'d2'" width="8%">工单状态</th>
		  <th data-options="field:'d3',align:'center'" width="7%">手机号码</th>
		  <th data-options="field:'d4',align:'center'" width="7%">客户姓名</th>
		  <th data-options="field:'d5'" width="10%">联系电话</th>
		  <th data-options="field:'d6',align:'center'" width="10%">在网时长</th>
		  <th data-options="field:'d7',align:'center'" width="10%">余额</th>
		  <th data-options="field:'d8',align:'center'" width="10%">套餐名</th>
		  <th data-options="field:'d9',align:'center'" width="10%">ARPU值</th>
		  <th data-options="field:'d10',align:'center'" width="10%">协议到期时间</th>
		  <th data-options="field:'d11',align:'center'" width="10%">欠费</th>
	  </tr>
	  </thead>
  </table>

  </body>
</html>

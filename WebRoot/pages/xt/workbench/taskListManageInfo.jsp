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
			  $(".widget-container-col").eq(0).find(".widget-body").show();
			  $(".widget-header").click(function(){
				  $(this).next(".widget-body").toggle();
				  $(this).parents(".widget-container-col").siblings().find(".widget-body").hide();
			  });
		  });


	  </script>
  </head>
  		<e:description>经责领域码表查询</e:description>
  <body>
  <div class="easyui-layout" data-options="fit:true" style="overflow-y: visible">
	  <!-- 框架顶部 -->
	  <div data-options="region:'north', border:false" style="background: #f2f2f2;">
		  <!-- 基本信息 -->
		  <div class="boxSpecial" style="width:40%; height: 270px;">
			  <div class="h2Special">
				  <h2>用户基本信息</h2><a class="easyui-linkbutton" href="javascript:void(0)"><i class="bonc-icon fa fa-comment-o"></i>更多信息</a>
			  </div>
			  <table cellspacing="0" cellpadding="0" border="0" class="tableSpecial">
				  <colgroup>
					  <col width="25%" />
					  <col width="25%" />
					  <col width="25%" />
					  <col width="*" />
				  </colgroup>
				  <tbody>
				  <tr>
					  <th class="blue"><span>王小虎</span></th>
					  <td class="blue">先生</td>
					  <td class="blue" colspan="2">13888888888</td>
				  </tr>
				  <tr>
					  <th>在网时长：</th>
					  <td>2年4个月</td>
					  <th>账户余额：</th>
					  <td><em>308元</em></td>
				  </tr>
				  <tr>
					  <th>积分：</th>
					  <td>3648</td>
					  <th>欠费金额：</th>
					  <td><em>0元</em></td>
				  </tr>
				  <tr>
					  <th>业务类型：</th>
					  <td>4G</td>
					  <th>欠费最早时长：</th>
					  <td><em>0日</em></td>
				  </tr>
				  <tr>
					  <th>价值等级：</th>
					  <td>高级</td>
					  <th>户均流量：</th>
					  <td>400M</td>
				  </tr>
				  </tbody>
			  </table>
			  <table cellpadding="0"cellspacing="0" class="tableLevel">
				  <colgroup>
					  <col width="33%" />
					  <col width="33%" />
					  <col width="*" />
				  </colgroup>
				  <tbody>
				  <tr>
					  <th>正常在用</th>
					  <th class="star">
						  <i class="bonc-icon fa fa-star"></i>
						  <i class="bonc-icon fa fa-star"></i>
						  <i class="bonc-icon fa fa-star"></i>
					  </th>
					  <th class="red">¥&nbsp;168.00</th>
				  </tr>
				  <tr>
					  <td>用户状态</td>
					  <td>用户星级</td>
					  <td>ARPU</td>
				  </tr>
				  </tbody>
			  </table>
		  </div>
		  <!-- //基本信息 -->
		  <!-- 产品信息 -->
		  <div class="boxSpecial" style="width:27%; height: 270px;">
			  <div class="h2Special">
				  <h2>产品信息</h2>
			  </div>
			  <table cellpadding="0" cellspacing="0" border="0" class="tableSpecial">
				  <colgroup>
					  <col width="40%" />
					  <col width="*" />
				  </colgroup>
				  <tbody>
				  <tr>
					  <th>套餐名称：</th>
					  <td>套餐名称A</td>
				  </tr>
				  <tr>
					  <th>合约类型：</th>
					  <td>合约类型A</td>
				  </tr>
				  <tr>
					  <th>合约名称：</th>
					  <td>合约名称A</td>
				  </tr>
				  <tr>
					  <th>合约开始日期：</th>
					  <td><span>2016-09-09</span></td>
				  </tr>
				  <tr>
					  <th>合约结束日期：</th>
					  <td><span>2016-09-09</span></td>
				  </tr>
				  <tr>
					  <th>合约剩余月份：</th>
					  <td><span>9个月</span></td>
				  </tr>
				  </tbody>
			  </table>
		  </div>
		  <!-- //产品信息 -->
		  <!-- 终端信息 -->
		  <div class="boxSpecial" style="width:27%; height: 270px;">
			  <div class="h2Special">
				  <h2 class="blue">终端信息</h2>
			  </div>
			  <table cellpadding="0" cellspacing="0" border="0" class="tableSpecial tableSpecialBlue">
				  <colgroup>
					  <col width="40%" />
					  <col width="*" />
				  </colgroup>
				  <tbody>
				  <tr>
					  <th>终端品牌：</th>
					  <td>iPhone</td>
				  </tr>
				  <tr>
					  <th>终端机型：</th>
					  <td>iPhone6s plus</td>
				  </tr>
				  <tr>
					  <th>网络制式：</th>
					  <td>网络制式A</td>
				  </tr>
				  </tbody>
			  </table>
		  </div>
		  <!-- //终端信息 -->
	  </div>
	  <!-- 子页容器 -->
	  <div data-options="region:'center', border:false">
		  <div class="widget-container-col">
			  <div class="widget-box collapsed">
				  <!-- #section:custom/widget-box.options.collapsed -->
				  <div class="widget-header">
					  <h4 class="widget-title">
						  <span class="img01"></span>
                         <span class="Left">
                            4G登网活动
                             <span class="pointsImg01"></span>
                             <span class="pointsText01">100</span>
                         </span>
                         <span class="Right">
                                <span>回访状态: <i class="bonc-icon fa fa-circle"></i> 已回访</span>
                                <span>回访时间：2016-09-09 15：34</span>
                         </span>

					  </h4>

					  <div class="widget-toolbar">
						  <a href="#" data-action="collapse">
							  <i class="ace-icon fa fa-sort-down" data-icon-show="fa-sort-down" data-icon-hide="fa-sort-up"></i>
						  </a>
					  </div>
				  </div>

				  <div class="widget-body">
					  <div class="widget-main">
						  <div class="h2Special">
							  <h2>执行工单</h2><a class="easyui-linkbutton" href="javascript:void(0)"onclick="$('#Record').dialog('open')"><i class="bonc-icon fa fa-history"></i>接触历史</a>
						  </div>
						  <!-- 成功标准 -->
						  <dl class="contentBox contentBoxBlue">
							  <dt>成功标准：</dt>
							  <dd>
								  <p>订购流量包-省内半年流量包，日包</p>
								  <p>订购流量包-省内半年流量包，日包</p>
							  </dd>
						  </dl>
						  <!-- //成功标准 -->
						  <!-- 推荐信息 -->
						  <div class="contentBox contentBoxYellow">
							  <dt>推荐信息：</dt>
							  <dd>
								  <p>订购流量包-省内半年流量包，日包</p>
							  </dd>
						  </div>
						  <!-- //推荐信息 -->
						  <!-- 策略话术短信 -->
						  <div class="buttonGroup">
							  <a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#Marketing').dialog('open')"><i class="bonc-icon fa fa-lightbulb-o"></i>策略</a>
							  <a class="easyui-linkbutton easyui-linkbutton-green" href="javascript:void(0)" onclick="$('#Word').dialog('open')"><i class="bonc-icon fa fa-bullhorn"></i>话术</a>
							  <a class="easyui-linkbutton easyui-linkbutton-red" href="javascript:void(0)" onclick="$('#Message').dialog('open')"><i class="bonc-icon fa fa-envelope-o"></i>短信</a>
						  </div>
						  <!-- //策略话术短信 -->
						  <!-- 接触结果 -->
						  <div class="resultBox">
							  <h3>接触结果</h3>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">同意</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">拒绝</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">有倾向</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">已经办理</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">未接通</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">直接挂断</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">停机</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">关机</a>
							  <textarea  rows="3" cols="20" placeholder="备注文案示例" style="width: 98%;margin: 0 auto; height: 140px"></textarea>
						  </div>
						  <!-- //接触结果 -->
						  <!-- 提交按钮群 -->
						  <div class="submit-box">
							  <a class="easyui-linkbutton" href="javascript:void(0)">返回列表</a>
							  <a class="easyui-linkbutton" href="javascript:void(0)">提交当前工单</a>
							  <a class="easyui-linkbutton" href="javascript:void(0)">提交全部工单</a>
						  </div>
						  <!-- //提交按钮群 -->
					  </div>
				  </div>
			  </div>
		  </div>

		  <div class="widget-container-col">
			  <div class="widget-box collapsed">
				  <!-- #section:custom/widget-box.options.collapsed -->
				  <div class="widget-header">
					  <h4 class="widget-title">
						  <span class="img02"></span>
                         <span class="Left">
                            金秋升级活动
                             <span class="pointsImg02"></span>
                             <span class="pointsText02">100</span>
                         </span>
                         <span class="Right">
                                <span>回访状态: <i class="bonc-icon fa fa-circle red"></i> 已回访</span>
                                <span>回访时间：2016-09-09 15：34</span>
                         </span>

					  </h4>

					  <div class="widget-toolbar">
						  <a href="#" data-action="collapse">
							  <i class="ace-icon fa fa-sort-down" data-icon-show="fa-sort-down" data-icon-hide="fa-sort-up"></i>
						  </a>
					  </div>
				  </div>

				  <div class="widget-body">
					  <div class="widget-main">
						  <div class="h2Special">
							  <h2>执行工单</h2><a class="easyui-linkbutton" href="javascript:void(0)"onclick="$('#Record').dialog('open')"><i class="bonc-icon fa fa-history"></i>接触历史</a>
						  </div>
						  <!-- 成功标准 -->
						  <dl class="contentBox contentBoxBlue">
							  <dt>成功标准：</dt>
							  <dd>
								  <p>订购流量包-省内半年流量包，日包</p>
								  <p>订购流量包-省内半年流量包，日包</p>
							  </dd>
						  </dl>
						  <!-- //成功标准 -->
						  <!-- 推荐信息 -->
						  <div class="contentBox contentBoxYellow">
							  <dt>推荐信息：</dt>
							  <dd>
								  <p>订购流量包-省内半年流量包，日包</p>
							  </dd>
						  </div>
						  <!-- //推荐信息 -->
						  <!-- 策略话术短信 -->
						  <div class="buttonGroup">
							  <a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#Marketing').dialog('open')"><i class="bonc-icon fa fa-lightbulb-o"></i>策略</a>
							  <a class="easyui-linkbutton easyui-linkbutton-green" href="javascript:void(0)" onclick="$('#Word').dialog('open')"><i class="bonc-icon fa fa-bullhorn"></i>话术</a>
							  <a class="easyui-linkbutton easyui-linkbutton-red" href="javascript:void(0)" onclick="$('#Message').dialog('open')"><i class="bonc-icon fa fa-envelope-o"></i>短信</a>
						  </div>
						  <!-- //策略话术短信 -->
						  <!-- 接触结果 -->
						  <div class="resultBox">
							  <h3>接触结果</h3>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">同意</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">拒绝</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">有倾向</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">已经办理</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">未接通</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">直接挂断</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">停机</a>
							  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">关机</a>
							  <textarea  rows="3" cols="20" placeholder="备注文案示例" style="width: 98%;margin: 0 auto; height: 140px"></textarea>
						  </div>
						  <!-- //接触结果 -->
						  <!-- 提交按钮群 -->
						  <div class="submit-box">
							  <a class="easyui-linkbutton" href="javascript:void(0)">返回列表</a>
							  <a class="easyui-linkbutton" href="javascript:void(0)">提交当前工单</a>
							  <a class="easyui-linkbutton" href="javascript:void(0)">提交全部工单</a>
						  </div>
						  <!-- //提交按钮群 -->
					  </div>
				  </div>
			  </div>
		  </div>
		  <div class="widget-container-col">
			  <div class="widget-box collapsed">
				  <!-- #section:custom/widget-box.options.collapsed -->
				  <div class="widget-header">
					  <h4 class="widget-title">
						  <span class="img03"></span>
                         <span class="Left">
                            终端换机活动
                             <span class="pointsImg03"></span>
                             <span class="pointsText03">100</span>
                         </span>
                         <span class="Right">
                                <span>回访状态: <i class="bonc-icon fa fa-circle"></i> 已回访</span>
                                <span>回访时间：2016-09-09 15：34</span>
                         </span>

					  </h4>

					  <div class="widget-toolbar">
						  <a href="#" data-action="collapse">
							  <i class="ace-icon fa fa-sort-down" data-icon-show="fa-sort-down" data-icon-hide="fa-sort-up"></i>
						  </a>
					  </div>
				  </div>

				  <div class="widget-body">
					  <div class="widget-main">
						  <div class="boxSpecial" style="width:98%;">
							  <div class="h2Special">
								  <h2>执行工单</h2><a class="easyui-linkbutton" href="javascript:void(0)"onclick="$('#Record').dialog('open')"><i class="bonc-icon fa fa-history"></i>接触历史</a>
							  </div>
							  <!-- 成功标准 -->
							  <dl class="contentBox contentBoxBlue">
								  <dt>成功标准：</dt>
								  <dd>
									  <p>订购流量包-省内半年流量包，日包</p>
									  <p>订购流量包-省内半年流量包，日包</p>
								  </dd>
							  </dl>
							  <!-- //成功标准 -->
							  <!-- 推荐信息 -->
							  <div class="contentBox contentBoxYellow">
								  <dt>推荐信息：</dt>
								  <dd>
									  <p>订购流量包-省内半年流量包，日包</p>
								  </dd>
							  </div>
							  <!-- //推荐信息 -->
							  <!-- 策略话术短信 -->
							  <div class="buttonGroup">
								  <a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#Marketing').dialog('open')"><i class="bonc-icon fa fa-lightbulb-o"></i>策略</a>
								  <a class="easyui-linkbutton easyui-linkbutton-green" href="javascript:void(0)" onclick="$('#Word').dialog('open')"><i class="bonc-icon fa fa-bullhorn"></i>话术</a>
								  <a class="easyui-linkbutton easyui-linkbutton-red" href="javascript:void(0)" onclick="$('#Message').dialog('open')"><i class="bonc-icon fa fa-envelope-o"></i>短信</a>
							  </div>
							  <!-- //策略话术短信 -->
							  <!-- 接触结果 -->
							  <div class="resultBox">
								  <h3>接触结果</h3>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">同意</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">拒绝</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">有倾向</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">已经办理</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">未接通</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">直接挂断</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">停机</a>
								  <a class="easyui-linkbutton easyui-linkbutton-Outline" href="javascript:void(0)">关机</a>
								  <textarea  rows="3" cols="20" placeholder="备注文案示例" style="width: 98%;margin: 0 auto; height: 140px"></textarea>
							  </div>
							  <!-- //接触结果 -->
							  <!-- 提交按钮群 -->
							  <div class="submit-box">
								  <a class="easyui-linkbutton" href="javascript:void(0)">返回列表</a>
								  <a class="easyui-linkbutton" href="javascript:void(0)">提交当前工单</a>
								  <a class="easyui-linkbutton" href="javascript:void(0)">提交全部工单</a>
							  </div>
							  <!-- //提交按钮群 -->
						  </div>
					  </div>
				  </div>
			  </div>
		  </div>

	  </div>
	  <!-- window -->
	  <div id="Marketing" class="easyui-window" title="营销策略" style="top:200px; width:500px;height:260px;padding:10px" data-options="closed:true">
		  <p>本客户是IT企业高层领导，需要长时间出差，可以从流量包为话题切入</p>
	  </div>
	  <div id="Word" class="easyui-window" title="话术" style="top:200px; width:500px;height:260px;padding:10px" data-options="closed:true">
		  <p>1、本客户是IT企业高层领导，需要长时间出差，可以从流量包为话题切入</p>
		  <p>1、本客户是IT企业高层领导，需要长时间出差，可以从流量包为话题切入</p>
		  <p>1、本客户是IT企业高层领导，需要长时间出差，可以从流量包为话题切入</p>
		  <p>1、本客户是IT企业高层领导，需要长时间出差，可以从流量包为话题切入</p>
	  </div>
	  <div id="Message" class="easyui-window" title="短信" style="top:200px; width:500px;height:260px;padding:10px" data-options="closed:true">
		  <p><textarea  rows="3" cols="20" placeholder="输入短信模版内容" style="width: 98%;margin: 0 auto; height: 140px"></textarea></p>
		  <a class="easyui-linkbutton" href="javascript:void(0)">发送</a>
	  </div>

	  <div id="Record" class="easyui-window" title="回访历史记录" style="top:200px; width:800px;height:400px;" data-options="closed:true">
		  <table class="easyui-datagrid" style="width:100%;"
				 data-options="singleSelect:true,collapsible:true,url:'datagrid_data1.json',method:'get'">
			  <thead>
			  <tr>
				  <th data-options="field:'name'" width="25%">活动名称</th>
				  <th data-options="field:'size'" width="25%">回访结果</th>
				  <th data-options="field:'date'" width="25%">回访时间</th>
				  <th data-options="field:'date'" width="29%" align="left">备注</th>
			  </tr>
			  </thead>
		  </table>

	  </div>
	  <!-- //window -->

  </div>
  </body>

</html>

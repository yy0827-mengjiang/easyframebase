<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<e:set var="kpiCategory">${param.kpi_category }</e:set>
<e:q4l var="unit">select code,name from x_kpi_code where type='0'</e:q4l>
<e:set var="unitJson">${e:java2json(unit.list) }</e:set>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
<e:script
	value="/resources/easyResources/component/easyui/jquery.easyui.min.js" />
<script type="text/javascript">
	$(function() {
		var unit = ${unitJson};
		var vUnit = $('#kpi_unit0');
		for (var i = 0; i < unit.length; i++) {
			vUnit.append("<option value='"+unit[i].CODE+"'>" + unit[i].NAME
					+ "</option>");
		}
	});
</script>
<body id="underLine">
	<div class="easyui-panel newAddkpi" title="新增指标">
		<div class="comOutBox">
			<!--titOut-->
			<div class="titOut">
				<h3>
					<span>复合指标组成</span>
				</h3>
			</div>
			<!--//titOut-->
			<!--comInbox-->
			<div class="comInbox">
				<input type="hidden" id="kpiCode" name="kpiCode"> <input
					type="hidden" id="code" name="code" value="${code }"> <input
					type="hidden" id="complexkpiCode" name="complexkpiCode"> <input
					type="hidden" id="hidForms" name="hidForms"> <input
					type="hidden" id="kpiVersion" name="kpiVersion" value="0">
				<input type="hidden" id="kpiCategory" name="kpiCategory"
					value="${kpiCategory }">

				<dl class="group">
					<dt class="topLine">指标名称：</dt>
					<dd>
						<input type="text" id="kpi_name0" name="kpi_name0" width="45%"
							style="height: 22px;" class="noSearch"> <input
							type="hidden" id="isFormula" name="isFormula" value="1">
						<span class="pl6">指标单位：</span><select id="kpi_unit0"
							name="kpi_unit0"></select>
					</dd>
				</dl>
				<dl>
					<dt>指标公式：</dt>
					<dd>
						<div id="formKpi" myAttr="formkpi" contenteditable="true"
							class="formEdit"
							onclick="saveRange();clickArea(window.event,'formKpi')"
							onkeydown="saveRange();" onkeyup="saveRange();" tabIndex='-1'></div>
					</dd>
				</dl>
			</div>
			<!--//comInbox-->
			<div id="conditionDiv" class="condDiv" " myAttr="condition"
				myChil="conditionTable"
				onclick="clickArea(window.event,'conditionDiv')">

				<!--titOut-->
				<div class="titOut">
					<h3>
						<span>约束条件</span>
					</h3>
				</div>
				<!--//titOut-->
				<!--comInbox-->
				<div class="comInbox">
					<input type="hidden" name="dIndex" id="dIndex" />
					<!-- 条件id -->
					<c:datagrid url="#" id="conditionTable" pagination="false"
						rownumbers="true" onDblClickRow="chooseTjz">
						<thead>
							<tr>
								<th data-options="field:'ljf',width:100">连接符</th>
								<th data-options="field:'dimName',width:100">维度名称</th>
								<th data-options="field:'ljkjf',width:100">逻辑符</th>
								<th data-options="field:'tjz',width:100">条件值</th>
							</tr>
						</thead>
					</c:datagrid>
				</div>
			</div>
			<div id="tb">
				<ul class="btnItem1">
					<li><a href="javascript:void(0)" class="deleteBtn" iconCls="icon-remove"
						onClick="removekpi();" plain="true">删除条件</a></li>
				</ul>
			</div>
			<!--titOut-->
			<div class="titOut">
				<h3>
					<span>手动输入约束条件</span>
				</h3>
			</div>
			<div>
				<input type="text" id="condition" name="condition"  placeholder="多个and之间请使用空格进行分格"
					style="width:100%">
			</div>
			<div class="titOut">
				<h3>
					<span>指标口径、解释</span>
				</h3>
			</div>
			<!--//titOut-->
			<!--comInbox-->
			<div class="comInbox">
				<dl class="group">
					<dt>指标口径：</dt>
					<dd>
						<textarea rows="3" id="kpiCalIber" name="kpiCalIber" style="width:100%"></textarea>
					</dd>
				</dl>
				<dl class="group">
					<dt>指标解释：</dt>
					<dd>
						<textarea rows="3" id="kpiExplain" name="kpiExplain" style="width: 100%"></textarea>
					</dd>
				</dl>

			</div>
			<!--titOut-->
			<div div class="titOut">
				<h3>
					<span>指标出处</span>
				</h3>
			</div>
			<!--//titOut-->
			<div div class="comInbox">
				<p class="titleSearch">
					指标提出人：<input type="text" id="kpiUser" name="kpiUser">
					指标提出部门：&nbsp;<input type="text" id="kpiDept" name="kpiDept">
				</p>
				<p class="titleSearch">
					指标需求：
					<textarea rows="3" id="kpiFile" name="kpiFile" style="width: 80%"></textarea>
				<p>
			</div>

			<!--//comInbox-->
			<!--titOut-->

			<!--//comInbox-->
			<div class="centerBtnItem">
				<p>
					<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
						onclick="onAgree2()">保存</a>
				</p>
			</div>
		</div>

		<div id="tjz-dlg" class="easyui-dialog" title="条件值"
			style="width:460px;height:430px;"
			data-options="closed:true,modal:true" buttons="#dlg-buttons">
			<div class="twoSelectOut">
				<input type="hidden" id="rowIndex" name="rowIndex">
				<div>
					连接符：<select id="ljkjf" name="ljkjf" style="width:90%;">
						<option value="and">并且</option>
						<option value='or'>或者</option>
					</select>
				</div>
				<div>
					运算符：<select id="ljf_name" name="ljf_name" style="width:90%;">
						<option value='0'>等于</option>
						<option value='1'>包含</option>
						<option value='2'>大于</option>
						<option value='3'>小于</option>
						<option value='4'>不等于</option>
						<option value='5'>大于等于</option>
						<option value='6'>小于等于</option>
						<option value='7'>为空</option>
						<option value='8'>不为空</option>
					</select>
				</div>
				<div class="group">
					<div class="twoSelectL">
						<h4>维度</h4>
						<select id="dim1" name="dim1" style="width:190px; height: 200px;"
							multiple="multiple">
						</select>
					</div>
					<div class="twoSelectM">
						<a href="javascript:void(0)" class="easyui-linkbutton" onClick="leftToRight()"
							plain="true">&gt;&gt;</a> <a href="javascript:void(0)" class="easyui-linkbutton"
							onClick="rightToLeft()" plain="true">&lt;&lt;</a>
					</div>
					<div class="twoSelectR">
						<h4>值</h4>
						<select id="dim_value1" name="dim_value1"
							style="width:190px; height: 200px;" multiple="multiple">
						</select>
					</div>
				</div>
				<div class="twoSelectB">
					<p>
						<input type="checkbox" id="constant" name="constant"
							onclick="onConstant()">&nbsp;&nbsp;常量值 : <input
							type="text" id="clz0" name="clz0" style="width:350px;">
					</p>
					<div id="dlg-buttons1">
						<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
							onclick="onAgree()">确认</a>
					</div>
				</div>
			</div>
		</div>

	</div>
</body>

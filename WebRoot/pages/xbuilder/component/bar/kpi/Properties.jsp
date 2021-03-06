<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div class="propertiesPane">
	<h4>图表元素设置</h4>
	<div class="ppInterArea">
		<dl>
		  <dt>标题</dt>
		  <dd>
		    <input type="text" id="bar_title" class="wih_146" name="bar_title" onblur="bar_fun_SetTitle()" />&nbsp;
		    <input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
		  </dd>
		</dl>
	</div>
	<h4>数据设置</h4>
	<div class="ppInterArea">
	<a:kpiSelector id="barKpiSelector"></a:kpiSelector>
		<dl>
		   <dt></dt>
           <dd>
                <a class="openKpi" href="javascript:openBarKpiDialog()">打开指标库...</a>
                <a:kpiCaculateColumn id="barCaculateColumn" updateDatasetUiFunction="barUpdataDatasetUI"></a:kpiCaculateColumn>
           </dd>
		  <dt>维度列：</dt>
		  <dd>
		    <input id="bar_dim"  name="bar_dim" class="wih_176" readonly="readonly"/>
		  </dd>
		  <dt>排序列：</dt>
		  <dd>
		    <input id="bar_ord"  name="bar_ord" class="wih_176" readonly="readonly"/>
		  </dd>
		  <dt>排序方式</dt>
          <dd>
          	   <select class="easyui-combobox wih_182" id="bar_sorttype" data-options="onSelect:bar_fun_SetOrd">
						<option value="asc">正序</option>
						<option value="desc">倒序</option>
				</select>
          </dd>
		  <dd class="blockDd">
		    <div class="ppSetItem">
		      <table id="bar_tb2">
		        <thead>
		          <tr>
		            <th>指标列</th>
		            <th>指标名</th>
		            <th>颜色</th>
		            <th>y轴</th>
		          </tr>
		        </thead>
		      </table>
		      <ul class="btnItem1">
		        <li><a class="addBtn" href="javascript:void(0)" onclick="bar_appendKpiRow();">添加</a></li>
		        <li><a class="deleteBtn" href="javascript:void(0)" onclick="bar_removeKpiRow();">删除</a></li>
		      </ul>
		    </div>
		  </dd>
		</dl>
	</div>
	<h4>样式设置</h4>
	<div class="ppInterArea">
		<jsp:include page="../../ChartStyleSetter.jsp?chartType=bar&yAxis=${param.yAxis}"></jsp:include>
		<input type="hidden" id="curSelectInput"/>
		
		<!-- 添加指标行html模板 -->
		<table id="kpiRowHtml" class="none_dis">
		  <tr>
		    <td class="wih_120"><input name="bar_ser" class="bar_ser wih_80" value="" readonly="readonly"></td>
		    <td><input type="text" name="bar_sername" class="wih_100" onblur="bar_fun_SetKpi()"/></td>
		    <td><input type="text" name="bar_colour" class="colorpk" value="#fff"></td>
		    <td><input name="bar_ref" class="bar_ref wih_40" value="0" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:bar_fun_SetKpi"></td>
		  </tr>
		</table>
	</div>
</div>

<script>
	  $(function(){
		 bar_initDroppable();
	  });
	</script>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div class="propertiesPane">
  <h4>图表元素设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt>标题：</dt>
    <dd>
      <input type="text" id="line_title" class="wih_146" name="line_title" onblur="line_fun_SetTitle()" />&nbsp;
      <input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
    </dd>
  </dl>
  </div>
  <h4>数据设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt>数据集：</dt>
    <dd>
      <input id="line_data" name="line_data" value="请选择" class="easyui-combobox" style="width:140px;" validType="dataSet['数据集']" 
						data-options="url:appBase+'/getAllDataSourceJsonX.e?report_id=${param.report_id }',valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,onSelect:line_showColumn" />
	  <a:caculateColumn dataSetCombId="line_data" id="lineCaculateColumn" updateDatasetUiFunction="lineUpdataDatasetUI"></a:caculateColumn>
      </dd>
    <dt>维度列：</dt>
    <dd>
      <input id="line_dim"  name="line_dim"  class="easyui-combobox" style="width:240px;" validType="dataSet['维度']" 
		                          data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:line_fun_SetDim,onShowPanel:line_onShowPanel" />
    </dd>
    <dt>排序列：</dt>
    <dd>
      <input id="line_ord"  name="line_ord"  class="easyui-combobox" style="width:80px;" validType="dataSet['排序']" 
		                          data-options="valueField:'id', textField:'text', multiple:false, panelWidth:245, panelHeight:160,editable:false,onSelect:line_fun_SetOrd" />
		        &nbsp;<select class="easyui-combobox wih_65" id="line_kpitype" data-options="onSelect:line_fun_SetOrd">
						<option value="dim">维度</option>
						<option value="kpi">指标</option>
				</select>
				&nbsp;<select class="easyui-combobox wih_65" id="line_sorttype" data-options="onSelect:line_fun_SetOrd">
						<option value="asc">正序</option>
						<option value="desc">倒序</option>
				</select>    
    </dd>
    
    <dd class="blockDd">
      <div class="ppSetItem">
        <table id="line_tb2">
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
          <li><a class="easyui-linkbutton" href="javascript:void(0)" onclick="line_appendKpiRow();">添加</a></li>
          <li><a class="easyui-linkbutton easyui-linkbutton-red" href="javascript:void(0)" onclick="line_removeKpiRow();">删除</a></li>
        </ul>
      </div>
    </dd>
  </dl>
  </div>
  <h4>样式设置</h4>
  <div class="ppInterArea">
  <jsp:include page="../../ChartStyleSetter.jsp?chartType=line&yAxis=${param.yAxis}"></jsp:include>


<!-- 添加指标行html模板 -->
<table id="kpiRowHtml" class="none_dis">
  <tr>
    <td><input name="line_ser" class="line_ser" style="width:80px;" value="请选择" data-options="valueField:'id',textField:'text',multiple:false,panelWidth:180,editable:false,onSelect:line_selectSer,onShowPanel:line_onShowPanel"></td>
    <td><input type="text" name="line_sername" style="width:100px;" onblur="line_fun_SetKpi()"/></td>
    <td><input type="text" name="line_colour" class="colorpk" value="#fff"></td>
    <td><input name="line_ref" class="line_ref wih_40" value="0" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:line_fun_SetKpi"></td>
  </tr>
</table>
</div>
</div>


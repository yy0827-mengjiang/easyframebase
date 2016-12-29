<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

<div class="propertiesPane">
  <h4>图表元素设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt>标题：</dt>
    <dd>
      <input type="text" class="wih_146" id="pie_title" name="pie_title" onblur="pie_fun_SetTitle()" />&nbsp;
      <input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
    </dd>
  </dl>
  </div>
  <h4>数据设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt> 数据集： </dt>
    <dd>
    <input id="pie_data" name="pie_data" value="请选择" class="easyui-combobox" style="width:140px;" validType="dataSet['数据集']" 
        data-options="url:appBase+'/getAllDataSourceJsonX.e?report_id=${param.report_id }',valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,onSelect:pie_showColumn" /> 
    <a:caculateColumn dataSetCombId="pie_data" id="pieCaculateColumn" updateDatasetUiFunction="pieUpdataDatasetUI"></a:caculateColumn>    
    </dd>
    
    <dt> 维度列： </dt>
    <dd>
      <input id="pie_dim"  name="pie_dim"  class="easyui-combobox " style="width:240px;" validType="dataSet['维度']" 
                    data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:pie_fun_SetDim,onShowPanel:pie_onShowPanel" />
    </dd>
    <dt> 指标列： </dt>
    <dd>
      <input class="easyui-combobox" style="width:240px;" name="pie_ser" id="pie_ser" value="请选择" validType="dataSet['指标']"
          data-options="valueField:'id',textField:'text', multiple:false, panelHeight:160,panelWidth:0,editable:false,onSelect:pie_fun_setSer,onShowPanel:pie_onShowPanel" />
    </dd>
    <dt> 指标名： </dt>
    <dd>
      <input type="text" style="width:225px;"  id="pie_kpi_name" name="pie_kpi_name" onblur="pie_fun_SetKpiName()"/>
    </dd>
    <dt> 排序列： </dt>
    <dd>
      <input id="pie_ord" name="pie_ord"  class="easyui-combobox" style="width:90px;" validType="dataSet['排序']" 
                    data-options="valueField:'id', textField:'text', multiple:false, panelWidth:245, panelHeight:160,editable:false,onSelect:pie_fun_SetOrd" />
                &nbsp;<select class="easyui-combobox wih_65"  id="pie_kpitype" data-options="onSelect:pie_fun_SetOrd">
						<option value="dim">维度</option>
						<option value="kpi">指标</option>
				</select>
				&nbsp;<select class="easyui-combobox wih_65" id="pie_sorttype" data-options="onSelect:pie_fun_SetOrd">
						<option value="asc">正序</option>
						<option value="desc">倒序</option>
				</select>    
    </dd>
    <dt> 单&nbsp;&nbsp;位：</dt>
    <dd>
      <input type="text" style="width:140px" name="pie_unit" id="pie_unit" onblur="pie_fun_SetUnit()"/>
    </dd>
  <dl>
  </div>
  <h4>样式设置</h4>
  <div class="ppInterArea">
  <jsp:include page="../../ChartStyleSetter.jsp?chartType=pie"></jsp:include>
  </div>
</div>

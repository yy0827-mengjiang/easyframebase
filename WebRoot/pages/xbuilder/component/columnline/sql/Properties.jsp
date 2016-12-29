<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<div class="propertiesPane">
  <h4>图表元素设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt>标题： </dt>
    <dd>
      <input type="text" id="columnline_title" class="wih_146" name="columnline_title" onblur="columnline_fun_SetTitle()" />&nbsp;
      <input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
    </dd>
  </dl>
  </div>
  <h4>数据设置</h4>
  <div class="ppInterArea">
  <dl>
    <dt> 数据集：</dt>
    <dd>
      <input id="columnline_data" name="columnline_data" value="请选择" class="easyui-combobox" style=" width:140px;" validType="dataSet['数据集']" 
					data-options="url:appBase+'/getAllDataSourceJsonX.e?report_id=${param.report_id }',valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,onSelect:columnline_showColumn" /> 
	 <a:caculateColumn dataSetCombId="columnline_data" id="columnlineCaculateColumn" updateDatasetUiFunction="columnlineUpdataDatasetUI"></a:caculateColumn>
	 </dd>
     <dt> 维度列：</dt>
    <dd>
      <input id="columnline_dim" name="columnline_dim"  class="easyui-combobox"  style=" width:240px;"  validType="dataSet['维度']" 
	                          data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:columnline_fun_SetDim,onShowPanel:columnline_onShowPanel" />
    </dd>
    <dt> 排序列：</dt>
    <dd>
      <input id="columnline_ord" name="columnline_ord"  class="easyui-combobox"  style=" width:80px;"  validType="dataSet['排序']" 
	                          data-options="valueField:'id', textField:'text', multiple:false, panelWidth:245, panelHeight:160,editable:false,onSelect:columnline_fun_SetOrd" />
	       &nbsp;<select class="easyui-combobox wih_65" id="columnline_kpitype" data-options="onSelect:columnline_fun_SetOrd">
						<option value="dim">维度</option>
						<option value="kpi">指标</option>
				</select>
				&nbsp;<select class="easyui-combobox wih_65" id="columnline_sorttype" data-options="onSelect:columnline_fun_SetOrd">
						<option value="asc">正序</option>
						<option value="desc">倒序</option>
				</select>                         
    </dd>
    <dd class="blockDd">
      <div class="ppSetItem">
        <table id="columnline_tb2">
          <thead>
            <tr>
              <th width="25%">指标列</th>
              <th width="17%">指标名</th>
              <th width="22%">颜色</th>
              <th width="18%">类别</th>
              <th width="18%">y轴</th>
            </tr>
          </thead>
        </table>
        <ul class="btnItem1">
          <li><a class="easyui-linkbutton" href="javascript:void(0)" onclick="columnline_appendKpiRow();">添加</a></li>
          <li><a class="easyui-linkbutton easyui-linkbutton-red" href="javascript:void(0)" onclick="columnline_removeKpiRow();">删除</a></li>
        </ul>
      </div>
    </dd>
  </dl>
  </div>
  <h4>样式设置</h4>
  <div class="ppInterArea">
  <jsp:include page="../../ChartStyleSetter.jsp?chartType=columnline&yAxis=${param.yAxis}"></jsp:include>


<!-- 添加指标行html模板 -->
<table id="kpiRowHtml" class="none_dis">
  <tr>
    <td><input name="columnline_ser" class="columnline_ser"  style=" width:70px;"  value="请选择" data-options="valueField:'id',textField:'text',panelWidth:180,multiple:false,editable:false,onSelect:columnline_selectSer,onShowPanel:columnline_onShowPanel"></td>
    <td><input type="text" name="columnline_sername" style=" width:50px;"  onblur="columnline_fun_SetKpi()"/></td>
    <td><input type="text" name="columnline_colour" class="colorpk" value="#fff"></td>
    <td><input name="columnline_type" class="columnline_type"  style=" width:60px;"  data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:columnline_fun_SetKpi"></td>
    <td><input name="columnline_ref" class="columnline_ref wih_40" value="0" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:columnline_fun_SetKpi"></td>
  </tr>
</table>
</div>
</div>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
	<div class="propertiesPane">
		<h4>图表元素设置</h4>
		<div class="ppInterArea">
        <dl>
	        <dt>标题</dt>
	        <dd>
	        	<input type="text" class="wih_146" id="scatter_title" name="scatter_title" onblur="scatter_fun_SetTitle()" />&nbsp;
	        	<input type="checkbox" value="1" id="showTitle" name="showTitle" class="checkN" checked="checked" />&nbsp;显示
	        </dd>
		 </dl>
		</div>
    	<h4>数据设置</h4>
    	<div class="ppInterArea">
        <dl>
            <dt>数据集</dt>
           <dd>
           		<input id="scatter_data" name="scatter_data" value="请选择" class="easyui-combobox" style="width:120px;" validType="dataSet['数据集']" 
					data-options="url:appBase+'/getAllDataSourceJsonX.e?report_id=${param.report_id }',valueField:'id',textField:'text',multiple:false,panelHeight:160,editable:false,onSelect:scatter_showColumn" />
			    <a:caculateColumn dataSetCombId="scatter_data" id="scatterCaculateColumn" updateDatasetUiFunction="scatterUpdataDatasetUI"></a:caculateColumn>
           </dd>
           <dt>X轴指标</dt>
           <dd>
               <input id="scatter_kpiX"  name="scatter_kpiX"  class="easyui-combobox wih_196"
	                          data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:scatter_fun_SelectKpi"/>
           </dd>
           <dt>X轴标题</dt>
           <dd>
                <input id="scatter_kpiX_title"  name="scatter_kpiX_title" class="wih_198 pie_solid" onblur = "scatter_fun_SetKpi()"/>
           </dd>
           <dt>X轴单位</dt>
           <dd>
                <input id="scatter_kpiX_unit"  name="scatter_kpiX_unit" class="wih_198 pie_solid" onblur = "scatter_fun_SetKpi()"/>
           </dd>
           
           <dt>Y轴指标</dt>
           <dd>
                <input id="scatter_kpiY"  name="scatter_kpiY"  class="easyui-combobox wih_196"
	                          data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:scatter_fun_SelectKpi" />
           </dd>
           <dt>Y轴标题</dt>
           <dd>
                <input id="scatter_kpiY_title"  name="scatter_kpiY_title" class="wih_198 pie_solid" onblur = "scatter_fun_SetKpi()"/>
           </dd>
           <dt>Y轴单位</dt>
           <dd>
                <input id="scatter_kpiY_unit"  name="scatter_kpiY_unit" class="wih_198 pie_solid" onblur = "scatter_fun_SetKpi()"/>
           </dd>
           
           <dt>维度列</dt>
           <dd>
                <input id="scatter_dim"  name="scatter_dim"  class="easyui-combobox wih_196" validType="dataSet['维度']" 
	                          data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:scatter_fun_SetDim"/>
           </dd>
           <dt>最小粒度列</dt>
           <dd>
                <input id="scatter_min_dim"  name="scatter_min_dim"  class="easyui-combobox wih_196" validType="dataSet['维度']" 
	                          data-options="valueField:'id', textField:'text', multiple:false, panelHeight:160,editable:false,onSelect:scatter_fun_SetMinDim"/>
           </dd>
           
        </dl>
     </div>
    <h4>样式设置</h4>
    <div class="ppInterArea">
	<jsp:include page="../../ChartStyleSetter.jsp?chartType=scatter"></jsp:include>
	<input type="hidden" id="curSelectInput"/>
	 <!-- 添加指标行html模板 -->
	<table id="kpiRowHtml" class="none_dis">
	  <tr>
		 <td class="wih_90">
			<input type="text" name="scatter_ser" class="scatter_ser wih_40" value="" disabled="disabled"><a class="icoChoose" href="javascript:void(0)">选择</a>
		 </td>
		 <td>
			<input type="text" name="scatter_sername" class="wih_40" onblur="scatter_fun_SetKpi()"/>
		 </td>
		 <td>
			<input type="text" name="scatter_colour" class="colorpk" value="#fff">
		 </td>
		 <td>
			<input name="scatter_ref" class="scatter_ref wih_40" value="0" data-options="valueField:'id',textField:'text',multiple:false,panelHeight:160,onSelect:scatter_fun_SetKpi">
		 </td>
	  </tr>
	  </table>
	</div>
	</div>


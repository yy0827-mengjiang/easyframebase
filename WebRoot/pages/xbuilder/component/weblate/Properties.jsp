<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>

	<div class="propertiesPane">
		<h4>设置页面模版</h4>
		<div class="ppInterArea">
			<dl>
			<dt>标题</dt>
	        <dd>
	        	<input type="text" class="wih_204" id="column_title" name="column_title" onblur="column_fun_webTitle()" />&nbsp;
	        </dd>
	        <dt>地址</dt>
	        <dd>
	        	<textarea id="column_url" name="column_url" onblur="column_fun_webUrl()" style="width:200px; height:56px"></textarea>
	        </dd>
	        
	        <dd class="blockDd">
           		<div class="ppSetItem">
				<table id="column_tb2">
					<thead>
						<tr>
							<th>参数名</th>
							<th>参数值</th>
						</tr>
					</thead>
				</table>
					<ul class="btnItem1">
						<li><a class="easyui-linkbutton" href="javascript:void(0)" onclick="column_appendwebRow();">添加</a></li>
          	    		<li><a class="easyui-linkbutton easyui-linkbutton-red" href="javascript:void(0)" onclick="column_removewebRow();">删除</a></li>
					</ul>
				</div>
          	 </dd>
			</dl>
		</div>
		
	</div>
	
	<!-- 添加指标行html模板 -->
	<table id="kpiRowHtml" class="none_dis">
	  <tr>
		 <td>
		 	<input type="text" name="column_sername" class="wih_100" onblur="column_varname(this)"/>
		 </td>
		 <td>
		 	<input name="column_ser" class="column_ser wih_100" value="请选择" data-options="valueField:'id',textField:'text',multiple:false,panelWidth:180,editable:false,onSelect:column_desname">
		 </td>
	  </tr>
  	</table>
  	
<script type="text/javascript">
	 column_appendwebRow();
</script>
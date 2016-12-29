<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:if condition="${applicationScope['xdbauth'] == '1'}" var="dataSourceElse">
	<e:q4l var="db_name_list">
		SELECT distinct X.DB_ID, DB_NAME, DB_SOURCE ,x.ord
		    FROM X_EXT_DB_SOURCE  X,
		         X_DB_ACCOUNT  A
		    WHERE X.DB_ID=A.DB_ID
		      AND A.ACCOUNT_CODE in (
		          select ACCOUNT_CODE 
		             FROM E_USER_ACCOUNT
		           WHERE 
		               USER_ID = '${sessionScope.UserInfo.USER_ID}')
		       ORDER BY x.ord desc
		     
 	</e:q4l>
</e:if>
<e:else condition="dataSourceElse">
 	<e:q4l var="db_name_list">
		SELECT  DB_ID, DB_NAME, DB_SOURCE FROM X_EXT_DB_SOURCE 
	</e:q4l>
</e:else>
<!-- 数据集的MENU -->
<div id="create_data_menu" class="toolTopList">
	<ul id="datasetList" class="guideIcon">
	<e:if condition="${param.typeExt ne '3'}">
		<li class="tIco01" id="addli"><a href="javascript:void(0);" id ="add"   onclick="addDataSet()"><span>添加</span></a></li>
	</e:if>	
		<li class="tIco02" id="searchli"><a href="javascript:void(0);" id ="search"  onclick="searchDataSet(${param.typeExt})" ><span>引用</span></a></li>
	</ul>
</div>
<!-- 创建数据集 -->
<div id="StartCreateDataSetBtn" align="right">
	<a href="javascript:void(0)" id="create_data_one" class="easyui-linkbutton" onclick="saveDataset()" iconCls="icon-save">保存</a>
</div>
<div id="create_data_win" class="easyui-dialog" title="创建数据集SQL" data-options="closed:true,buttons:'#StartCreateDataSetBtn',modal:true" style="width:820px;height:450px;">	
		<table class="windowData" style="width: 100%;">
			<colgrounp>
			<col width="15%" />
			<col width="*" />
			</colgrounp>
			<tr>
				<th>数据集名称</th>
				<td>
					<input type="hidden" name="referenceId"  id="referenceId" />
					<input type="hidden" name="report_sql_id"  id="report_sql_id" />
					<input type="hidden" name="userId"  id="userId" value="${UserInfo.USER_ID}"/>
					<input type ="text" id="data_name" name="data_name"  class="easyui-validatebox" required="true" style="width: 97%;"/>
				</td>
			</tr>
			<tr>
				<th>数据源选择</th>
				<td>
				<select id="database_name" name="database_name" style="width: 97%; height:26px;">
						<option value = "">--请选择--</option>
					    <e:forEach items="${db_name_list.list}" var="ds">
			                 <option value ="${ds.DB_SOURCE}">${ds.DB_NAME}</option>	
			            </e:forEach>	
					</select>
				</td>
			</tr>
			<tr>
				<th>数据集SQL</th>
				<td>
					 <textarea name="data_sql" id="data_sql" style="width: 96%;height:240px;" class="easyui-validatebox" required="true" onblur="formatSQL();">
					 </textarea>
				</td>
			</tr>
			<!-- 如果数据集被使用了，不允许再修改。 -->
			<tr id="showUseDatasetInfo" style="display: none; color: red; text-align: center;">
				<th colspan="2" >该数据集已经被其他模板组件引用，显示项为只读，不允许修改。</th>
			</tr>
		</table>
      <br/>
</div>

<!-- 引用数据集 -->
<div id="other_data_dialog" class="easyui-dialog" title="创建数据集SQL-引用SQL" data-options="closed:true,modal:true" style="width:860px; height:530px;">
		<div class="easyui-tabs" data-options="tabWidth:112" fit="true" style="padding-top:6px;">
			<div title="全局SQL">
				<div id="global_data_load" style="width:100%; height:100%;"></div>
			</div>
			<e:if condition="${param.typeExt ne '3'}">
				<div title="报表SQL">
					<div id="other_data_load" style="width:100%; height:100%;"></div>
				</div>
			</e:if>
		</div>
</div>
<div id="showDetailSqlDialog" class="easyui-dialog" title="　引用数据集SQL-具体SQL" data-options="closed:true,top:320,modal:true,resizable:true" style="width:825px; padding:10px;">
	<textarea id="showDetailSql" style="width:792px; height: 300px; resize:none;" readonly="readonly"></textarea>
</div>

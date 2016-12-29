<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%@taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<c:resources type="easyui,app"  style="${ThemeStyle }"></c:resources> 
<e:q4l var="kpiType">select code,name from X_KPI_CODE_TYPE where type='1' order by ord</e:q4l>
<e:q4l var="serviceType">select code,name from X_KPI_CODE_TYPE where type='2' order by ord</e:q4l>
<e:q4l var="classification">select code,name from X_KPI_CODE_TYPE where type='3' order by ord</e:q4l>
<e:q4l var="cycle">select code,name from X_KPI_CODE_TYPE where type='4'  order by ord</e:q4l>
<e:q4l var="reservedAttr">select code,name from X_KPI_CODE_TYPE where type='6' order by ord</e:q4l>
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
<e:q4o var="auditStep">select STEP_ID,STEP_NAME,CURR_STATUS,NEXT_STATUS from X_KPI_AUDIT_STEP where step_id='2'</e:q4o>
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
<e:style value="/resources/easyResources/component/easyui/themes/default/easyui.css" />
	<e:style value="/resources/easyResources/component/easyui/icon.css" />
	<e:style value="/pages/xbuilder/resources/themes/base/boncX@links.css" />
	
	<script>
		function query(){
			var params={};
			params.kpi_name=$('#kpi_name').val();
			params.kpi_iscurr=$('#kpi_iscurr').val();
			params.cube_code = $("#cube_code").combobox("getValue");
// 			params.kt = $("#kt").val();
// 			params.st = $("#st").val();
// 			params.cl = $("#cl").val();
// 			params.cy = $("#cy").val();
// 			params.ra = $("#ra").val();
			params.kpi_category = $("#kpi_category").combotree("getValue");
			$('#kpiTable').datagrid('options').queryParams=params;
			$('#kpiTable').datagrid('reload');
		}
		function fr(value,row,index){
// 			if(value==='待审核'){
				return '<a id="kpi_status_1" href="javascript:void(0)" class="btn-submit1" style="color:green" onclick="openDlg(\'' + row.V20 + '\',\'' + row.V55 + '\',\'' + row.V21 + '\',\'' + row.V22 + '\',\'' + row.V23 + '\',\'' + row.V5 + '\',\'' + row.V1 + '\')">审核</a>';
// 			}
// 			else return value;
		}
		function audit(){
			$.messager.confirm('审核','您确认要进行当前操作吗?',function(r){
				if(r){
					var selected=$('#kpiTable').datagrid('getSelected');
					var kpi_status=$('#a_status').val();
					if(selected){
						var kpi_code=selected.V1;
						var kpi_key=selected.V0;
						var kpi_version=selected.V5;
						var kpi_owner = $("#kpi_owner").val();
						var kpi_table = $("#kpi_table").val();
						var kpi_column = $("#kpi_column").val();
						var audit_flag = $("#audit_flag").val();
						var audit_opinion = $("#audit_opinion").val();
						$('#a_dlg').dialog('close');
						$.post("../kpiManager/kpiQueryAndAuditAction.jsp?eaction=audit&kpiId=" + kpi_key,{"kpi_code":kpi_code,"kpi_version":kpi_version,"kpi_status":kpi_status,"kpi_key":kpi_key,"kpi_owner":kpi_owner,"kpi_table":kpi_table,"kpi_column":kpi_column,"audit_flag":audit_flag,"audit_opinion":audit_opinion,"currStatus":"${auditStep.CURR_STATUS}","nextStatus":"${auditStep.NEXT_STATUS}"},function(){
							$('#kpiTable').datagrid('reload');
// 							if(kpi_status==2){
// 								$.post("../../../audit.e",{"kpiCode":kpi_code});
// 							}
							$.messager.alert('提示信息','指标技术审核完成!','info');
						}).error(function(){
							$.messager.alert('提示信息','指标技术审核失败!','info');
						});
					}
				}
			})
		}
		function openDlg(kpiType,acctType,kpi_owner,kpi_table,kpi_column,kpi_version,kpi_code){
			$.ajax({
				type : "POST",
				url : "kpiQueryAndAuditAction.jsp?eaction=queryTab&kpiType="+kpiType+"&acctType="+acctType,
				async: false,
				success : function(data) {
					var _kpiTab = $('#kpi_table');
					_kpiTab.empty();
					var _data = $.parseJSON(data);
					for(var i=0;i<_data.length;i++){
						_kpiTab.append("<option value='"+_data[i].VALUE+"'>"+_data[i].TEXT);
					}
					if(kpi_version != '1') {
						$.ajax({
							type : "POST",
							url : "kpiQueryAndAuditAction.jsp?eaction=queryKpiDetail&kpi_code="+kpi_code,
							async: false,
							success : function(data) {
									var	myJosn = $.parseJSON(data);
									if(myJosn != undefined) {
										$("#kpi_owner").val(myJosn.KPI_OWNER);
										$("#kpi_table").val(myJosn.KPI_TABLE);
										if(myJosn.KPI_OWNER == null || myJosn.KPI_OWNER == "") {
											$("#kpi_owner").attr("disabled",false);
										} else {
											$("#kpi_owner").attr("disabled",true);
										}
										if(myJosn.KPI_TABLE == null || myJosn.KPI_TABLE == "") {
											$("#kpi_table").attr("disabled",false);
										} else {
											$("#kpi_table").attr("disabled",true);
										}
									} else {
										$("#kpi_owner").val("");
										$("#kpi_table").val("");
										$("#kpi_owner").attr("disabled",false);
										$("#kpi_table").attr("disabled",false);
									}
								}
							
						});
					} else {
						$("#kpi_owner").attr("disabled",false);
						$("#kpi_table").attr("disabled",false);
						$("#kpi_owner").val("");
						$("#kpi_table").val("");
					}
				}
			});
			//$("#kpi_table").val("");
			//$("#kpi_column").val("");
			$("#audit_opinion").val("");
			$('#a_dlg').dialog('open');
		}
		$(function(){
			$('#a_dlg').dialog({
				title:"审核",
				closed:true,
				modal:true,
				height:360,
				top:100,
				buttons:[{
					text:"确认",
					handler:function(){
						audit();
					}
				}]
			});
		})
		function fView(value,row,index){
			return '<a href="javascript:void(0)" onclick="winView('+row.V0+')">'+value+'</a>';
		}		
		function winView(kpi_key){
			window.open('../../../formulaKpiLook.e?kpi_key='+kpi_key);
		}
		function hisView(kpi_code) {
	        window.open('../version/kpi_version.jsp?kpi_code='+kpi_code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');

		}
		function frhis(value,row,index) {
			return '<a id="kpi_status_1" href="javascript:void(0)" onclick="hisView(\''+ row.V1 +'\')">'+value+'</a>';
		}	
		$(function(){
			$('#cube_code').combobox({
				editable : false,
// 				width : 200,
				url : '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCube"/>',
				valueField : 'CUBE_CODE',
				textField : 'CUBE_NAME',
				value :'',
				onSelect : function(_value) {
// 					$('#kpi_category').combotree({
// 					    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_value,
// 					    required: true
// 					});
					$('#kpi_category').combotree('reload');
				}
			});
			$('#kpi_category').combotree({
			    url: '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory"/>',
			    required: true,
			    value:'0',
			    onBeforeExpand:function(node) {
			    	var _cube_code = $('#cube_code').combobox("getValue");
			    	if(_cube_code==null ||_cube_code==' '){
			    		return false;
			    	}
			    	$('#kpi_category').combotree("tree").tree("options").url = '<e:url value="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=queryCategory&cube_code="/>'+_cube_code;
			    }
			}); 
		});
	</script>	
  </head>
  
  <body>
  	<div id="tb">
  		<h2>指标技术审核</h2>
  		<div class="search-area">
		  	数据魔方：<input id="cube_code">
<!--   		            业务编码：<select id="kt" name="kt"> -->
<!--         			<option value="">--全部--</option> -->
<!-- 				    <e:forEach items="${kpiType.list}" var="kt"> -->
<!-- 		                 <option value ="${kt.CODE}">${kt.NAME}</option>	 -->
<!-- 		            </e:forEach>	 -->
<!-- 				</select> -->
<!-- 				<select id="st" name="st"> -->
<!-- 					<option value="">--全部--</option> -->
<!-- 				    <e:forEach items="${serviceType.list}" var="st"> -->
<!-- 		                 <option value ="${st.CODE}">${st.NAME}</option>	 -->
<!-- 		            </e:forEach>	 -->
<!-- 				</select> -->
<!-- 				<select id="cl" name="cl"> -->
<!-- 					<option value="">--全部--</option> -->
<!-- 				    <e:forEach items="${classification.list}" var="cl"> -->
<!-- 		                 <option value ="${cl.CODE}">${cl.NAME}</option>	 -->
<!-- 		            </e:forEach>	 -->
<!-- 				</select> -->
<!-- 				<select id="cy" name="cy"> -->
<!-- 					<option value="">--全部--</option> -->
<!-- 				    <e:forEach items="${cycle.list}" var="cy"> -->
<!-- 		                 <option value ="${cy.CODE}">${cy.NAME}</option>	 -->
<!-- 		            </e:forEach>	 -->
<!-- 				</select> -->
<!-- 				<select id="ra" name="ra"> -->
<!-- 					<option value="">--全部--</option> -->
<!-- 				    <e:forEach items="${reservedAttr.list}" var="ra"> -->
<!-- 		                 <option value ="${ra.CODE}">${ra.NAME}</option>	 -->
<!-- 		            </e:forEach>	 -->
<!-- 				</select>&nbsp;&nbsp; -->
			指标分类：<input id="kpi_category">
  			指标名称： <input type="text" id="kpi_name"/>
  			<a class="easyui-linkbutton" onclick="query()">查询</a>
  		</div>
  	</div>
    <c:datagrid url="pages/kpi/kpiManager/kpiQueryAndAuditAction.jsp?eaction=query&queryFlag=3" id="kpiTable" singleSelect="true" nowrap="true" fit="true" toolbar="#tb" pageSize="20">
    	<thead>
    		<tr>
				<th field="V19" width="20%"  formatter="fView">指标编码</th>
    			<th field="V2" width="20%" formatter="fView">指标名称</th>
<!--     			<th field="V5" width="6%"  formatter="frhis">指标版本</th> -->
    			<th field="V18" width="13%">指标类型</th>
   				<th field="V11" width="13%">指标分类</th>
    			<th field="V12" width="10%">创建人</th>
    			<th field="V13" width="10%">创建时间</th>
    			<th field="V14" width="10%">修改人</th>
    			<th field="V15" width="10%">修改时间</th>
    			<!--<th field="V22" width="10%">业务审核意见</th>
    			<th field="V6" width="80px">当前指标</th>
    			<th field="V7">指标口径</th>
    			<th field="V1">指标编码</th>
    			<th field="V8">指标解释</th>
    			<th field="V9">指标标记</th> -->
    			<th field="V10" width="12%" formatter="fr">操作</th>    			
    		</tr>
    	</thead>
    </c:datagrid>
    <div id="a_dlg" style="width:450px;height:500px;">
  	    <input type="hidden" id="audit_flag" name="audit_flag" value="2"/>
	    <div class="messageText">
	    	<p><span>审核结果:</span><select id="a_status" style="width: 45%;">
	    		<option value="2">审核通过</option>
	    		<option value="3">审核未通过</option>
	    	</select></p>
	    	<p><span>数据源:</span>
		    	<select id="kpi_owner" name="kpi_owner" style="width:  45%;">
					<option value = "">--请选择--</option>
				    <e:forEach items="${db_name_list.list}" var="ds">
		                 <option value ="${ds.DB_SOURCE}">${ds.DB_NAME}</option>	
		            </e:forEach>	
				</select></p>
	    	<p><span>使用表:</span><select id="kpi_table" name="kpi_table" style="width:  45%;">
	    	   </select>
	    	
	    	<!-- <input type="text" id="kpi_table" name="kpi_table" style="width:  45%;"></p> -->
	    	<!-- <p><span>使用列:</span><input type="text" id="kpi_column" name="kpi_column" class="easyui-validatebox" style="width:  45%;"></p> -->
	    	<p><span>审核意见：</span><textarea rows="5" cols="40" id="audit_opinion" name="audit_opinion"></textarea>
	    	</p>
	    </div>
    </div>
  </body>
</html>

<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
  </head>
<body>
<%
   String dim_sql = request.getParameter("dim_sql");
   if(dim_sql !=null){
	   dim_sql = new String(org.apache.commons.codec.binary.Base64.decodeBase64(request.getParameter("dim_sql")), "UTF-8");
   	   request.setAttribute("dim_sql", dim_sql);
   }
%>

<span style="float:left;line-height:30px;text-align: right;min-width:80px;">${param.dim_var_desc}：</span>
<e:switch value="${param.type}">
  <e:case value="INPUT">
    <e:description>文件输入框</e:description>
    <input type="text" id="${param.reportId }${param.dimvar}" name="${param.reportId }${param.dimvar}" style="width:100px; float:left;"/>
  </e:case>
  <e:case value="SELECT">
    <e:description>下拉列表、平铺框</e:description>
    <e:if condition="${param.dim_create_type=='1'}">
		<e:if condition="${param.database_name!=null && param.database_name ne '' && e:trim(param.database_name) ne '' && e:trim(e:toLowerCase(param.database_name)) ne 'null'}" var="selectifcc">
			<e:q4l var="SELECT_LISTc" extds="${param.database_name}">
				select distinct ${param.dim_col_code } code,${param.dim_col_desc } codedesc,${param.dim_col_ord } ord from ${param.dim_table } order by ${param.dim_col_ord }
			</e:q4l>
		</e:if>
		<e:else condition="${selectifcc}">
			<e:q4l var="SELECT_LISTc">
				select distinct ${param.dim_col_code } code,${param.dim_col_desc } codedesc,${param.dim_col_ord } ord from ${param.dim_table } order by ${param.dim_col_ord }
			</e:q4l>
		</e:else>
			
		
		<span class="month-datebox">
		<style>
			.month-datebox .combo {float:left;}
			.month-datebox .combo .combo-text.validatebox-text { float:left;}
		</style>

			<select id="${param.reportId }${param.dimvar}" name="${param.reportId }${param.dimvar}" class="easyui-combobox" style="width:100px; float:left;">
			    <option value="-1">-请选择-</option>  
				<e:forEach items="${SELECT_LISTc.list}" var="item">
					<option value="${item.code }" <e:if condition="${item.code eq param.defaultvalue}"> selected </e:if> >${item.codedesc }</option>  
				</e:forEach>
			</select>
		<input type="hidden" id ="${param.dimvar}sql" name = "${param.dimvar}sql" value="select ${param.dim_col_code } code,${param.dim_col_desc } codedesc from ${param.dim_table } order by ${param.dim_col_ord }"/>
		</span>
	</e:if>
	
	<e:if condition="${param.dim_create_type=='2'}">
		<e:set var="dimSqlString">${dim_sql}</e:set>
		<e:set var="vDimSqlStrR" value="\r"/>
		<e:set var="vDimSqlStrN" value="\n"/>
		<e:set var="vDimSqlStrT" value="\t"/>
		<e:set var="dimSqlString" value="${e:replace(dimSqlString,vDimSqlStrR,' ')}"/>
		<e:set var="dimSqlString" value="${e:replace(dimSqlString,vDimSqlStrN,' ')}"/>
		<e:set var="dimSqlString" value="${e:replace(dimSqlString,vDimSqlStrT,' ')}"/>
	    <%
	    	String dimSqlStr = "" + pageContext.getAttribute("dimSqlString");
	    	dimSqlStr = cn.com.easy.xbuilder.parser.CommonTools.getDimSqlFina(dimSqlStr,request);
			System.out.println("INFO-维度下拉列表SQL"+dimSqlStr);
	    %>
		

			<e:if condition="${param.database_name!=null && param.database_name ne '' && e:trim(param.database_name) ne '' && e:trim(e:toLowerCase(param.database_name)) ne 'null'}" var = "selectifa">
				<e:q4l var="SELECT_LIST2" extds="${param.database_name}">
					<%=dimSqlStr %>
				</e:q4l>
			</e:if>
			<e:else condition="${selectifa}">
				<e:q4l var="SELECT_LIST2">
					<%=dimSqlStr %>
				</e:q4l>
			</e:else>
		<style>.select-datebox {position: relative; top:2px;}.select-datebox .combo, .select-datebox .combo-text.validatebox-text{float:left;}</style>
		<span class="select-datebox">
			<select id="${param.reportId }${param.dimvar}" name="${param.reportId }${param.dimvar}" class="easyui-combobox" style="width:100px; float:left;">
			<option value="-1">-请选择-</option>  
			 <e:forEach items="${SELECT_LIST2.list}" var="item">
					<option value="${item.code }">${item.codedesc }</option>  
				 </e:forEach>
			</select>
		</span>

		<input type="hidden" id ="${param.dimvar}sql" name = "${param.dimvar}sql" value="${dimSqlString}"/>
	</e:if>
	<input type="hidden" id ="${param.dimvar}database" name = "${param.dimvar}database" value="${param.database_name}"/> 
	<input type="hidden" id ="${param.dimvar}select_nodouble" name = "${param.dimvar}select_nodouble" value="${param.select_double}"/><!--增加是否复选  -->
  </e:case>
   <e:case value="MONTH">
    <e:description>月份组件</e:description>

		<e:q4l var="month_list">
			select * from CONSECUTIVE_2YEAR_MON where acct_month<=(select t.const_value maxmonth from ${dss }.sys_const_table t where t.const_type = 'var.dss' and const_name='calendar.maxmonth') order by acct_month desc
		</e:q4l>
		<style>.month-datebox {position: relative; top:2px;}.month-datebox .combo, .month-datebox .combo-text.validatebox-text{float:left;}</style>
		<span class="month-datebox">
		<select id="${param.reportId }${param.dimvar}" name="${param.reportId }${param.dimvar}" class="easyui-combobox" style="width:100px; float:left; height:28px;">
		 <e:forEach items="${month_list.list}" var="item">
		 	<option value="${item.ACCT_MONTH }">${item.ACCT_DESC }</option>  
			 </e:forEach>
		</select>
		</span>

  </e:case>
  <e:case value="DAY">
    <e:description>日期组件</e:description>
    <style>.day-datebox {position: relative; top:2px;}.day-datebox .combo.datebox {float:left;}</style>
    <span class="day-datebox"><input id="${param.reportId }${param.dimvar}" name="${param.reportId }${param.dimvar}" class="easyui-datebox" style="width:100px; float:left;"></input></span>
  </e:case>
  <e:case value="CASELECT">
    <e:description>联动组件</e:description>
    <e:set var="vDimSql" value="${dim_sql}"/>
	<e:set var="vDimSqlR" value="\r"/>
	<e:set var="vDimSqlN" value="\n"/>
	<e:set var="vDimSqlT" value="\t"/>
	<e:set var="vDimSql" value="${e:replace(vDimSql,vDimSqlR,' ')}"/>
	<e:set var="vDimSql" value="${e:replace(vDimSql,vDimSqlN,' ')}"/>
	<e:set var="vDimSql" value="${e:replace(vDimSql,vDimSqlT,' ')}"/>

	<style>.month-datebox {position: relative; top:2px;}.month-datebox .combo, .month-datebox .combo-text.validatebox-text{float:left;}</style>
		<span class="month-datebox">
		<input class='easyui-combobox' id ="${param.reportId}${param.dimvar}" name="${param.reportId }${param.dimvar}" style="float:left;">
			</span>
			<script type="text/javascript">
			$(function(){
				$("#${param.reportId}${param.dimvar}").combobox({
					url: appBase+'/pages/xbuilder/dimension/reportDesigner-dim-data.jsp?eaction=extCascade&PARENT_KEY=-1',
					valueField: 'CODE',
					textField: 'CODEDESC',
					panelWidth: 140,
					onBeforeLoad: function(param){
						param.CODE_TABLE = '${param.dim_table}';
						param.CODE_KEY = '${param.dim_col_code}';
						param.CODE_DESC = '${param.dim_col_desc}';
						param.CODE_ORD = '${param.dim_col_ord}';
						param.PARENT_CODE = '';
						param.CODE_PARENT_KEY = '${param.dim_parent_col}';
						param.CODE_SQL = base64encode('${vDimSql}');
						param.DIM_LVL = '${param.dim_lvl }';
						param.DATABASE_NAME = '${param.database_name}';
						
						param.SELECT_DOUBLE = '${param.select_double}';
					},
					onLoadSuccess:  function(){
						//默认值
						$('#${param.reportId }${param.dimvar}').combobox('setValue',' ');
					},
					onSelect: function(node){
						if(typeof(cascade_${param.reportId }${param.dimvar})!='undefined'){
							cascade_${param.reportId }${param.dimvar}(node.CODE);
						}
					}
					
				});
			});
			<e:if condition="${param.parent_dim_name!=null && param.parent_dim_name ne ''}">
				function cascade_${param.reportId }${param.parent_dim_name}(key){
					$('#${param.reportId }${param.dimvar}').combobox('reload',appBase+'/pages/xbuilder/dimension/reportDesigner-dim-data.jsp?eaction=extCascade&PARENT_KEY='+key);
					var opList = [];
					//opList.push({ "CODEDESC": "-请选择-", "CODE": "" });
					$('#${param.reportId }${param.dimvar}').combobox('loadData', opList);
				}
			</e:if>
			</script>

	<input type="hidden" id ="parent_${param.dimvar}_col" name = "parent_${param.dimvar}_col" value="${param.dim_parent_col}"/>
	<input type="hidden" id ="parent_${param.dimvar}_var" name = "parent_${param.dimvar}_var" value="${param.parent_dim_name}"/>
	<input type="hidden" id ="parent_${param.dimvar}_multiple" name = "parent_${param.dimvar}_multiple" value="${param.select_double}"/>
	<input type="hidden" id ="dim_table_${param.dimvar}" name = "dim_table_${param.dimvar}" value="${param.dim_table}"/>
	<input type="hidden" id ="dim_col_code_${param.dimvar}" name = "dim_col_code_${param.dimvar}" value="${param.dim_col_code}"/>
	<input type="hidden" id ="dim_col_desc_${param.dimvar}" name = "dim_col_desc_${param.dimvar}" value="${param.dim_col_desc}"/>
	<input type="hidden" id ="dim_col_ord_${param.dimvar}" name = "dim_col_ord_${param.dimvar}" value="${param.dim_col_ord}"/>
	<input type="hidden" id ="dim_sql_${param.dimvar}" name = "dim_sql_${param.dimvar}" value="${vDimSql}"/>
	<input type="hidden" id ="dim_lvl_${param.dimvar}" name = "dim_lvl_${param.dimvar}" value="${param.dim_lvl}"/>
	<input type="hidden" id ="dim_database_${param.dimvar}" name = "dim_database_${param.dimvar}" value="${param.database_name}"/>
	<input type="hidden" id ="select_double_${param.dimvar}" name = "select_double_${param.dimvar}" value="${param.select_double}"/><!--增加是否复选  -->
  </e:case>
</e:switch>
<input type="hidden" id ="${param.dimvar}" name = "${param.dimvar}" value="${param.type }"/>
<input type="hidden" id ="${param.dimvar}dimsiontype" name = "${param.dimvar}dimsiontype" value="${param.type }"/>
<input type="hidden" id ="${param.dimvar}desc" name = "${param.dimvar}desc" value="${param.dim_var_desc}"/>
<input type="hidden" id ="${param.dimvar}showtype" name = "${param.dimvar}showtype" value="0"/>
</body>
</html>
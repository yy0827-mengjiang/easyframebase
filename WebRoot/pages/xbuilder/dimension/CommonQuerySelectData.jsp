<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@page import="cn.com.easy.ebuilder.parser.CommonTools"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="codedesc" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.actionstate}">
	<e:case value="dataBean">
		<e:if condition="${param.extds !=null && param.extds ne '' && param.extds ne 'undefined' }" var = "extdsselectlistelse">
		  	<e:q4o var="dataBeanList" extds="${param.extds}">
			  select code as "CODE",codedesc as "CODEDESC" from (${param.datasqlquery })  aa 
				where 1=1 and code in(${param.code})
				group by code,codedesc
	   		</e:q4o>${dataBeanList}
		</e:if>
		<e:else condition="${extdsselectlistelse }">
			<e:q4o var="dataBeanList">
			 select code as "CODE",codedesc as "CODEDESC" from (${param.datasqlquery })  aa1 
				where 1=1 and code in(${param.code})
				group by code, codedesc
	   		</e:q4o>${dataBeanList}
		</e:else>
			
   	</e:case>
	<e:case value="data">
		<e:if condition="${param.extds !=null && param.extds ne '' && param.extds ne 'undefined' }" var = "extdsselectlistelse1">
			<%
				String sql = request.getParameter("datasqlquery");
				String datasqlquery = new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
				System.out.println(datasqlquery);
			%>
			<e:set var="aaa" value="<%=datasqlquery%>" />
			<c:tablequery extds="${param.extds}">
			select code as "CODE",codedesc as "CODEDESC" from (${aaa }) as aa2 
			where 1=1 
			<e:if condition="${(((param.codedesc != null)&&(e:trim(param.codedesc) != '')&&(param.codedesc != 'null'))||((codedesc != null)&&(e:trim(codedesc) != '')&&(codedesc != 'null')))}">
		        and codedesc like '%'||#codedesc#||'%'
		     </e:if>
		     group by code, codedesc 
   			</c:tablequery>
		</e:if>
		<e:else condition="${extdsselectlistelse1 }">
			<%
				String sql = request.getParameter("datasqlquery");
				String datasqlquery = new String(org.apache.commons.codec.binary.Base64.decodeBase64(sql), "UTF-8");
				System.out.println(datasqlquery);
			%>
			<e:set var="aaa" value="<%=datasqlquery%>" />
			<c:tablequery >
			select code as "CODE",codedesc as "CODEDESC" from (${aaa }) aa3 
			where 1=1 
			<e:if condition="${(((param.codedesc != null)&&(e:trim(param.codedesc) != '')&&(param.codedesc != 'null'))||((codedesc != null)&&(e:trim(codedesc) != '')&&(codedesc != 'null')))}">
		        and codedesc like '%'||#codedesc#||'%'
		     </e:if>
		     group by code, codedesc 
   			</c:tablequery>
		</e:else>
	</e:case>
	<e:case value="dom">
		<script>
		$(function(){  
		  //回显
		  var str = parent.document.getElementById("mode${param.id}").value;
		  if(str!=""){
	  	    var domeArray = str.split(",");
		    for(var _j=0;_j<domeArray.length;_j++){
		  	  var array = domeArray[_j].split("!");
		  	  addConditionValue${param.id}${param.name}(array[0],array[1]);
		    }
		  }
		})
		function sCZ${param.id}(value,rowData){
			var read = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="selectOption${param.id}(\''+rowData.CODE+'\',\''+rowData.CODEDESC+'\')">选择</a>';
			return  read;
		}
		function selectOption${param.id}(code,codedesc){
			if(typeof(selectOption${param.id}${param.name}wrt)!='undefined'){
				addConditionValue${param.id}${param.name}(code,codedesc);
				//selectOption${param.id}${param.name}wrt(code,codedesc);
			}
		}
		function queryOption${param.id}(){
			$('#report${param.id}Table').datagrid({
				queryParams: {
					codedesc: $("#datagridtext${param.id }").val()
				}
			});
			$('#report${param.id}Table').datagrid('reload'); 
		}
		function addConditionValue${param.id}${param.name}(code,codedesc) {
			var $value_${param.id}${param.name} = "<li class=\"ui-state-default\" id=\"li_condition_"+ code +"\"  codeValue=\""+ code +"\" descValue=\""+ codedesc  +"\"><span class=\"delBtn_sql\" id=\"labelp_"+ code +"\">"+ codedesc +"<a class=\"colbtn\" href=\"javascript:void(0)\" onclick=\"javascript:removeConditionValue${param.id}${param.name}('"+ code +"')\">删除</a></span></li>";
			var flag = true;
			var multiple = "${param.multiple}";
			$("#condition_${param.id }").find("li").each(function(index,item){
				if(code == $(item).attr("codeValue")) {
					flag = false;
				}
			});
			if(flag) {
				if(multiple == "true" || multiple == "1" ) {
					$("#condition_${param.id }").append($value_${param.id}${param.name});
				} else {
					$("#condition_${param.id }").html($value_${param.id}${param.name});
				}
			}
		}
		function removeConditionValue${param.id}${param.name}(code) {
			$("#li_condition_" + code).remove();
		}
		function doConfirmConditionValue${param.id}${param.name}() {
			var multiple = "${param.multiple}";
			var myArray = new Array();
			var tempStr="";
			//回显删除
			removeAllOption${param.id}${param.name}();
			$("#condition_${param.id}").find("li").each(function(index,item){
				if(multiple == "true" || multiple == "1" ) {
					myArray.push({code:$(item).attr("codeValue"),codedesc:$(item).attr("descValue")});
					//回显多个值
					codetmp = $(item).attr("codeValue");
					codedesctmp = $(item).attr("descValue");
					tempStr+=codetmp+"!"+codedesctmp+",";
				} else {
					code = $(item).attr("codeValue");
					codedesc = $(item).attr("descValue"); 
					selectOption${param.id}${param.name}wrt(code,codedesc);
					//回显一个值
					codetmp = $(item).attr("codeValue");
					codedesctmp = $(item).attr("descValue");
					tempStr+=codetmp+"!"+codedesctmp;
					parent.document.getElementById("mode${param.id}").value=tempStr;
				}
			});
			if(multiple == "true" || multiple == "1" ) {
				selectOption${param.id}${param.name}wrtValues(myArray);
				//回显存入父级页面
				tempStr = tempStr.substr(0,tempStr.length-1);
				parent.document.getElementById("mode${param.id}").value=tempStr;
			}
			$("#w${param.id }${param.name }selectList").window("close");
		}
		</script>
		<div style="float:left;width:70%;height:100%;">
		<div style="width:98%;  padding:2px 0 2px 2%">
			描述:<input type="text" id ="datagridtext${param.id }" class="back_none" name ="datagridtext${param.id }" style="width:280px">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="queryOption${param.id}();">查询</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" onclick="doConfirmConditionValue${param.id}${param.name}()">确定</a>
		</div>
		<c:datagrid url="pages/xbuilder/dimension/CommonQuerySelectData.jsp?extds=${param.extds}&actionstate=data&datasqlquery=${param.datasql }" id="report${param.id}Table" pageSize="7">
		<thead>
			<tr>
				<th field="CODE" width="40" align="center">编码</th>
				<th field="CODEDESC" width="50" align="center">描述</th>
				<th field="cz" width="40" align="center" formatter="sCZ${param.id}" >操作</th>
			</tr>
		</thead>
		</c:datagrid>
		</div>
		<div class="checkboxGroup1" style="float:right;width:30%;overflow: auto;height:100%;">
		<p style="height:22px; line-height:22px;">选中的数据</p>
			<ul id="condition_${param.id }">
			</ul>
         </div>
	</e:case>
</e:switch>
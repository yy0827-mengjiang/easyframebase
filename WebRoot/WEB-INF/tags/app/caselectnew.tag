<%@ tag body-content="scriptless" import="cn.com.easy.xbuilder.parser.CommonTools"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<e:description>
	手动写sql时，字段别名分别为CODE,CODEDESC,PARENT_COL	
	例：
		<a:caselectnew id='area_no' childElementId="city_no" defaultValue="431" defaultItemValue="" defaultItemText="请选择">
			select area_no code,area_desc codedesc from cmcode_area
		</a:caselectnew>
		<a:caselectnew id='city_no' table='cmcode_city' descCol='city_desc' codeCol='city_no' sortCol="area_no" parentCol="area_no" parentElementId="area_no" childElementId="town_no" multiple="true"  defaultValue="43101,43102" defaultItemValue="-1"></a:caselectnew>	
		<a:caselectnew id='town_no' table='cmcode_city' descCol='city_desc' codeCol='city_no' sortCol="city_no" parentCol="city_no" parentElementId="city_no" defaultValue=""></a:caselectnew>
		
		
</e:description>
<%@ attribute name="id" required="true" %>    					<e:description>id（必选）</e:description>
<%@ attribute name="table" required="false" %>					<e:description>数据表名，默认为空字符</e:description>
<%@ attribute name="codeCol" required="false" %>				<e:description>值字段，对应下拉框的value值，默认为空字符</e:description>
<%@ attribute name="descCol" required="false" %>				<e:description>描述字段，对应下拉框的text值，默认为空字符</e:description>
<%@ attribute name="sortCol" required="false" %>				<e:description>排序字段，确定数据以哪个字段排序，默认为空字符</e:description>
<%@ attribute name="parentCol" required="false" %>				<e:description>父选项值对应字段，默认为空字符</e:description>
<%@ attribute name="extds" required="false" %>					<e:description>扩展数据源，默认为空字符</e:description>
<%@ attribute name="parentElementId" required="false" %>		<e:description>父选项的id</e:description>
<%@ attribute name="childElementId" required="false" %>			<e:description>子选项的id</e:description>
<%@ attribute name="defaultValue" required="false" %>			<e:description>默认值，有多个默认值时以逗号分隔，默认为空字符</e:description>
<%@ attribute name="defaultItemValue" required="false" %>		<e:description>空白单元的值，默认为空字符</e:description>
<%@ attribute name="defaultItemText" required="false" %>		<e:description>空白单元的显示内容，默认为请选择</e:description>

<%@ attribute name="width" required="false" %>					<e:description>宽度(数字)，默认为auto</e:description>
<%@ attribute name="panelWidth" required="false" %>				<e:description>下拉面板宽度(数字)，默认为auto</e:description>
<%@ attribute name="panelHeight" required="false" %>			<e:description>下拉面板高度(数字)，默认为200</e:description>

<%@ attribute name="multiple" required="false" %>				<e:description>是否多选(true/false)，默认为false</e:description>
<jsp:doBody var="bodyRes" />
<e:set var="defaultItemValue_temp">${defaultItemValue}</e:set>
<e:if condition="${defaultItemValue_temp=='null'||defaultItemValue_temp=='undefined'}">
	<e:set var="defaultItemValue_temp"></e:set>
</e:if>
<e:set var="dimSql" scope="request" value="${bodyRes}" />

<e:if condition="${parentSql==null||parentSql eq ''}">
	<e:set var="sql">
		<e:if condition="${bodyRes!=null&&bodyRes ne ''}">
			<%
				String sqlDim = request.getAttribute("dimSql")+"";
				sqlDim = CommonTools.getDimSqlFilterWhere(sqlDim,request);
			%>
			<%=sqlDim%>
		</e:if>
		<e:if condition="${bodyRes==null||bodyRes eq ''}">
			select  
				 ${codeCol} as "CODE"
				,${descCol} as "CODEDESC"
				<e:if condition="${parentCol!=null&&parentCol!=''}">
					,${parentCol} as "PARENT_COL" 
				</e:if>
				<e:if condition="${parentCol==null||parentCol==''}">
					,'' as "PARENT_COL" 
				</e:if>
				<e:if condition="${sortCol!=null&&sortCol!=''&&sortCol!=codeCol&&sortCol!=descCol&&sortCol!=parentCol}">
					,${sortCol }
				</e:if>
			from ${table} 
			 	group by ${codeCol}
				,${descCol} 
				<e:if condition="${parentCol!=null&&parentCol!=''}">
					,${parentCol}  
				</e:if>
				<e:if condition="${sortCol!=null&&sortCol!=''&&sortCol!=codeCol&&sortCol!=descCol&&sortCol!=parentCol}">
					,${sortCol }
				</e:if>
			
			order by ${sortCol }
		</e:if>
	</e:set>
</e:if>

<e:if condition="${extds!=null&&extds ne ''}" var="pExtdIf">
	<e:q4l var="dataList" extds="${extds}">${sql}</e:q4l>
</e:if>
<e:else condition="${pExtdIf}">
    <e:q4l var="dataList">${sql}</e:q4l>
</e:else> 
<input id="${id}" name="${id}" value=""/>
 
<script type="text/javascript">
	$("#${id}").combobox({
		editable:false,
	    valueField:'value',
	    textField:'text',
	    <e:if condition="${width!=null&&width!=''&&width!='auto'}">
	    	width:${width},
	 	</e:if>
	 	<e:if condition="${panelWidth!=null&&panelWidth!=''&&panelWidth!='auto'}">
	    	panelWidth:${panelWidth},
	 	</e:if>
	 	<e:if condition="${panelHeight!=null&&panelHeight!=''&&panelHeight!='auto'}">
	    	panelHeight:${panelHeight},
	 	</e:if>
	    <e:if condition="${multiple=='true'}">
	    	multiple:true,
	 	</e:if>
	    onLoadSuccess: function () {
	    	setDefault${id}();
        }
	   	,onSelect:function(record){
	   		if(window["select_${childElementId}"]!=undefined){//change child element
	   			window["select_${childElementId}"]();
	   		}
		}
		<e:if condition="${multiple=='true'}">
			,onUnselect:function(record){
		   		if(window["select_${childElementId}"]!=undefined){//change child element
		   			window["select_${childElementId}"](record.value);
		   		}
			}
		</e:if>
	});
	var data${id}=${e:java2json(dataList.list)};	
	var defaultItemValue${id}='${defaultItemValue}';
	if(defaultItemValue${id}=='null'){
		defaultItemValue${id}='';
	}
	var defaultItemText${id}='${defaultItemText}';
	if(defaultItemText${id}==''||defaultItemText${id}=='null'){
		defaultItemText${id}='请选择';
	}
	var hasParentFlag${id}=false;
	var parentElementId${id}="${parentElementId}";
	var parentElementValue${id}=[];
	if(parentElementId${id}!=''&&parentElementId${id}!='null'){
		hasParentFlag${id}=true;
		parentElementValue${id}=$("#"+parentElementId${id}).combobox("getValues");
	}else{
		hasParentFlag${id}=false;
		parentElementValue${id}.push("");
	}
	var comboData${id}=[{"value":defaultItemValue${id},"text":defaultItemText${id}}];
	for(var a=0;a<parentElementValue${id}.length;a++){
		for(var i=0;i<data${id}.length;i++){
			if((!hasParentFlag${id})||parentElementValue${id}[a]==data${id}[i]["PARENT_COL"]){
				var info={};
				info.value=data${id}[i].CODE;  
				info.text=data${id}[i].CODEDESC;  
				comboData${id}.push(info);
			}
		}
	}
	$("#${id}").combobox("loadData",comboData${id});
	
	<e:if condition="${parentElementId!=null&&parentElementId!=''}">
		function select_${id}(exceptValue){
			var values${id}=$("#${parentElementId}").combobox("getValues");
			var comboData${id}=[{"value":defaultItemValue${id},"text":defaultItemText${id}}];
			for(var a=0;a<values${id}.length;a++){
				for(var i=0;i<data${id}.length;i++){
					if(values${id}[a]==data${id}[i]["PARENT_COL"]&&values${id}[a]!=exceptValue){
						var info={};
						info.value=data${id}[i].CODE;  
						info.text=data${id}[i].CODEDESC;  
						comboData${id}.push(info);
					}
				}
			}
			$("#${id}").combobox("clear").combobox("loadData",comboData${id}).combobox("setValue",defaultItemValue${id});
		}
	</e:if>
	function setDefault${id}(){
		var defaultValue='${defaultValue}'.split(",");
		if(defaultValue==null||defaultValue.length==0){
			defaultValue=[defaultItemValue${id}];
		}
		if('${multiple}'=='true'){
			$("#${id}").combobox("setValues",defaultValue);
		}else{
			$("#${id}").combobox("setValue",defaultValue[0]);
		}
		//$("#${id}").combobox("select",defaultValue[0]);
	}
	
</script>


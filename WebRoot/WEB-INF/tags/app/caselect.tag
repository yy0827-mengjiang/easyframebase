<%@ tag body-content="scriptless"  pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ attribute name="id" required="true" %>    <e:description>id（必选）</e:description>
<%@ attribute name="parentLabelWidth" required="false" %>
<%@ attribute name="childLabelWidth" required="false" %>

<%@ attribute name="parentLabel" required="false" %>
<%@ attribute name="parentTable" required="false" %>
<%@ attribute name="parentCodeCol" required="false" %>
<%@ attribute name="parentDescCol" required="false" %>
<%-- <%@ attribute name="parentSql" required="false" %> --%>
<%@ attribute name="parentDefault" required="false" %>
<%@ attribute name="parentName" required="true" %>

<%@ attribute name="childLabel" required="false" %>
<%@ attribute name="childTable" required="false" %>
<%@ attribute name="childCodeCol" required="false" %>
<%@ attribute name="childDescCol" required="false" %>
<%@ attribute name="parentCol" required="false" %>
<%-- <%@ attribute name="childSql" required="false" %> --%>
<%@ attribute name="childDefault" required="false" %>
<%@ attribute name="layout" required="false" %>
<%@ attribute name="getValueMethod" required="false" %>
<%@ attribute name="childName" required="true" %>
<%@ attribute name="parentExtds" required="false" %>
<%@ attribute name="childExtds" required="false" %>
<jsp:doBody var="bodyRes" />

<e:set var="parentSql" value=""></e:set>
<e:set var="childSql" value=""></e:set>
 
<e:if condition="${bodyRes!=null&&bodyRes ne ''}">
    <e:set var="parentSql" value="${e:split(bodyRes,';')[0]}"></e:set>
    <e:set var="childSql" value="${e:split(bodyRes,';')[1]}"></e:set>
    
    <e:set var="parentSql" value="${e:trim(parentSql)}"></e:set>
    <e:set  var="parentSqlLength" value="${e:length(parentSql)}"/>
    <e:set var="parentSql" value="${e:substring(parentSql,1,parentSqlLength-1)}"></e:set>
    
    <e:set var="childSql" value="${e:trim(childSql)}"></e:set>
    <e:set  var="childSqlLength" value="${e:length(childSql)}"/>
    <e:set var="childSql" value="${e:substring(childSql,1,childSqlLength-1)}"></e:set>
    
</e:if>

<e:if condition="${parentSql==null||parentSql eq ''}">
	<e:set var="parentSql">
	   select ${parentCodeCol} code,${parentDescCol} codedesc from ${parentTable}
	</e:set>
</e:if>

<e:if condition="${childSql==null||childSql eq ''}">
	<e:set var="childSql">
	   select ${childCodeCol} code,${childDescCol} codedesc,${parentCol} parent_col from ${childTable}
	</e:set>
</e:if>  

<e:if condition="${parentExtds!=null&&parentExtds ne ''}" var="pExtdIf">
	<e:q4l var="level1List" extds="${parentExtds}">${parentSql}</e:q4l>
</e:if>   
<e:else condition="${pExtdIf}">
    <e:q4l var="level1List">${parentSql}</e:q4l>
</e:else> 


<e:if condition="${childExtds!=null&&childExtds ne ''}" var="cExtdIf">
	<e:q4l var="level2List" extds="${childExtds}">${childSql}</e:q4l>
</e:if>   
<e:else condition="${cExtdIf}">
    <e:q4l var="level2List">${childSql}</e:q4l>
</e:else> 

<e:if condition="${parentDefault==null||parentDefault eq ''}">
  <e:set var="parentDefault" value="" /> 
</e:if>              
<e:if condition="${childDefault==null||childDefault eq ''}">
  <e:set var="childDefault" value="" /> 
</e:if>      
      
<e:if condition="${parentLabelWidth==null||parentLabelWidth eq ''}">
	<e:set var="parentLabelWidth" value="45" /> 
</e:if>      
<e:if condition="${childLabelWidth==null||childLabelWidth eq ''}">
	<e:set var="childLabelWidth" value="45" /> 
</e:if>      
<style>
	.parentList {display:inline-block; margin:9px 0 0 0; }
	.parentList li { float:left; margin:0 10px 0 4px; font-size:14px;} 
	.parentList li select {margin-left:4px; height:26px;}
</style>
<ul class="parentList">
	<li>${parentLabel}<select id="${id}_level1" name="${parentName}" onchange="change_${id}_level1()" style="width:140px;"></li>
	 <option value="">--请选择--</option>
	</select>
	<li>${childLabel}<select id="${id}_level2" name="${childName}" style="width:140px;">
	 <option value="">--请选择--</option>
	</select></li>
</ul>
<script type="text/javascript">
    var level1Sel${id}=document.getElementById("${id}_level1");
    var level2Sel${id}=document.getElementById("${id}_level2");
    
	var data=${e:java2json(level1List.list)};
	var data2=${e:java2json(level2List.list)};
	
	for(var i=0;i<data.length;i++){
		 var objOption=document.createElement("OPTION");  
		 objOption.value=data[i].CODE;  
		 objOption.text=data[i].CODEDESC;  
		 level1Sel${id}.add(objOption);  
	}
    
	if("${parentDefault}"!=""){
		level1Sel${id}.value="${parentDefault}";
		for(var i=0;i<data2.length;i++){
		    if(data2[i].PARENT_COL=="${parentDefault}"){
		    	addOption(level2Sel${id},data2[i].CODE,data2[i].CODEDESC);
		    }
	    } 
		level2Sel${id}.value="${childDefault}";
	} 

	function change_${id}_level1(){
		   var parentSelObj=level1Sel${id}.options[level1Sel${id}.options.selectedIndex];
		   level2Sel${id}.options.length=0;
		   addOption(level2Sel${id},"","--请选择--");
		   for(var i=0;i<data2.length;i++){
			    if(data2[i].PARENT_COL==parentSelObj.value){
					 addOption(level2Sel${id},data2[i].CODE,data2[i].CODEDESC);
			    }
		   }  
	}
	  
	function addOption(selObj,value,text){
		 var objOption=document.createElement("OPTION");  
		 objOption.value=value;  
		 objOption.text=text;  
		 selObj.add(objOption);  
	}
	
	<e:if condition="${getValueMethod!=null&&getValueMethod ne ''}">
	function ${getValueMethod}(){

		 var parentSelObj=level1Sel${id}.options[level1Sel${id}.options.selectedIndex];
		 var childSelObj=level2Sel${id}.options[level2Sel${id}.options.selectedIndex];
		 var value="{'parentValue':'"+parentSelObj.value+"','parentText':'"+parentSelObj.text+"','childValue':'"+childSelObj.value+"','childText':'"+childSelObj.text+"'}";
	     return value;
	}
	</e:if>
	
</script>


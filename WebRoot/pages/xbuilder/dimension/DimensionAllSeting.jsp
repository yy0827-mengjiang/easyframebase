<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="cn.com.easy.xbuilder.element.*,cn.com.easy.xbuilder.*,cn.com.easy.xbuilder.service.*"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c" %>
<%
	String reportId = request.getParameter("reportId");
	Report reportObj=XContext.getEditView(reportId);
	List<Dimsion> dimsionList=null;
	if(reportObj !=null && reportObj.getDimsions() !=null)
		dimsionList = reportObj.getDimsions().getDimsionList();
	String isall = "0";
	String isnull = "1";
	String jsonStr = "";
	if(dimsionList!=null){
		jsonStr +="[";
		for(Dimsion dimsion:dimsionList){
			if(dimsion.getIsparame() !=null &&dimsion.getIsparame().equals("1"))
				isall = "1";
			else
				isall = "0";
			jsonStr+="{\"id\":\""+dimsion.getVarname()+"\",\"var_name\":\""+dimsion.getVarname()+"\",\"desc\":\""+dimsion.getDesc()+"\",\"varname\":\""+dimsion.getVarname()+"\",\"type\":\""+dimsion.getType()+"\","+"\"isparame\":\""+dimsion.getIsparame()+"\"},";
		}
		if(!"[".equals(jsonStr))
			jsonStr = jsonStr.substring(0,jsonStr.length()-1);
		jsonStr+="]";
		DimensionService dimensionservice = new DimensionService();
		String jsonString = dimensionservice.getDimsions(reportId);
		request.setAttribute("dimString",jsonString);
		jsonString = jsonString.replaceAll("\'", "\\\\'");
		request.setAttribute("jsonString",jsonString);
	}else{
		isnull = "0";
	}
	
	request.setAttribute("jsonStr",jsonStr);
    request.setAttribute("isnull",isnull);
%>
<script>
	$(function() {
		$( "#sortable" ).sortable();
		$( "#sortable" ).disableSelection();
		
		$( "#sortable" ).sortable({
			start : function(event, ui){dimSortStart(event, ui,'dim');},
			stop:function(event, ui){dimSortStop(event, ui,'dim');	}
		});
		//还原选择状态
		var isall = '<%=isall%>';
		if(isall == '1'){
			$("#checkall").iCheck('check');//$("#checkall").attr("checked","checked");
		}
		var $jsonObj = $.parseJSON('${jsonStr}');
		
		if($jsonObj!=''&&$jsonObj!=null&&$jsonObj!='null'){
			for(var i=0;i<$jsonObj.length;i++){
			   var varname = $jsonObj[i].varname;
			   var isparam = $jsonObj[i].isparame;
			   var $dimCheckObj = $("#check"+varname);
			   var $liCheckObj = $("#li"+varname);
			   if(isparam == '1'){
				   $dimCheckObj.iCheck('check');//$dimCheckObj.attr("checked","checked");
				   $dimCheckObj.attr("isparame","1");
				   $liCheckObj.attr("isparame","1");
			   }
			}
		}
	});
	function dimSortStart(event, ui,type){
	}
	function dimSortStop(event, ui,type){
		$sortable = $("#sortable");
		var dimList = [];
		var $jsonObj = $.parseJSON('${jsonString}');
		$sortable.find("li").each(function (index, domEle){
		    for(var i =0;i<$jsonObj.length;i++){
			   var dimMap = {};
			   dimMap.var_name = $(domEle).attr("attid");
			   if($jsonObj[i].varname == dimMap.var_name){
			   		dimMap.id=$jsonObj[i].id;
					dimMap.type=$(domEle).attr("atttype");//$jsonObj[i].type;
					dimMap.varname=$jsonObj[i].varname;
					dimMap.table=$jsonObj[i].table;
					dimMap.field=$jsonObj[i].field;
					dimMap.desc=$jsonObj[i].desc;
					dimMap.name=$jsonObj[i].desc;
					dimMap.codecolumn=$jsonObj[i].codecolumn;
					dimMap.desccolumn=$jsonObj[i].desccolumn;
					dimMap.level=$jsonObj[i].level;
					dimMap.ordercolumn=$jsonObj[i].ordercolumn;
					dimMap.parentdimname=$jsonObj[i].parentdimname;
					dimMap.parentcol=$jsonObj[i].parentcol;
					dimMap.isselectm=$jsonObj[i].isselectm;
					dimMap.index=$jsonObj[i].index;
					dimMap.sql=$jsonObj[i].sql;
					dimMap.createtype=$jsonObj[i].createtype;
					dimMap.defaultvalue=$jsonObj[i].defaultvalue;
					dimMap.isparame=$jsonObj[i].isparame;
					dimMap.formula=$jsonObj[i].formula;
					dimMap.showtype=$jsonObj[i].showtype;
					dimMap.fieldid=$jsonObj[i].fieldid;
					dimMap.fieldtype=$jsonObj[i].fieldtype;
					dimMap.datasourceid = $jsonObj[i].datasourceid;
					dimMap.conditiontype = $jsonObj[i].conditiontype;
					dimMap.index = index;
					dimMap.isparame =  $(domEle).attr("isparame");
					dimList.push(dimMap);
			   }
		    }
		});
		selectDim(dimList);
	}
	function onCheckAll(){
		var checkrs = $("#checkall").attr("checked");
		var $jsonObj = $.parseJSON('${jsonString}');
		// $sortable = $("#sortable");
		if(checkrs == 'undefined' || checkrs == undefined){
			$("#checkall").iCheck('check');//$(":input[type='checkbox']").attr("checked","checked");
			$("input[checkone='checkone']").iCheck('check');
		    for(var i =0;i<$jsonObj.length;i++){
		    	var $dimCheckObj = $("#check"+$jsonObj[i].varname);
				var $liCheckObj = $("#li"+$jsonObj[i].varname);
				$dimCheckObj.attr("isparame","1");
				$liCheckObj.attr("isparame","1");
			    var dimMap = {};
			    dimMap.var_name = $jsonObj[i].varname;
		   		dimMap.id=$jsonObj[i].id;
				dimMap.type=$jsonObj[i].type;
				dimMap.varname=$jsonObj[i].varname;
				dimMap.table=$jsonObj[i].table;
				dimMap.field=$jsonObj[i].field;
				dimMap.desc=$jsonObj[i].desc;
				dimMap.name=$jsonObj[i].desc;
				dimMap.codecolumn=$jsonObj[i].codecolumn;
				dimMap.desccolumn=$jsonObj[i].desccolumn;
				dimMap.level=$jsonObj[i].level;
				dimMap.ordercolumn=$jsonObj[i].ordercolumn;
				dimMap.parentcol=$jsonObj[i].parentcol;
				dimMap.parentdimname=$jsonObj[i].parentdimname;
				dimMap.isselectm=$jsonObj[i].isselectm;
				dimMap.index=$jsonObj[i].index;
				dimMap.sql=$jsonObj[i].sql;
				dimMap.createtype=$jsonObj[i].createtype;
				dimMap.defaultvalue=$jsonObj[i].defaultvalue;
				dimMap.isparame=$jsonObj[i].isparame;
				dimMap.formula=$jsonObj[i].formula;
				dimMap.showtype=$jsonObj[i].showtype;
				dimMap.fieldid=$jsonObj[i].fieldid;
				dimMap.fieldtype=$jsonObj[i].fieldtype;
				dimMap.datasourceid = $jsonObj[i].datasourceid;
				dimMap.conditiontype = $jsonObj[i].conditiontype;
				//dimMap.index = index;
				dimMap.isparame = "1";
				//设置成参数以后不能设置维度
				unHref(dimMap.var_name,dimMap.desc);
				cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(dimMap),function(e,d){});
		    }
		}else{
			$("#checkall").iCheck('uncheck');//$(":input").removeAttr("checked");
			$("input[checkone='checkone']").iCheck('uncheck');
			for(var i =0;i<$jsonObj.length;i++){
				var $dimCheckObj = $("#check"+$jsonObj[i].varname);
				var $liCheckObj = $("#li"+$jsonObj[i].varname);
				$dimCheckObj.attr("isparame","0");
				$liCheckObj.attr("isparame","0");
			
			    var dimMap = {};
			    dimMap.var_name = $jsonObj[i].varname;
		   		dimMap.id=$jsonObj[i].id;
				dimMap.type=$jsonObj[i].type;
				dimMap.varname=$jsonObj[i].varname;
				dimMap.table=$jsonObj[i].table;
				dimMap.field=$jsonObj[i].field;
				dimMap.desc=$jsonObj[i].desc;
				dimMap.name=$jsonObj[i].desc;
				dimMap.codecolumn=$jsonObj[i].codecolumn;
				dimMap.desccolumn=$jsonObj[i].desccolumn;
				dimMap.level=$jsonObj[i].level;
				dimMap.ordercolumn=$jsonObj[i].ordercolumn;
				dimMap.parentcol=$jsonObj[i].parentcol;
				dimMap.parentdimname=$jsonObj[i].parentdimname;
				dimMap.isselectm=$jsonObj[i].isselectm;
				dimMap.index=$jsonObj[i].index;
				dimMap.sql=$jsonObj[i].sql;
				dimMap.createtype=$jsonObj[i].createtype;
				dimMap.defaultvalue=$jsonObj[i].defaultvalue;
				dimMap.isparame=$jsonObj[i].isparame;
				dimMap.formula=$jsonObj[i].formula;
				dimMap.showtype=$jsonObj[i].showtype;
				dimMap.fieldid=$jsonObj[i].fieldid;
				dimMap.fieldtype=$jsonObj[i].fieldtype;
				dimMap.datasourceid = $jsonObj[i].datasourceid;
				dimMap.conditiontype = $jsonObj[i].conditiontype;
				//dimMap.index = index;
				dimMap.isparame = "0";
				//取消设置成参数后可以设置维度
				onHref(dimMap.var_name,dimMap.desc);
				cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(dimMap),function(e,d){ });
		    }
		}
	}
	function checkdim(id){
		var $dimCheckObj = $("#check"+id);
		var $liCheckObj = $("#li"+id);
		var $jsonObj = $.parseJSON('${jsonString}');
		var checkrs = $dimCheckObj.attr("checked");
		if(checkrs == 'undefined' || checkrs == undefined){
			$dimCheckObj.attr("isparame","1");
			$liCheckObj.attr("isparame","1");
			var var_name = $dimCheckObj.attr("attid");
			for(var i =0;i<$jsonObj.length;i++){
			    if(var_name == $jsonObj[i].varname){
			    	var dimMap = {};
				    dimMap.var_name = $dimCheckObj.attr("attid");
			   		dimMap.id=$jsonObj[i].id;
					dimMap.type=$jsonObj[i].type;
					dimMap.varname=$jsonObj[i].varname;
					dimMap.table=$jsonObj[i].table;
					dimMap.field=$jsonObj[i].field;
					dimMap.desc=$dimCheckObj.attr("varname");
					dimMap.name=$jsonObj[i].desc;
					dimMap.codecolumn=$jsonObj[i].codecolumn;
					dimMap.desccolumn=$jsonObj[i].desccolumn;
					dimMap.level=$jsonObj[i].level;
					dimMap.ordercolumn=$jsonObj[i].ordercolumn;
					dimMap.parentcol=$jsonObj[i].parentcol;
					dimMap.parentdimname=$jsonObj[i].parentdimname;
					dimMap.isselectm=$jsonObj[i].isselectm;
					dimMap.index=$jsonObj[i].index;
					dimMap.sql=$jsonObj[i].sql;
					dimMap.createtype=$jsonObj[i].createtype;
					dimMap.defaultvalue=$jsonObj[i].defaultvalue;
					dimMap.isparame=$jsonObj[i].isparame;
					dimMap.formula=$jsonObj[i].formula;
					dimMap.showtype=$jsonObj[i].showtype;
					dimMap.fieldid=$jsonObj[i].fieldid;
					dimMap.fieldtype=$jsonObj[i].fieldtype;
					dimMap.datasourceid = $jsonObj[i].datasourceid;
					dimMap.conditiontype = $jsonObj[i].conditiontype;
					//dimMap.index = index;
					dimMap.isparame = "1";
					cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(dimMap),function(e,d){
						//设置成参数以后不能设置维度
						unHref(var_name,dimMap.desc);
					});
			    }
		    }
		}else{
			$dimCheckObj.attr("isparame","0");
			$liCheckObj.attr("isparame","0");
			
			var var_name = $dimCheckObj.attr("attid");
			for(var i =0;i<$jsonObj.length;i++){
			    if(var_name == $jsonObj[i].varname){
			    	var dimMap = {};
				    dimMap.var_name = $dimCheckObj.attr("attid");
			   		dimMap.id=$jsonObj[i].id;
					dimMap.type=$jsonObj[i].type;
					dimMap.varname=$jsonObj[i].varname;
					dimMap.table=$jsonObj[i].table;
					dimMap.field=$jsonObj[i].field;
					dimMap.desc=$dimCheckObj.attr("varname");
					dimMap.name=$jsonObj[i].desc;
					dimMap.codecolumn=$jsonObj[i].codecolumn;
					dimMap.desccolumn=$jsonObj[i].desccolumn;
					dimMap.level=$jsonObj[i].level;
					dimMap.ordercolumn=$jsonObj[i].ordercolumn;
					dimMap.parentcol=$jsonObj[i].parentcol;
					dimMap.parentdimname=$jsonObj[i].parentdimname;
					dimMap.isselectm=$jsonObj[i].isselectm;
					dimMap.index=$jsonObj[i].index;
					dimMap.sql=$jsonObj[i].sql;
					dimMap.createtype=$jsonObj[i].createtype;
					dimMap.defaultvalue=$jsonObj[i].defaultvalue;
					dimMap.isparame=$jsonObj[i].isparame;
					dimMap.formula=$jsonObj[i].formula;
					dimMap.showtype=$jsonObj[i].showtype;
					dimMap.fieldid=$jsonObj[i].fieldid;
					dimMap.fieldtype=$jsonObj[i].fieldtype;
					dimMap.datasourceid = $jsonObj[i].datasourceid;
					dimMap.conditiontype = $jsonObj[i].conditiontype;
					//dimMap.index = index;
					dimMap.isparame = "0";
					cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(dimMap),function(e,d){
						//取消设置成参数后可以设置维度
						onHref(var_name,dimMap.desc);
					});
			    }
		    }
		}
	}
	
</script>
<style type="text/css">
body ul.ui-sortable li.ui-state-default>div{ margin-top:-8px!important;}
</style>
<div class="checkboxGroup1">
	<e:if condition="${isnull !=null && isnull ne '0'}">
		<p><input class="checkN" type="checkbox" id ="checkall" name="checkall" onclick="onCheckAll();"> 是否全部为参数</p>
	</e:if>
	<ul id="sortable">
		<e:forEach items="${e:json2java(dimString)}" var="item">
			<li class="ui-state-default" id="li${item.varname }" attid="${item.varname }" atttype="${item.type }" isparame = "${item.isparame }" varname="${item.desc }">
					<input class="checkN" type="checkbox" id ="check${item.varname }" attid="${item.varname }" checkone="checkone" varname="${item.desc }" onclick="checkdim('${item.varname }');">
					<span class="delBtn_sql" id="labelp${item.varname }">${item.desc }<%if(reportObj !=null && "2".equals(reportObj.getInfo().getType())){ %><a class="colbtn" href="javascript:void(0)" onclick="javascript:delDim('${item.varname }')">删除</a><%} %></span>
			</li>
		</e:forEach>
	</ul>
</div>
<script>
$(function(){
	$("input[name='checkall']").iCheck({
	    labelHover : false,
	    cursor : true,
	    checkboxClass : 'icheckbox_square-blue',
	    radioClass : 'iradio_square-blue',
	    increaseArea : '20%'
	}).on('ifClicked', function(event){
	  	onCheckAll();
	});
	$("input[checkone='checkone']").iCheck({
	    labelHover : false,
	    cursor : true,
	    checkboxClass : 'icheckbox_square-blue',
	    radioClass : 'iradio_square-blue',
	    increaseArea : '20%'
	}).on('ifClicked', function(event){
		var varname = $(this).attr("attid");
	  	checkdim(varname);
	});
});
</script>
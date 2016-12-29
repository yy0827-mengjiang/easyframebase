var rsList = [];
var flag = false;
function delDim(dim_name) {
	hideToolsPanel();//隐藏左边框
	$.messager.confirm('确认信息','您确定要删除当前查询条件吗?',function(msg){
		if(msg) {
			var flag = false;
			if(dim_name == null || dim_name == "") {
				dim_name = $("#dim_var_name").val();
				flag = true;
			}
			cn.com.easy.xbuilder.service.DimensionService.delDimsion(StoreData.xid,dim_name,function(result,exception){
				if(flag) {
					$propertiesPage = autoAppendObj("dimproperties");
					autoAppendObj("dimproperties").hide();
					$propertiesPage.empty(); 
					hideToolsPanel();//隐藏左边框
				} else { //点击全部参数中的删除操作
					//openAlldim();
					hideToolsPanel();//隐藏左边框
					$('a[dimcol='+dim_name+']').attr('class','weiLink_default');//取消维度选中
				}
				//删除rsList中的查询条件
				if(rsList.length > 0) {
					rsList = removeObj(rsList,dim_name);
				}
				editDim();
			});
		} else {
			toolsPanel();//打开左边框
			$('a[dimcol='+dim_name+']').attr('class','weiLink_active');//选中维度
		}
	});
	
}

function delDim_cq(dim_name) {
	if($('#tools_panel').css('display')=='none'){//为了避免面板冲突在查询条件区域点击加时隐藏面板
		hideToolsPanel();
		$('.kpiSelectorCon').hide();
	};
	$.messager.confirm('确认信息','您确定要删除当前查询条件吗?',function(msg){
		if(msg) {
			var flag = false;
			if(dim_name == null || dim_name == "") {
				dim_name = $("#dim_var_name").val();
				flag = true;
			}
			cn.com.easy.xbuilder.service.DimensionService.delDimsion(StoreData.xid,dim_name,function(result,exception){
				if(flag) {
					$propertiesPage = autoAppendObj("dimproperties");
					autoAppendObj("dimproperties").hide();
					$propertiesPage.empty(); 
					hideToolsPanel();//隐藏左边框
				} else { //点击全部参数中的删除操作
					//openAlldim();
					$('a[dimcol='+dim_name+']').attr('class','weiLink_default');//icheck选中取消时重新勾选
				}
				//删除rsList中的查询条件
				if(rsList.length > 0) {
					rsList = removeObj(rsList,dim_name);
				}
				editDim();
			});
		} else {
			$('a[dimcol='+dim_name+']').attr('class','weiLink_active');//icheck选中取消时重新勾选
		}
	});
	
}
function removeObj(arr, val) {
	var newArray = new Array();
	for(var i = 0; i < arr.length; i++) {
		if(arr[i].varname != val) {
			newArray.push(arr[i]);
		}
	}
	return newArray;
}
/**
*编辑查询条件
*/
function editDim(){
	cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(result,exception){
		if(result != null && result != "" && result!= "null") {
			var dataArr = $.parseJSON(result);
			selectDim(dataArr,'1');
			rsList = [];
			$.each(dataArr,function(index,item){
				rsList.push(item);
			});
		}
	});
}
/**
*自动注入查询条件
*/
function addDimFromSql(){
	cn.com.easy.xbuilder.service.DimensionService.getRestrainVar(StoreData.xid,function(data,exception){
	    if(data!=""){
	    	selectDim(data,'1');
	    }else{
	    	//当没有变量时，删除所有对应显示与XML内容
	    	cn.com.easy.xbuilder.service.DimensionService.removeAllDimsion(StoreData.xid,function(data,exception){
				var $dimsion = $("#dimsion");
				$dimsion.empty();
				//setAllDim('1');
			});
	    }
	});
}
function openAlldim(){
	toolsPanel();//打开左边框
	setProPageTitle("查询条件属性设置");
	setAllDim('1');
}
function autoAppendObj(id){
	$object = $("#"+id);
	var $propertiesPage = $("#propertiesPage");
	var len = $propertiesPage.find("div[id='"+id+"']").length;
	if(len>0){
		return $object;
	}else{
		 var $autoDivObj = $("<div id=\""+id+"\" objtype = 'container'></div>");
		 $autoDivObj.appendTo($propertiesPage);
         $.parser.parse($propertiesPage);
         return $("#"+id);
	}
}
function divObjEmpty(){	
	//var $dimproall = autoAppendObj("dimproall");
	var $dimproallCache = $("#dimproallCache");
	//var $dimproperties = autoAppendObj("dimproperties");
	var $dimpropertiesCache = $("#dimpropertiesCache");
	//var $dimtemplateview = autoAppendObj("dimtemplateview");
	var $dimtemplateviewCache = $("#dimtemplateviewCache");
	$("#propertiesPage").empty();
	autoAppendObj("dimproall").html($dimproallCache.html());
	autoAppendObj("dimproperties").html($dimpropertiesCache.html());
	autoAppendObj("dimtemplateview").html($dimtemplateviewCache.html());
	$.parser.parse($("#propertiesPage"));
}
function dataMove(){
	var $dimproall = autoAppendObj("dimproall");
	var $dimproallCache = $("#dimproallCache");
	var $dimproperties = autoAppendObj("dimproperties");
	var $dimpropertiesCache = $("#dimpropertiesCache");
	var $dimtemplateview = autoAppendObj("dimtemplateview");
	var $dimtemplateviewCache = $("#dimtemplateviewCache");
	$dimproallCache.empty();
	$dimproallCache.html($dimproall.html());
	$dimpropertiesCache.empty();
	$dimpropertiesCache.html($dimproperties.html());
	$dimtemplateviewCache.empty();
	$dimtemplateviewCache.html($dimtemplateview.html());
}
/*
*设置所有查询条件
*/
function setAllDim(status){
	if(status != null && status != undefined && status != '0' ){
		toolsPanel();//打开左边框
		setProPageTitle("查询条件属性设置");
		divObjEmpty();//容器清空
		$propertiesPage = autoAppendObj("dimproall");//$("#dimproall");
		$propertiesPage.show(); 
		$propertiesPage.empty();
		var param = {};
		param.dataStr = $("#dimsion").attr("dstr");
		if(param.dataStr != undefined)
			param.dataStr = param.dataStr.replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "").replace(/(^\s*)|(\s*$)/g, "");
		param.reportId = StoreData.xid;
		$propertiesPage.load(appBase+'/pages/xbuilder/dimension/DimensionAllSeting.jsp',param,function(){
			//dataMove();//数据复制
			autoAppendObj("dimproperties").hide();//$("#dimproperties").hide();
			autoAppendObj("dimtemplateview").hide();//$("#dimtemplateview").hide();
	        $.parser.parse($propertiesPage);
	    });
		if(window["tableHideColSelectorWin"]!=undefined){
			tableHideColSelectorWin();//指标库类型时，关闭指标列表窗口
		}
    }
}

//指标库数据源，添加查询条件
function addDimFromKpi(){
	 var cubeId = StoreData.cubeId;
	 conditionKpiSelector.open(cubeId);
}

//自定义SQL，添加查询条件
function addSQLWhere(){
	 var xid = StoreData.xid;
	 conditionSqlSelector.open(xid);
}

function addRsList(data) {
	if(rsList.length > 0) {
		var flag = false;
		var tmpList = [];
		for(var i = 0; i < rsList.length; i++) {
			if(rsList[i].fieldid == data.fieldid) {
				flag = true;
				tmpList.push(data.name);
			}
		}
		if(!flag) {
			rsList.push(data);
		} else {
			$.messager.alert("提示信息！","查询条件填写错误!<br/>错误信息：<span style=\"color:red\">"+tmpList.join(",") +"查询条件已经存在</span>","error");
		} 
	} else {
		rsList.push(data);
	}
}
//初始化reList
function setRsList(pagedata,selectType){
	sqlSelectorService.getRestrainVar(StoreData.xid,function(data,exception){
		 if(data!=""){
		 	rsList = [];
		 	for(var i=0;i<data.length;i++){
		 		var info = {};
		 		info.var_name=data[i].varname;
				info.varname =data[i].varname;
				info.type=data[i].type;
				info.parentcol = data[i].parentcol;
				info.parentdimname= data[i].parentdimname;
				info.table = data[i].table;
				info.codecolumn = data[i].codecolumn;
				info.desccolumn= data[i].desccolumn;
				info.ordercolumn= data[i].ordercolumn;
				info.sql = data[i].sql;
				info.desc = data[i].desc.replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "").replace(/(^\s*)|(\s*$)/g, "");
				info.database = data[i].database;
				info.defaultvalue = data[i].defaultvalue;
				info.id = data[i].id;
				info.showtype = data[i].showtype;
				info.formula = data[i].formula;
				if(data[i].conditiontype=="1"){
					info.fieldid = data[i].vardesc;//拖过来的
				}else{
					info.fieldid = data[i].varname;//原来的
				}
				info.fieldtype = data[i].fieldtype;
				info.isparame = data[i].isparame;
				info.createtype = data[i].createtype;
				info.databasename = '';
				info.level = data[i].level;
				info.index = data[i].index;
				info.datasourceid = data[i].datasourceid;
				info.conditiontype = data[i].conditiontype;
				info.vardesc = data[i].vardesc;
				addRsList(info);
		 	}
		 	enterDim(pagedata,selectType);
		 }else{
		 	enterDim(pagedata,selectType);
		 }
	});
}
//指标库模式自动初始化查询条件
function autoInitDim(cubeId) {
	cn.com.easy.xbuilder.service.DimensionService.autoInitDimsionForKpi(cubeId,function(mydata,exception){
		if(mydata != null && mydata.length > 0) {
			for(var i = 0; i < mydata.length; i++){
				addRsList(mydata[i]);
				selectDim(rsList,'1');
			}
		}
	});
}
//指标进入查询条件统一入口
function enterDim(data,selectType){
	//指标库模式
	if(StoreData.dsType=="2"){
		cn.com.easy.xbuilder.service.DimensionService.getDimsionForKpi($.toJSON(data[0]),StoreData.cubeId,function(mydata,exception){
			addRsList(mydata);
			selectDim(rsList,'1');
			if(data.length>0){
				$('a[dimcol='+data[0].column+']').attr('class','weiLink_active');//选中维度
			}
		});
	} else {
		for(var i = 0;i<data.length;i++){
			var info = {};
			info.var_name=data[i].column;
			info.varname =data[i].column;
			info.type='INPUT';
			info.parentcol  = '';
			info.parentdimname= '';
			info.table = '';
			info.codecolumn = '';
			info.desccolumn= '';
			info.ordercolumn= '';
			info.sql = '';
			info.desc = data[i].desc.replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "").replace(/(^\s*)|(\s*$)/g, "");
			info.database = '';
			info.defaultvalue = '';
			info.id = data[i].column;
			info.showtype ='0';
			info.formula = "05";
			if(StoreData.dsType=="2"){
				info.fieldid = data[i].id;//字段ID   指标库
			}else{
				info.fieldid = data[i].vardesc;//字段ID  非指标库
			}
			info.fieldtype =data[i].kpiType;
			info.isparame = '0';
			info.createtype = '1';
			info.databasename = '';
			info.level = '0';
			info.index = i;
			if(data[i].datasourceid != null)
				info.datasourceid = data[i].datasourceid;
			else
				info.datasourceid = "";
			if(data[i].conditiontype != null)
				info.conditiontype = data[i].conditiontype;
			else
				info.conditiontype = "";
			info.vardesc = data[i].vardesc;
			addRsList(info);
		}
		selectDim(rsList,'1');
	}
}
function selectDim(data,status){
 	var $dimsion = $("#dimsion");
	$dimsion.empty();
	$dimsion.attr("dstr","");
	$dimsion.attr("dstr",$.toJSON(data));
	//var dataList = [];
	$(data).each(function (index, domEle){
	   var info = domEle;
	   info.extds = info.database;
       var paramInfo = {};
       paramInfo.idend = '0';
       if((index+1)==data.length){
       	   paramInfo.idend = '1';
       }
       paramInfo.reportId = StoreData.xid;//报表ID
       var varname = info.var_name == undefined?'':info.var_name;
       if(varname == null || varname == '' || varname == undefined){
       	   varname = info.varname == undefined?'':info.varname;
       	   info.var_name = info.varname;
       }
       paramInfo.filed = info.filed;
       paramInfo.dimvar = varname;//变量名称
       paramInfo.var_name = varname;//变量名称
       paramInfo.desc=info.desc == undefined?'':info.desc;
       if(info.type != null && info.type != undefined && info.type != ''){
	       paramInfo.type = info.type;
       }else{
       	   paramInfo.type = 'INPUT';
       }
       paramInfo.dim_parent_col = info.parentcol == undefined?'':info.parentcol;//上级字段名称
       paramInfo.parent_dim_name = info.parentdimname;//上级变量名称
       paramInfo.dim_table = info.table == undefined?'':info.table;
       paramInfo.dim_col_code = info.codecolumn == undefined?'':info.codecolumn;
       paramInfo.dim_col_desc = info.desccolumn;
       paramInfo.dim_col_ord = info.ordercolumn;
       paramInfo.select_double = '';//增加是否复选
       if(info.sql != null && info.sql !='' && info.sql!=undefined){
       	   paramInfo.dim_sql=base64encode(utf16to8(info.sql.replace(/\r\n/g,'')));
       }else{
           paramInfo.dim_sql='';
       }
       paramInfo.dim_create_type=info.createtype;
       paramInfo.dim_var_desc=info.desc;
       paramInfo.extds=info.database;
       paramInfo.dim_lvl=info.level;
       
       paramInfo.dimId=info.id;
       paramInfo.id=info.id;
       paramInfo.showtype=info.showtype;
       //指标标来源使用 start
       paramInfo.formula=info.formula;
	   paramInfo.fieldid=info.fieldid;
	   paramInfo.fieldtype=info.fieldtype;
       //指标标来源使用 end
       if(info.isparame != undefined && info.isparame == '1'){
			paramInfo.isparame = '1';
		}else{
			paramInfo.isparame = '0';
		}
       paramInfo.index = index;
       info.index = index;
       paramInfo.conditiontype = info.conditiontype;
       paramInfo.datasourceid = info.datasourceid;
       paramInfo.vardesc = info.vardesc;
       if(paramInfo.type == "SELECT" || paramInfo.type == "CASELECT") {
    	   paramInfo.createType=info.createtype;
    	   if(info.sql != null && info.sql != undefined && info.sql != ''){
    		   paramInfo.dimsql = base64encode(utf16to8(info.sql.replace(/\r\n/g,'')));
    	   } else  {
    		   paramInfo.dimsql = '';
    	   }
    	   paramInfo.database_name = info.database;
    	   paramInfo.databaseName = info.database;
    	   paramInfo.caslvl = info.level;
       }
       loadDimView(paramInfo,status,info);
//       if(paramInfo.type=="SELECT"||paramInfo.type=="CASELECT"){
//	       paramInfo.createType=info.createtype;
//	       if(info.sql != null && info.sql != undefined && info.sql != ''){
//	       		paramInfo.dimsql = base64encode(utf16to8(info.sql));
//	       }else{
//	       		paramInfo.dimsql = '';
//	       }
//	       paramInfo.database_name = info.database;
//	       paramInfo.databaseName = info.database;
//	       paramInfo.caslvl = info.level;
//	        $.ajax({
//		        type : "post",
//		        url : appBase+"xbuilder/varcharge.e",
//		        data : paramInfo,
//		        cache: false,
//		        async : false,
//		        success : function(data) {
//	       		   if($.trim(data).indexOf("FAIL")==0){
//	       			  //loadDimView(paramInfo,status,info);
//			          $.messager.alert("提示信息！","表相关信息填写错误!<br/>错误信息：<span style=\"color:red\">"+data.substr(4)+"</span>","error");
//	       		   }else{
//			          loadDimView(paramInfo,status,info);
//			       }
//	            }
//            }); 
//       }else{
//         loadDimView(paramInfo,status,info);
//       }
    });
}
function onHref(varname,vardesc){
	var $dimsion = $("#dimsion");
	var $set = $("<span class=\"icoSet\" id='seting"+varname+"' onclick=\"setdim('"+varname+"','"+vardesc+"')\">设置</span>");
	var $selectSpan = $("#selectSpan"+varname);
	var $setOld = $("#seting"+varname);
	$setOld.remove();
	$set.appendTo($selectSpan);
	$.parser.parse($selectSpan);
	$.parser.parse($dimsion);
}
function unHref(varname,vardesc){
	var $dimsion = $("#dimsion");
	var $set = $("<span class=\"icoUnSet\" id='seting"+varname+"')\">设置</span>");//需要这个样式的时候添加一个图标icoUnSet
	var $selectSpan = $("#selectSpan"+varname);
	var $setOld = $("#seting"+varname);
	$setOld.remove();
	$set.appendTo($selectSpan);
	$.parser.parse($selectSpan);
	$.parser.parse($dimsion);
}
function loadDimView(paramInfo,status,info){
	var $dimsion = $("#dimsion");
	$dimsion.attr("dstr","");
	$dimsion.attr("dstr",$.toJSON(paramInfo));
	var pagespath = appBase + "/pages/xbuilder/dimension/DimensionViewSet.jsp";
    var $newSelect = $("<span class=\"selectSpan\" id=\"selectSpan"+paramInfo.var_name+"\" style=\"display:inline-block;\"></span>");//查询条件容器
    var del = "";
    if(StoreData.dsType == '2') {
        del = "<span class=\"icoCancle\" id='delete"+paramInfo.var_name+"' onclick=\"delDim('"+paramInfo.var_name+"')\">删除</span>";
    }
    var $set = $("<span class=\"icoSet\" id='seting"+paramInfo.var_name+"' onclick=\"setdim('"+paramInfo.var_name+"','"+paramInfo.desc+"')\">设置</span>" +del);//查询条件单个设置
    var isparam = paramInfo.isparame;
     if(isparam !=null && isparam!=undefined && isparam == '1'){
    	$set = $("<span class=\"icoUnSet\" id='seting"+paramInfo.var_name+"')\">设置</span>" +del);
    } 
    $.ajax({
        type : "post",
        url : pagespath,
        data : paramInfo,
        cache: false,
        async : false,
        success : function(data) {
          //注入选择条件HTML
          data = data.replace(/\t/g,'').replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "");
          $newSelect.html(data);
          $set.appendTo($newSelect);
          $newSelect.appendTo($dimsion);//最后加载到查询条件容器
          $.parser.parse($dimsion);//编译查询条件容器
          cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(info),function(e,d){
	         //setAllDim(status);
	         //最近一次执行事件
	         if(StoreData.dsType == '2') {
	        	  if(paramInfo.idend !=null 
	        			  && paramInfo.idend != undefined 
	        			  && paramInfo.idend != '' 
	        			  && paramInfo.idend == '1'){
	        		  //保存指标库SQL语句查询条件
	        		  cn.com.easy.xbuilder.service.DimensionService.addDimsionForKpi(StoreData.xid,function(e,d){
	        		  });
	 	         }
	         }
	      });
	    },
	    error: function(XMLHttpRequest, textStatus, errorThrown) {
	    	  $newSelect.html("<span class=\"searchItemName\" id=\"label" + paramInfo.dimvar+ "\">" + paramInfo.dim_var_desc + "</span><input type=\"text\" id=\""+paramInfo.reportId +paramInfo.dimvar+"\" name=\""+ paramInfo.reportId+paramInfo.dimvar+"\" style=\"width:145px; \"/>");
	          $set.appendTo($newSelect);
	          $newSelect.appendTo($dimsion);//最后加载到查询条件容器
	          $.parser.parse($dimsion);//编译查询条件容器
	          hideToolsPanel();
	  		  $.messager.alert("提示信息！","参数定义错误!<br/>错误信息：<span style=\"color:red\">数据集参数配置错误，组成SQL失败。</span>","error",function(){
	  			 toolsPanel();
	  		  });
	    }
     }); 
}
/**
*设置单个查询条件
*@param  id 为变量名称  area_no
*@param  name 为变量中文名称 地市  区县
**/
function setdim(id,name){
	toolsPanel();//打开左边框
	setProPageTitle("查询条件属性设置【" + name + "】");
	divObjEmpty();
	$propertiesPage = autoAppendObj("dimproperties");//$("#dimproperties");
	autoAppendObj("dimproall").hide();//$("#dimproall").hide();
	autoAppendObj("dimproperties").show();//$("#dimproperties").show();
	autoAppendObj("dimtemplateview").hide();//$("#dimtemplateview").hide();
	$propertiesPage.empty(); 
	var param = {};
	param.reportId = StoreData.xid;
	param.varname = id;
	param.desc = name;
	$propertiesPage.load(appBase+'/pages/xbuilder/dimension/DimensionProperties.jsp',param,function(){
        $.parser.parse($propertiesPage);
        var dim_var_name=param.varname;
		if(dim_var_name!=undefined&&dim_var_name!=null){
			cn.com.easy.xbuilder.service.DimensionService.getEditDimsion(StoreData.xid,dim_var_name,function(data,exception){
				if(data!=""){
			    	var jsonObj=$.parseJSON(data);
			    	fillRestrainForm(jsonObj);
			    }
			});
		}else{
			showSimple();
		}
    });
	if(window["tableHideColSelectorWin"]!=undefined){
		tableHideColSelectorWin();//指标库类型时，关闭指标列表窗口
	}
}
/**
*保存所有属性
***/

function saveDimsion(){
	var dimInfo=getPropertiesObj();
 	cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(dimInfo),addDimsionBack);
}
//添加或修改维度回调
function addDimsionBack(data,exception){ 
	$("#isModel").val("1");//用来区分是否是选择了模板
	 var value = $("#dim_var_type").val();
	 var table=$("#dim_table").val();//码表名称
	 var codecolumn=$("#dim_col_code").val();//编码字段
	 var desccolumn=$("#dim_col_desc").val();//中文字段
	 //var ordercolumn=$("#dim_col_ord").val();//排序字段
	 var ordercolumn=$("#dim_col_ord").val();//排序字段
	 var sql=$("#sql").val();
	 var createtype = $("input[name=createType]:checked").val();
	 
	 var level=parseInt($("#caslvl").val()+"");//联动级别 
	 var parentcol=$("#dim_parent_col").val();//上级维度编码
	 
	 if(value==""||value=="INPUT"||value=="UPLOAD"||value=="MONTH"||value=="DAY"||value=="HIDDEN"){
		 cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(data1,exception){
		 	selectDim($.parseJSON(data1),'0');
		 });
	 }else if(value=="SELECT"){
 		if((table !=null && table != undefined && table != '' &&
 		   codecolumn !=null && codecolumn != undefined && codecolumn != '' &&
 		   desccolumn !=null && desccolumn != undefined && desccolumn != '' &&
 		   ordercolumn !=null && ordercolumn != undefined && ordercolumn != '' && 
 		   createtype !=null && createtype != undefined && createtype == '1' )||
 		   (sql !=null && sql != undefined && sql != ''&& 
 		   createtype !=null && createtype != undefined && createtype == '2')
 		){
 			 cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(data2,exception){
			 	selectDim($.parseJSON(data2),'0');
			 });
 		}
	 }else{
	 	var rstemp = false;
		if(table !=null && table != undefined && table != '' &&
 		   codecolumn !=null && codecolumn != undefined && codecolumn != '' &&
 		   desccolumn !=null && desccolumn != undefined && desccolumn != '' &&
 		   ordercolumn !=null && ordercolumn != undefined && ordercolumn != '' && 
 		   createtype !=null && createtype != undefined && createtype == '1' ){
 		   		rstemp = true;
 		 }else if(sql !=null && sql != undefined && sql != ''&& 
 		   createtype !=null && createtype != undefined && createtype == '2') {
 		   		rstemp = true;
 		 }   
 		if(level !=null && level !=undefined && level <= 1 && rstemp){
 			cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(data3,exception){
			 	selectDim($.parseJSON(data3),'0');
			});
 		}else if(level !=null && level !=undefined && level > 1 && 
 		         parentcol !=null && parentcol !=undefined && parentcol > 1 &&
 		       rstemp){
 			cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(data4,exception){
			 	selectDim($.parseJSON(data4),'0');
			});
 		}
	 }
}
//获取约束条件属性值
function getPropertiesObj(){
	var dimInfo=new Object();
 		dimInfo.var_name=$("#dim_var_name").val();//变量名:AREA_NO
 		dimInfo.filed = $("#filed").val();
 		dimInfo.desc=$("#dim_var_desc").val();//维度名称
 		$("#label"+dimInfo.var_name).text(dimInfo.desc);
 		dimInfo.type=$("#dim_var_type").val();//类别:INPUT、SELECT、MONTH...
 		dimInfo.database=$("#database_name1").val();//数据源
 		dimInfo.sql=$("#sql").val();//sql语句
 		dimInfo.extds=$("#database_name1").val();//数据源
 		dimInfo.table=$("#dim_table").val();//码表名称
 		dimInfo.codecolumn=$("#dim_col_code").val();//编码字段
 		dimInfo.desccolumn=$("#dim_col_desc").val();//中文字段
 		dimInfo.ordercolumn=$("#dim_col_ord").val();//排序字段
 		dimInfo.level=$("#caslvl").val();//联动级别
 		dimInfo.parentcol=$("#dim_parent_col").val();//上级维度编码
 		dimInfo.parentdimname=$("#parent_dim_name").val();//上级维度编码
 		//dimInfo.defaultvalue=$("#defaule_value").val();//默认值
// 		dimInfo.createtype=$("input[name=createType]:checked").val();//创建类型
// 		dimInfo.isselectm=$("input[name=select_double]:checked").val();//是否复选
 		dimInfo.createtype= $("#create_type").val();//创建类型
 		dimInfo.isselectm = $("#select_double_s").val();//是否复选
 		dimInfo.showtype=$("#showtype").val();//显示方式
 		dimInfo.formula=$("#formula").val();//指标库使用的公式
 		dimInfo.fieldid=$("#fieldid").val();//指标库中的ID
 		dimInfo.fieldtype=$("#fieldtype").val();//类型 dim维度 kpi指标
 		
 		//常量还是用户属性
 		dimInfo.datasourceid = $("#datasourceid").val();
 		dimInfo.conditiontype = $("#conditiontype").val();
 		dimInfo.defaultvaluetype=$("#defaultvaluetype").val();
 		dimInfo.vardesc = $("#vardesc").val();
 		var deftype = $("#defaultvaluetype").val();
 		if("1"==deftype){
 			$("#inpVal").show();
			$("#selVal").hide();
 			dimInfo.defaultvalue = $("#inpVal").val();
 		}else if("2"==deftype){
 			$("#inpVal").hide();
			$("#selVal").show();
 			dimInfo.defaultvalue = $("#selVal").val();
 		}
 		return dimInfo;
}
/**
*回显约束条件属性
**/
function fillRestrainForm(jsonData){
	//指标来源时使用
	$("#formula").val(jsonData.formula);
	$("#fieldid").val(jsonData.fieldid);
	$("#fieldtype").val(jsonData.fieldtype);
	$("#field").val(jsonData.field);

	$("#dim_var_desc").val(jsonData.desc);
	//$("#dim_var_type").val(data.type);
	$("#database_name1").val(jsonData.sql.extds);
	
  	$("#dim_table").val(jsonData.table);
  	$("#dim_col_code").val(jsonData.codecolumn);
  	$("#dim_col_desc").val(jsonData.desccolumn);
  	$("#dim_col_ord").val(jsonData.ordercolumn);
  	if(jsonData.showtype==""){
  		$("#showtype").val("0");
  	}else{
  		$("#showtype").val(jsonData.showtype);
  	}
  	$("#sql").val(jsonData.sql.sql);
    $("#caslvl").val(jsonData.level);
    if(jsonData.createtype == "") {
    	$("#create_type").val("1");
    } else {
    	$("#create_type").val(jsonData.createtype);
    }
    
//    $("#parent_dimid").val(jsonData.parentdimname + "@" +jsonData.parentcol);
    $("#dim_parent_col").val(jsonData.parentcol);
	$("#parent_dim_name").val(jsonData.parentdimname);
   // $("#defaule_value").val(jsonData.defaultvalue);
    //常量还是用户属性
    $("#datasourceid").val(jsonData.datasourceid);
    $("#conditiontype").val(jsonData.conditiontype);
    $("#vardesc").val(jsonData.vardesc);
    if(jsonData.datasourceid!="" && jsonData.conditiontype!= ""){
    	$("#dtcondtion").show();
    }else{
    	$("#dtcondtion").hide();
    }
    
    
    var defaultValueType = jsonData.defaultValueType;
    if(jsonData.defaultValueType==""){
    	 $("#defaultvaluetype").val("1");
    }else{
    	$("#defaultvaluetype").val(jsonData.defaultValueType);
    }
    if("1"==defaultValueType){
    	$("#inpVal").show();
		$("#selVal").hide();
    	$("#inpVal").val(jsonData.defaultvalue);
    }else if("2"==defaultValueType){
    	$("#inpVal").hide();
		$("#selVal").show();
    	$("#selVal").val(jsonData.defaultvalue);
    }
    $("#dim_var_type").val(jsonData.type);
    $("#select_double_s").val(jsonData.isselectm);
    var var_type=jsonData.type;
	//回显类别
	if(var_type==""||var_type=="INPUT"||var_type=="MONTH"||var_type=="DAY"||var_type=="HIDDEN"||var_type=="UPLOAD"){
		$("#dimVarType00").iCheck('check'); 
		showSimple();
	}else if(var_type=="SELECT"){
		showSelect(jsonData.createtype);
	}else if(var_type=="CASELECT"){
		showCascade(jsonData.createtype,jsonData.level);
	}
	$("[name='dimVarType']:radio").each(function(index,item){
		if(var_type == $(item).val()) {
			$(item).iCheck('check'); 
		}
	}); 
	$("[name='select_double']:radio").each(function(index,item){
		if(jsonData.isselectm == $(item).val()) {
			$(item).iCheck('check'); 
		}
	}); 
	$("[name='createType']:radio").each(function(index,item){
		if(jsonData.createtype == $(item).val()) {
			$(item).iCheck('check'); 
		}
	}); 
    if(parseInt(jsonData.level)>0){
		cn.com.easy.xbuilder.service.DimensionService.getParentDims(StoreData.xid,$("#dim_var_name").val(),function(result,exception){
			getParentDimsBack(result,exception);
			var parentOptions = document.getElementById("parent_dimid").options;
			var optionsLength = parentOptions.length;
			for (var j = 0; j < optionsLength; j++) {
				if(parentOptions[j].value.indexOf(jsonData.parentdimname+"@") !=-1 ) {
					parentOptions[j].selected = true;
					break;
				}
			}
//			if(jsonData.createtype == "1") {
//				document.getElementById("parent_dimid").value = jsonData.parentdimname + "@" + jsonData.parentcol;
//			} else {
//				document.getElementById("parent_dimid").value = jsonData.parentdimname + "@";
//			}
			saveDimsion();//回调函数调用。
		});
	} else {
		saveDimsion();
	}
}
//==============引用模板=================
function selectTemplate(varname){//原selectVar()
	//toolsPanel();//打开左边框 autoAppendObj(
	//setProPageTitle("约束条件属性设置");
//	divObjEmpty();
	$dimtemplate = autoAppendObj("dimtemplateview");//$dimtemplate = $("#dimtemplateview");
	$dimtemplate.empty();
	var param = {};
	param.varname = varname;
	$dimtemplate.load(appBase+'/pages/xbuilder/dimension/DimensionTemplates.jsp',param,function(){
		$.parser.parse($dimtemplate);
//		dataMove();//数据复制
		autoAppendObj("dimproall").hide();
//		autoAppendObj("dimproperties").hide();
		autoAppendObj("dimtemplateview").show();
		showSimple();
    });
}
function dimdbSelect(node){
	var url = appBase+"/pages/xbuilder/dimension/DimensionAction.jsp";
	$.post(url,{id:node.id,eaction:"CURDIMDATA"},function(data){
		var var_type = data.dim_var_type;
		var varname = $("#dimtemplate_varname").val();
		var vardesc = data.dim_var_desc;
		data.var_name = varname;
		data.desc = vardesc;
		//autoAppendObj("dimproall").hide();
		//autoAppendObj("dimproperties").show();
		//autoAppendObj("dimtemplateview").hide();
		setDimProperValue(data);
	},"json");
	//弹出提示
	$.messager.show({
		title:'条件设置提示',
		msg:'查询条件设置成功',
		width:200,
		showType:'show',
		timeout:3000,
		style:{
			left:0,
			right:'',
			top:'',
			bottom:document.body.scrollTop-document.documentElement.scrollTop
		}
	});
}
function dimNodeextendAll(node,data){
	var root = $("#var_select_load").tree('getRoot');
	if(root != null) {
		$('#var_select_load').tree('expand',root.target);
	}
}
//设置约束条件属性
function setDimProperValue(data){
	var var_type=data.dim_var_type;
    if(var_type==""||var_type=="INPUT"||var_type=="UPLOAD"||var_type=="MONTH"||var_type=="DAY"||var_type=="HIDDEN"){
    	var_type = "INPUT";
    }
	$("[name='dimVarType']:radio").each(function(index,item){
		if(var_type == $(item).val()) {
			$(item).iCheck('check'); 
		}
	});
	if(var_type == ""||var_type == "INPUT"||var_type == "MONTH"||var_type=="DAY"||var_type=="HIDDEN"){
		showSimple();
	}else if(var_type=="SELECT"){
		showSelect(data.createType);
	}else if(var_type=="CASELECT"){
		showCascade(data.createType,data.caslvl);
	} 
	$("[name='createType']:radio").each(function(index,item){
		if(data.createType == $(item).val()) {
			$(item).iCheck('check'); 
		}
	}); 
	if(StoreData.dsType=="2"){
		if(data.formula != null && data.formula != "")
			$("#formula").val(data.formula);
		else 
			$("#formula").val("05");
	} else {
		$("#formula").val("");
	}
 	$("#fieldid").val(data.fieldid);
 	$("#fieldtype").val(data.fieldtype);
	$("#dim_var_name").val(data.var_name);
	$("#dim_var_desc").val(data.dim_var_desc);
	$("#dim_var_type").val(data.dim_var_type);
	$("#database_name1").val(data.database_name);
  	$("#dim_table").val(data.dim_table);
  	$("#dim_col_code").val(data.dim_col_code);
  	$("#dim_col_desc").val(data.dim_col_desc);
  	$("#dim_col_ord").val(data.dim_col_ord);
  	$("#sql").val(data.dimSql);
    $("#caslvl").val(data.caslvl);
    $("#dim_parent_col").val(data.dim_parent_col);
    $("#defaule_value").val(data.defaule_value);
    $("#create_type").val(data.createType);
    if(parseInt(data.caslvl)>0){
		$("#parent_dim_id_tr").show();
		$("#dim_parent_col_tr").show();
		cn.com.easy.xbuilder.service.DimensionService.getParentDims(StoreData.xid,$("#dim_var_name").val(),function(data,exception){
			getParentDimsBack(data,exception);
			$("#parent_dimid").val(data.parent_dim_id);
			saveDimsion();
		});
	}else{
		$("#parent_dim_id_tr").hide();
		$("#dim_parent_col_tr").hide();
		saveDimsion();
	}
}
function savaDimToTemplate(){
	cn.com.easy.xbuilder.service.DimensionService.getDimsions(StoreData.xid,function(result,exception){
		var paramInfo = {};
		paramInfo.dimJsonStr = result;
		paramInfo.reportId = StoreData.xid;
		paramInfo.reportName = $("#autoInput").val();
		paramInfo.eaction = "savetotemplate";
		var pagespath = appBase + "/pages/xbuilder/dimension/DimensionAction.jsp";
	    $.ajax({
	        type : "post",
	        url : pagespath,
	        data : paramInfo,
	        cache: false,
	        async : false,
	        success : function(data) {
	          //data = data.replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "").replace(/(^\s*)|(\s*$)/g, "");
		    }
	     });
	});
}
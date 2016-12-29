/**
*自动注入查询条件
*/
function addDimFromSql(){
	cn.com.easy.xbuilder.service.DimensionService.getRestrainVar(StoreData.xid,function(data,exception){
	    if(data!=""){
	    	selectDim(data,'1');
	    }
	});
}
function openAlldim(){
	toolsPanel();//打开左边框
	setProPageTitle("约束条件设置");
	$("#dimproall").show();
	$("#dimproperties").hide();
	$("#dimtemplateview").hide();
}
/*
*设置所有查询条件
*/
function setAllDim(status){
	if(status != null && status != undefined && status != '0' ){
		toolsPanel();//打开左边框
		setProPageTitle("约束条件设置");
		$propertiesPage = $("#dimproall");
		$propertiesPage.show(); 
		$propertiesPage.empty();
		var param = {};
		param.dataStr = $("#dimsion").attr("dstr");
		param.dataStr = param.dataStr.replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "").replace(/(^\s*)|(\s*$)/g, "");
		param.reportId = StoreData.xid;
		$propertiesPage.load(appBase+'/pages/xbuilder/dimension/DimensionAllSeting.jsp',param,function(){
			$("#dimproperties").hide();
			$("#dimtemplateview").hide();
	        $.parser.parse($propertiesPage);
	    });
    }
}

//指标库数据源，添加查询条件
function addDimFromKpi(){
	$.messager.alert("提示信息！","addDimFromKpi enter...","info");
	//$('#wid').window('open');
	kpiSel1_openDialog();
}
function setDimFromKpi(){
	$.messager.alert("提示信息！","setDimFromKpi enter...","info");
}
//指标库选择指标回调事件
function selectKpi(data){
	enterDim(data,'kpi');
}
//指标库选择维度回调事件
function selectDimension(data){
	enterDim(data,'dim');
}
//指标进入查询条件统一入口
function enterDim(data,selectType){
	var rsList = [];
	for(var i = 0;i<data.length;i++){
		var info = {};
		info.var_name=data[i].column;
		info.varname =data[i].column;
		info.type=data[i].name;
		info.parentcol  = '';
		info.parentdimname= '';
		nfo.table = '';
		info.codecolumn = '';
		info.desccolumn= '';
		info.ordercolumn= '';
		info.sql = '';
		info.desc = '参数('+i+')';
		info.database = '';
		info.defaultvalue = '';
		info.id = data[i].column;
		info.showtype ='0';
		info.formula = "01";
		info.fieldid = 
		info.fieldtype =selectType;
		info.isparame = '0';
		info.createtype = '1';
		info.databasename = ''
		info.level = '0';
		info.index = i;
		rsList.push(info);
	}
	selectDim(rsList,'1');
}
//选择维度
/*
function selectDima(data,status){
	$dimsion = $("#dimsion");
	$dimsion.empty();
	$dimsion.attr("dstr","");
	$dimsion.attr("dstr",$.toJSON(data));
	var dataList = [];
	$(data).each(function (index, domEle){
	   var info = domEle;
	   var $defaultDim = $("<span id=\"label"+info.id+"\">"+info.name+"</span><input type=\"text\" id=\""+info.id+"\">");//默认显示的文本，之后根据
	   var $newSelect = $("<span class=\"selectSpan\" style=\"display:block; float:left;\"></span>");//查询条件容器
	   var $set = $("<span style=\"margin-right:20px;color:#06F\" onclick=\"setdim('"+info.id+"','"+info.name+"')\">设置</span>");//查询条件单个设置
	   $defaultDim.appendTo($newSelect);
	   $set.appendTo($newSelect);
       $newSelect.appendTo($dimsion);//最后加载到查询条件容器
       $.parser.parse($dimsion);//编译查询条件容器
      //写入XML MAP对象
      	var XmlInfo = {};  
		XmlInfo.id = info.id;
		XmlInfo.var_name = info.id;
		XmlInfo.desc = info.name;
		XmlInfo.type = 'INPUT';
		if(info.isparame != undefined && info.isparame == '1'){
			XmlInfo.isparame = '1';
		}else{
			XmlInfo.isparame = '0';
		}
		XmlInfo.index = index;
		cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(XmlInfo),function(e,d){
			setAllDim(status);
		});
	});
}
*/
function selectDim(data,status){
	var $dimsion = $("#dimsion");
	$dimsion.empty();
	$dimsion.attr("dstr","");
	$dimsion.attr("dstr",$.toJSON(data));
	var dataList = [];
	$(data).each(function (index, domEle){
	   var info = domEle;
       var paramInfo = {};
       paramInfo.reportId = StoreData.xid;//报表ID
       var varname = info.var_name == undefined?'':info.var_name;
       if(varname == null || varname == '' || varname == undefined){
       	   varname = info.varname == undefined?'':info.varname;
       	   info.var_name = info.varname;
       }
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
       	   paramInfo.dim_sql=base64encode(utf16to8(info.sql));
       }else{
           paramInfo.dim_sql='';
       }
       paramInfo.dim_create_type=info.createtype;
       paramInfo.dim_var_desc=info.desc;
       paramInfo.extds=info.database;
       paramInfo.dim_lvl=info.level;
       paramInfo.defaultvalue=info.defaultvalue;
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
       if(paramInfo.type=="SELECT"||paramInfo.type=="CASELECT"){
	       paramInfo.createType=info.createtype;
	       if(info.sql != null && info.sql != undefined && info.sql != ''){
	       		paramInfo.dimsql = base64encode(utf16to8(info.sql));
	       }else{
	       		paramInfo.dimsql = '';
	       }
	       paramInfo.database_name = info.database;
	       paramInfo.caslvl = info.level;
	        $.ajax({
		        type : "post",
		        url : appBase+"/xbuilder/varcharge.e",
		        data : paramInfo,
		        cache: false,
		        async : false,
		        success : function(data) {
	       		   if($.trim(data).indexOf("FAIL")==0){
			          $.messager.alert("提示信息！","表相关信息填写错误!<br/>错误信息：<span style=\"color:red\">"+data.substr(4)+"</span>","error");
			       }else{
			          loadDimView(paramInfo,status,info);
			       }
	            }
            }); 
       }else{
         loadDimView(paramInfo,status,info);
       }
    });
}
function loadDimView(paramInfo,status,info){
	var $dimsion = $("#dimsion");
	$dimsion.attr("dstr","");
	$dimsion.attr("dstr",$.toJSON(paramInfo));
	var pagespath = appBase + "/pages/xbuilder/dimension/DimensionViewSet.jsp";
    var $newSelect = $("<span class=\"selectSpan\" id=\"selectSpan"+paramInfo.var_name+"\"></span>");//查询条件容器
    //$newSelect.attr("dstr","");
    //$newSelect.attr("dstr",$.toJSON(paramInfo));
    var $set = $("<span class=\"icoSet\" onclick=\"setdim('"+paramInfo.var_name+"','"+paramInfo.name+"')\">设置</span>");//查询条件单个设置
    $.ajax({
        type : "post",
        url : pagespath,
        data : paramInfo,
        cache: false,
        async : false,
        success : function(data) {
          //注入选择条件HTML
          data = data.replace(/\r\n/g,'').replace(/(^\s*)|(\s*$)/g, "").replace(/(^\s*)|(\s*$)/g, "");
          $newSelect.html(data);
          
          $set.appendTo($newSelect);
          $newSelect.appendTo($dimsion);//最后加载到查询条件容器
          $.parser.parse($dimsion);//编译查询条件容器
          
          cn.com.easy.xbuilder.service.DimensionService.addDimsion(StoreData.xid,$.toJSON(info),function(e,d){
	         setAllDim(status);
	      });
	    }
     }); 
}
function removedimhtml(obj){
}
function addQueryLinkBack(e,data){
}
function callback(e,data){

}
//=====================
/**
*设置单个查询条件
*@param  id 为变量名称  area_no
*@param  name 为变量中文名称 地市  区县
**/
function setdim(id,name){
	toolsPanel();//打开左边框
	setProPageTitle("约束条件设置");
	$propertiesPage = $("#dimproperties");
	$("#dimproall").hide();
	$("#dimproperties").show();
	$("#dimtemplateview").hide();
	$propertiesPage.empty();
	var param = {};
	
	/*$selectSpanDim = $("#selectSpan"+id);
	var dimJsonStr = $selectSpanDim.attr("dstr");
	var dimJsonObj = {};
	if(dimJsonStr !=null && dimJsonStr != undefined){
		dimJsonObj = $.parseJSON(dimJsonStr);
		param.reportId=dimJsonObj.reportId;
		param.dimvar=dimJsonObj.dimvar;
		param.var_name=dimJsonObj.var_name;
		param.desc=dimJsonObj.desc;
		param.type=dimJsonObj.type;
		param.dim_parent_col=dimJsonObj.dim_parent_col;
		param.parent_dim_name=dimJsonObj.parent_dim_name;
		param.dim_table=dimJsonObj.dim_table;
		param.dim_col_code=dimJsonObj.dim_col_code;
		param.dim_col_desc=dimJsonObj.dim_col_desc;
		param.dim_col_ord=dimJsonObj.dim_col_ord;
		param.select_double=dimJsonObj.select_double;
		param.dim_sql=dimJsonObj.dim_sql;
		param.dim_create_type=dimJsonObj.dim_create_type;
		param.dim_var_desc=dimJsonObj.dim_var_desc;
		param.extds=dimJsonObj.extds;
		param.dim_lvl=dimJsonObj.dim_lvl;
		param.defaultvalue=dimJsonObj.defaultvalue;
		param.dimId=dimJsonObj.dimId;
		param.id=dimJsonObj.id;
		param.showtype=dimJsonObj.showtype;
		param.isparame=dimJsonObj.isparame;
		param.index=dimJsonObj.index;
		param.createType=dimJsonObj.createType;
		param.dimsql=dimJsonObj.dimsql;
		param.databaseName=dimJsonObj.databaseName;
		param.caslvl=dimJsonObj.caslvl;
	}*/
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
	 var value = $("#dim_var_type").val();
	 
	 var table=$("#dim_table").val();//码表名称
	 var codecolumn=$("#dim_col_code").val();//编码字段
	 var desccolumn=$("#dim_col_desc").val();//中文字段
	 var ordercolumn=$("#dim_col_ord").val();//排序字段
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
 		dimInfo.defaultvalue=$("#defaule_value").val();//默认值
 		dimInfo.createtype=$("input[name=createType]:checked").val();//创建类型
 		dimInfo.isselectm=$("input[name=select_double]:checked").val();//是否复选
 		dimInfo.showtype=$("#showtype").val();//显示方式
 		dimInfo.formula=$("#formula").val();//类别:INPUT、SELECT、MONTH...
 		dimInfo.fieldid=$("#fieldid").val();//类别:INPUT、SELECT、MONTH...
 		dimInfo.fieldtype=$("#fieldtype").val();//类别:INPUT、SELECT、MONTH...
 		return dimInfo;
}
/**
*回显约束条件属性
**/
function fillRestrainForm(data){
	//指标来源时使用
	$("#formula").val(data.formula);
	$("#fieldid").val(data.fieldid);
	$("#fieldtype").val(data.fieldtype);
	

	$("#dim_var_desc").val(data.desc);
	$("#dim_var_type").val(data.type);
	$("#database_name1").val(data.sql.extds);
	
  	$("#dim_table").val(data.table);
  	$("#dim_col_code").val(data.codecolumn);
  	$("#dim_col_desc").val(data.desccolumn);
  	$("#dim_col_ord").val(data.ordercolumn);
  	$("#sql").val(data.sql.sql);
  	
    $("#caslvl").val(data.level);
    if(parseInt(data.level)>0){
		cn.com.easy.xbuilder.service.DimensionService.getParentDims(StoreData.xid,$("#dim_var_name").val(),function(result,exception){
			getParentDimsBack(result,exception);
			$("#parent_dim_id").combobox("setValue",data.parentcol);
		});
	}
    
    $("#parent_dim_id").combobox("setValue",data.parentcol);
    $("#dim_parent_col").val(data.parentcol);
    $("#defaule_value").val(data.defaultvalue);
    
    var var_type=data.type;
	if(var_type==""||var_type=="INPUT"||var_type=="MONTH"||var_type=="DAY"||var_type=="HIDDEN"){
		showSimple();
	}else if(var_type=="SELECT"){
		showSelect(data.createtype);
	}else if(var_type=="CASELECT"){
		showCascade(data.createtype,data.level);
	}		
}
//==============引用模板=================
function selectTemplate(varname){//原selectVar()
	toolsPanel();//打开左边框
	setProPageTitle("约束条件设置");
	$dimtemplate = $("#dimtemplateview");
	$dimtemplate.empty();
	var param = {};
	param.varname = varname;
	$dimtemplate.load(appBase+'/pages/xbuilder/dimension/DimensionTemplates.jsp',param,function(){
		$.parser.parse($dimtemplate);
        $("#dimproall").hide();
		$("#dimproperties").hide();
		$("#dimtemplateview").show();
    });
}
function dimdbSelect(node){
	var url = appBase+"/pages/xbuilder/dimension/DimensionAction.jsp";
	$.post(url,{id:node.id,eaction:"CURDIMDATA"},function(data){
		var var_type = data.dim_var_type;
		var varname = $("#dimtemplate_varname").val();
		var vardesc = data.dim_var_desc;
		//setdim(varname,vardesc);
		$("#dimproall").hide();
		$("#dimproperties").show();
		$("#dimtemplateview").hide();
		setDimProperValue(data);
		saveDimsion();
	},"json");
}
function dimNodeextendAll(node,data){
	var root = $("#var_select_load").tree('getRoot');
	$('#var_select_load').tree('expand',root.target);
}
 //设置约束条件属性
function setDimProperValue(data){
	$("#formula").val('01');
 	//$("#fieldid").val();
 	$("#fieldtype").val('dim');

	$("#dim_var_desc").val(data.dim_var_desc);
	$("#dim_var_type").val(data.dim_var_type);
	$("#database_name1").val(data.database_name);
	
  	$("#dim_table").val(data.dim_table);
  	$("#dim_col_code").val(data.dim_col_code);
  	$("#dim_col_desc").val(data.dim_col_desc);
  	$("#dim_col_ord").val(data.dim_col_ord);
  	$("#sql").val(data.dimSql);
  	
    $("#caslvl").val(data.caslvl);
    changeLevel(data.caslvl);
    if(data.parent_dim_id!=undefined){
		   $("#parent_dim_id").combobox("setValue",data.parent_dim_id);
	}
    $("#dim_parent_col").val(data.dim_parent_col);
    $("#defaule_value").val(data.defaule_value);
    
    var var_type=data.dim_var_type;
	if(var_type==""||var_type=="INPUT"||var_type=="MONTH"||var_type=="DAY"||var_type=="HIDDEN"){
		showSimple();
	}else if(var_type=="SELECT"){
		showSelect(data.createType);
	}else if(var_type=="CASELECT"){
		showCascade(data.createType,data.caslvl);
	}
}

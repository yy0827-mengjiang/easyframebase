/**
 * 编辑还原
 */
 function weblate_web_edit(containerId,componentId){
	cn.com.easy.xbuilder.service.component.WebLateService.getWeblinkJsonData(StoreData.xid,containerId,componentId,$.toJSON({}),function(data,exception){
		var jsonObj=$.parseJSON(data);
		if(jsonObj!=null&&jsonObj!=undefined){
			/*设置标题*/
			var column_title = jsonObj.title;
			if(column_title!=""){
				$("#column_title").val(column_title);
			}else{
				$("#column_title").val("");
			}
			/*设置地址*/
			var column_url = jsonObj.userUrl;
			if(column_url!=""){
				$("#column_url").val(column_url);
			}else{
				$("#column_url").val("");
			}
			/*设置条件*/
			var weblink = jsonObj.weblink;
			if(weblink!=null){
				cList = weblink.condition;
				$("#column_tb2 tr:gt(0)").remove();
				for(var i=0;i<cList.length;i++){
					var $row = column_appendwebRow();
					if(cList[i].varname)$row.find(":text[name='column_sername']").val(cList[i].varname);
					if(cList[i].desname)$row.find(":text.column_ser").combobox("setValue",cList[i].desname);
				}
			}
		}else{
			
		}
		
	});
 }
 
 
 /**
 * 设置组件标题
 */
function column_fun_webTitle(){
	var info={};
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var title = $("#column_title").val();
	if(typeof(title)!="undefined"){
		info.title=title;
		cn.com.easy.xbuilder.service.component.WebLateService.setTitle(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			synTitleToOther(containerId,componentId,title);
		});
	}
}

/**
 * 设置组件url
 */
 function column_fun_webUrl(){
 	var info={};
 	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var userUrl = $("#column_url").val();
	
	//去掉回车
	userUrl = userUrl.replace(/[\r\n]/g,"");
	//去掉空格
	userUrl = userUrl.replace(/\ +/g,"");
	userUrl = userUrl.replace(/[ ]/g, "");
	
	$("#column_url").val(userUrl.replace(/[\r\n]/g,""));
	$("#column_url").val(userUrl.replace(/\ +/g,""));
	$("#column_url").val(userUrl.replace(/[ ]/g, ""));
	if(userUrl!=""){
		if(typeof(userUrl)!="undefined"){
		info.userUrl=userUrl;
		cn.com.easy.xbuilder.service.component.WebLateService.setUrl(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){
			//synTitleToOther(containerId,componentId,title);
		});
	  }
	}else{
		cn.com.easy.xbuilder.service.component.WebLateService.getWebLinkUserUrl(StoreData.xid,containerId,componentId,function(data,exception){
			$("#column_url").val(data);
		});
		$.messager.alert("页面模版","地址不能为空","error");
	}
 }
 
 /**
 * 选中操作（参数名）
 */
function column_varname(obj){
	var column_url = $("#column_url").val();
	//去掉回车
	column_url = column_url.replace(/[\r\n]/g,"");
	//去掉空格
	column_url = column_url.replace(/\ +/g,"");
	column_url = column_url.replace(/[ ]/g, "");
	
	$("#column_url").val(column_url.replace(/[\r\n]/g,""));
	$("#column_url").val(column_url.replace(/\ +/g,""));
	$("#column_url").val(column_url.replace(/[ ]/g, ""));
	
	if(column_url!=""){
		addRow();
	}else{
		$.messager.alert("页面模版","填加参数名前地址不能为空","error");
	}
	
}

 /**
 * 选中操作（参数值）
 */
function column_desname(obj){
	var column_url = $("#column_url").val();
	//去掉回车
	column_url = column_url.replace(/[\r\n]/g,"");
	//去掉空格
	column_url = column_url.replace(/\ +/g,"");
	column_url = column_url.replace(/[ ]/g, "");
	
	$("#column_url").val(column_url.replace(/[\r\n]/g,""));
	$("#column_url").val(column_url.replace(/\ +/g,""));
	$("#column_url").val(column_url.replace(/[ ]/g, ""));
	
	if(column_url!=""){
		addRow();
	}else{
		$.messager.alert("页面模版","填加参数值前地址不能为空","error");
	}
}
 /**
 * 写元数据
 */
function addRow(){
	var reportId=StoreData.xid;
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	
	var info={};
	var list = [];
	$("#column_tb2 tr:gt(0)").each(function(i){
		var cols = {};
		var ser_name = $(this).find(":text[name='column_sername']").val();
		var ser_value = $(this).find(":text.column_ser").combobox("getValue");
		if(typeof(ser_name)!="undefined"&&ser_name!=""){
			cols.ser_name = ser_name;
		}else{
			cols.ser_name = "";
		}
		
		if(typeof(ser_value)!="undefined"&&ser_value!="请选择"&&ser_value!=""){
			cols.ser_value = ser_value;
		}else{
			cols.ser_value = "";
		}
		list.push(cols);
	})
	 
	info.clist = list;
	
	cn.com.easy.xbuilder.service.component.WebLateService.addWeblinkOrCondition(StoreData.xid,containerId,componentId,$.toJSON(info),function(data,exception){});
	
} 

 /**
 * 添加指标行
 */
function column_appendwebRow(){
	var reportId=StoreData.xid;
	var componentId = StoreData.curComponentId;
	var containerId = StoreData.curContainerId;
	var info={};
	var errMsg = validColumnwebRow();
	var ser_data =[];
	//errMsg="";
	if(errMsg!=""){
		$.messager.alert("页面模版","添加失败，请先处理以下错误：<br/>"+errMsg,"error");
		return;
	}
	$("#column_tb2").append($("#kpiRowHtml").find("tr").eq(0)[0].outerHTML);
	var $row = $("#column_tb2 tr:last-child");

	var $ser = $row.find(":text.column_ser").combobox();
	
	var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+"&isTempFile=1",type:"POST",cache: false,async: false}).responseText;
	dimsionsJson=$.parseJSON(dimsionsJson);
	if(dimsionsJson!=""){
		for(var i=0;i<dimsionsJson.length;i++){
			var nameId=dimsionsJson[i]["varname"];
			var nameDesc=dimsionsJson[i]["desc"];
			ser_data.push({"id":nameId,"text":nameDesc});
			$ser.combobox('setValue', '请选择').combobox('loadData', ser_data); 
		}
	}else{
		$ser.combobox('setValue', '请选择').combobox('loadData', ser_data); 
	}
	$row.click(function(){
		$("#column_tb2 tr").each(function(index,item){
			$(item).removeClass("kpi_select_row");
		})
		$row.addClass("kpi_select_row");
		$("#column_tb2 tr:eq(0)").removeClass("kpi_select_row");
	});
	
	return $row; 
}


/**
 * 删除指标行
 * @param obj
 */
function column_removewebRow(obj){
	var obj = $(".kpi_select_row").eq(0);
	if(obj[0]==undefined){
		$.messager.alert("页面模版","请选择要删除的指标!","error");
	}else if(obj[0]!=undefined&&$("#column_tb2 tr:gt(0)").length>1){
		$(obj).remove();
		addRow();
	}else if(obj[0]!=undefined&&$("#column_tb2 tr:gt(0)").length==1){
		$.messager.alert("页面模版","不能删除,请至少保留一个参数!","error");
	}else{
		$.messager.alert("页面模版","删除失败","error");
	}
	
}

 
 /**
 * 校验指标行
 * @returns {String}
 */
function validColumnwebRow(){
	var errMessage = "";
	var kpiMap = new Object();
	$("#column_tb2 tr:gt(0)").each(function(index){
		var ser = $(this).find(":text.column_ser").combobox("getText");
		var ser_name = $(this).find(":text[name='column_sername']").val();
		if(typeof(ser)=="undefined"||ser=="请选择"||ser==""){
			errMessage+="第"+(index+1)+"行参数值不能为空;<br/>";
		}
		if(typeof(ser_name)=="undefined"||ser_name=="请选择"||ser_name==""){
			errMessage+="第"+(index+1)+"行参数名不能为空;<br/>";
		}
	});
	return errMessage;
}
 
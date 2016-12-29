		var binds_var = '';
		var dataValue='';
		var currentEditRestrain;
		var refSqlArr=[];
		var datasetSqlMap=new Object();
		var useDataSet;
		var datasetEditFlag = {};
		$.extend($.fn.validatebox.defaults.rules, {
		     testDataSet: {
		         validator: function(value, param){
		         var temp = /[A-Za-z0-9_]\.[A-Za-z0-9_]/g;
				 var spaceEmpty = value;
				 return temp.test(spaceEmpty);
		         },
		     message: '{0}格式为用户名.表名且用户名表名只能由（A-Za-z0-9_@）组成。'
		     }
		 });
		/**
		 * 添加数据集,弹出新建窗口
		 */
		function addDataSet(){
			window.open(appBase + "/pages/xbuilder/dataset/XBuilderSQL.jsp?reportId="+StoreData.xid);
		}
		function initEditDataSet() {
			cn.com.easy.xbuilder.service.DataSetService.getTreeData(StoreData.xid,getTreeDataBack);
		}
	    /**
	     * 添加数据集，保存SQL
	     */
	    function saveDataset(datasource,sql,datasetName,sqlId,referenceId,userId){
	    	var info={};
  			info.id=sqlId;
  			info.name=datasetName;
  			info.data_sql=base64encode(utf16to8(sql));
  			info.extds=datasource;
  			info.creator=userId;
  			info.index="";
  			info.reference=referenceId;
  			cn.com.easy.xbuilder.service.DataSetService.addDataSet(StoreData.xid,$.toJSON(info),addDatasetBack);
  			$('#create_data_win').dialog('close');
	    }
	    
	     /**
	      * 刷新数据集节点内容
	      */
	     function refreshDatasetItem(){
	    	cn.com.easy.xbuilder.service.DataSetService.getTreeData(StoreData.xid,getTreeDataBack);
	     }
		  /**
		   * 保存数据集回调
		   */
		  function addDatasetBack(data,exception){
			  cn.com.easy.xbuilder.service.DataSetService.getTreeData(StoreData.xid,getTreeDataBack);
			  var info={};
	  		  info.id=data.id;
	  		  info.name=data.name;
	  		  info.data_sql=data.sql;
	  		  info.extds=data.extds;
	  		  info.report_id=StoreData.xid;
	  		  var url = appBase + "/pages/xbuilder/dataset/ReportSqlAction.jsp?eaction=DATAFINAL";
			  $.post(url,info,function(data){});
			  addDimFromSql();
		  }
		  
		  $(function(){
			
		  });
		 
		  //查询数据集回调
		  function getTreeDataBack(data,exception){
			    var jsonObj=$.parseJSON(data);
			    var tempStr='';
			    var num=2;//typeExt为3的时候是全局数据集只显示引用
			    if(typeExt=='3'){
			    	num=1;
			    }
			    $("#datasetList>li").each(function(index,item) {
			    	if(index < num) {
			    		tempStr += "<li class=\""+ $(item).attr("class") +"\">" + $(item).html() + "</li>"; 
			    	}
			    });
			    if(jsonObj["yes"] != undefined && jsonObj["yes"] != null) {
			    	var myjsonObj = jsonObj["yes"];
			    	useDataSet = jsonObj["yes"];
				    var obj;
				    refSqlArr=[];
				    for(var i=0;i<myjsonObj.length;i++){
				    	obj=myjsonObj[i];
				    	var ref=obj.attributes.reference;
				    	if(ref!=""&&ref!=undefined&&ref!="null"){
				    		refSqlArr.push(ref);
				    	}
				    }
				    $.each(myjsonObj,function(index,item){
				    	tempStr += "<li class='tIco03'><a id='"+item.id+"' href='javascript:void(0)' datatype='"+item.attributes.datatype+"' reference='"+item.attributes.reference+"' text=\""+EscapeCharS(item.text)+"\" extds='"+item.attributes.extds+"' onclick='editDataSet(this)'><span>"+item.text+"<span><div style='display:none'>"+item.attributes.sql+"</div></a><a class='icoclose' href='javascript:void(0);' title='删除' value='"+item.id+"' onclick='removeData(this)'>删除</a></li>";
				    });
//				    $("#datasetList>li").each(function(index,item){
//				    		if(index > 1) {
//				    			$(item).find("a").each(function(index,item) {
//				    				if(index == 0) {
//				    					$(item).click(editDataSet);
//				    				} else {
//				    					$(item).click(removeData);
//				    				}
//				    			});
//				    		}
//				    });
			    }
			    $("#datasetList").html(tempStr);
			    if(jsonObj["no"] != undefined && jsonObj["no"] != null) {
			    	var errorStr = "";
			    	var tmpDataSet = jsonObj["no"];
			    	$.each(tmpDataSet,function(index,item){
			    		errorStr += "<li class='tIco04'><a id='"+item.id+"' href='javascript:void(0)' onclick='javascript:editTmpDataSet(this)' reference='"+item.referenceId+"' text=\""+EscapeCharS(item.text)+"\" extds='"+item.extds+"'><span>"+item.text+"(暂存)<span><div style='display:none'>"+item.sql+"</div></a><a class='icoclose' href='javascript:void(0);' title='删除' value='"+item.id+"' onclick='javascript:removeTmpData(this)'>删除</a></li>";
					});
			    	$("#datasetList").append(errorStr);
			    }
		  }
		  function removeTmpData(obj) {
			var id = $(obj).attr("value").substr(1);
		  	$.messager.confirm('提示信息', '您确定要删除临时保存的数据集?', function(r){
				if (r){
					    cn.com.easy.xbuilder.service.DataSetService.delTmpDataSource(id,StoreData.xid,function(data){
					    if(data != "success") {
					    	$.messager.alert("提示信息",data,"error");
					    	return false;
					    }
//					    //删除引用数组里的值
//					    var index=-1;	
//					    for(var i=0;i<refSqlArr.length;i++){
//					    	if(refId==refSqlArr[i]){
//					    		index=i;
//					    	}
//					    }
//					    if(index!=-1){
//					    	refSqlArr.splice(index, 1);
//					    }
//					    addDimFromSql();
					    cn.com.easy.xbuilder.service.DataSetService.getTreeData(StoreData.xid,getTreeDataBack);
					});
				}
			});
		  }
		  /**
		   * 删除数据集
		   */
		  function removeData(obj){
		  	var id = $(obj).attr("value").substr(1);
		  	var refId = $(obj).attr("reference");
		  	$.messager.confirm('提示信息', '删除数据集会删除相关的配置等信息，是否继续?', function(r){
				if (r){
					    cn.com.easy.xbuilder.service.DataSetService.removeDataSet(StoreData.xid,id,function(data){
					    if(data != "success") {
					    	$.messager.alert("提示信息",data,"error");
					    	return false;
					    }
					    //删除引用数组里的值
					    var index=-1;	
					    for(var i=0;i<refSqlArr.length;i++){
					    	if(refId==refSqlArr[i]){
					    		index=i;
					    	}
					    }
					    if(index!=-1){
					    	refSqlArr.splice(index, 1);
					    }
					    addDimFromSql();
					    cn.com.easy.xbuilder.service.DataSetService.getTreeData(StoreData.xid,getTreeDataBack);
					});
				}
			});
		  }
		  
		 /**
		  * 修改数据集
		  */
		 function editDataSet(obj){
			 var dsId = $(obj).attr("id");  //获取当前选择div 的 id
			 $.each(useDataSet,function(index,item){
				 if(dsId == item.id) {
					 var reportSqlId = dsId.substr(1);
					 var referenceId = item.attributes.reference;
					 if(datasetEditFlag[referenceId]){//根据id判断数据集是否可以编辑，全局数据集不可以编辑
						top.$.messager.alert("提示信息","全局数据集不可以编辑！","error");					 	
					 	return;
					 }
					 var datasetName = item.text;
					 window.open(appBase + "/pages/xbuilder/dataset/XBuilderSQL.jsp?reportSqlId="+reportSqlId);
				 }
			 }); 
		 }
	     function editTmpDataSet(obj) {
			 var dsId = $(obj).attr("id").substr(1);  //获取当前选择div 的 id
			 var dataSetName = $(obj).attr("text");
		     var referenceId = $(obj).attr("reference");
			 window.open(appBase + "/pages/xbuilder/dataset/XBuilderSQL.jsp?reportSqlId="+dsId+"&tmp=1");
	     }
		 function getCurEditDataset(id){
			 var obj = {
				sql:$("#"+id).find("div:eq(0)").text(),
				datasetName:$("#"+id).attr("text"),
				extds:$("#"+id).attr("extds"),
				referenceId:$("#"+id).attr("reference"),
				datatype:$("#"+id).attr("datatype"),
				reportId:StoreData.xid
			 }
			 return obj;
		 }
	/**
	 * 打开引用数据集对话框
	 */
	function searchDataSet(typeExt){
		var info = {};
		info.report_id=$("#repoid").val();
		$("#tools_panel .closeTools").click();
		dataset_openDialog("other_data_dialog");
		if(typeExt != '3'){//全局sql模式，没有自定义sql
			var url = appBase + "/pages/xbuilder/dataset/ReportSqlReference.jsp?reportId="+StoreData.xid;
			$("#other_data_load").load(url,{},function(data){
				$.parser.parse($("#other_data_load"));
			});
		}
		var glurl = appBase + "/pages/xbuilder/dataset/GlobalSqlReference.jsp?reportId="+StoreData.xid;
		$("#global_data_load").load(glurl,{},function(data){
			$.parser.parse($("#global_data_load"));
		});
	}
	
	/**
	 * 查询要引用的数据集(报表sql)
	 */
	function doOtherQuery(){
		var info = {};
		info.report_name = $("#other_report_name").val();
		info.report_sql_name = $("#other_data_name").val();
		$("#dataOtherTable").datagrid("load",info);
	}
	/**
	 * 查询要引用的数据集（全局sql）
	 */
	function doGlobalQuery(){
		var info = {};
		info.glbdataset_name = $("#GLBDATASET_NAME").val();
		info.create_user_name = $("#CREATE_USER_NAME").val();
		info.start_time = $('#START_TIME').datebox('getValue');
    	info.end_time = $("#END_TIME").datebox('getValue');
		$("#dataGlobalTable").datagrid("load",info);
	}
	
	/**
	 * 格式化报表sql“选择”按钮列
	 */
	function data_select(value,rowData){
		datasetSqlMap["SQL"+rowData.REPORT_SQL_ID]=rowData.REPORT_SQL;
		return "<a href='javascript:void(0);' style='text-decoration: none;margin:0 5px;' onclick=\"selectOtherDataSet('"+rowData.REPORT_SQL_ID+"','"+EscapeChar(rowData.REPORT_SQL_NAME)+"','"+rowData.EXTDS+"',false)\">复制</a>";
	}
	/**
	 * 格式化全局sql“选择”按钮列
	 */
	function data_select_glb(value,rowData){
		datasetSqlMap["SQL"+rowData.GLBDATASET_ID]=rowData.GLBDATASET_SQL;
		return "<a href='javascript:void(0);' style='text-decoration: none;margin:0 5px;' onclick=\"selectOtherDataSet('"+rowData.GLBDATASET_ID+"','"+EscapeChar(rowData.GLBDATASET_NAME)+"','"+rowData.TYPE+"',true)\">引用</a>";
	}
	//转换方法,js方法参数里的单引号和双引号
    function EscapeChar(HaveSpecialval) {
        HaveSpecialval = HaveSpecialval.replace(/\"/g, "&quot;").replace(/\'/g, "\\\'");
        return HaveSpecialval;
    }
    //转换方法,标签属性里的双引号
    function EscapeCharS(HaveSpecialval) {
        HaveSpecialval = HaveSpecialval.replace(/\"/g, "&quot;");
        return HaveSpecialval;
    }
	/**
	 * 格式化SQL显示列
	 * @param value
	 * @param rowData
	 * @returns {String}
	 */
	function formattSql(value,rowData){
		if(value!=null){
		    return '<div style="color:blue" class="sqlText" title="点击显示具体SQL">'+value.substr(0,70)+'...'+'</div>';
		}else{
		    return '';		
		}
	}
	
	/**
	 * 显示详细的SQL语句
	 * @param rowIndex
	 * @param field
	 * @param value
	 */
	function showDetailSql(rowIndex, field, value){
		if(field=='REPORT_SQL'||field=='GLBDATASET_SQL'){
			$("#showDetailSql").text(value);
			dataset_openDialog('showDetailSqlDialog');
		}
	}
	
	/**
	 * 选择SQL按钮点击事件
	 * @param datasetId
	 * @param datasetName
	 * @param report_extds
	 */
	function selectOtherDataSet(datasetId,datasetName,report_extds,isglobaldataset){
		datasetEditFlag[datasetId] = isglobaldataset;//记录数据集id和是否全局数据集
		for(var i=0;i<refSqlArr.length;i++){
			if(datasetId==refSqlArr[i]){
				top.$.messager.alert("提示信息","该数据集已引用，不能重复引用！","error");
				return;
			}
		}
        var info={};
		info.id = datasetId;
		info.name=datasetName;
		info.data_sql=base64encode(utf16to8(datasetSqlMap["SQL"+datasetId]));
		if(report_extds=="null"||report_extds==undefined){
			report_extds="";
		}
		info.extds=report_extds;
		info.creator=$("#userId").val();
		info.index="0";
		info.reference=datasetId;
		cn.com.easy.xbuilder.service.DataSetService.addDataSet(StoreData.xid,$.toJSON(info),addDatasetBack);
		$("#other_data_dialog").dialog("close");
		
			
	}
	
	function ieVersion(){
		var browser=navigator.appName;
		var b_version=navigator.appVersion;
		var version=b_version.split(";"); 
		var trim_Version="";
		if(version.length>1){
			trim_Version=version[1].replace(/[ ]/g,""); 
		}
		if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE6.0") 
		{ 
			return 6;
		} 
		else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE7.0") 
		{ 
			return 7;
		} 
		else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE8.0") 
		{ 
			return 8;
		} 
		else if(browser=="Microsoft Internet Explorer" && trim_Version=="MSIE9.0") 
		{ 
			return 9;
		} 
	}
	
	
	function dataset_openDialog(id){
		var $dialog1 = $("#"+id);
		var toolsTop = 100;
	 	if(ieVersion()!=7){  
	 		toolsTop=toolsTop+$dialog1.offset().top;
	 	}else{    
	 		toolsTop=toolsTop+$dialog1.offset().top+166;
	 	} 
	 	var scrollTop = 0;
	 	try {//兼容上海的模式
	 		scrollTop = $('#LC',parent.window.document).scrollTop();
	 	} catch(e){
	 		
	 	}
		scrollTop = toolsTop + scrollTop;
		$dialog1.dialog("open");
		$dialog1.dialog('move',{top:scrollTop });
	}
	
	function formatSQL() {
		$("#data_sql").format({
    		method: 'sql'
    	});
	}
	
	
	
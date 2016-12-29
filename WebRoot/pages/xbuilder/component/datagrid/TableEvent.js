var TableEvent = {
	"setHeadui" : function (reportId,containerId,componentId,headui) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.headui=headui;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setHeadui",info,function(data,e){});
    },
    "setTitle" : function (reportId,containerId,componentId,title) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="title";
    	info.attrValue=title;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){
    		synTitleToOther(containerId,componentId,title);
    	});
    },
    "setShowTitleFlag" : function (reportId,containerId,componentId,showTitleFlag) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="showTitle";
    	info.attrValue=showTitleFlag;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "setShowRowTotalFlag" : function (reportId,containerId,componentId,showRowTotalFlag) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tableshowrowtotal";
    	info.attrValue=showRowTotalFlag;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "setShowTotalFlag" : function (reportId,containerId,componentId,showTotalFlag) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tableshowtotal";
    	info.attrValue=showTotalFlag;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){
    		if(showTotalFlag=='0'){
    			$("#tableShowTotalPosition").combobox("setValue","top");
    			$("#tableShowTotalName").val("合计");
    			var positionInfo={};
		    	positionInfo.reportId=reportId;
		    	positionInfo.containerId=containerId;
		    	positionInfo.componentId=componentId;
		    	positionInfo.attrKey="tableshowtotalposition";
		    	positionInfo.attrValue=$("#tableShowTotalPosition").combobox("getValue");
		    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",positionInfo,function(data,e){
		    		var nameInfo={};
			    	nameInfo.reportId=reportId;
			    	nameInfo.containerId=containerId;
			    	nameInfo.componentId=componentId;
			    	nameInfo.attrKey="tableshowtotalname";
			    	nameInfo.attrValue=$("#tableShowTotalName").val();
			    	
			    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",nameInfo,function(data,e){});
		    	});
    		}
    	});
    },
    "setShowTotalPosition" : function (reportId,containerId,componentId,showTotalPostion) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tableshowtotalposition";
    	info.attrValue=showTotalPostion;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "seShowTotalName" : function (reportId,containerId,componentId,showTotalName) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tableshowtotalname";
    	info.attrValue=showTotalName;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "setSetSum" : function (reportId,containerId,componentId,setSumFlag) {
    	 var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tablesetsum";
    	info.attrValue=setSumFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){
	    	if(LayOutUtil.data.sumControlExpFlag=='1'){//当聚合属性变化需要影响导出属性变化时
	    		if(setSumFlag=='0'){
	    			var info1={};
			    	info1.reportId=reportId;
			    	info1.containerId=containerId;
			    	info1.componentId=componentId;
			    	info1.attrKey="tableshowrowtotal";
			    	info1.attrValue="0";
			    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info1,function(data,e){
			    		var info2={};
				    	info2.reportId=reportId;
				    	info2.containerId=containerId;
				    	info2.componentId=componentId;
				    	info2.attrKey="tableshowtotal";
				    	info2.attrValue="0";
						Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info2,function(data,e){
							$("#tableShowTotalPosition").combobox('hidePanel');
							var info3={};
					    	info3.reportId=reportId;
					    	info3.containerId=containerId;
					    	info3.componentId=componentId;
					    	info3.attrKey="tableshowtotalposition";
					    	info3.attrValue="top";
							Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info3,function(data,e){
								$('#tableExport').iCheck("disable");
					    		$('#tableExport').iCheck("uncheck");
					    		TableEvent.setExportFlag(reportId,containerId,componentId,'0');
							});
						});
			    	});
					    		
	    		}else{
	    			$('#tableExport').iCheck("enable");
			    	TableEvent.setExportFlag(reportId,containerId,componentId,'1');
	    		}
	    	}else{
	    		if(setSumFlag=='0'){
	    			var info1={};
			    	info1.reportId=reportId;
			    	info1.containerId=containerId;
			    	info1.componentId=componentId;
			    	info1.attrKey="tableshowrowtotal";
			    	info1.attrValue="0";
			    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info1,function(data,e){
			    		var info2={};
				    	info2.reportId=reportId;
				    	info2.containerId=containerId;
				    	info2.componentId=componentId;
				    	info2.attrKey="tableshowtotal";
				    	info2.attrValue="0";
						Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info2,function(data,e){
								var info3={};
						    	info3.reportId=reportId;
						    	info3.containerId=containerId;
						    	info3.componentId=componentId;
						    	info3.attrKey="tableshowtotalposition";
						    	info3.attrValue="top";
								Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info3,function(data,e){});
						
						});
			    	});
	    		}
    		}
    		
    		
    	});
    	
    },
    "setPagiFlag" : function (reportId,containerId,componentId,pagiFlag) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tablepagi";
    	info.attrValue=pagiFlag;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){
    		if(pagiFlag=='0'){
    			$("#tablePagiNum").numberbox("setValue",LayOutUtil.data.xDefautlTablePagiNum);
    			$("#tablePagiNum").numberbox("disable");
    			$('#tableExport').iCheck("uncheck");
    			var info1={};
		    	info1.reportId=reportId;
		    	info1.containerId=containerId;
		    	info1.componentId=componentId;
		    	info1.attrKey="tableexport";
		    	info1.attrValue="0";
		    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info1,function(data,e){
		    		tableSetPagiNum($("#tablePagiNum").numberbox("getValue"));
		    	});
    		}else{
    			$("#tablePagiNum").numberbox("enable");
    		
    		}
    	
    	});
    },
    
    "setPagiNum" : function (reportId,containerId,componentId,pagiNum,callFun) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tablepaginum";
    	info.attrValue=pagiNum;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "setExportFlag" : function (reportId,containerId,componentId,exportFlag) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tableexport";
    	info.attrValue=exportFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){
    		if(exportFlag=='1'){
    			if($("#tablePagi").attr("checked")!="checked"&&$("#tablePagi").attr("checked")!=true){
    				tableSetPagi();
    				$('#tablePagi').iCheck("check");
    			}
    			
    			
    		}
    	});
    },
    "setColLockFlag" : function (reportId,containerId,componentId,colLockFlag) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tablecollock";
    	info.attrValue=colLockFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){
    		if(colLockFlag=='1'){
    			tableSetColLockNum('1');
	    	}else{
	    		tableSetColLockNum('');
	    	}
    	
    	});
    	
    },
    "setColLockNum" : function (reportId,containerId,componentId,colLockNum) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tablecollocknum";
    	info.attrValue=colLockNum;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "setDatasourceId" : function (reportId,containerId,componentId,datasourceId) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="datasourceid";
    	info.attrValue=datasourceId;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setComponentAttr",info,function(data,e){});
    },
    "addMoreKpiStoreCols" : function (reportId,containerId,componentId,kpiStoreColArray,backFun) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.infoList=kpiStoreColArray;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.addMoreKpiStoreCols",info,function(data,e){backFun()});
    },
    "setDimCol" : function (reportId,containerId,componentId,rowCode,colCode,dimColObj,freeColCode) {
    	var moveInfo={};
    	moveInfo.reportId=reportId;
    	moveInfo.containerId=containerId;
    	moveInfo.componentId=componentId;
    	moveInfo.tablerowcode=rowCode;
    	moveInfo.tablecolcode=freeColCode;
    	moveInfo.inserttablecolcode=colCode;
    	
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.tablerowcode=rowCode;
    	info.tablecolcode=colCode;
    	var infoList=[];
    	
    	var tempInfo={};
    	tempInfo.attrKey="datacoltype";
    	tempInfo.attrValue="dim";
    	infoList.push(tempInfo);
    	
    	for(var key in dimColObj){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=dimColObj[key];
	    	infoList.push(tempInfo);
    	}
    	info.infoList=infoList;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.moveDatacolColPosition",moveInfo,function(data,e){
		       		Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setDatacolAttrs",info,function(data,e){
		        		tableSetHeadui();
			    	});
		        });	
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.moveDatacolColPosition",moveInfo,function(data,e){
	       		Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setDatacolAttrs",info,function(data,e){
	        		treeTableSetHeadui();
		    	});
	        });
   		}
       	
    	
        
    },
    "removeDimCol" : function (reportId,containerId,componentId,colCode) {
     	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.tablecolcode=colCode;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeDatacol",info,function(data,e){
		    		tableSetHeadui();
		    	});
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeDatacol",info,function(data,e){
	    		tableSetHeadui();
	    	});
   		}
    	
     },
     "removeMoreCol" : function (reportId,containerId,componentId,colCodeArray) {
     	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.colCodeArray=colCodeArray;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeMoreDatacol",info,function(data,e){
		    		tableSetHeadui();
		    	});
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeMoreDatacol",info,function(data,e){
	    		tableSetHeadui();
	    	});
   		}
    	
     },
         
    "setKpiCol" : function (reportId,containerId,componentId,rowCode,colCode,kpiColObj) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.tablerowcode=rowCode;
    	info.tablecolcode=colCode;
    	var infoList=[];
    	
    	var tempInfo={};
    	tempInfo.attrKey="datacoltype";
    	tempInfo.attrValue="kpi";
    	infoList.push(tempInfo);
    	
    	
    	for(var key in kpiColObj){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=kpiColObj[key];
	    	infoList.push(tempInfo);
    	}
    	info.infoList=infoList;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				 Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setDatacolAttrs",info,function(data,e){
		        	tableSetHeadui();
		        });
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			 Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setDatacolAttrs",info,function(data,e){
	        	tableSetHeadui();
	        });
   		}
       
    },
    "updateKpiStoreCol" : function (reportId,containerId,componentId,kpiColObj) {
    	 var info = {reportId:reportId,containerId:containerId,componentId:componentId,kpiMap:kpiColObj};
    	 Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.updateKpiStoreCol",info,function(data,e){});
    },
    "setMoreKpiCol" : function (reportId,containerId,componentId,kpiObjectArray) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<kpiObjectArray.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in kpiObjectArray[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=kpiObjectArray[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=kpiObjectArray[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
		        	tableSetHeadui();
		        });
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
	        	tableSetHeadui();
	        });
   		}
        
    },
    "removeKpiCol" : function (reportId,containerId,componentId,colCode) {
     	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.tablecolcode=colCode;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeDatacol",info,function(data,e){
		    		tableSetHeadui();
		    	});
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeDatacol",info,function(data,e){
	    		tableSetHeadui();
	    	});
   		}
    	
     },
     "moveColPostion" : function (reportId,containerId,componentId,rowCode,colCode,insertColCode,colInfo) {
     
     	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.tablerowcode=rowCode;
    	info.tablecolcode=colCode;
    	var infoList=[];
    	for(var key in colInfo){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=colInfo[key];
	    	infoList.push(tempInfo);
    	}
    	info.infoList=infoList;
    	
    	
    	var moveInfo={};
    	moveInfo.reportId=reportId;
    	moveInfo.containerId=containerId;
    	moveInfo.componentId=componentId;
    	moveInfo.tablerowcode=rowCode;
    	moveInfo.tablecolcode=colCode;
    	moveInfo.inserttablecolcode=insertColCode;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setDatacolAttrs",info,function(data,e){
        	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.moveDatacolColPosition",moveInfo,function(data,e){
	       		tableSetHeadui();
	    	});
        });
     
    	
    	
    },
    "setSortCol" : function (reportId,containerId,componentId,sortColObj) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var attrList=[];
    	
    	for(var key in sortColObj){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=sortColObj[key];
	    	attrList.push(tempInfo);
    	}
    	var tempInfo={};
    	tempInfo.attrList=attrList;
    	var infoList=[];
    	infoList.push(tempInfo);
    	info.infoList=infoList;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreSortcolMoreAttrs",info,function(data,e){});
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreSortcolMoreAttrs",info,function(data,e){});
   		}
        
    },
    "removeSortCol" : function (reportId,containerId,componentId,romoveIds) {
    	
     	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.romoveIds=romoveIds;
    	if(StoreData.dsType=='2'){//指标库
   			window["tableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeMoreSortcol",info,function(data,e){});
   			
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeMoreSortcol",info,function(data,e){});
   		}
    	
     },
    
    "setSortMode" : function (reportId,containerId,componentId,sortObj) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	
    	var attrList=[];
    	
    	for(var key in sortObj){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=sortObj[key];
	    	attrList.push(tempInfo);
    	}
    	
    	var tempInfo={};
    	tempInfo.attrList=attrList;
    	var infoList=[];
    	infoList.push(tempInfo);
    	info.infoList=infoList;
    	
    	
    	info.infoList=infoList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreSortcolMoreAttrs",info,function(data,e){});
    },
    "setSortKpiType" : function (reportId,containerId,componentId,sortObj) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	
    	var attrList=[];
    	
    	for(var key in sortObj){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=sortObj[key];
	    	attrList.push(tempInfo);
    	}
    	
    	var tempInfo={};
    	tempInfo.attrList=attrList;
    	var infoList=[];
    	infoList.push(tempInfo);
    	info.infoList=infoList;
    	
    	
    	info.infoList=infoList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreSortcolMoreAttrs",info,function(data,e){});
    },
    "overWriteSortCol" : function (reportId,containerId,componentId,sortObjs) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var infoList=[];
    	for(var a=0;a<sortObjs.length;a++){
    		var tempInfo={};
    		var attrList=[];
	    	for(var key in sortObjs[a]){
	    		var tempAttrInfo={};
		    	tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=sortObjs[a][key];
		    	attrList.push(tempAttrInfo);
	    	}
    		tempInfo.attrList=attrList;
	    	infoList.push(tempInfo);
    	}
    	info.infoList=infoList;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.overWriteSortcols",info,function(data,e){});
    },
    
    "getComponentJsonData" : function (reportId,containerId,componentId) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.getComponentJsonData",info,function(data,e){
    		tableComponentEditBack(data);
    	});
    },
    "setHeadColValue" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadSynCol" : function (reportId,containerId,componentId,dynHeadList,editOrRemove,openOrcloseProperiesWindow) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dynHeadCols=[];
    	info.dynHeadCols=dynHeadCols;
    	for(var a=0;a<dynHeadList.length;a++){
   			var dynheadcol={};
   			dynheadcol.dynHeadColId=dynHeadList[a]["id"];
   			var dynHeadColAttrs=[];
   			for(var key in dynHeadList[a]){
   				var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=dynHeadList[a][key];
   				dynHeadColAttrs.push(tempAttrInfo);
    		}
   			dynheadcol.dynHeadColAttrs=dynHeadColAttrs;
   			dynHeadCols.push(dynheadcol);
   		}
   		
    	if(editOrRemove=='edit'){
    		Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDynheadcolMoreAttrs",info,function(data,e){
	        	tableSetHeadui();
	        	if(openOrcloseProperiesWindow){
	        		tableHeadColOpenProperties();	
	        	}
	        });
    		
    	}else if(editOrRemove=='remove'){
    		Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.removeMoreDynheadcol",info,function(data,e){
	        	tableSetHeadui();
	        	if(!openOrcloseProperiesWindow){
	        		hideToolsPanel();
	        	}
	        });
    	
    	}
    },
    "setMergeCell":function(reportId,containerId,componentId){
    	if(tableMergeCell(componentId)){
	    	$("#tableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
			$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
			$("#tableHeadSplitCellButton_"+componentId).removeAttr("disabled");
			$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtn").removeClass("splitBtnDisable");
			var $selecteds=$("#selectable_"+componentId).find('.ui-selected');
			$("#tableHeadColValue_"+componentId).removeAttr("disabled");
			$("#tableHeadColValue_"+componentId).val(tableRestoreHtml($selecteds.html()));
			$("#tableHeadColValue_"+componentId).focus();
			if($selecteds.size()==1){
				$("#tableHeadColType_"+componentId).removeAttr("disabled")
			}
			tableSetHeadui();
    	}
    	
		
    	
    },
    "setSplitCell":function(reportId,containerId,componentId){
    	if(tableSplitCell(componentId)){
    		$("#tableHeadMergeCellButton_"+componentId).removeAttr("disabled");
	    	$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtn").removeClass("margerBtnDisable");
			$("#tableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
			$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
			var $selecteds=$("#selectable_"+componentId).find('.ui-selected');
			if($selecteds.size()>=1){
				$("#tableHeadColType_"+componentId).attr("disabled","disabled")
			}
	    	tableSetHeadui();
    	}
    	
    },
    "setHeadDataType" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataNumberStep" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataThousand" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataAlign" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataBorderSetFlag" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataBorderValue" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataBorderGtColor" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataBorderLtColor" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setHeadDataBorderShowUpDown" : function (reportId,containerId,componentId,cellInfoList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var dataCols=[];
    	info.dataCols=dataCols;
    	for(var a=0;a<cellInfoList.length;a++){
    		var dataColInfo={};
    		var dataColAttrs=[];
    		for(var key in cellInfoList[a]){
    			if(key=='tablerowcode'||key=='tablecolcode'){
    				dataColInfo[key]=cellInfoList[a][key];
    				continue;
    			}
    			var tempAttrInfo={};
    			tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=cellInfoList[a][key];
		    	dataColAttrs.push(tempAttrInfo);
    		}
    		dataColInfo.dataColAttrs=dataColAttrs;
    		dataCols.push(dataColInfo);
    	
    	}
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setDataClearEvent" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
        Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setClearMoreEvent",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setDataEventLink" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setDataEventLinkParameter" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setDataEventActive" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	tableSetHeadui();
        });
    },
    "setDataEventActiveParameter" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.DatagridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	tableSetHeadui();
        });
    }
    
}
var TreeTableEvent = {
	"setHeadui" : function (reportId,containerId,componentId,headui) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.headui=headui;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setHeadui",info,function(data,e){});
    },
    "setTitle" : function (reportId,containerId,componentId,title) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="title";
    	info.attrValue=title;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){
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
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){});
    },
    "setPagiFlag" : function (reportId,containerId,componentId,pagiFlag) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tablepagi";
    	info.attrValue=pagiFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){});
    },
    "setExportFlag" : function (reportId,containerId,componentId,exportFlag) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="tableexport";
    	info.attrValue=exportFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){});
    },
    "setDatasourceId" : function (reportId,containerId,componentId,datasourceId) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="datasourceid";
    	info.attrValue=datasourceId;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){});
    },
    "addMoreKpiStoreCols" : function (reportId,containerId,componentId,kpiStoreColArray,backFun) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.infoList=kpiStoreColArray;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.addMoreKpiStoreCols",info,function(data,e){backFun();});
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
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.moveDatacolColPosition",moveInfo,function(data,e){
		       		Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setDatacolAttrs",info,function(data,e){
		        		treeTableSetHeadui();
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
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeDatacol",info,function(data,e){
		    		treeTableSetHeadui();
		    	});
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeDatacol",info,function(data,e){
	    		treeTableSetHeadui();
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
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeMoreDatacol",info,function(data,e){
		    		treeTableSetHeadui();
		    	});
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeMoreDatacol",info,function(data,e){
	    		treeTableSetHeadui();
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
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setDatacolAttrs",info,function(data,e){
		        	treeTableSetHeadui();
		        });
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setDatacolAttrs",info,function(data,e){
	        	treeTableSetHeadui();
	        });
   		}
        
    },
    "updateKpiStoreCol" : function (reportId,containerId,componentId,kpiColObj) {
	   	 var info = {reportId:reportId,containerId:containerId,componentId:componentId,kpiMap:kpiColObj};
	   	 Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.updateKpiStoreCol",info,function(data,e){});
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
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				 Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
			        	treeTableSetHeadui();
			        });
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			 Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
	        	treeTableSetHeadui();
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
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeDatacol",info,function(data,e){
		    		treeTableSetHeadui();
		    	});
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			 Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeDatacol",info,function(data,e){
	    		treeTableSetHeadui();
	    	});
   		}
    	
     },
     "moveColPostionAndRemoveDrill" : function (reportId,containerId,componentId,rowCode,colCode,insertColCode,colInfo,removeColumnIds) {
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
    	
    	var removeInfo={};
    	removeInfo.reportId=reportId;
    	removeInfo.containerId=containerId;
    	removeInfo.componentId=componentId;
    	removeInfo.romoveIds=removeColumnIds;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setDatacolAttrs",info,function(data,e){
        	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.moveDatacolColPosition",moveInfo,function(data,e){
        		Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeMoreDrillcol",removeInfo,function(data,e){
        			
	       			treeTableSetHeadui();
        		});
        		
	    	});
        });
     
    	
    	
    },
    "setDrillCol" : function (reportId,containerId,componentId,drillColObj) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var attrList=[];
    	
    	for(var key in drillColObj){
    		var tempInfo={};
	    	tempInfo.attrKey=key;
	    	tempInfo.attrValue=drillColObj[key];
	    	attrList.push(tempInfo);
    	}
    	var tempInfo={};
    	tempInfo.attrList=attrList;
    	var infoList=[];
    	infoList.push(tempInfo);
    	info.infoList=infoList;
        if(StoreData.dsType=='2'){//指标库
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreSubdrillMoreAttrs",info,function(data,e){
        		});
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreSubdrillMoreAttrs",info,function(data,e){
        	});
   		}
    	
        
    },
    "removeDrillCol" : function (reportId,containerId,componentId,romoveIds) {
    	
     	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.romoveIds=romoveIds;
    	if(StoreData.dsType=='2'){//指标库
   			window["treeTableInsertMoreKpiStoreColumn"](true,function(){
   				Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeMoreDrillcol",info,function(data,e){});
   			});
   		}else if(StoreData.dsType=='1'){//自定义sql
   			Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeMoreDrillcol",info,function(data,e){});
   		}
    	
     },
    "overWriteDrillCol" : function (reportId,containerId,componentId,drillObjs) {
        var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	var infoList=[];
    	for(var a=0;a<drillObjs.length;a++){
    		var tempInfo={};
    		var attrList=[];
	    	for(var key in drillObjs[a]){
	    		var tempAttrInfo={};
		    	tempAttrInfo.attrKey=key;
		    	tempAttrInfo.attrValue=drillObjs[a][key];
		    	attrList.push(tempAttrInfo);
	    	}
    		tempInfo.attrList=attrList;
	    	infoList.push(tempInfo);
    	}
    	info.infoList=infoList;
    	
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.overWriteDrillcols",info,function(data,e){});
    },
    
    "getComponentJsonData" : function (reportId,containerId,componentId) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.getComponentJsonData",info,function(data,e){
    		treeTableComponentEditBack(data);
    	});
    },
    "setTreeFieldTitle" : function (reportId,containerId,componentId,treeFieldTitle) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="treefieldtitle";
    	info.attrValue=treeFieldTitle;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){
    		treeTableSetHeadui();
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
    		Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDynheadcolMoreAttrs",info,function(data,e){
	        	treeTableSetHeadui();
	        	if(openOrcloseProperiesWindow){
	        		treeTableHeadColOpenProperties();	
	        	}
	        });
    		
    	}else if(editOrRemove=='remove'){
    		Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.removeMoreDynheadcol",info,function(data,e){
	        	treeTableSetHeadui();
	        	if(!openOrcloseProperiesWindow){
	        		hideToolsPanel();
	        	}
	        });
    	
    	}
    },
    "setMergeCell":function(reportId,containerId,componentId){
    	if(treeTableMergeCell(componentId)){
	    	$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
			$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
			$("#treeTableHeadSplitCellButton_"+componentId).removeAttr("disabled");
			$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtn").removeClass("splitBtnDisable");
			var $selecteds=$("#selectable_"+componentId).find('.ui-selected');
			$("#treeTableHeadColValue_"+componentId).removeAttr("disabled");
			$("#treeTableHeadColValue_"+componentId).val(treeTableRestoreHtml($selecteds.html()));
			$("#treeTableHeadColValue_"+componentId).focus();
			if($selecteds.size()==1){
				$("#treeTableHeadColType_"+componentId).removeAttr("disabled")
			}
			treeTableSetHeadui();
    	}
    	
		
    	
    },
    "setSplitCell":function(reportId,containerId,componentId){
    	if(treeTableSplitCell(componentId)){
    		$("#treeTableHeadMergeCellButton_"+componentId).removeAttr("disabled");
	    	$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtn").removeClass("margerBtnDisable");
			$("#treeTableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
			$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
			var $selecteds=$("#selectable_"+componentId).find('.ui-selected');
			if($selecteds.size()>=1){
				$("#treeTableHeadColType_"+componentId).attr("disabled","disabled")
			}
	    	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
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
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreDatacolMoreAttrs",info,function(data,e){
        	treeTableSetHeadui();
        });
    },
    "setDataClearEvent" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
        Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setClearMoreEvent",info,function(data,e){
        	treeTableSetHeadui();
        });
    },
    "setDataEventLink" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	treeTableSetHeadui();
        });
    },
    "setDataEventLinkParameter" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	treeTableSetHeadui();
        });
    },
    "setDataEventActive" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	treeTableSetHeadui();
        });
    },
    "setDataEventActiveParameter" : function (reportId,containerId,componentId,eventStoreList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.eventStoreList=eventStoreList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setMoreEventStoreMoreEvent",info,function(data,e){
        	treeTableSetHeadui();
        });
    },
    "setDrillName" : function (reportId,containerId,componentId,drillColSelector,name) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcoltitle";
    	info.attrValue=name;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    
    },
    "setDrillCode" : function (reportId,containerId,componentId,drillColSelector,code) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcode";
    	info.attrValue=code;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    
    },
   "setDrillDatasourceId" : function (reportId,containerId,componentId,drillColSelector,datasourceId) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="datasourceid";
    	info.attrValue=datasourceId;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
    		if(window["treeTableDrillSetCodecolAndDesccolCode"]!=undefined&&window["treeTableDrillSetCodecolAndDesccolCode"]!=null){
    			window["treeTableDrillSetCodecolAndDesccolCode"]();
    		}
        });
    
    }, 
    "setDrillCodecolCode" : function (reportId,containerId,componentId,drillColSelector,codecolCode) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcolcode";
    	info.attrValue=codecolCode;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	if(window["treeTableSynDrillSetSortcolCode"]!=undefined&&window["treeTableSynDrillSetSortcolCode"]!=null){
    			window["treeTableSynDrillSetSortcolCode"]();
    		}
        });
    
    },
    "setDrillDesccolCode" : function (reportId,containerId,componentId,drillColSelector,desccolCode) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcoldesc";
    	info.attrValue=desccolCode;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    },
    "setDrillCodecolAndDesccolCode" : function (reportId,containerId,componentId,drillColSelector,codecolCode,desccolCode) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcolcode";
    	info.attrValue=codecolCode;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
    		info.attrKey="drillcoldesc";
    		info.attrValue=desccolCode;
        	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
	        	//treeTableSetHeadui();
	        });
        });
    
    },
    "setDrillSortcol" : function (reportId,containerId,componentId,drillColSelector,drillSortcolList) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcolSortcolList";
    	info.attrValue=drillSortcolList;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    },
    "setDrillDimCol" : function (reportId,containerId,componentId,drillColSelector,drillCodecolCode,drillDesccolCode) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcolcode";
    	info.attrValue=drillCodecolCode;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
    		info.attrKey="drillcoldesc";
    		info.attrValue=drillDesccolCode;
        	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
	        	//treeTableSetHeadui();
	        });
        });
    
    },
    "setDrillShowLevel" : function (reportId,containerId,componentId,drillColSelector,showLevel) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="level";
    	info.attrValue=showLevel;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    
    }, 
    "setDrillGroupName" : function (reportId,containerId,componentId,drillColSelector,groupName) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="group";
    	info.attrValue=groupName;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    
    }, 
    "setDrillDefaulShowFlag" : function (reportId,containerId,componentId,drillColSelector,defaulShowFlag) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="isdefault";
    	info.attrValue=defaulShowFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    
    },  
    "setDrillWidth" : function (reportId,containerId,componentId,width) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="fieldwidth";
    	info.attrValue=width;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){});
    },
    "setDrillTotalShowFlag" : function (reportId,containerId,componentId,totalShowFlag) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="hastotalflag";
    	info.attrValue=totalShowFlag;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){
    		treeTableSetHeadui();
    	});
    },
    "setDrillTotalCode" : function (reportId,containerId,componentId,totalCode) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="totalcode";
    	info.attrValue=totalCode;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){
    		treeTableSetHeadui();
    	});
    },
    "setDrillTotalName" : function (reportId,containerId,componentId,totalName) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.attrKey="totaltitle";
    	info.attrValue=totalName;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setComponentAttr",info,function(data,e){
    		treeTableSetHeadui();
    	});
    },
    
    "xxxx" : function (reportId,containerId,componentId,drillColSelector,name) {
    	var info={};
    	info.reportId=reportId;
    	info.containerId=containerId;
    	info.componentId=componentId;
    	info.subdrillIndex=drillColSelector;
    	info.attrKey="drillcoltitle";
    	info.attrValue=name;
    	Service.Factory.service("cn.com.easy.xbuilder.service.component.TreegridService.setOneSubdrillOneAttr",info,function(data,e){
        	//treeTableSetHeadui();
        });
    
    }
    //setDrillName ff
}
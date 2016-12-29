var downApp = {
	waiting:false,
	//c:datagrid下载
	downDataGrid:function downDataGrid(id,epath,cmenuid,downArgs,filename,url){
		downApp.getArgs(id,url,downArgs,filename,0,epath,1);
	},
	
	//c:treegrid下载
	downTreeGridJson:function downTreeGridJson(id,epath,cmenuid,downArgs,filename){
		downApp.getArgs(id,'',downArgs,filename,2,epath,2);
	},
	
	//c:treegrid 分级下载
	downTreeGrid:function downTreeGrid(id,epath,field,idField,cmenuid,downArgs,filename,url){
		var $id = $('#'+id)
		var info = {};
		var node = $id.treegrid('getSelected');
		if(node){
			downApp.getTreeGridParams($id,node,idField,info);
		}
		var drillArgs = '&dim='+field+'&'+$.param(info);
		downApp.getArgs(id,url,downArgs+drillArgs,filename,1,epath,1);
	},
	
	//获得所有参数
	getArgs:function getArgs(id,url,downArgs,filename,ctype,filetype,datatype){
		var $id = $('#'+id);
		var get_params = '';
		if(url){
			url += url.indexOf('?')!=-1?'&is_down_table=true':'?is_down_table=true';
			get_params = url.substring(url.indexOf('?')+1);
		}
		
		var qParams = {};
		if(ctype>0){
			qParams = $id.treegrid('options').queryParams;
		}else{
			qParams = $id.datagrid('options').queryParams;
		}
		 
		qParams.fileType = filetype;
		qParams.dataType = datatype;
		
		var q_param_str = ',';
		$.each(qParams, function(key, val){
			q_param_str +=key+',';
		});
		var params = get_params+downArgs;
		if(params != null && params != ''){
			var arr_tmp = params.split('&');
			if(arr_tmp.length>0){
				for(var a=0;a<arr_tmp.length;a++){
					if(arr_tmp[a] != null && arr_tmp[a].length>0){
						var v_arr = arr_tmp[a].split('=');
						if(q_param_str.indexOf(','+v_arr[0]+',')<=-1){
							qParams[v_arr[0]]=v_arr[1];
						}
					}
				}
			}else{
				var v_arr = arr_tmp[0].split('=');
				if(q_param_str.indexOf(','+v_arr[0]+',')<=-1){
					qParams[v_arr[0]]=v_arr[1];
				}
			}
		}
		
		if(ctype<2){
			$.post(url,qParams,function(data){
				var parm = downApp.getGridColumns(id,$id,qParams,filename,ctype);
				popDown(parm);
			});
		}else if(ctype ==2){
			var parm = downApp.getGridColumns(id,$id,qParams,filename,ctype);
			popDown(parm);
		}
	},
	
	//获得表格所有列信息
	getGridColumns:function getGridColumns(id,$id,qParams,filename,ctype){
		var ebuilderData = {};
		if (typeof(ebuilder_grid_field_percent) != "undefined") {
			for (var i = 0; i < ebuilder_grid_field_percent.length; i++) {
				var data = ebuilder_grid_field_percent[i];
				if (data.comid == id) {
					ebuilderData[data.filedkey] = '1';
				}
			}
		}
	
		var str='';
		var frozenTitle2Arr = $id.datagrid('options').frozenColumns;
		var title2Arr = $id.datagrid('options').columns;
		for(var i=0;i<frozenTitle2Arr.length;i++){
			for(var n=0; n<frozenTitle2Arr[i].length; n++){
				var col=frozenTitle2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				var value = ebuilderData[col.field];
				if(value !=null && value !='' && value !=undefined && value !='undefined'){
					if(value == '1'){
						str += col.title+','+col.field+','+rn+','+cn+',1;';
					}else{
						str += col.title+','+col.field+','+rn+','+cn+',0;';
					}
				}else{
					str += col.title+','+col.field+','+rn+','+cn+',0;';
				}
				if(n == (frozenTitle2Arr[i].length-1) && i !=(frozenTitle2Arr.length-1)){
					str +='&';
				}
			}
		}
	
		for(var i=0;i<title2Arr.length;i++){
			for(var n=0; n<title2Arr[i].length; n++){
				var col=title2Arr[i][n];
				var rn = col.rowspan == undefined?"1":col.rowspan;
				var cn = col.colspan == undefined?"1":col.colspan;
				var value = ebuilderData[col.field];
				if(value !=null && value !='' && value !=undefined && value !='undefined'){
					if(value == '1'){
						str += col.title+','+col.field+','+rn+','+cn+',1;';
					}else{
						str += col.title+','+col.field+','+rn+','+cn+',0;';
					}
				}else{
					str += col.title+','+col.field+','+rn+','+cn+',0;';
				}
				if(n == (title2Arr[i].length-1) && i !=(title2Arr.length-1)){
					str +='&';
				}
			}
		}
		str = str.replace(/&nbsp;/g,"").replace(/<\/?.+?>/g,"");
		if(ctype >= 1){
			var $dim_obj=$id.find('tr');
			var maxRow=0;
			$.each($dim_obj,function(index, o){
				maxRow++;
			});
			if(maxRow>1){
				var treeDimStr = str.substring(0,str.indexOf(";"));
				var surplusStr = str.substring(str.indexOf(";"));
				var treeDimArr = treeDimStr.split(",");
				treeDimArr[2] = maxRow;
				str = treeDimArr.join(",")+surplusStr;
			}
			qParams.columns = str;
			if(ctype == 2){
				var tgObj = $id.treegrid('getData');
				qParams.jsonData=$.toJSON(tgObj);
			}
		}else{
			qParams.columns = str;
		}
		
		qParams.downid = id;
		if(filename){
			qParams.fileName=filename;
		}else{
			qParams.fileName='数据';
		}
		return qParams;
	},
	
	//获得下钻表格的下钻参数
	getTreeGridParams:function getTreeGridParams($id,node,idField, params){
		params[node.DIM] = node[idField];
		var parent = $id.treegrid('getParent',node.TREETABLEID);
		if(parent!=null){
			downApp.getTreeGridParams($id,parent,idField,params);
		}
	}
}

//-----------------------------------------------
var taskArray=[];//任务列表
var downLoadServerUrl='';
var timer;//定时器
var timerIsExute=false;//定时器是否正在执行

/*
$(function(){
	var downLoadServerUrl1='${DownLoadServerUrl1}';
	var downLoadServerUrl2='${DownLoadServerUrl1}';
	var currentHref=window.location.href;
	var flagStr=currentHref.substring(0,currentHref.indexOf("."));
	if(downLoadServerUrl1.indexOf(flagStr)==0){
		downLoadServerUrl=downLoadServerUrl1;
	}else if(downLoadServerUrl2.indexOf(flagStr)==0){
		downLoadServerUrl=downLoadServerUrl2;
	}

});
*/
  
/*生在惟一标识（uuid）*/
function createUUID() {
	var s = [];
	var hexDigits = "0123456789abcdef";
	for (var i = 0; i < 36; i++) {
		s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
	}
	s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
	s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
	s[8] = s[13] = s[18] = s[23] = "-";

	var uuid = s.join("");
	return uuid;
}
/*深度复制*/
function deepCopy(source) { 
	var result={};
	for (var key in source) {      
		result[key] = typeof source[key]==='object'? deepCoyp(source[key]): source[key];   
	} 
   	
   	return result; 
}

function slide(createFlag){
	//var popupWindow=$("#popupId").parent();
	//console.log(window.top.document.getElementById("downloadFile_a_show").id);
	//alert(top.window.document.getElementById("downloadFile_a_show").text);
	var msgHeight=100;
	var msgStr='<table width="100%" align="left">';
	msgStr+='<tr>';
	msgStr+='    <th align="left" width="240px">名称</th>';
	msgStr+='    <th align="left" width="100px">状态</th>';
	msgStr+='    <th align="left" width="60px">操作</th>';
	msgStr+='</tr>';
	var tempName='';
	for(var i=0;i<taskArray.length;i++){
		tempName=taskArray[i].fileName
		//console.log(tempName.length);
		if(tempName.length>25){
			var preNameStr=tempName.substring(0,10);
			var aftNameStr=tempName.substring(tempName.length-10,tempName.length);
			tempName=preNameStr+'.....'+aftNameStr;
		}
		//console.log(taskArray[i].id+":"+tempName+'.'+taskArray[i].fileType);
		if(taskArray[i].status!='-1'){//生成中
			msgStr+='<tr>';
			msgStr+='    <td>'+tempName+'['+taskArray[i].fileType+']</td>';
			msgStr+='    <td>生成中</td>';
			msgStr+='    <td><a href="javascript:void(0);" onclick="cancelGenerateFile(\''+taskArray[i].id+'\')">取消</a></td>';
			msgStr+='</tr>';
		}else{//生成完成
			downloadFile(taskArray[i].id,taskArray[i].fileName);
			taskArray.splice(i,1);
			/*
			msgStr+='<tr>';
			msgStr+='    <td>'+tempName+'['+taskArray[i].fileType+']</td>';
			msgStr+='    <td>生成完成</td>';
			msgStr+='    <td><a href="javascript:void(0);" id="downfileA'+i+'" onclick="downloadFile(\''+taskArray[i].id+'\',\''+taskArray[i].fileName+'\')">下载</a></td>';
			msgStr+='</tr>';
			//taskInfo.isDown=0;//是否正在下载，0：否，1：是
			if(taskArray[i].isDown==0){
				taskArray[i].isDown=1;
				downloadFile(taskArray[i].id,taskArray[i].fileName);
				
			}
			*/
		}
		msgHeight+=20;
		
	}
	msgStr+='</table>';
	
	if(msgHeight<100){
		msgHeight=100;
	}
	if(msgHeight>400){
		msgHeight=400;
	}
	//pop窗口是否已存在
	if($("#popupId").size()==0){
		
		//不创建pop窗口
		if(createFlag!=true){
			return false;
		}
		//初始化pop窗口
		$.messager.show({
			id:"popupId",
			title:'文件生成列表',
			msg:'<div id="popupDiv"></div>',
			width:400,
			height:300,
			timeout:0,
			showType:null
		});
		$("#popupId").css("overflow","auto");//滚动条自动显示
		
		//清除显示入口
		if($("#popShowDiv")!=undefined){
			$("#popShowDiv").remove();
		}
		//点击关闭（红叉）时显示一个显示入口
		$("#popupId").parent().find("a[class='panel-tool-close']").click(function(){
			//追加一个div,点击这个div时显示pop窗口
			$("body").append('<div id="popShowDiv" style="position: fixed;right: 0;bottom: 400px;background: #00ff00" onclick="slide(true)">显示</div>');
		});
	}
	$("#popupDiv").html(msgStr);
	if(taskArray.length==0){
		clearInterval(timer);
		timer=null;
		
		$("#popupId").parent().remove();
		$("#popShowDiv").remove();
		//$("#popupId").parent().find("a[class='panel-tool-close']").click();
	}
	
	
}
/*
function slide(createFlag){
	var msgHeight=100;
	var msgStr='<ul>';
	var tempName='';
	for(var i=0;i<taskArray.length;i++){
		tempName=taskArray[i].fileName
		//console.log(tempName.length);
		if(tempName.length>25){
			var preNameStr=tempName.substring(0,10);
			var aftNameStr=tempName.substring(tempName.length-10,tempName.length);
			tempName=preNameStr+'.....'+aftNameStr;
		}
		
		if(taskArray[i].status!='-1'){//生成中
			msgStr+='    <li id="li_'+taskArray[i].id+'"><a href="javascript:void(0);">'+tempName+'['+taskArray[i].fileType+']</a></li>';
		}else{//生成完成
			downloadFile(taskArray[i].id,taskArray[i].fileName);
			taskArray.splice(i,1);
		}
		
	}
	msgStr+='</ul>';
	
	if(taskArray.length>0){
		$(window.top.document.getElementById("downloadFile_num_show")).html(taskArray.length);
		$(window.top.document.getElementById("downloadFile_a_show")).show();
	}else{
		$(window.top.document.getElementById("downloadFile_a_show")).hide();
		$(window.top.document.getElementById("downloadWindow")).hide();
		clearInterval(timer);
	}
	$(window.top.document.getElementById("downloadWindow")).html(msgStr);
	
	
}
 */



/*入口*/
function popDown(param){
	//console.log(sql);
	//alert($.toJSON(param));
	var taskInfo=deepCopy(param);
	
	var uuid=createUUID();
	taskInfo.id=uuid;//惟一标识
	taskInfo.status=1;//状态，1：生成中，-1：生成完成
	taskInfo.isDown=0;//是否正在下载，0：否，1：是
	taskArray.push(taskInfo);
	
	generateFile(taskInfo);
	if(timer==null){
		timer= window.setInterval("updateTaskStatus()",1000);
	}
	

}

/*生成文件*/
function generateFile(param){
	
	
	/*$.getJSON(appBase+'/generateFile.e?jsoncallback=?', param, function(json) {
		if($.trim(json.returnStr)=='-1'){
       		for(var i=0;i<taskArray.length;i++){
       			if(taskArray[i].id==param.id){
       				taskArray[i].status=-1;
       			}
       		}
       	}
		slide(true);

    });　 */
	
	$.ajax({
          type : "post",  
          url : appBase+'/generateFileReady.e',  
          data : param,  
          async : false,  
          success : function(data){
          	var tempData=$.trim(data);
          	var tempDataArray=tempData.split(";");
          	if(tempDataArray!=null&&tempDataArray.length==2){
          		if(tempDataArray[0]=='-1'){
	          		for(var i=0;i<taskArray.length;i++){
	          			if(taskArray[i].id==param.id){
	          				taskArray[i].status=-1;
	          			}
	          		}
	          	}
	          	
	          	downLoadServerUrl=tempDataArray[1];
          	}
          	slide(true);
          	
          	
          }  
        }); 
      
}


/*取消生成文件*/
function cancelGenerateFile(id){
	for(var i=0;i<taskArray.length;i++){
		if(taskArray[i].id==id){
			
			/*$.getJSON(appBase+'/cancelGenerateFile.e?jsoncallback=?', taskArray[i], function(json){
	          	slide(false);
	    		
	    	});*/
	    	
	    	
			$.ajax({
	          type : "post",  
	          url :  appBase+'/cancelGenerateFileReady.e',  
	          data : taskArray[i],  
	          async : false,  
	          success : function(data){ 
	          	taskArray.splice(i,1); 
	          	slide(false);
	          }  
	        }); 
	        
	        break;
		
			
		}
	
	}

}

/*下载文件*/
function downloadFile(id,fileName){
	var downFormStr='<form id="form'+id+'" method="post" action="'+downLoadServerUrl+'/downloadFile.e?id='+id+'" >';
		downFormStr+='     <input type="hidden" id="fileName" name="fileName" value="'+fileName+'">';
		downFormStr+='</form>';
	$("body").append(downFormStr);
	$("#form"+id).submit();
}



function updateTaskStatus(){
	//alert($.toJSON(taskArray));
	var ids='';
	for(var a=0;a<taskArray.length;a++){
		if(taskArray[a].status!=-1){
			ids+=taskArray[a].id+",";
		}
    }
    if(ids!=''){
    	//console.log(1);
    	/*$.getJSON(appBase+'/getAllStatus.e?jsoncallback=?', {"ids":ids}, function(json){
    		var tempData=json;
            for(var i=0;i<tempData.length;i++){
            	for(var j=0;j<taskArray.length;j++){
            		if(tempData[i].id==taskArray[j].id&&taskArray[j].status!=undefined){
            			taskArray[j].status=tempData[i].status;
            		}
            	}
            
            }
          	slide(false);
    		
    	});*/
		$.ajax({
	          type : "post",  
	          url :  appBase+'/getAllStatusReady.e',  
	          data : {"ids":ids},  
	          async : false,  
	          success : function(data){
	            var tempData=eval("("+data+")");
	            for(var i=0;i<tempData.length;i++){
	            	for(var j=0;j<taskArray.length;j++){
	            		if(tempData[i].id==taskArray[j].id&&taskArray[j].status!=undefined){
	            			taskArray[j].status=tempData[i].status;
	            		}
	            	}
	            
	            }
	          	slide(false);
	          }  
	        }); 
        }else{
        	if(timer!=null){
        		clearInterval(timer);
        		timer=null;
        	}
        
        }
//console.log(1);
}

	

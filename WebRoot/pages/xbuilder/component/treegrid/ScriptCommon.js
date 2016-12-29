var treeTableCurrentEvnetCompenentId='';
var treeTableCurrentEvnetEventId='';
var treeTableSortStartArray=[];
var treeTableSortStartTypeArray=[];
var treeTableSortEndArray=[];
var treeTableHeadCellAttrNameArray=["data-treeTableHeadWidth"];
var treeTableDataCellAttrNameArray=["data-treeTableDataTdType","data-treeTableDataNumberStep","data-treeTableDataThousand","data-treeTableDataType",
				"data-treeTableDataAlign","data-treeTableDataRowMerge","data-treeTableDataBorderSetFlag","data-treeTableDataBorderValue",
				"data-treeTableDataBorderGtColor","data-treeTableDataBorderLtColor","data-treeTableDataBorderShowUpDown",
				"data-treeTableDataEvent","data-treeTableEventSelectJson","width"];
var treeTableDrillKeyValueArray=[{"key":"AREA","value":"地市"},{"key":"CITY","value":"区县"},{"key":"TOWN","value":"乡镇"}];

//------------------表格整体开始-------------------------------------------//
/** 描述：判断字符串是否包含汉字
	参数：
		value 字符串
*/
function treeTableCheckContainChinese(value){
	var resultFlag=false;
	var reqExp=new RegExp("[\\u4E00-\\u9FFF]+","g");
	if (reqExp.test(value)){//包含汉字
		resultFlag=true;
	}
	return resultFlag;
}

/** 描述：替换字符串中汉字为空字符
	参数：
		value 字符串
*/
function treeTableReplaceChinese2Null(value){
	var resultStr=""
	var reqExp=new RegExp("[\\u4E00-\\u9FFF]+","g");
	if (value!=null&&value!=undefined){//包含汉字
		resultFlag=true;
		resultStr=value.replace(reqExp,"");
	}
	return resultStr;
}
/** 描述：合并单元格
	参数：
		componentId 组件编号
*/
function treeTableMergeCell(componentId){
	var selectedsText='';//所有选中单元格文本
	var $selecteds=$("#selectable_"+componentId).find('.ui-selected');
	var $selecttreeTable = $selecteds.parent().parent().parent();
	var isHead =null;
	var continueFlag=true;
	var maxRowNum=1;//选中单元格最大行
	var minRowNum=1;//选中单元格最小行
	var maxColNum=1;//选中单元格最大列
	var minColNum=1;//选中单元格最小列
	var isRightSelect=true;//选择正确 标识
	var headRowBorder=$selecttreeTable.find("tr").length-1; //与数据单元格相邻的行号
	var colSpanNum=1;//列合并值
	var rowSpanNum=1;//行合并值
	if($selecteds.size()==0){
		return false;
	}
	if(!continueFlag){
		$.messager.alert("下钻表格","选中的单元格不能进行列合并操作！","error");
		continueFlag=true;
		return false;
	}
	$selecteds.each(function (i,e) {
		selectedsText+=$(e).text();
		if(i==0){
			isHead=$(e).attr("ishead");
			/*初始化最大行，最小行，最大列，最小列*/
			maxRowNum=parseInt($(e).attr("istt").substr(2));
			minRowNum=parseInt($(e).attr("istt").substr(2));
			maxColNum=parseInt($(e).attr("tdInd"));
			minColNum=parseInt($(e).attr("tdInd"));
		}
		if(isHead!=$(e).attr("ishead")){
			continueFlag=false;
		}
		/*重置合并列的值*/
		if($(e).attr("colspan")==undefined||$(e).attr("colspan")==""){
			colSpanNum=1;
		}else{
			colSpanNum=parseInt($(e).attr("colspan"));
		}
		/*重置合并行的值*/
		if($(e).attr("rowspan")==undefined||$(e).attr("rowspan")==""){
			rowSpanNum=1;
		}else{
			rowSpanNum=parseInt($(e).attr("rowspan"));
		}
		/*计算最大行*/
		if((parseInt($(e).attr("istt").substr(2))+rowSpanNum-1)>maxRowNum){
			maxRowNum=(parseInt($(e).attr("istt").substr(2))+rowSpanNum-1);
		}
		/*计算最小行*/
		if(parseInt($(e).attr("istt").substr(2))<minRowNum){
			minRowNum=parseInt($(e).attr("istt").substr(2));
		}
		/*计算最大列*/
		if((parseInt($(e).attr("tdInd"))+colSpanNum-1)>maxColNum){
			maxColNum=(parseInt($(e).attr("tdInd"))+colSpanNum-1);
		}
		/*计算最小列*/
		if(parseInt($(e).attr("tdInd"))<minColNum){
			minColNum=parseInt($(e).attr("tdInd"));
		}
		
	});
	
	if(!continueFlag){
		$.messager.alert("下钻表格","选中的单元格不属于同类！","error");
		return false;
	}
	/*
	alert("maxRowNum:"+maxRowNum);
	alert("minRowNum:"+minRowNum);
	alert("maxColNum:"+maxColNum);
	alert("minColNum:"+minColNum);
	*/
	if(headRowBorder>=minRowNum&&headRowBorder<=maxRowNum&&maxColNum!=minColNum){
		$.messager.alert("下钻表格","与数据单元格相邻的表头单元格不允许合并！","error");
		return false;
	}
	
	/*计算 选择的单元格是否规范（是否为一个整体，长方形）*/
	for(var a=(minRowNum);a<(maxRowNum+1);a++){
		for(var b=minColNum;b<(maxColNum+1);b++){
			continueFlag=false;
			$selecteds.each(function (i,e) {
				colSpanNum=1;
				rowSpanNum=1;
				if($(e).attr("colspan")!=undefined){
					colSpanNum=parseInt($(e).attr("colspan"));
				}
				if($(e).attr("rowspan")!=undefined){
					rowSpanNum=parseInt($(e).attr("rowspan"));
				}
				/*选中单元格中是否包含遍历来的单元格*/
				if((parseInt($(e).attr("istt").substr(2))+rowSpanNum-1)>=a
					&&a>=parseInt($(e).attr("istt").substr(2))
					&&(parseInt($(e).attr("tdInd"))+colSpanNum-1)>=b
					&&b>=parseInt($(e).attr("tdInd"))){
					continueFlag=true;
				}
			
			});
			
			if(!continueFlag){//如果不包含，说明选中单元格不是矩形，设置isRightSelect标志为false
				isRightSelect=false;
				break;
			}
		}
	
	}
	if(!isRightSelect){
		$.messager.alert("下钻表格","选中的单元格不规范，不能进行列合并操作！","error");
		return false;
	}
	//alert(2);
	$selecteds.each(function (iii,eee) {
		if(iii==0){//第一个单元格
			$(eee).attr("rowspan",(maxRowNum-minRowNum+1));//设置行合并
			$(eee).attr("colspan",(maxColNum-minColNum+1));//设置列合并
			$(eee).text(selectedsText);
			
			var curRowNum = parseInt($(eee).attr("istt").substr(2));
			var curColNum = parseInt($(eee).attr("tdInd"))-1;
			var cell = treeTableGetCellByRowCol("#selectable_"+componentId, curRowNum, curColNum);
			if(cell!=null && $(cell).attr('ishead')==undefined && parseInt($(eee).attr("rowspan"))>1){
				$(eee).attr("field", $(cell).attr('data-data_col'));
			}
		}else{
			$(eee).remove();//清除多余单元格
		}
	});
	return true;
	
}

function treeTableGetCellByRowCol(treeTableId, rowNum, colNum){
	var cell = null;
	$(treeTableId).find("tbody tr").each(function(i ,r){
		if(i == rowNum){
			$(this).find("td").each(function(j ,c){
				if(j==colNum){
					cell = c;
				}
			});
		}
	});
	return cell;
}

/** 描述：拆分单元格
	参数：
		componentId 组件编号
*/
function treeTableSplitCell(componentId){
	var $selecteds=$("#selectable_"+componentId).find('.ui-selected').eq(0);//选中的第一个单元格
	var selectedsText=$selecteds.text();
	var selectedsIstt=$($selecteds).attr("istt");
	var $selecttreeTable = $selecteds.parent().parent().parent(); //表格对象
	var treeTable_select = document.getElementById('selectable_'+componentId);//表格的dom对象，为下面取列个数用的
	var treeTable_col_length=treeTable_select.rows[0].cells.length;//表格列个数
	var colNum;//列值
	var rowNum;//行值
	var colSpanNum=1;//列合并值
	var rowSpanNum=1;//行合并值
	var colNumResult=1;//计算
	var rowCellNum;
	
	var tempColNum;//临时列值
	var tempRowNum;//临时行值
	var tempColSpanNum=1;//临时列合并值
	var tempRowSpanNum=1;//临时行合并值
	var lastColResult=0;//上一次计算后的列值
	var $td="";//插入单元格
	
	
	/*获取选中单元格的行值、列值、合并行值、合并列值*/
	colNum=parseInt($($selecteds).attr("tdInd"));
	rowNum=parseInt($($selecteds).attr("istt").substr(2));
	if($($selecteds).attr("colspan")!=undefined){
		colSpanNum=parseInt($($selecteds).attr("colspan"));
	}
	if($($selecteds).attr("rowspan")!=undefined){
		rowSpanNum=parseInt($($selecteds).attr("rowspan"));
	}
	if (colSpanNum == 1 && rowSpanNum == 1)
		return false;
	
	$selecteds.remove();//清除选中单元格
	
	if(treeTable_col_length==colSpanNum+1){//选中单元格所在行只有选中列一列
		treeTable_split_part($selecttreeTable,colSpanNum);
	}else{
		if(colSpanNum!=1||rowSpanNum!=1){//有合并行或合并列
			$selecttreeTable.find("tbody tr").each(function(i,e){
				lastColResult=0;
				rowCellNum=e.cells.length;//当前行列数量
				if(i>=(rowNum-2)&&i<(rowNum+rowSpanNum-2)){//遍历行行数在选中单元格范围内
					if(rowCellNum==1)//遍历行只有一个单元格（序号单元格）
						treeTable_split_row_part($(e),colSpanNum,colNum);
					$(e).find("td").each(function(ii,ee){
						tempColNum=1;
						tempRowNum=1;
						tempColNum=parseInt($(ee).attr("tdInd"));
						tempRowNum=parseInt($(ee).attr("istt").substr(2));
						if($(ee).attr("colspan")!=undefined&&$(ee).attr("colspan")!=""){
							tempColSpanNum=parseInt($(ee).attr("colspan"));
						}else{
							tempColSpanNum=1;
						}
						if($($selecteds).attr("rowspan")!=undefined&&$($selecteds).attr("rowspan")!=""){
							tempRowSpanNum=parseInt($(ee).attr("rowspan"));
						}else{
							tempRowSpanNum=1;
						}
						if(colNum<(tempColNum+tempColSpanNum-1)&&colNum>lastColResult){//选定列小于本列值，大于上一列值
						
							for(var a=0;a<colSpanNum;a++){
								$td= "<td class=\"ui-state-default ui-selected\" istt=\"td"+tempRowNum+"\"  ishead=\"1\" tdInd=\""+(colNum+a)+"\"style=\"width:100px;\"></td>";
								$($td).insertBefore($(ee));
							}
						
						}
						lastColResult=tempColNum+tempColSpanNum-1;//重置上一次计算后的列值
						if(ii==(rowCellNum-2)&&(tempColNum+tempColSpanNum-1)<colNum){//遍历行最后一列小于选中列列值
							for(var a=0;a<colSpanNum;a++){
								$td= "<td class=\"ui-state-default\" istt=\"td"+tempRowNum+"\"  ishead=\"1\" tdInd=\""+(colNum+colSpanNum-a-1)+"\"style=\"width:100px;\"></td>";
								$($td).insertAfter($(ee));
							}
						}
						
					});
				
				
				}
				
			});
			
		}
	}
	var mergerAfterFirstCell=$('#selectable_'+componentId+' tr>td[istt="'+selectedsIstt+'"][tdInd="'+colNum+'"]');
	if(mergerAfterFirstCell.size()>0){
		mergerAfterFirstCell.text(selectedsText);
	}
	$("#selectable_"+componentId).selectable('refresh');
	
	return true;
}


/** 描述：当合并的行数过多使得其中一行不复存在时候
	参数：
		$tr 所在行
		colSpanNum 合并列值
		colNum	列值
*/
function treeTable_split_row_part($tr,colSpanNum,colNum){
	var $th = $($tr.find('th'));
	var tempRowNum = parseInt($th.attr("istt").substr(2));
	for(var a=colSpanNum;a>0;a--){
		var $td = "<td class=\"ui-state-default\" istt=\"td"
				+ tempRowNum
				+ "\"  ishead=\"1\" tdInd=\""
				+ (colNum+a-1)
				+ "\"style=\"width:100px;\"></td>";
		$($td).insertAfter($th);
	}
}
		

/** 描述：当选中列为一行时调用的方法
	参数：
		$selecttreeTable 所在表格
		colSpanNum 合并列值
*/
function treeTable_split_part($selecttreeTable,colSpanNum){
	$selecttreeTable.find('tbody tr').each(function(tr_index,tr_dom){
		if(tr_dom.cells.length==1){
			var $th =$($(tr_dom).find('th'));
			var tempRowNum = parseInt($th.attr("istt").substr(2));
			for(var a=colSpanNum;a>0;a--){
				var $td = "<td class=\"ui-state-default\" istt=\"td"
						+ tempRowNum
						+ "\"  ishead=\"1\" tdInd=\""
						+ a
						+ "\"style=\"width:100px;\"></td>";
				$($td).insertAfter($th);
			}
		}
	});
}

/** 描述：插入列
	参数：
		componentId 组件编号
		position 插入位置（左left、右right）
*/
function treeTableInsertColumn(componentId,position){
		/*初始化列序号数组*/
		var th_show = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
		for(var th_i=0;th_i<26;th_i++){
			for(var th_j=0;th_j<26;th_j++){
				th_show[(th_i+1)*26+th_j]=th_show[th_i]+th_show[th_j];
			}
		}
		
		
		var $selecteds=$("#selectable_"+componentId).find('.ui-selected').eq(0);//选中单元格
		var $selecttreeTable = $selecteds.parent().parent().parent();//选中表格
		var select_index = parseInt($selecteds.attr('tdInd'));//选中单元格的“tdInd”属性值，即列值
		var select_tdInd=parseInt($selecteds.attr('tdInd'));//选中单元格的“tdInd”属性值，即列值
		var exitNumInRow=0;
		var isFirstSameIndCell=true;
		var hasGetTdFlag=false;
		var tdPosition;  
		var tempTdInd=0;
		var tempColSpan=1;
		var continueFlag=true;
		var minSpaceNum=9999;
		if($selecteds.attr('colspan')!=undefined&&$selecteds.attr('colspan')!='1'){
			$.messager.alert("下钻表格","选中单元格所在列有列合并单元格，不能插入列，请拆分后再操作！","error");
			return false;
		}
		$selecttreeTable.find("tr").each(function(i1,e1){
			$(this).find("td").each(function(index1,domEle1){
				tempTdInd=parseInt($(domEle1).attr("tdInd"));
				if($(domEle1).attr("colspan")!=undefined){
					tempColSpan=parseInt($(domEle1).attr("colspan"));
				}else{
					tempColSpan=1;
				}
				if(tempTdInd==select_tdInd&&tempColSpan!=1){//
					continueFlag=false;
					return false;
				}else if((tempTdInd+tempColSpan)>select_tdInd&&(select_tdInd)>tempTdInd){
					continueFlag=false;
					return false;
				}
			});
			if(!continueFlag){
				return false;
			}
		});
		if(!continueFlag){
			$.messager.alert("下钻表格","选中单元格所在列有列合并单元格，不能插入列，请拆分后再操作！","error");
			return false;
		}
		
		$selecttreeTable.find("tr").each(function (index, domEle) {
			var $newColumn = "";
			var th_tr = $(this).find(":first-child").attr("istt");
			var isHead = $(this).find(":first-child").attr("ishead");
			//alert(th_tr);
			var $td = null;
			var tempColSpanForCommitTd=1;
			if(th_tr.indexOf('th')>=0){
				$td=$(domEle).find("th:last-child");//取最后一列，后面会对字母进行矫正
				$newColumn = $('<th class="ui-state-default" istt="th'+(index+1)+'" style="width:100px;"></th>');
				tdPosition='back';
			}else{
				
				/*
					取插入单元格，即以哪个单元格进行操作
				*/
				$td = null;
				if(position=="left"){//左侧插入
					$(domEle).find("td").each(function(aa,bb){
						if(parseInt($(bb).attr("tdInd"))==select_index){//遍历的单元格tdInd属性值等于选中单元格tdInd属性值
							$td=$(bb);
							tdPosition='back';
						}
					});
					
					if($td==null){//遍历的单元格tdInd属性值没有等于选中单元格tdInd属性值的，取在选中单元格tdInd属性值后面的最近的单元格
						hasGetTdFlag=false;
						tdPosition='back';
						$(domEle).find("td").each(function(cc,dd){
							if(parseInt($(dd).attr("tdInd"))>select_index&&(!hasGetTdFlag)){
								$td=$(dd);
								hasGetTdFlag=true;
								tdPosition='back';
							}
							if(!hasGetTdFlag){
								$td=$(dd);
								tdPosition='front';
							}
						});
					}
					
				}else if(position=="right"){//右侧插入
					$(domEle).find("td").each(function(aa,bb){
						if($(bb).attr("colspan")!=undefined){///遍历的单元格colspan属性不为空
							tempColSpanForCommitTd=parseInt($(bb).attr("colspan"));
						}else{
							tempColSpanForCommitTd=1;
						}
						/**/
						if((parseInt($(bb).attr("tdInd"))+tempColSpanForCommitTd-1)>=select_index&&parseInt($(bb).attr("tdInd"))<=select_index){
							$td=$(bb);
						}
						//Math.abs(0)
						
						if($td==null){//没取到，取在选中单元格tdInd属性值前面的最近的单元格
							hasGetTdFlag=false;
							minSpaceNum=9999;
							$(domEle).find("td").each(function(cc,dd){
								if(Math.abs(parseInt($(dd).attr("tdInd"))-select_index)<minSpaceNum){
									minSpaceNum=Math.abs(parseInt($(dd).attr("tdInd"))-select_index);
									$td=$(dd);
								}
							});
						}
						/*
						if($td==null){//没取到，取在选中单元格tdInd属性值前面的最近的单元格
							hasGetTdFlag=false;
							$(domEle).find("td").each(function(cc,dd){
								if(parseInt($(dd).attr("tdInd"))<=select_index&&(!hasGetTdFlag)){
									$td=$(dd);
								}else{
									hasGetTdFlag=true;
								}
							});
						}
						*/
					});
				}
				
				$newColumn = '<td class="ui-state-default" istt="td'+(index+1)+'"';
				if(isHead=='1'){
					$newColumn=$newColumn+' ishead="1" style="width:100px;"';
				}
				
				$newColumn=$($newColumn+' tdInd="'+(select_index)+'"></td>');
			}
			if(position=="left"){
			
				if(tdPosition=='front'){
					$newColumn.insertAfter($td);
				}else{
					$newColumn.insertBefore($td);
				}
				
			}else if(position=="right"){
				if(parseInt($td.attr("tdInd"))<=select_index){
					$newColumn.insertAfter($td);
				}else{
					$newColumn.insertBefore($td);
				}
					
			}
		});
		$selecttreeTable.find("tr").each(function(i2,e2){
			isFirstSameIndCell=true;
			exitNumInRow=0;
			if(i2==0){//thead  字母行
				$(this).find("th").each(function(index,domEle){//矫正
					if(index>0){
						$(this).html(th_show[index-1]);
					}
						
				});
			}else{//tbody
				/*插入列后，计算遍历行中单元格为选中单元格tdInd属性值的个数，选中单元格有合并行时会出现1，否则为2*/
				$(this).find("td").each(function(indexForGetExitNum,domEleForGetExitNum){
					if(parseInt($(domEleForGetExitNum).attr("tdInd"))==select_index){
						exitNumInRow=exitNumInRow+1;
					}
				});
				//alert(i2+"exitNumInRow:"+exitNumInRow);
				/*遍历行，更正单元格的tdInd属性值*/
				$(this).find("td").each(function(index,domEle){
					if(exitNumInRow==2){//本行有两个单元格的tdInd属性值为选中单元格的tdInd属性值，选中单元格没有行合并；
						if(parseInt($(domEle).attr("tdInd"))==select_index&&isFirstSameIndCell){//两个单元格中第一个的tdInd属性值不变
							isFirstSameIndCell=false;
							//alert("true:"+select_index);
						}else if(parseInt($(domEle).attr("tdInd"))==select_index&&(!isFirstSameIndCell)){//两个单元格中第二个单元格的tdInd属性值加1
							//alert("false:"+$(domEle).attr("tdInd"));
							$(domEle).attr("tdInd",""+(select_index+1));
						
						}else if(parseInt($(domEle).attr("tdInd"))>select_index){//以后单元格的tdInd属性值加1
							//alert($(domEle).attr("tdInd"));
							$(domEle).attr("tdInd",""+(parseInt($(domEle).attr("tdInd"))+1));
						}
					}else if(exitNumInRow==1){//本行有1个单元格的tdInd属性值为选中单元格的tdInd属性值，选中单元格有行合并；
						if(position=="left"){//左侧插入
							if(parseInt($(domEle).attr("tdInd"))>select_index){//大于选中行tdInd属性值（没有等于）的单元格的tdInd属性值加1
								$(domEle).attr("tdInd",""+(parseInt($(domEle).attr("tdInd"))+1));
							}
								//
						}else if(position=="right"){//右则插入
							if(parseInt($(domEle).attr("tdInd"))>=select_index){//大于等于选中行tdInd属性值的单元格的tdInd属性值加1
								$(domEle).attr("tdInd",""+(parseInt($(domEle).attr("tdInd"))+1));
							}
						}
						
						
					}
					
						
				});
			}
			
		});
			
		var oldWidth=$("#selectable_"+componentId).css("width");
		$("#selectable_"+componentId).css("width",(parseInt(oldWidth.substring(0,oldWidth.indexOf("px")))+100)+"px");
		return true;
		 
}
		
		
/** 描述：插入行
	参数：
		componentId 组件编号
		position 插入位置（上up、下down）
*/
function treeTableInsertRow(componentId,position){
	var $selecteds=$("#selectable_"+componentId).find('.ui-selected').eq(0);
	var $selecttreeTable = $selecteds.parent().parent().parent();
	var $tr = $selecteds.parent();
	var continueFlag=true;
	var $selectTrIsttNum=0;
	var $rowSpan=1;
	$selectTrIsttNum=parseInt($selecteds.attr('istt').substr(2));
	if($selecteds.attr("rowspan")!=undefined&&$selecteds.attr("rowspan")!='1'){
		$.messager.alert("下钻表格","选中行有行合并单元格，不能插入行，请拆分后再操作！","error");
		return false;
	}
	 /*遍历表格所有单元格，检查是否有合并单元格，如果有，设置标志continueFla为false*/
	 $selecttreeTable.find("tr").each(function(index_tr,domEle_tr){
	 	$(this).find("td").each(function(index_td,domEle_td){
	 		var tempTrIstt=parseInt($(domEle_td).attr("istt").substr(2));
	 		 if($(domEle_td).attr("rowspan")!=undefined&&$(domEle_td).attr("rowspan")!='1'){
			 	$rowSpan=parseInt($(domEle_td).attr("rowspan"));
			 	if((tempTrIstt+$rowSpan)>$selectTrIsttNum&&($selectTrIsttNum+1)>tempTrIstt){
			 		continueFlag=false;
		 			return false;
			 	}
			 }
		});
		 if(!continueFlag){
		 	return false;
		 }
		
	 });
	 if(!continueFlag){
	 	$.messager.alert("下钻表格","选中行有行合并单元格，不能插入行，请拆分后再操作！","error");
	 	return false;
	 }
	
	var $tempTr=null;
	var isHead = $selecteds.attr("ishead");
	$selecttreeTable.find("tr").each(function(i,v){
		if(i==0)
			$tempTr=$(this);
	});
	var tr_index = parseInt($selecteds.attr('istt').substr(2));//行值
	var tr_str='<tr>';//插入行字符串
	if(position=='down')
		tr_index=tr_index+1;
		$tempTr.find("th").each(function(index,domEle){
		if(index==0){
			if(isHead=='1'){
				tr_str = tr_str + '<th class="ui-state-default" istt="td'+(tr_index)+'" ishead="1">'+(tr_index-1)+'</th>';
			}else{
				tr_str = tr_str + '<th class="ui-state-default" istt="td'+(tr_index)+'" >'+(tr_index-1)+'</th>';
			}
		}else{
			if(isHead=='1'){
				tr_str = tr_str + '<td class="ui-state-default" istt="td'+(tr_index)+'" ishead="1" tdInd="'+index+'" style="width:100px;"></td>';
			}else{
				tr_str = tr_str + '<td class="ui-state-default" istt="td'+(tr_index)+'" tdInd="'+index+'" ></td>';
			}
			
		}
	});
	$selecttreeTable.find("tr").each(function(index,domEle){
		if(index+1>=tr_index){
			var temp = index+2;
			$(this).find("th").each(function(index,domEle){
				$(this).attr("istt","td"+temp);
				$(this).html(temp-1);
			});
			$(this).find("td").each(function(index,domEle){
				$(this).attr("istt","td"+temp);
			});
		}
	});
	tr_str = tr_str+'</tr>';
	if(position=='up')
		$(tr_str).insertBefore($tr);
	else
		$(tr_str).insertAfter($tr);
	return true;
	
}

	
/** 描述：删除列
	参数：
		componentId 组件编号
*/	
function treeTableDeleteColumn(componentId) {
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected");
	var $selecttreeTable = $selecteds.eq(0).parent().parent().parent();
	var th_show = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	for(var th_i=0;th_i<26;th_i++){
		for(var th_j=0;th_j<26;th_j++){
			th_show[(th_i+1)*26+th_j]=th_show[th_i]+th_show[th_j];
		}
	}
	var tdLength=null;
	var hasDeleteNum=0;
	var selectCol=[];
	var colNumForCompare;
	var exitFlag=false;
	var miniTdInd=0;
	
	var flag1=true;
	var flag2=true;
	var flag3=true;
	var flag4=true;
	if($selecteds.length==0){
		$.messager.alert("下钻表格","请选择至少一个单元格！","error");
		return false;
	}else{
		/*计算选中单元格包含几列*/
		$selecteds.each(function(aa,bb){
			exitFlag=false;
			colNumForCompare=$(bb).attr("tdInd");
			for(var k=0;k<selectCol.length;k++){
				if(selectCol[k]==colNumForCompare){
					exitFlag=true;
				}
			}
			if(!exitFlag){
				selectCol[selectCol.length]=colNumForCompare;
			}
		});
		
		
		if((selectCol.length+1)==$selecttreeTable.find("tr").eq(0).find("th").length){
			$.messager.alert("下钻表格","删除后将没有单元格，不允许删除！","error");
			flag4=false;
			return false;
		}
		$selecteds.each(function(aa,bb){
			/*计算选中单元格最小tdInd*/
			if(aa==0){
				miniTdInd=colNumForCompare;
			}else{
				if(miniTdInd>colNumForCompare){
					miniTdInd=colNumForCompare;
				}
			}
			
			if($selecttreeTable.find("tr").eq(0).find("th").length==2){
				$.messager.alert("下钻表格","最后一列，不允许删除！","error");
				flag1=false;
				return false;
			}
			
			var select_tdInd=parseInt($(bb).attr('tdInd'));
			var tempTdInd=0;
			var tempColSpan=1;
			var continueFlag=true;
			if($(bb).attr('colspan')!=undefined&&$(bb).attr('colspan')!='1'){
				$.messager.alert("下钻表格","<br/>"+th_show[(parseInt($(bb).attr("tdInd"))-1)]+"列有列合并单元格，不能删除！","error");
				flag2=false;
				return false;
			}
			
			/*选中列是否有列合并*/
			$selecttreeTable.find("tr").each(function(i1,e1){
				$(this).find("td").each(function(index1,domEle1){
					tempTdInd=parseInt($(domEle1).attr("tdInd"));
					if($(domEle1).attr("colspan")!=undefined){
						tempColSpan=parseInt($(domEle1).attr("colspan"));
					}else{
						tempColSpan=1;
					}
					if(tempTdInd==select_tdInd&&tempColSpan!=1){
						continueFlag=false;
						return false;
					}else if((tempTdInd+tempColSpan)>select_tdInd&&(select_tdInd)>tempTdInd){
						continueFlag=false;
						return false;
					}
				});
				if(!continueFlag){
					return false;
				}
			});
			if(!continueFlag){
				$.messager.alert("下钻表格","<br/>"+th_show[(parseInt($(bb).attr("tdInd"))-1)]+"列有列合并单元格，不能删除！","error");
				flag3=false;
				return false;
			}else{
				/*删除操作*/
				$selecttreeTable.find("tr").each(function(i2,e2){
					$(this).find("td").each(function(index2,domEle2){
						tempTdInd=parseInt($(domEle2).attr("tdInd"));
						if(tempTdInd==select_tdInd){
							$(domEle2).remove();
						}
					});
				});
			
			}
			hasDeleteNum=hasDeleteNum+1;
		
		});
	
		if(flag1&&flag2&&flag3&&flag4){
			/*清除字母列*/
			$selecttreeTable.find("tr:first").each(function(i3,e3){
				$(this).find("th").each(function(index3,domEle3){
					if(index3>0&&index3<=selectCol.length){
						$(domEle3).remove();
					}
				
				});
			});
	
			/*重置字母*/
			$selecttreeTable.find("tr").each(function(i,e){
				//$(this).find(":nth-child(" + select_index + ")").remove();
				if(i==0){
					$(this).find("th").each(function(index,domEle){
						if(index>0){
							$(this).html(th_show[index-1]);
						}else{
							$(this).html('');
						}
					});
				}
			});
				
			
			/*重置tdInd*/
			$selecttreeTable.find("tr").each(function(i4,e4){
				$(this).find("td").each(function(index4,domEle4){
					if(parseInt($(domEle4).attr("tdInd"))>miniTdInd){
						$(domEle4).attr("tdInd",(parseInt($(domEle4).attr("tdInd"))-selectCol.length));
					}
				});
			});
			/*重置表格宽度*/
			for(var l=0;l<selectCol.length;l++){
				var oldWidth=$("#selectable_"+componentId).css("width");
				$("#selectable_"+componentId).css("width",(parseInt(oldWidth.substring(0,oldWidth.indexOf("px")))-100)+"px");
				
			}
		
		}else{
			return false;
		}
	}
	return true;
}
		
/** 描述：删除行
	参数：
		componentId 组件编号
*/			
function treeTableDeleteRow(componentId) {
	var treeTable = document.getElementById("selectable_"+componentId);
	var treeTable_length = treeTable.rows.length;
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected");
	var $selecttreeTable = $selecteds.parent().parent();
	var $selectedTr =null;
	var tr_index = null;
	var $selectTrIsttNum=0;
	var $rowSpan=1;
	var continueFlag=true;
	var hasDeleteNum=0;
	if($selecteds.length==0){
		$.messager.alert("下钻表格","请选择表格！","error");
		return false;
	}else{
		$selecteds.each(function(selectedIndex,selectedTdEle){
		
			treeTable_length=treeTable_length-hasDeleteNum;
	
			$selectedTr=$(selectedTdEle).parent();
			tr_index=$selecttreeTable.children().index($selectedTr)+1;
			if((treeTable_length==3&&tr_index==(treeTable_length-2))||tr_index==(treeTable_length-1)){//是否最后一行
				$.messager.alert("下钻表格","此行不能删除，表格里至少保留一行数据和一行表头！","error");
				return false;
			}else{
				 
				// $(selectedTdEle).parent().remove();
				 $selectTrIsttNum=parseInt($(selectedTdEle).attr('istt').substr(2));
				 //alert("-"+$(selectedTdEle).attr("rowspan")+"-");
				 if($(selectedTdEle).attr("rowspan")!=undefined&&$(selectedTdEle).attr("rowspan")!='1'){
				 	$.messager.alert("下钻表格","<br/>第"+(parseInt($(selectedTdEle).attr("istt").substr(2))-1)+"行有行合并单元格，不能删除！","error");
				 	return false;
				 }
				 /*判断是否有列合并*/
				 $selecttreeTable.find("tr").each(function(index_tr,domEle_tr){
				 	$(this).find("td").each(function(index_td,domEle_td){
				 		var tempTrIstt=parseInt($(domEle_td).attr("istt").substr(2));
				 		 if($(domEle_td).attr("rowspan")!=undefined&&$(domEle_td).attr("rowspan")!='1'){
						 	$rowSpan=parseInt($(domEle_td).attr("rowspan"));
						 	if((tempTrIstt+$rowSpan)>$selectTrIsttNum&&($selectTrIsttNum+1)>tempTrIstt){
						 		continueFlag=false;
					 			return false;
						 	}
						 }
					});
					 if(!continueFlag){
					 	return false;
					 }
					
				 });
				 if(!continueFlag){
				 	$.messager.alert("下钻表格","<br/>第"+(parseInt($(selectedTdEle).attr("istt").substr(2))-1)+"行有行合并单元格，不能删除！","error");
				 	return false;
				 }
				 /*如果是表头的最后一行，判断它的上一行是否有列合并，如果有，不允许删除，与数据行相邻的表头行不可以有列合并*/
				 if($selectTrIsttNum==(treeTable_length-1)){
					 continueFlag=true;
					 $selecttreeTable.find("tr").each(function(index_tr1,domEle_tr1){
					 	$(this).find("td").each(function(index_td1,domEle_td1){
					 		var tempTrIstt=parseInt($(domEle_td1).attr("istt").substr(2));
							if($(domEle_td1).attr("rowspan")!=undefined&&$(domEle_td1).attr("rowspan")!='1'){
								$rowSpan=parseInt($(domEle_td1).attr("rowspan"));
							}else{
								$rowSpan=1;
							}
							if((tempTrIstt+$rowSpan-1)>=($selectTrIsttNum-1)){
								
								if($(domEle_td1).attr("colspan")!=undefined&&$(domEle_td1).attr("colspan")!="1"){
									continueFlag=false;
						 			return false;
								}
								
							}
						});
						 if(!continueFlag){
						 	return false;
						 }
					 });
					 if(!continueFlag){
					 	$.messager.alert("下钻表格","<br/>第"+(parseInt($(selectedTdEle).attr("istt").substr(2))-1)+"行的上一行有列合并单元格，不能删除！","error");
					 	return false;
					 }
				 
				 
				 
				 }
				 
				 
			 	$(selectedTdEle).parent().remove();
			 	hasDeleteNum=hasDeleteNum+1;
			 	$selecttreeTable.find("tr").each(function(index,domEle){
					if(index+1>=tr_index){
						var temp = index+2;
						$(this).find("th").each(function(index1,domEle1){
							//alert($(domEle1).html()+"th");
							$(domEle1).attr("istt","td"+temp);
							$(domEle1).html(temp-1);
						});
						$(this).find("td").each(function(index,domEle){
							//alert($(domEle).html()+"td");
							$(domEle).attr("istt","td"+temp);
						});
					}
					
				});
				 
				 
			}

		});
	}
	return true;
}

/** 描述：将"<"用"&lt;"替换、">"用"&gt;"替换
	参数：
		htmlCode html字符串
*/				
function treeTableFilterHtml(htmlCode){
	    return htmlCode.replace(/</g,"&lt;").replace(/>/g,"&gt;");//替换“<”和“>”
}
		
/** 描述：将"&lt;"用"<"替换、"&gt;"用">"替换
	参数：
		htmlCode html字符串
*/			
function treeTableRestoreHtml(htmlCode){
	return htmlCode.replace(/&lt;/g,"<").replace(/&gt;/g,">");//还原“<”和“>”
}

/** 描述：将rgb(0,0,0)转换为#000000
	参数：
		rgb rgb颜色
*/	
function treeTableRgb2hex(rgb) {
    rgb = rgb.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);
    return (rgb && rgb.length === 4) ? "#" + ("0" + parseInt(rgb[1], 10).toString(16)).slice( - 2) + ("0" + parseInt(rgb[2], 10).toString(16)).slice( - 2) + ("0" + parseInt(rgb[3], 10).toString(16)).slice( - 2) : '';
}

/** 描述：移动单元格
	参数：
		componentId 组件编号
		rowCode 行
		colCode 列
		insertColCode 目标列
*/
function treeTableMoveCell(componentId,rowCode,colCode,insertColCode){
	if(rowCode<=1){
		$.messager.alert("下钻表格","请设置rowcode参数大于1","error");
		return false;
	}
	var thShowArray = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	for(var th_i=0;th_i<26;th_i++){
		for(var th_j=0;th_j<26;th_j++){
			thShowArray[(th_i+1)*26+th_j]=thShowArray[th_i]+thShowArray[th_j];
		}
	}
	var colCodeNum=0;
	var insertColCodeNum=0;
	for(var a=0;a<thShowArray.length;a++){
		if(colCode==thShowArray[a]){
			colCodeNum=a+1;
		}
		if(insertColCode==thShowArray[a]){
			insertColCodeNum=a+1;
		}
	}
	var lastTrTd=$("#selectable_"+componentId+" tr>td[istt='td"+rowCode+"']");
	var tempColNum=0;
	var tempOldLastRowCell=null;//移动前的距数据单元格最近的表头单元格(例如有行合并的时候)
	var tempNewLastRowCell=null;//移动后的距数据单元格最近的表头单元格(例如有行合并的时候)
	var currentCell={};
	var currentSelectCell=$("#selectable_"+componentId+" tr>td[istt='td"+rowCode+"'][tdInd='"+colCodeNum+"']").clone();
	var currentLastRowCell=$(treeTableFindLastRowCellByTdInd(componentId,currentSelectCell.attr("tdInd"))).clone();
	if(insertColCodeNum>colCodeNum){
		for(var b=1;b<=lastTrTd.length;b++){
			tempColNum=parseInt($(lastTrTd[b-1]).attr("tdInd"));
			if(tempColNum>=colCodeNum&&tempColNum<insertColCodeNum){
				treeTableMoveAllCellAttr($(lastTrTd[b]),$(lastTrTd[b-1]),'0');
				tempOldLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(lastTrTd[b]).attr("tdInd"));
				tempNewLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				treeTableMoveAllCellAttr($(tempOldLastRowCell),$(tempNewLastRowCell),'1');
			}else if(tempColNum==insertColCodeNum){
				treeTableMoveAllCellAttr($(currentSelectCell),$(lastTrTd[b-1]),'0');
				tempNewLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				treeTableMoveAllCellAttr($(currentLastRowCell),$(tempNewLastRowCell),'1');
			}
		}
	}else if(insertColCodeNum<colCodeNum){
		for(var b=lastTrTd.length;b>=1;b--){
			tempColNum=parseInt($(lastTrTd[b-1]).attr("tdInd"));
			if(tempColNum>insertColCodeNum&&tempColNum<=colCodeNum){
				treeTableMoveAllCellAttr($(lastTrTd[b-2]),$(lastTrTd[b-1]),'0')
				tempOldLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-2]).attr("tdInd"));
				tempNewLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				treeTableMoveAllCellAttr($(tempOldLastRowCell),$(tempNewLastRowCell),'1');
				
			}else if(tempColNum==insertColCodeNum){
				treeTableMoveAllCellAttr($(currentSelectCell),$(lastTrTd[b-1]),'0');
				tempNewLastRowCell=treeTableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				treeTableMoveAllCellAttr($(currentLastRowCell),$(tempNewLastRowCell),'1');
			}
		}
	}
	
}
/** 描述：移动单元格属性
	参数：
		oldCell 原来单元格
		newCell 新单元格
		isHead  是否是表头单元格

*/

function treeTableMoveAllCellAttr(oldCell,newCell,isHead){
	var keyArray=[];
	if(isHead=='1'){
		keyArray=treeTableHeadCellAttrNameArray;
	}else{
		keyArray=treeTableDataCellAttrNameArray;
	}
	var tempKeyValue='';
	for(var a=0;a<keyArray.length;a++){
		tempKeyValue=oldCell.attr(keyArray[a]);
		if(tempKeyValue!=undefined&&tempKeyValue!=''&&tempKeyValue!=null&&tempKeyValue!='null'){
			newCell.attr(keyArray[a],tempKeyValue);
		}else{
			newCell.removeAttr(keyArray[a]);
		}
		oldCell.removeAttr(keyArray[a]);
	}
	newCell.text(oldCell.text());
}
/**	描述：清除单元格属性
  	参数：
  		componentId 组件id
  		rowCode 行
  		colCode 列
*/
function treeTableClearCell(componentId,rowCode,colCode){
	if(rowCode<=1){
		$.messager.alert("下钻表格","请设置rowcode参数大于1","error");
		return false;
	}
	var thShowArray = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
	for(var th_i=0;th_i<26;th_i++){
		for(var th_j=0;th_j<26;th_j++){
			thShowArray[(th_i+1)*26+th_j]=thShowArray[th_i]+thShowArray[th_j];
		}
	}
	var colCodeNum=0;
	for(var a=0;a<thShowArray.length;a++){
		if(colCode==thShowArray[a]){
			colCodeNum=a+1;
		}
	}
	var currentSelectCell=$("#selectable_"+componentId+" tr>td[istt='td"+rowCode+"'][tdInd='"+colCodeNum+"']");
	var keyArray=[];
	if(currentSelectCell.attr("ishead")=='1'){
		keyArray=treeTableHeadCellAttrNameArray;
	}else{
		keyArray=treeTableDataCellAttrNameArray;
	}
	var tempKeyValue='';
	for(var a=0;a<keyArray.length;a++){
		currentSelectCell.removeAttr(keyArray[a]);
	}
	currentSelectCell.text("");
}



function treeTableFindLastRowCellByTdInd(componentId,tdInd){
	var resultCell=null;
	var treeTableTrs=$("#selectable_"+componentId+" tr");
	for(var a=treeTableTrs.length-2;a>=0;a--){
		if($(treeTableTrs[a]).find("td[tdInd='"+tdInd+"']").size()>0){
			resultCell=$(treeTableTrs[a]).find("td[tdInd='"+tdInd+"']")[0];
			break;
		}
	}
	return resultCell;
}
/**	描述：切换布局方式 
	参数：
		lType 布局方式,1:电脑、2:手机
*/
function treeTableSwitchLType(lType){
	if(lType=='1'){
		if($("#treeTablePagiDt").size()>0){
			$("#treeTablePagiDt").show();//显示导出的dt标签
		}
		if($("#treeTablePagiDd").size()>0){
			$("#treeTablePagiDd").show();//显示导出的dd标签
		}
		if($("#treeTableDataEventDiv").size()>0){
			$("#treeTableDataEventDiv").show();//显示动作
		}
	
	}else if(lType=='2'){
		if($("#treeTablePagiDt").size()>0){
			$("#treeTablePagiDt").hide();//隐藏导出的dt标签
		}
		if($("#treeTablePagiDd").size()>0){
			$("#treeTablePagiDd").hide();//隐藏导出的dd标签
		}
		if($("#treeTableDataEventDiv").size()>0){
			$("#treeTableDataEventDiv").hide();//隐藏动作
		}
		
	}
	
}
/* 保存页头源码 */
function treeTableSetHeadui(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var headui=$('#selectable_' + componentId).html();
	TreeTableEvent.setHeadui(reportId,containerId,componentId,headui);
}

/** 描述：还原按钮点击事件（）
	参数：
		data json数据

*/
function treeTableComponentEditButton(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	treeTableComponentEdit(reportId,containerId,componentId);
}

/** 描述：表格整体属性还原方法
	参数：
		reportId		报表id
		containerId		容器id
		componentId		组件id
*/
function treeTableComponentEdit(containerId,componentId){
	var reportId=StoreData.xid;
	//StoreData.xid=reportId;
	StoreData.curContainerId=containerId;
	StoreData.curComponentId=componentId;
	TreeTableEvent.getComponentJsonData(reportId,containerId,componentId);
}


//------------------表格整体结束-------------------------------------------//
//------------------表头单元格开始-------------------------------------------//
function treeTableHeadColTypeValue(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected");
	var textValue="";
	if($selecteds.size()>0){
		var dynHeadList=[];
		if(value==2&&($($selecteds[0]).attr("data-dynheadid")==undefined||$($selecteds[0]).attr("data-dynheadid")==null)){//当前为静态并且要设置成动态
			for(var a=0;a<$selecteds.length;a++){
				var dynHeadId=LayOutUtil.uuid();//data-dynheadid
				$($selecteds[a]).attr("data-dynheadid",dynHeadId);
				$($selecteds[a]).attr("data-treeTableHeadColDynType",'1');
				$($selecteds[a]).attr("data-treeTableDynHeadDataType",'1');
				$($selecteds[a]).attr("data-treeTableDynHeadYearStep",'0');
				$($selecteds[a]).attr("data-treeTableDynHeadMonthStep",'0');
				$($selecteds[a]).attr("data-treeTableDynHeadDayStep",'0');
				$($selecteds[a]).attr("data-treeTableDynHeadPrefixStr",'');
				$($selecteds[a]).attr("data-treeTableDynHeadSuffixStr",'');
				var dynHeadInfo={};
				dynHeadInfo.id=dynHeadId;
				dynHeadList.push(dynHeadInfo);
				
				textValue="动态表头[日]";
				$($selecteds[a]).attr("data-treeTableHeadValueBeforeDyn",$($selecteds[a]).text());
				$($selecteds[a]).text(textValue);
				$("#treeTableHeadColValue_"+componentId).val(textValue);
				$("#treeTableHeadColValue_"+componentId).attr("disabled","disabled");
				$("#treeTableHeadColValue_"+componentId).blur();
				
				
			}
			/*设置合并、拆分按钮 start*/
			$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
			$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
			$("#treeTableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
			$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
			/*设置合并、拆分按钮 end*/
			
			TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",true);
			
		}else if(value==1&&$($selecteds[0]).attr("data-dynheadid")!=undefined&&$($selecteds[0]).attr("data-dynheadid")!=null){//当前为动态并且要设置成静态
			for(var a=0;a<$selecteds.length;a++){
				var dynHeadId=$($selecteds[a]).attr("data-dynheadid");//data-dynheadid
				$($selecteds[a]).removeAttr("data-dynheadid");
				$($selecteds[a]).removeAttr("data-treeTableHeadColDynType");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadDataType");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadDimsionName");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadYearStep");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadMonthStep");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadDayStep");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadPrefixStr");
				$($selecteds[a]).removeAttr("data-treeTableDynHeadSuffixStr");
				var dynHeadInfo={};
				dynHeadInfo.id=dynHeadId;
				dynHeadList.push(dynHeadInfo);
				
				textValue=""
				if($($selecteds[a]).attr("data-treeTableHeadValueBeforeDyn")!=undefined&&$($selecteds[a]).attr("data-treeTableHeadValueBeforeDyn")!=null){
					textValue=$($selecteds[a]).attr("data-treeTableHeadValueBeforeDyn");
					$($selecteds[a]).removeAttr("data-treeTableHeadValueBeforeDyn");
				}
				$($selecteds[a]).text(textValue);
				$("#treeTableHeadColValue_"+componentId).val(textValue);
				$("#treeTableHeadColValue_"+componentId).removeAttr("disabled");
				$("#treeTableHeadColValue_"+componentId).focus();
			}
			if($selecteds.size()==1){//
				if(($($selecteds[0]).attr("colspan")!=null&&$($selecteds[0]).attr("colspan")!=undefined&&$($selecteds[0]).attr("colspan")!=''&&parseInt($($selecteds[0]).attr("colspan"))>1)
					||($($selecteds[0]).attr("rowspan")!=null&&$($selecteds[0]).attr("rowspan")!=undefined&&$($selecteds[0]).attr("rowspan")!=''&&parseInt($($selecteds[0]).attr("rowspan"))>1)){
					/*设置合并不可用、拆分按钮可用 start*/
					$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
					$("#treeTableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
					$("#treeTableHeadSplitCellButton_"+componentId).removeAttr("disabled");
					$("#treeTableHeadSplitCellButton_"+componentId).addClass("splitBtn").removeClass("splitBtnDisable");
					/*设置合并不可用、拆分按钮可用 end*/
				}
			}
			TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"remove",false);
		}
		
	}else{
		$.messager.alert("下钻表格","请选择要设置的表头单元格！","error");
	}
}

/** 描述：显示动态表头单元格的设置窗口并还原已设置的属性
	参数：
		dynheadid 动态属性id
*/	
function treeTableHeadColOpenProperties(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	setProPageTitle("组件属性设置");
	$("#propertiesPage").load(appBase+"/pages/xbuilder/component/treegrid/PropertiesDynHead.jsp?t="+(new Date().getTime()),function(){
		$.parser.parse($("#propertiesPage"));
		toolsPanel();
		toolsAddHideEvent();
		var dimsionsJson=$.ajax({url: appBase+"/getAllDimsionsJsonX.e?report_id="+reportId+'&isTempFile=1',type:"POST",cache: false,async: false}).responseText;
		dimsionsJson=$.parseJSON(dimsionsJson);
		var dimsionData=[];
		for(var a=0;a<dimsionsJson.length;a++){
			if(dimsionsJson[a]["isparame"]=='0'){
				var tempDimsion={};
				tempDimsion["id"]=dimsionsJson[a]["varname"];
				tempDimsion["text"]=dimsionsJson[a]["desc"];
				dimsionData.push(tempDimsion);
			}
		}
		$("#treeTableDynHeadDimsionName").combobox("loadData",dimsionData);
		var $selectable= $("#selectable_"+componentId);
		var $selectTds=$selectable.find(".ui-selected");
		var treeTableHeadColDynType='';//是否是动态表头
		var treeTableHeadColDynTypeSameFlag=true;
		for(var a=0;a<$selectTds.length;a++){
			if(a==0){//初始化临时变量
				treeTableHeadColDynType=$($selectTds[a]).attr("data-treeTableHeadColDynType");
			}
			if(treeTableHeadColDynType!=$($selectTds[a]).attr("data-treeTableHeadColDynType")){
				treeTableHeadColDynTypeSameFlag=false;
			}
			
		}
		if(treeTableHeadColDynTypeSameFlag){//有相同的动态类型
			var treeTableDynHeadDataType=$($selectTds[0]).attr("data-treeTableDynHeadDataType");
			var treeTableDynHeadDimsionName=$($selectTds[0]).attr("data-treeTableDynHeadDimsionName");
			var treeTableDynHeadYearStep=$($selectTds[0]).attr("data-treeTableDynHeadYearStep");
			var treeTableDynHeadMonthStep=$($selectTds[0]).attr("data-treeTableDynHeadMonthStep");
			var treeTableDynHeadDayStep=$($selectTds[0]).attr("data-treeTableDynHeadDayStep");
			var treeTableDynHeadPrefixStr=$($selectTds[0]).attr("data-treeTableDynHeadPrefixStr");
			var treeTableDynHeadSuffixStr=$($selectTds[0]).attr("data-treeTableDynHeadSuffixStr");
			if(treeTableHeadColDynType==null||treeTableHeadColDynType==undefined||treeTableHeadColDynType==''){
				$("input[name='treeTableHeadColDynType'][value='1']").iCheck('check');
				$("#treeTableDynHeadDataType").combobox("setValue",'1');
				$("#treeTableDynHeadDimsionNameDt").hide();
				$("#treeTableDynHeadDimsionNameDd").hide();
				$("#treeTableDynHeadYearStep").numberbox("setValue",'0');
				$("#treeTableDynHeadMonthStep").numberbox("setValue",'0');
				$("#treeTableDynHeadDayStep").numberbox("setValue",'0');
				$("#treeTableDynHeadPrefixStr").val('');
				$("#treeTableDynHeadSuffixStr").val('');
			}else if(treeTableHeadColDynType=='1'){
				$("input[name='treeTableHeadColDynType'][value='1']").iCheck('check');
				$("#treeTableDynHeadDimsionNameDt").hide();
				$("#treeTableDynHeadDimsionNameDd").hide();
				
				if(treeTableDynHeadDataType==null||treeTableDynHeadDataType==undefined||treeTableDynHeadDataType=='1'){
					$("#treeTableDynHeadDataType").combobox("setValue",'1');
					$("#treeTableDynHeadDayStepDt").show();
					$("#treeTableDynHeadDayStepDd").show();
					
				}else{
					$("#treeTableDynHeadDataType").combobox("setValue",treeTableDynHeadDataType);
					$("#treeTableDynHeadDayStepDt").hide();
					$("#treeTableDynHeadDayStepDd").hide();
				}
				
				if(treeTableDynHeadYearStep==null||treeTableDynHeadYearStep==undefined){
					$("#treeTableDynHeadYearStep").numberbox("setValue",'0');
				}else{
					$("#treeTableDynHeadYearStep").numberbox("setValue",treeTableDynHeadYearStep);
				}
				
				if(treeTableDynHeadMonthStep==null||treeTableDynHeadMonthStep==undefined){
					$("#treeTableDynHeadMonthStep").numberbox("setValue",'0');
				}else{
					$("#treeTableDynHeadMonthStep").numberbox("setValue",treeTableDynHeadMonthStep);
				}
				
				if(treeTableDynHeadDayStep==null||treeTableDynHeadDayStep==undefined){
					$("#treeTableDynHeadDayStep").numberbox("setValue",'0');
				}else{
					$("#treeTableDynHeadDayStep").numberbox("setValue",treeTableDynHeadDayStep);
				}
				if(treeTableDynHeadPrefixStr==null||treeTableDynHeadPrefixStr==undefined){
					$("#treeTableDynHeadPrefixStr").val('');
				}else{
					$("#treeTableDynHeadPrefixStr").val(treeTableDynHeadPrefixStr);
				}
				if(treeTableDynHeadSuffixStr==null||treeTableDynHeadSuffixStr==undefined){
					$("#treeTableDynHeadSuffixStr").val('');
				}else{
					$("#treeTableDynHeadSuffixStr").val(treeTableDynHeadSuffixStr);
				}
				
			}else if(treeTableHeadColDynType=='2'){
				$("input[name='treeTableHeadColDynType'][value='2']").iCheck('check');
				$("#treeTableDynHeadDimsionNameDt").show();
				$("#treeTableDynHeadDimsionNameDd").show();
				
				if(treeTableDynHeadDataType==null||treeTableDynHeadDataType==undefined||treeTableDynHeadDataType=='1'){
					$("#treeTableDynHeadDataType").combobox("setValue",'1');
					$("#treeTableDynHeadDayStepDt").show();
					$("#treeTableDynHeadDayStepDd").show();
					
				}else{
					$("#treeTableDynHeadDataType").combobox("setValue",treeTableDynHeadDataType);
					$("#treeTableDynHeadDayStepDt").hide();
					$("#treeTableDynHeadDayStepDd").hide();
				}
				
				if(treeTableDynHeadDimsionName==null||treeTableDynHeadDimsionName==undefined){
					$("#treeTableDynHeadDimsionName").combobox("setValue",'请选择');
				}else{
					$("#treeTableDynHeadDimsionName").combobox("setValue",treeTableDynHeadDimsionName);
				}
				
				if(treeTableDynHeadYearStep==null||treeTableDynHeadYearStep==undefined){
					$("#treeTableDynHeadYearStep").numberbox("setValue",'0');
				}else{
					$("#treeTableDynHeadYearStep").numberbox("setValue",treeTableDynHeadYearStep);
				}
				
				if(treeTableDynHeadMonthStep==null||treeTableDynHeadMonthStep==undefined){
					$("#treeTableDynHeadMonthStep").numberbox("setValue",'0');
				}else{
					$("#treeTableDynHeadMonthStep").numberbox("setValue",treeTableDynHeadMonthStep);
				}
				
				if(treeTableDynHeadDayStep==null||treeTableDynHeadDayStep==undefined){
					$("#treeTableDynHeadDayStep").numberbox("setValue",'0');
				}else{
					$("#treeTableDynHeadDayStep").numberbox("setValue",treeTableDynHeadDayStep);
				}
				if(treeTableDynHeadPrefixStr==null||treeTableDynHeadPrefixStr==undefined){
					$("#treeTableDynHeadPrefixStr").val('');
				}else{
					$("#treeTableDynHeadPrefixStr").val(treeTableDynHeadPrefixStr);
				}
				if(treeTableDynHeadSuffixStr==null||treeTableDynHeadSuffixStr==undefined){
					$("#treeTableDynHeadSuffixStr").val('');
				}else{
					$("#treeTableDynHeadSuffixStr").val(treeTableDynHeadSuffixStr);
				}
				
			}
			
		}else{//不同的动态类型
			/*
			$("input[name='treeTableHeadColDynType']").iCheck('uncheck');
			$("#treeTableDynHeadDataType").combobox("setValue",'请选择');
			$("#treeTableDynHeadDimsionNameDt").hide();
			$("#treeTableDynHeadDimsionNameDd").hide();
			$("#treeTableDynHeadYearStep").numberbox("setValue",'0');
			$("#treeTableDynHeadMonthStep").numberbox("setValue",'0');
			$("#treeTableDynHeadDayStep").numberbox("setValue",'0');
			*/
		
		}
	
	});
}



/** 描述：设置动态表头单元格的动态类型
	参数：
		value 值
*/
function treeTableHeadSetDynType(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var isSameDynTypeWithOldFlag=true;
	for(var i=0;i<$selectTds.length;i++){
		if($($selectTds[i]).attr("data-treeTableHeadColDynType")!=value){
			isSameDynTypeWithOldFlag=false;
		}
	}
	if(isSameDynTypeWithOldFlag){
		return;
	}
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.bindingtype=value;
		dynHeadInfo.datatype='1';
		dynHeadInfo.dimsionname='';
		dynHeadInfo.yearstep='0';
		dynHeadInfo.monthstep='0';
		dynHeadInfo.daystep='0';
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableHeadColDynType",value);
	}
	
	if(value=='1'){//常量
		$("#treeTableDynHeadDimsionNameDt").hide();
		$("#treeTableDynHeadDimsionNameDd").hide();
		$("#treeTableDynHeadDataType").combobox("setValue",'1');
		$("#treeTableDynHeadYearStep").numberbox("setValue",'0');
		$("#treeTableDynHeadMonthStep").numberbox("setValue",'0');
		$("#treeTableDynHeadDayStep").numberbox("setValue",'0');
		$("#treeTableDynHeadDayStepDt").show();
		$("#treeTableDynHeadDayStepDd").show();
		$("#treeTableDynHeadPrefixStr").val('');
		$("#treeTableDynHeadSuffixStr").val('');
	}else if(value=='2'){//查询条件
		$("#treeTableDynHeadDimsionNameDt").show();
		$("#treeTableDynHeadDimsionNameDd").show();
		$("#treeTableDynHeadDataType").combobox("setValue",'1');
		$("#treeTableDynHeadDimsionName").combobox("setValue",'请选择');
		$("#treeTableDynHeadYearStep").numberbox("setValue",'0');
		$("#treeTableDynHeadMonthStep").numberbox("setValue",'0');
		$("#treeTableDynHeadDayStep").numberbox("setValue",'0');
		$("#treeTableDynHeadDayStepDt").show();
		$("#treeTableDynHeadDayStepDd").show();
		$("#treeTableDynHeadPrefixStr").val('');
		$("#treeTableDynHeadSuffixStr").val('');
	}
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的数据类型
	参数：
		obj combobox数据对象
*/
function treeTableHeadSetDynDataType(obj){
	var value=obj.id;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.datatype=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadDataType",value);
		$($selectTds[a]).text("动态表头["+(value=='1'?'日':'月')+"]");
	}
	if(value=='1'){//日
		$("#treeTableDynHeadDayStepDt").show();
		$("#treeTableDynHeadDayStepDd").show();
	}else if(value=='2'){//月
		$("#treeTableDynHeadDayStepDt").hide();
		$("#treeTableDynHeadDayStepDd").hide();
	}
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
	
	
}


/** 描述：设置动态表头单元格的绑定查询条件
	参数：
		obj combobox数据对象
*/
function treeTableHeadSetDynDimsionName(obj){
	var value=obj.id;
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.dimsionname=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadDimsionName",value);
	}
	
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的年偏移量
	参数：
		value 值
*/
function treeTableHeadSetDynYearStep(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.yearstep=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadYearStep",value);
	}
	
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的月偏移量
	参数：
		value 值
*/
function treeTableHeadSetDynMonthStep(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.monthstep=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadMonthStep",value);
	}
	
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}
/** 描述：设置动态表头单元格的日偏移量
	参数：
		value 值
*/
function treeTableHeadSetDynDayStep(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.daystep=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadDayStep",value);
	}
	
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的前缀字符
	参数：
		value 值
*/
function treeTableHeadSetDynPrefixStr(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.prefixstr=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadPrefixStr",value);
	}
	
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的后缀字符
	参数：
		value 值
*/
function treeTableHeadSetDynSuffixStr(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var dynHeadInfo={};
		if($($selectTds[a]).attr("data-dynheadid")!=null&&$($selectTds[a]).attr("data-dynheadid")!=undefined){
			dynHeadInfo.id=$($selectTds[a]).attr("data-dynheadid");
		}else{
			dynHeadInfo.id=LayOutUtil.uuid();
		}
		dynHeadInfo.suffixstr=value;
		dynHeadList.push(dynHeadInfo);
		$($selectTds[a]).attr("data-treeTableDynHeadSuffixStr",value);
	}
	
	TreeTableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}




/** 描述：修改选中单元格的值
	参数：
		componentId 组件编号
		value 值
*/				
function treeTableHeadColValue(value){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected").eq(0);
	$selecteds.html(treeTableFilterHtml(value))
	var treeTableIsDrillFlag=false;//选中单元格是否是下钻表头
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		//$($selectTds[a]).attr("value",value);
		if($($selectTds[a]).attr("tdInd")=='1'){
			treeTableIsDrillFlag=true;
		}
	}
	if(treeTableIsDrillFlag){
		if($.trim($selecteds.html())==''){
			value='下钻名称';
			$selecteds.html('下钻名称')
		}
		TreeTableEvent.setTreeFieldTitle(reportId,containerId,componentId,value);
	}else{
		treeTableSetHeadui();
	}
}

/** 描述：点击合并按钮执行的方法
	参数：
*/
function treeTableHeadMergeCell(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if($("#treeTableHeadMergeCellButton_"+componentId).attr("disabled")=="disabled"||$("#treeTableHeadMergeCellButton_"+componentId).attr("disabled")==true){
		return false;
	}
	TreeTableEvent.setMergeCell(reportId,containerId,componentId);
}

/** 描述：点击拆分按钮执行的方法
	参数：
*/
function treeTableHeadSplitCell(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if($("#treeTableHeadSplitCellButton_"+componentId).attr("disabled")=="disabled"||$("#treeTableHeadSplitCellButton_"+componentId).attr("disabled")==true){
		return false;
	}
	TreeTableEvent.setSplitCell(reportId,containerId,componentId);
}

//------------------表头单元格结束-------------------------------------------//
//------------------数据单元格开始-------------------------------------------//

/** 描述：设置单元格宽度（与数据行相邻表头行中的单元格）
	参数：
		value 值
*/
function treeTableDataSetWidth(value){
	if(value==''){
		return false;
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(value==''){
		value='100';
		$("#treeTableDataWidth").numberbox("setValue",value);
	}
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	
	var temptreeTableCell=null;
	var temptreeTableCellInd=null;
	for(var a=0;a<$selectTds.length;a++){
		temptreeTableCellInd=$($selectTds[a]).attr("tdInd");
		temptreeTableCell=treeTableFindLastRowCellByTdInd(componentId,temptreeTableCellInd);
		$(temptreeTableCell).attr("width",value);
		$($selectTds[a]).attr("data-treeTableHeadWidth",value);
	}
	treeTableSetHeadui();
}

/** 描述：设置数据单元格的数据类型
	参数：
		value 值
*/
function treeTableDataSetType(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmttype=value;
		cellInfo.datadecimal='0';
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataType",value);
	}
	if(value!='common'){//非常规，即数值或百分数
		$("#treeTableDataNumberStep").numberbox("setValue",0);
		$("#treeTableDataNumberStep").numberbox("enable");
		$("#treeTableDataThousand").iCheck('uncheck');
		$("#treeTableDataThousand").iCheck('enable');
	}else{
		$("#treeTableDataNumberStep").numberbox("setValue",'');
		$("#treeTableDataNumberStep").numberbox("disable");
		$("#treeTableDataThousand").iCheck('uncheck');
		$("#treeTableDataThousand").iCheck('disable');
	}
	TreeTableEvent.setHeadDataType(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的小数位数（数值或百分数时设置）
	参数：
		value 值
*/
function treeTableDataSetNumberStep(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	if($.trim(value)==''){
		value='0';
		$("#treeTableDataNumberStep").numberbox("setValue",'0');
	}
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datadecimal=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataNumberStep",value);
	}
	TreeTableEvent.setHeadDataNumberStep(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 使用千分符（,）
	参数：
		
*/
function treeTableDataSetThousand(){
	var value='0';
	if($("#treeTableDataThousand").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtthousand=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataThousand",value);
	}
	TreeTableEvent.setHeadDataThousand(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 对齐方式
	参数：
		value 值
*/
function treeTableDataSetAlign(value){

	if(value=='left'){
		$("#treeTableDataAlignLeft").addClass("positionLeftSelect").removeClass("positionLeft");
		$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
		$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
	}else if(value=='center'){
		$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
		$("#treeTableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
		$("#treeTableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");

	}else if(value=='right'){
		$("#treeTableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
		$("#treeTableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
		$("#treeTableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
	}

	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtalign=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataAlign",value);
	}
	TreeTableEvent.setHeadDataAlign(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 行间相邻相同数据合并
	参数：
		
*/
function treeTableDataSetRowMerge(){
	var value='0';
	if($("#treeTableDataRowMerge").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtrowmerge=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataRowMerge",value);
	}
	TreeTableEvent.setHeadDataThousand(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 设置边界
	参数：
		
*/
function treeTableDataSetBorderSetFlag(){
	var value='0';
	
	if($("#treeTableDataBorderSetFlag").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtisbd=value;
		cellInfo.datafmtisbdvalue='0';
		cellInfo.datafmtbdup='#00ff00';
		cellInfo.datafmtbddown='#ff0000';
		cellInfo.datafmtisarrow='0';
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataBorderSetFlag",value);
	}
	$("#treeTableDataBorderValue").numberbox("setValue",'0');
	$("#treeTableDataBorderGtColor").spectrum("set","#00ff00");
	$("#treeTableDataBorderLtColor").spectrum("set","#ff0000");
	$("#treeTableDataBorderShowUpDown").iCheck('uncheck');
	if(value=='1'){
		$("#treeTableDataBorderValue").numberbox("enable");
		$("#treeTableDataBorderGtColor").spectrum("enable");
		$("#treeTableDataBorderLtColor").spectrum("enable");
		$("#treeTableDataBorderShowUpDown").iCheck('enable');
	}else{
		$("#treeTableDataBorderValue").numberbox("disable");
		$("#treeTableDataBorderGtColor").spectrum("disable");
		$("#treeTableDataBorderLtColor").spectrum("disable");
		$("#treeTableDataBorderShowUpDown").iCheck('disable');
	}
	
	
	TreeTableEvent.setHeadDataBorderSetFlag(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的边界值
	参数：
		value 值
*/
function treeTableDataSetBorderValue(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	if($.trim(value)==''){
		value='0';
		$("#treeTableDataBorderValue").numberbox("setValue",'0');
	}
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtisbdvalue=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataBorderValue",value);
	}
	TreeTableEvent.setHeadDataBorderValue(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的大于边界值的颜色
	参数：
		color 颜色对象
*/
function treeTableDataSetBorderGtColor(color){
	var value=color.toHexString();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtbdup=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataBorderGtColor",value);
	}
	TreeTableEvent.setHeadDataBorderGtColor(reportId,containerId,componentId,cellInfoList);
}
/** 描述：设置数据单元格的数据的小于边界值的颜色
	参数：
		color 颜色对象
*/
function treeTableDataSetBorderLtColor(color){
	var value=color.toHexString();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtbddown=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataBorderLtColor",value);
	}
	TreeTableEvent.setHeadDataBorderLtColor(reportId,containerId,componentId,cellInfoList);
}
/** 描述：设置数据单元格的数据的 行间相邻相同数据合并
	参数：
		
*/
function treeTableDataSetBorderShowUpDown(){
	var value='0';
	if($("#treeTableDataBorderShowUpDown").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtisarrow=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-treeTableDataBorderShowUpDown",value);
	}
	TreeTableEvent.setHeadDataBorderShowUpDown(reportId,containerId,componentId,cellInfoList);
}

/** 描述：点击数据单元格动作类型时执行的方法，“无”：清除动作并隐藏选项，“链接”：显示链接选项，“联动”：显示联动选项
	参数：
		value 值
*/
function treeTableDataSetEvent(value){
	if($("input[name='treeTableDataEvent']:checked").val()==value){
		return false;
	}
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var isHasSameEventJsonFlag=true;
	var treeTableEventSelectJsonStr='';
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		}
		if(treeTableEventSelectJsonStr!=$($selectTds[a]).attr("data-treeTableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	if(isHasSameEventJsonFlag){
		var eventStoreList=[];
		var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		for(var a=0;a<$selectTds.length;a++){
			var evetStoreInfo={};
			evetStoreInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
			evetStoreInfo.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
			eventStoreList.push(evetStoreInfo);
			if($($selectTds[a]).attr("data-treeTableDataEvent")!=value){
				$($selectTds[a]).removeAttr("data-treeTableEventSelectJson");
			}
			$($selectTds[a]).attr("data-treeTableDataEvent",value);
		}
		TreeTableEvent.setDataClearEvent(reportId,containerId,componentId,eventStoreList);
	}
	
	
	if(value=="none"){
		$("#treeTableDataEventLinkDiv").hide();
		$("#treeTableDataEventActiveDiv").hide();
	}else if(value=="link"){
		$("#treeTableDataEventLink").val("");
		$("#treeTableDataEventLinkShow").val("");
		$("#treeTableDataEventLinkParam").val("");
		$("#treeTableDataEventLinkParamShow").val("");
		$("#treeTableDataEventLinkDiv").show();
		$("#treeTableDataEventActiveDiv").hide();
		var $selectable= $("#selectable_"+componentId);
		var $selectTds=$selectable.find(".ui-selected");
		for(var a=0;a<$selectTds.length;a++){
			if($($selectTds[a]).attr("data-treeTableDataEvent")!=value){
				$($selectTds[a]).removeAttr("data-treeTableEventSelectJson");
			}
			$($selectTds[a]).attr("data-treeTableDataEvent",value);
		}
		
	}else if(value=='active'){
		treeTableDataEventSetActiveShow(reportId,containerId,componentId);
	}

}

/** 描述：点击数据单元格动作类型中的“联动”时，执行的显示部分（前台显示）的方法
	参数：
		reportId	报表id
		containerId 容器id
		componentId 组件id
*/
function treeTableDataEventSetActiveShow(reportId,containerId,componentId){
	var isHasSameEventJsonFlag=true;
	var treeTableEventSelectJsonStr='';
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		}
		if(treeTableEventSelectJsonStr!=$($selectTds[a]).attr("data-treeTableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	var eventList=[];
	if(isHasSameEventJsonFlag){
		if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
			treeTableEventSelectJsonStr='{}';
		}
		var treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
		
		if(treeTableEventSelectJson!=null){
			eventList=treeTableEventSelectJson["eventList"];
			if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
				eventList=[];
			}
		}
	}
	var divHtmlStr='';
	var containersJson=$.ajax({url: appBase+"/getAllContainersJsonX.e?report_id="+reportId,type:"POST",cache: false,async: false}).responseText;
	containersJson=$.parseJSON(containersJson);
	if(containersJson!=null&&containersJson!=undefined&&containersJson!='null'){
		for(var a=0;a<containersJson.length;a++){
			var tempContainerId=containersJson[a]["id"];
			var tempContainerType=containersJson[a]["type"];
			var tempContainerPop=containersJson[a]["pop"];
			var tempComponents=containersJson[a]["components"];
			if(tempComponents!=null&&tempComponents!=undefined&&tempComponents!='null'){
				var tempComponentList=tempComponents["componentList"];
				if(tempComponentList!=null&&tempComponentList!=undefined&&tempComponentList!='null'){
					for(var x=0;x<tempComponentList.length;x++){
						var tempComponentId=tempComponentList[x]["id"];
						var tempComponentType=tempComponentList[x]["type"];
						var tempComponentTitle=tempComponentList[x]["title"];
						if(tempComponentId==componentId||tempComponentType.indexOf("GRID")>-1||tempComponentType.indexOf("TABLE")>-1){
							continue;
						}
						if(tempContainerPop!=null&&tempContainerPop!=''&&tempContainerPop!='null'&&tempContainerPop==tempComponentId){
							continue;
						}
						var tempEventId=null;
						for(var w=0;w<eventList.length;w++){
							if(eventList[w]['source']==tempComponentId){
								tempEventId=eventList[w]["id"];
								break;
							}
						}
						var classStr='eventActive_'+tempComponentType.replace(/\d+/g,'');
						if(tempEventId==null||tempEventId==undefined||tempEventId=='null'){
							tempEventId=LayOutUtil.uuid();
							divHtmlStr+='<dt></dt>';
							divHtmlStr+='<dd>';
							divHtmlStr+='<p>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="checkbox" id="treeTableDataEventActiveCheckbox" name="treeTableDataEventActiveCheckbox" value="'+tempComponentId+'" eventId="'+tempEventId+'"/><strong class="eventActiveChartCommon '+classStr+'">'+tempComponentTitle+'</strong>';
							divHtmlStr+='</span>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="button" value="设置" class="eventActiveSetButtonClass" name="treeTableDataEventActiveButton" onclick="treeTableDataOpenEventActiveDialog(\''+tempComponentId+'\',\''+tempEventId+'\')" disabled="disabled"/>';
							divHtmlStr+='</span>';
							divHtmlStr+='</p>';
							divHtmlStr+='</dd>';
						}else{
							divHtmlStr+='<dt></dt>';
							divHtmlStr+='<dd>';
							divHtmlStr+='<p>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="checkbox" id="treeTableDataEventActiveCheckbox" name="treeTableDataEventActiveCheckbox" value="'+tempComponentId+'" eventId="'+tempEventId+'" checked="checked"/><strong class="eventActiveChartCommon '+classStr+'">'+tempComponentTitle+'</strong>';
							divHtmlStr+='</span>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="button" value="设置" class="eventActiveSetButtonClass" name="treeTableDataEventActiveButton" onclick="treeTableDataOpenEventActiveDialog(\''+tempComponentId+'\',\''+tempEventId+'\')" />';
							divHtmlStr+='</span>';
							divHtmlStr+='</p>';
							divHtmlStr+='</dd>';
						}
						
					}
				}
			}
		}
	}
	$("#treeTableDataEventActiveDiv>dl").html(divHtmlStr);
	
	//动作类型多选框
	$("input[name='treeTableDataEventActiveCheckbox']").iCheck({
	    labelHover : false,
	    cursor : true,
	    checkboxClass : 'icheckbox_square-blue',
	    radioClass : 'iradio_square-blue',
	    increaseArea : '20%'
	}).on('ifClicked', function(event){
	  	treeTableDataEventActiveSetCheck(this);
	});
	
	
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if($($selectTds[a]).attr("data-treeTableDataEvent")!="active"){
			$($selectTds[a]).removeAttr("data-treeTableEventSelectJson");
		}
		$($selectTds[a]).attr("data-treeTableDataEvent","active");
	}
	$("#treeTableDataEventLinkDiv").hide();
	$("#treeTableDataEventActiveDiv").show();
}

/** 描述：打开数据单元格的选择面页的面板
	参数：
	
*/
function treeTableDataOpenEventLinkDialog(){
	$("#treeTableDataEventLinkReportId").val("");
	$("#treeTableDataEventLinkReportName").val("");
	treeTableDataEventLinkReportQuery();
	$("#treeTableDataEventLinkDialog").dialog("open");
	hideToolsPanel();
}

/** 描述：数据单元格的选择面页的面板中“操作”列的格式化方法
	参数：
		value	当前列数据
		rowData	行数据
	
*/
function treeTableDataEventLinkReportFormatter(value,rowData){
	var commentStr = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="treeTableDataEventLinkReportCommit(\''+rowData.ID+'\',\''+rowData.NAME+'\',\''+rowData.URL+'\')">选择</a>';
	return  commentStr;
}

/** 描述：数据单元格的选择面页的面板中点击查询按钮执行的方法
	参数：
	
*/
function treeTableDataEventLinkReportQuery(){
	var info = {};
	info.treeTableDataEventLinkReportId = $("#treeTableDataEventLinkReportId").val();
	info.treeTableDataEventLinkReportName = $("#treeTableDataEventLinkReportName").val();
	info.treeTableDataEventLinkCurrentReportId=StoreData.xid;
	$("#treeTableDataEventLinkReportDatagrid").datagrid("load",info);
}

/** 描述：选择面页的面板中中点击完成按钮执行的方法
	参数：
		value	当前列数据
		rowData	行数据
	
*/
function treeTableDataEventLinkReportCommit(sourceId,sourceName,sourceUrl){
	var oldEventLink=$("#treeTableDataEventLink").val();
	$("#treeTableDataEventLinkShow").val(sourceName);
	$("#treeTableDataEventLink").val(sourceId);
	$('#treeTableDataEventLinkDialog').dialog('close');
	showToolsPanel();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var tempEventId='';
	for(var a=0;a<$selectTds.length;a++){
		var treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
			treeTableEventSelectJsonStr='{}';
		}
		var treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
		
		var eventStore={};
		eventStore.type='link';
		eventStore.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		eventStore.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		
		var eventList=[];
		var event={};
		event.id=LayOutUtil.uuid();
		event.source=sourceId;
		event.sourceShow=sourceName;
		var tempEventStore=treeTableEventSelectJson;
		if(tempEventStore["eventList"]!=null){
			var tempEventList=tempEventStore["eventList"];
			if(tempEventList.length>0){
				event.id=tempEventList[0]["id"];
				if(oldEventLink==sourceId){
					event.parameterList=tempEventList[0]["parameterList"];
					event.parameterShow=tempEventList[0]["parameterShow"];
					$("#treeTableDataEventLinkParamShow").val(event.parameterShow);
				}else{
					$("#treeTableDataEventLinkParamShow").val("");
				}
			}
		}
		
		eventList.push(event);
		eventStore.eventList=eventList;
		$($selectTds[a]).attr("data-treeTableEventSelectJson",$.toJSON(eventStore));
		eventStoreList.push(eventStore);
	}
	
	TreeTableEvent.setDataEventLink(reportId,containerId,componentId,eventStoreList);
}


/** 描述：数据单元格的联动的设置参数的面板的添加行
	参数：
*/
function treeTableDataOpenEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField){
	var insertHtmlStr='';
	insertHtmlStr+='<tr>';
	insertHtmlStr+='<td width="50%">参数名:&nbsp;<input type="text" id="'+name+'" name="treeTableDataEventLinkParamName" dimsionId="'+dimsionId+'" style="width:120px;" value="" readonly="readonly"></td>';
	insertHtmlStr+='<td>对应数据列:&nbsp;<input name="treeTableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>';
	insertHtmlStr+='</tr>';
	var $row = $(insertHtmlStr);
	$row.appendTo($("#treeTableDataEventLinkParamtreeTable"));
	var treeTableDataEventLinkParamName=$row.find("input[name='treeTableDataEventLinkParamName']");
	treeTableDataEventLinkParamName.val(nameDesc);
	var treeTableDataEventLinkParamValue=$row.find("input[name='treeTableDataEventLinkParamValue']");
	treeTableDataEventLinkParamValue.combobox({   
	    data:valueData,   
	    valueField:valueField,   
	    textField:TextField,
	    editreeTable:false,
	    value:value
	});  
	
}

/** 描述：数据单元格的链接的设置参数的面板的完成按钮的执行方法
	参数：
*/
function treeTableDataOpenEventLinkParamCommit(){
	var treeTableDataEventLinkParamtreeTableTr=$("#treeTableDataEventLinkParamtreeTable tr");
	var treeTableDataEventLinkParamShowStr='';
	var parameterList=[];
	for(var a=0;a<treeTableDataEventLinkParamtreeTableTr.length;a++){
		var nameInput=$(treeTableDataEventLinkParamtreeTableTr[a]).find("input[name='treeTableDataEventLinkParamName']");
		var valueInput=$(treeTableDataEventLinkParamtreeTableTr[a]).find("input[name='treeTableDataEventLinkParamValue']");
		var value=null;
		if(valueInput!=undefined&&valueInput!=null&&valueInput.size()==1){
			value=valueInput.combobox().combobox("getValue");
		}
		if(value!=undefined&&value!=null&&value!=''&&value!='请选择'){
			if(nameInput!=undefined&&nameInput!=null&&nameInput.size()==1){
				var parameter={};
				parameter["dimsionid"]=nameInput.attr("dimsionId");
				parameter["name"]=nameInput.attr("id");
				parameter["value"]=value;
				parameterList.push(parameter);
				treeTableDataEventLinkParamShowStr+=nameInput.attr("value")+'='+value+';';
			}
		}
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
			treeTableEventSelectJsonStr='{}';
		}
		var treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
		if(treeTableEventSelectJson!=null){
			var eventList=treeTableEventSelectJson["eventList"];
			if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
				var event=eventList[0];
				if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'){
					event.parameterList=parameterList;
					event.parameterShow=treeTableDataEventLinkParamShowStr;
				}
			}
		}
		$($selectTds[a]).attr("data-treeTableDataEvent",'link');
		$($selectTds[a]).attr("data-treeTableEventSelectJson",$.toJSON(treeTableEventSelectJson));
		eventStoreList.push(treeTableEventSelectJson);
	}
	
	TreeTableEvent.setDataEventLinkParameter(reportId,containerId,componentId,eventStoreList);
	$("#treeTableDataEventLinkParamShow").val(treeTableDataEventLinkParamShowStr);
	$("#treeTableDataEventLinkParamDialog").dialog("close");
	showToolsPanel();
}


/** 描述：设置数据单元格的联动面板中的组件是否联动
	参数：
	
*/
function treeTableDataEventActiveSetCheck(obj){
	var eventId=$(obj).attr("eventId");
	var eventSource=$(obj).attr("value");
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var isHasSameEventJsonFlag=true;
	var treeTableEventSelectJsonStr='';
	var treeTableEventSelectJson=null;
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		}
		if(treeTableEventSelectJsonStr!=$($selectTds[a]).attr("data-treeTableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	var eventList=null;
	if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
		treeTableEventSelectJsonStr='{}';
	}
	treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
	eventList=treeTableEventSelectJson["eventList"];
	if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
		eventList=[];
		treeTableEventSelectJson.eventList=eventList;
	}
	var eventInfo=null;
	var eventInfoIndex=0;
	for(var i=0;i<eventList.length;i++){
		if(eventList[i]["id"]==eventId){
			eventInfo=eventList[i];
			eventInfoIndex=i;
			break;
		}
	}
	if(eventInfo==undefined||eventInfo==null||eventInfo==''||eventInfo=='null'){
		eventInfo={};
		eventInfo.id=eventId;
		eventInfo.source=eventSource;
		eventInfoIndex=eventList.length;
		eventList.push(eventInfo);
	}
	
	if($(obj).attr("checked")!='checked'){
		$(obj).parent().parent().parent().find("input[name='treeTableDataEventActiveButton']").removeAttr("disabled");
	}else{
		eventInfo={};
		eventList[eventInfoIndex]=eventInfo;
		$(obj).parent().parent().parent().find("input[name='treeTableDataEventActiveButton']").attr("disabled","disabled");
	}
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var eventStoreList=[];
	for(var a=0;a<$selectTds.length;a++){
		var tempEventStore=jQuery.extend(true, {}, treeTableEventSelectJson); 
		tempEventStore.type='cas';
		tempEventStore.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		tempEventStore.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		eventStoreList.push(tempEventStore);
		$($selectTds[a]).attr("data-treeTableEventSelectJson",$.toJSON(treeTableEventSelectJson));
	}
	TreeTableEvent.setDataEventActive(reportId,containerId,componentId,eventStoreList);
	
	
	

}


/** 描述：数据单元格的联动的设置参数的面板的添加行
	参数：
*/
function treeTableDataOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField){
	var insertHtmlStr='';
	insertHtmlStr+='<tr>';
	insertHtmlStr+='<td width="50%">参数名:&nbsp;<input type="text" id="'+name+'" name="treeTableDataEventActiveParamName" dimsionId="'+dimsionId+'" style="width:120px;" value="" readonly="readonly"></td>';
	insertHtmlStr+='<td>对应数据列:&nbsp;<input name="treeTableDataEventActiveParamValue" value="请选择"  style="width:120px"></td>';
	insertHtmlStr+='</tr>';
	var $row = $(insertHtmlStr);
	$row.appendTo($("#treeTableDataEventActiveParamtreeTable"));
	var treeTableDataEventActiveParamName=$row.find("input[name='treeTableDataEventActiveParamName']");
	treeTableDataEventActiveParamName.val(nameDesc);
	var treeTableDataEventActiveParamValue=$row.find("input[name='treeTableDataEventActiveParamValue']");
	treeTableDataEventActiveParamValue.combobox({   
	    data:valueData,   
	    valueField:valueField,   
	    textField:TextField,
	    editreeTable:false,
	    value:value
	});  
}

/** 描述：数据单元格的联动的设置参数的面板的完成按钮执行的方法
	参数：
*/
function treeTableDataOpenEventActiveParamCommit(){
	var treeTableDataEventActiveParamtreeTableTr=$("#treeTableDataEventActiveParamtreeTable tr");
	var parameterList=[];
	for(var a=0;a<treeTableDataEventActiveParamtreeTableTr.length;a++){
		var nameInput=$(treeTableDataEventActiveParamtreeTableTr[a]).find("input[name='treeTableDataEventActiveParamName']");
		var valueInput=$(treeTableDataEventActiveParamtreeTableTr[a]).find("input[name='treeTableDataEventActiveParamValue']");
		var value=null;
		if(valueInput!=undefined&&valueInput!=null&&valueInput.size()==1){
			value=valueInput.combobox().combobox("getValue");
		}
		if(value!=undefined&&value!=null&&value!=''&&value!='请选择'){
			if(nameInput!=undefined&&nameInput!=null&&nameInput.size()==1){
				var parameter={};
				parameter["dimsionid"]=nameInput.attr("dimsionId");
				parameter["name"]=nameInput.attr("id");
				parameter["value"]=value;
				parameterList.push(parameter);
			}
		}
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var treeTableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var treeTableEventSelectJsonStr=$($selectTds[a]).attr("data-treeTableEventSelectJson");
		if(treeTableEventSelectJsonStr==undefined||treeTableEventSelectJsonStr==''||treeTableEventSelectJsonStr==null||treeTableEventSelectJsonStr=='null'){
			treeTableEventSelectJsonStr='{}';
		}
		var treeTableEventSelectJson=$.parseJSON(treeTableEventSelectJsonStr);
		if(treeTableEventSelectJson==null){
			treeTableEventSelectJson={};
		}
		treeTableEventSelectJson.type='cas';
		treeTableEventSelectJson.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		treeTableEventSelectJson.tablecolcode=$(treeTableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		var eventList=treeTableEventSelectJson["eventList"];
		if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
			eventList=[];
		}
		treeTableEventSelectJson.eventList=eventList;
		var event=null;
		for(var x=0;x<eventList.length;x++){
			if(eventList[x]["id"]==treeTableCurrentEvnetEventId&&eventList[x]["source"]==treeTableCurrentEvnetCompenentId){
				event=eventList[x];
				break;
			}
		}
		if(event==null){
			event={};
			event["id"]=treeTableCurrentEvnetEventId;
			event["source"]=treeTableCurrentEvnetCompenentId;
			eventList.push(event);
		}
		
		event.parameterList=parameterList;
		
		$($selectTds[a]).attr("data-treeTableEventSelectJson",$.toJSON(treeTableEventSelectJson));
		eventStoreList.push(treeTableEventSelectJson);
	}
	
	TreeTableEvent.setDataEventActiveParameter(reportId,containerId,componentId,eventStoreList);
	$("#treeTableDataEventActiveParamDialog").dialog("close");
	showToolsPanel();
	
}


//------------------数据单元格结束-------------------------------------------//

var tableCurrentEvnetCompenentId='';
var tableCurrentEvnetEventId='';
var tableSortStartArray=[];
var tableSortStartTypeArray=[];
var tableSortEndArray=[];
var tableHeadCellAttrNameArray=["data-tableHeadWidth","data-tableHeadAlign","data-tableHeadEvent","data-tableEventSelectJson"];
var tableDataCellAttrNameArray=["data-tableDataTdType","data-tableDataNumberStep","data-tableDataThousand","data-tableDataType",
				"data-tableDataAlign","data-tableDataRowMerge","data-tableDataBorderSetFlag","data-tableDataBorderValue",
				"data-tableDataBorderGtColor","data-tableDataBorderLtColor","data-tableDataBorderShowUpDown",
				"data-tableDataEvent","data-tableEventSelectJson","width"];


//------------------表格整体开始-------------------------------------------//
/** 描述：合并单元格
	参数：
		componentId 组件编号
*/
function tableMergeCell(componentId){
	var selectedsText='';//所有选中单元格文本
	var $selecteds=$("#selectable_"+componentId).find('.ui-selected');
	var $selectTable = $selecteds.parent().parent().parent();
	var isHead =null;
	var continueFlag=true;
	var maxRowNum=1;//选中单元格最大行
	var minRowNum=1;//选中单元格最小行
	var maxColNum=1;//选中单元格最大列
	var minColNum=1;//选中单元格最小列
	var isRightSelect=true;//选择正确 标识
	var headRowBorder=$selectTable.find("tr").length-1; //与数据单元格相邻的行号
	var colSpanNum=1;//列合并值
	var rowSpanNum=1;//行合并值
	if($selecteds.size()==0){
		return false;
	}
	if(!continueFlag){
		$.messager.alert("基础表格","选中的单元格不能进行列合并操作！","error");
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
		$.messager.alert("基础表格","选中的单元格不属于同类！","error");
		return false;
	}
	/*
	alert("maxRowNum:"+maxRowNum);
	alert("minRowNum:"+minRowNum);
	alert("maxColNum:"+maxColNum);
	alert("minColNum:"+minColNum);
	*/
	if(headRowBorder>=minRowNum&&headRowBorder<=maxRowNum&&maxColNum!=minColNum){
		$.messager.alert("基础表格","与数据单元格相邻的表头单元格不允许合并！","error");
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
		$.messager.alert("基础表格","选中的单元格不规范，不能进行列合并操作！","error");
		return false;
	}

	$selecteds.each(function (iii,eee) {
		if(iii==0){//第一个单元格
			$(eee).attr("rowspan",(maxRowNum-minRowNum+1));//设置行合并
			$(eee).attr("colspan",(maxColNum-minColNum+1));//设置列合并
			$(eee).text(selectedsText);
			
			var curRowNum = parseInt($(eee).attr("istt").substr(2));
			var curColNum = parseInt($(eee).attr("tdInd"))-1;
			var cell = tableGetCellByRowCol("#selectable_"+componentId, curRowNum, curColNum);
			if(cell!=null && $(cell).attr('ishead')==undefined && parseInt($(eee).attr("rowspan"))>1){
				$(eee).attr("field", $(cell).attr('data-data_col'));
			}
		}else{
			$(eee).remove();//清除多余单元格
		}
	});
	return true;
	
}

function tableGetCellByRowCol(tableId, rowNum, colNum){
	var cell = null;
	$(tableId).find("tbody tr").each(function(i ,r){
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
function tableSplitCell(componentId){
	var $selecteds=$("#selectable_"+componentId).find('.ui-selected').eq(0);//选中的第一个单元格
	var selectedsText=$selecteds.text();
	var selectedsIstt=$($selecteds).attr("istt");
	var $selectTable = $selecteds.parent().parent().parent(); //表格对象
	var table_select = document.getElementById('selectable_'+componentId);//表格的dom对象，为下面取列个数用的
	var table_col_length=table_select.rows[0].cells.length;//表格列个数
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
	
	if(table_col_length==colSpanNum+1){//选中单元格所在行只有选中列一列
		table_split_part($selectTable,colSpanNum);
	}else{
		if(colSpanNum!=1||rowSpanNum!=1){//有合并行或合并列
			$selectTable.find("tbody tr").each(function(i,e){
				lastColResult=0;
				rowCellNum=e.cells.length;//当前行列数量
				if(i>=(rowNum-2)&&i<(rowNum+rowSpanNum-2)){//遍历行行数在选中单元格范围内
					if(rowCellNum==1)//遍历行只有一个单元格（序号单元格）
						table_split_row_part($(e),colSpanNum,colNum);
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
function table_split_row_part($tr,colSpanNum,colNum){
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
		$selectTable 所在表格
		colSpanNum 合并列值
*/
function table_split_part($selectTable,colSpanNum){
	$selectTable.find('tbody tr').each(function(tr_index,tr_dom){
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
function tableInsertColumn(componentId,position){
		/*初始化列序号数组*/
		var th_show = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
		for(var th_i=0;th_i<26;th_i++){
			for(var th_j=0;th_j<26;th_j++){
				th_show[(th_i+1)*26+th_j]=th_show[th_i]+th_show[th_j];
			}
		}
		
		
		var $selecteds=$("#selectable_"+componentId).find('.ui-selected').eq(0);//选中单元格
		var $selectTable = $selecteds.parent().parent().parent();//选中表格
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
			$.messager.alert("基础表格","选中单元格所在列有列合并单元格，不能插入列，请拆分后再操作！","error");
			return false;
		}
		$selectTable.find("tr").each(function(i1,e1){
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
			$.messager.alert("基础表格","选中单元格所在列有列合并单元格，不能插入列，请拆分后再操作！","error");
			return false;
		}
		
		$selectTable.find("tr").each(function (index, domEle) {
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
		$selectTable.find("tr").each(function(i2,e2){
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
function tableInsertRow(componentId,position){
	var $selecteds=$("#selectable_"+componentId).find('.ui-selected').eq(0);
	var $selectTable = $selecteds.parent().parent().parent();
	var $tr = $selecteds.parent();
	var continueFlag=true;
	var $selectTrIsttNum=0;
	var $rowSpan=1;
	$selectTrIsttNum=parseInt($selecteds.attr('istt').substr(2));
	if($selecteds.attr("rowspan")!=undefined&&$selecteds.attr("rowspan")!='1'){
		$.messager.alert("基础表格","选中行有行合并单元格，不能插入行，请拆分后再操作！","error");
		return false;
	}
	 /*遍历表格所有单元格，检查是否有合并单元格，如果有，设置标志continueFla为false*/
	 $selectTable.find("tr").each(function(index_tr,domEle_tr){
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
	 	$.messager.alert("基础表格","选中行有行合并单元格，不能插入行，请拆分后再操作！","error");
	 	return false;
	 }
	
	var $tempTr=null;
	var isHead = $selecteds.attr("ishead");
	$selectTable.find("tr").each(function(i,v){
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
	$selectTable.find("tr").each(function(index,domEle){
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
function tableDeleteColumn(componentId) {
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected");
	var $selectTable = $selecteds.eq(0).parent().parent().parent();
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
		$.messager.alert("基础表格","请选择至少一个单元格！","error");
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
		
		
		if((selectCol.length+1)==$selectTable.find("tr").eq(0).find("th").length){
			$.messager.alert("基础表格","删除后将没有单元格，不允许删除！","error");
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
			
			if($selectTable.find("tr").eq(0).find("th").length==2){
				$.messager.alert("基础表格","最后一列，不允许删除！","error");
				flag1=false;
				return false;
			}
			
			var select_tdInd=parseInt($(bb).attr('tdInd'));
			var tempTdInd=0;
			var tempColSpan=1;
			var continueFlag=true;
			if($(bb).attr('colspan')!=undefined&&$(bb).attr('colspan')!='1'){
				$.messager.alert("基础表格","<br/>"+th_show[(parseInt($(bb).attr("tdInd"))-1)]+"列有列合并单元格，不能删除！","error");
				flag2=false;
				return false;
			}
			
			/*选中列是否有列合并*/
			$selectTable.find("tr").each(function(i1,e1){
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
				$.messager.alert("基础表格","<br/>"+th_show[(parseInt($(bb).attr("tdInd"))-1)]+"列有列合并单元格，不能删除！","error");
				flag3=false;
				return false;
			}else{
				/*删除操作*/
				$selectTable.find("tr").each(function(i2,e2){
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
			$selectTable.find("tr:first").each(function(i3,e3){
				$(this).find("th").each(function(index3,domEle3){
					if(index3>0&&index3<=selectCol.length){
						$(domEle3).remove();
					}
				
				});
			});
	
			/*重置字母*/
			$selectTable.find("tr").each(function(i,e){
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
			$selectTable.find("tr").each(function(i4,e4){
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
function tableDeleteRow(componentId) {
	var table = document.getElementById("selectable_"+componentId);
	var table_length = table.rows.length;
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected");
	var $selectTable = $selecteds.parent().parent();
	var $selectedTr =null;
	var tr_index = null;
	var $selectTrIsttNum=0;
	var $rowSpan=1;
	var continueFlag=true;
	var hasDeleteNum=0;
	if($selecteds.length==0){
		$.messager.alert("基础表格","请选择表格！","error");
		return false;
	}else{
		$selecteds.each(function(selectedIndex,selectedTdEle){
		
			table_length=table_length-hasDeleteNum;
	
			$selectedTr=$(selectedTdEle).parent();
			tr_index=$selectTable.children().index($selectedTr)+1;
			if((table_length==3&&tr_index==(table_length-2))||tr_index==(table_length-1)){//是否最后一行
				$.messager.alert("基础表格","此行不能删除，表格里至少保留一行数据和一行表头！","error");
				return false;
			}else{
				 
				// $(selectedTdEle).parent().remove();
				 $selectTrIsttNum=parseInt($(selectedTdEle).attr('istt').substr(2));
				 //alert("-"+$(selectedTdEle).attr("rowspan")+"-");
				 if($(selectedTdEle).attr("rowspan")!=undefined&&$(selectedTdEle).attr("rowspan")!='1'){
				 	$.messager.alert("基础表格","<br/>第"+(parseInt($(selectedTdEle).attr("istt").substr(2))-1)+"行有行合并单元格，不能删除！","error");
				 	return false;
				 }
				 /*判断是否有列合并*/
				 $selectTable.find("tr").each(function(index_tr,domEle_tr){
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
				 	$.messager.alert("基础表格","<br/>第"+(parseInt($(selectedTdEle).attr("istt").substr(2))-1)+"行有行合并单元格，不能删除！","error");
				 	return false;
				 }
				 /*如果是表头的最后一行，判断它的上一行是否有列合并，如果有，不允许删除，与数据行相邻的表头行不可以有列合并*/
				 if($selectTrIsttNum==(table_length-1)){
					 continueFlag=true;
					 $selectTable.find("tr").each(function(index_tr1,domEle_tr1){
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
					 	$.messager.alert("基础表格","<br/>第"+(parseInt($(selectedTdEle).attr("istt").substr(2))-1)+"行的上一行有列合并单元格，不能删除！","error");
					 	return false;
					 }
				 
				 
				 
				 }
				 
				 
			 	$(selectedTdEle).parent().remove();
			 	hasDeleteNum=hasDeleteNum+1;
			 	$selectTable.find("tr").each(function(index,domEle){
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
function tableFilterHtml(htmlCode){
	    return htmlCode.replace(/</g,"&lt;").replace(/>/g,"&gt;");//替换“<”和“>”
}
		
/** 描述：将"&lt;"用"<"替换、"&gt;"用">"替换
	参数：
		htmlCode html字符串
*/			
function tableRestoreHtml(htmlCode){
	return htmlCode.replace(/&lt;/g,"<").replace(/&gt;/g,">");//还原“<”和“>”
}

/** 描述：将rgb(0,0,0)转换为#000000
	参数：
		rgb rgb颜色
*/	
function tableRgb2hex(rgb) {
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
function tableMoveCell(componentId,rowCode,colCode,insertColCode){
	if(rowCode<=1){
		$.messager.alert("基础表格","请设置rowcode参数大于1!","error");
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
	var currentLastRowCell=$(tableFindLastRowCellByTdInd(componentId,currentSelectCell.attr("tdInd"))).clone();
	if(insertColCodeNum>colCodeNum){
		for(var b=1;b<=lastTrTd.length;b++){
			tempColNum=parseInt($(lastTrTd[b-1]).attr("tdInd"));
			if(tempColNum>=colCodeNum&&tempColNum<insertColCodeNum){
				tableMoveAllCellAttr($(lastTrTd[b]),$(lastTrTd[b-1]),'0');
				tempOldLastRowCell=tableFindLastRowCellByTdInd(componentId,$(lastTrTd[b]).attr("tdInd"));
				tempNewLastRowCell=tableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				tableMoveAllCellAttr($(tempOldLastRowCell),$(tempNewLastRowCell),'1');
			}else if(tempColNum==insertColCodeNum){
				tableMoveAllCellAttr($(currentSelectCell),$(lastTrTd[b-1]),'0');
				tempNewLastRowCell=tableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				tableMoveAllCellAttr($(currentLastRowCell),$(tempNewLastRowCell),'1');
			}
		}
	}else if(insertColCodeNum<colCodeNum){
		for(var b=lastTrTd.length;b>=1;b--){
			tempColNum=parseInt($(lastTrTd[b-1]).attr("tdInd"));
			if(tempColNum>insertColCodeNum&&tempColNum<=colCodeNum){
				tableMoveAllCellAttr($(lastTrTd[b-2]),$(lastTrTd[b-1]),'0')
				tempOldLastRowCell=tableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-2]).attr("tdInd"));
				tempNewLastRowCell=tableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				tableMoveAllCellAttr($(tempOldLastRowCell),$(tempNewLastRowCell),'1');
				
			}else if(tempColNum==insertColCodeNum){
				tableMoveAllCellAttr($(currentSelectCell),$(lastTrTd[b-1]),'0');
				tempNewLastRowCell=tableFindLastRowCellByTdInd(componentId,$(lastTrTd[b-1]).attr("tdInd"));
				tableMoveAllCellAttr($(currentLastRowCell),$(tempNewLastRowCell),'1');
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

function tableMoveAllCellAttr(oldCell,newCell,isHead){
	var keyArray=[];
	if(isHead=='1'){
		keyArray=tableHeadCellAttrNameArray;
	}else{
		keyArray=tableDataCellAttrNameArray;
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
function tableClearCell(componentId,rowCode,colCode){
	if(rowCode<=1){
		$.messager.alert("基础表格","请设置rowcode参数大于1!","error");
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
		keyArray=tableHeadCellAttrNameArray;
	}else{
		keyArray=tableDataCellAttrNameArray;
	}
	var tempKeyValue='';
	for(var a=0;a<keyArray.length;a++){
		currentSelectCell.removeAttr(keyArray[a]);
	}
	currentSelectCell.text("");
}



function tableFindLastRowCellByTdInd(componentId,tdInd){
	var resultCell=null;
	var tableTrs=$("#selectable_"+componentId+" tr");
	for(var a=tableTrs.length-2;a>=0;a--){
		if($(tableTrs[a]).find("td[tdInd='"+tdInd+"']").size()>0){
			resultCell=$(tableTrs[a]).find("td[tdInd='"+tdInd+"']")[0];
			break;
		}
	}
	return resultCell;
}
/**	描述：切换布局方式 
	参数：
		lType 布局方式,1:电脑、2:手机
*/
function tableSwitchLType(lType){
	if(lType=='1'){
		if($("#tablePagiDt").size()>0){
			$("#tablePagiDt").show();//显示分页的dt标签
		}
		if($("#tablePagiDd").size()>0){
			$("#tablePagiDd").show();//显示分页的dd标签
		}
		if($("#tableExportDt").size()>0){
			$("#tableExportDt").show();//显示导出的dt标签
		}
		if($("#tableExportDd").size()>0){
			$("#tableExportDd").show();//显示导出的dd标签
		}
		if($("#tableDataRowMergePTag").size()>0){
			$("#tableDataRowMergePTag").show();//显示行间相邻相同数据合并
		}
		if($("#tableDataEventDiv").size()>0){
			$("#tableDataEventDiv").show();//显示动作
		}
	
	}else if(lType=='2'){
		if($("#tablePagiDt").size()>0){
			$("#tablePagiDt").hide();//隐藏分页的dt标签
		}
		if($("#tablePagiDd").size()>0){
			$("#tablePagiDd").hide();//隐藏分页的dd标签
		}
		if($("#tableExportDt").size()>0){
			$("#tableExportDt").hide();//隐藏导出的dt标签
		}
		if($("#tableExportDd").size()>0){
			$("#tableExportDd").hide();//隐藏导出的dd标签
		}
		if($("#tableDataRowMergePTag").size()>0){
			$("#tableDataRowMergePTag").hide();//隐藏行间相邻相同数据合并
		}
		if($("#tableDataEventDiv").size()>0){
			$("#tableDataEventDiv").hide();//隐藏动作
		}
		
	}
	
}
/* 保存页头源码 */
function tableSetHeadui(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var headui=$('#selectable_' + componentId).html();
	TableEvent.setHeadui(reportId,containerId,componentId,headui);
}

/** 描述：还原按钮点击事件（）
	参数：
		data json数据

*/
function tableComponentEditButton(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	tableComponentEdit(reportId,containerId,componentId);
}

/** 描述：表格整体属性还原方法
	参数：
		reportId		报表id
		containerId		容器id
		componentId		组件id
*/
function tableComponentEdit(containerId,componentId){
	var reportId=StoreData.xid;
	//StoreData.xid=reportId;
	StoreData.curContainerId=containerId;
	StoreData.curComponentId=componentId;
	TableEvent.getComponentJsonData(reportId,containerId,componentId);
}


//------------------表格整体结束-------------------------------------------//
//------------------表头单元格开始-------------------------------------------//
/** 描述：修改选中单元格的类型（动态、静态）
	参数：
		componentId 组件编号
		value 值
*/	
function tableHeadColTypeValue(value){
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
				$($selecteds[a]).attr("data-tableHeadColDynType",'1');
				$($selecteds[a]).attr("data-tableDynHeadDataType",'1');
				$($selecteds[a]).attr("data-tableDynHeadYearStep",'0');
				$($selecteds[a]).attr("data-tableDynHeadMonthStep",'0');
				$($selecteds[a]).attr("data-tableDynHeadDayStep",'0');
				$($selecteds[a]).attr("data-tableDynHeadPrefixStr",'');
				$($selecteds[a]).attr("data-tableDynHeadSuffixStr",'');
				var dynHeadInfo={};
				dynHeadInfo.id=dynHeadId;
				dynHeadList.push(dynHeadInfo);
				textValue="动态表头[日]";
				$($selecteds[a]).attr("data-tableHeadValueBeforeDyn",$($selecteds[a]).text());
				$($selecteds[a]).text(textValue);
				$("#tableHeadColValue_"+componentId).val(textValue);
				$("#tableHeadColValue_"+componentId).attr("disabled","disabled");
				$("#tableHeadColValue_"+componentId).blur();
			}
			/*设置合并、拆分按钮 start*/
			$("#tableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
			$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
			$("#tableHeadSplitCellButton_"+componentId).attr("disabled","disabled");
			$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtnDisable").removeClass("splitBtn");
			/*设置合并、拆分按钮 end*/
			
			TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",true);
			
		}else if(value==1&&$($selecteds[0]).attr("data-dynheadid")!=undefined&&$($selecteds[0]).attr("data-dynheadid")!=null){//当前为动态并且要设置成静态
			for(var a=0;a<$selecteds.length;a++){
				var dynHeadId=$($selecteds[a]).attr("data-dynheadid");//data-dynheadid
				$($selecteds[a]).removeAttr("data-dynheadid");
				$($selecteds[a]).removeAttr("data-tableHeadColDynType");
				$($selecteds[a]).removeAttr("data-tableDynHeadDataType");
				$($selecteds[a]).removeAttr("data-tableDynHeadDimsionName");
				$($selecteds[a]).removeAttr("data-tableDynHeadYearStep");
				$($selecteds[a]).removeAttr("data-tableDynHeadMonthStep");
				$($selecteds[a]).removeAttr("data-tableDynHeadDayStep");
				$($selecteds[a]).removeAttr("data-tableDynHeadPrefixStr");
				$($selecteds[a]).removeAttr("data-tableDynHeadSuffixStr");
				var dynHeadInfo={};
				dynHeadInfo.id=dynHeadId;
				dynHeadList.push(dynHeadInfo);
				textValue=""
				if($($selecteds[a]).attr("data-tableHeadValueBeforeDyn")!=undefined&&$($selecteds[a]).attr("data-tableHeadValueBeforeDyn")!=null){
					textValue=$($selecteds[a]).attr("data-tableHeadValueBeforeDyn");
					$($selecteds[a]).removeAttr("data-tableHeadValueBeforeDyn");
				}
				$($selecteds[a]).text(textValue);
				$("#tableHeadColValue_"+componentId).val(textValue);
				$("#tableHeadColValue_"+componentId).removeAttr("disabled");
				$("#tableHeadColValue_"+componentId).focus();
			}
			if($selecteds.size()==1){//
				if(($($selecteds[0]).attr("colspan")!=null&&$($selecteds[0]).attr("colspan")!=undefined&&$($selecteds[0]).attr("colspan")!=''&&parseInt($($selecteds[0]).attr("colspan"))>1)
					||($($selecteds[0]).attr("rowspan")!=null&&$($selecteds[0]).attr("rowspan")!=undefined&&$($selecteds[0]).attr("rowspan")!=''&&parseInt($($selecteds[0]).attr("rowspan"))>1)){
					/*设置合并不可用、拆分按钮可用 start*/
					$("#tableHeadMergeCellButton_"+componentId).attr("disabled","disabled");
					$("#tableHeadMergeCellButton_"+componentId).addClass("margerBtnDisable").removeClass("margerBtn");
					$("#tableHeadSplitCellButton_"+componentId).removeAttr("disabled");
					$("#tableHeadSplitCellButton_"+componentId).addClass("splitBtn").removeClass("splitBtnDisable");
					/*设置合并不可用、拆分按钮可用 end*/
					
				}
			}
			TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"remove",false);
		}
		
	}else{
		$.messager.alert("基础表格","请选择要设置的表头单元格！","error");
	}
}

/** 描述：显示动态表头单元格的设置窗口并还原已设置的属性
	参数：
		dynheadid 动态属性id
*/	
function tableHeadColOpenProperties(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	setProPageTitle("组件属性设置");
	$("#propertiesPage").load(appBase+"/pages/xbuilder/component/datagrid/PropertiesDynHead.jsp?t="+(new Date().getTime()),function(){
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
		$("#tableDynHeadDimsionName").combobox("loadData",dimsionData);
		var $selectable= $("#selectable_"+componentId);
		var $selectTds=$selectable.find(".ui-selected");
		var tableHeadColDynType='';//是否是动态表头
		var tableHeadColDynTypeSameFlag=true;
		for(var a=0;a<$selectTds.length;a++){
			if(a==0){//初始化临时变量
				tableHeadColDynType=$($selectTds[a]).attr("data-tableHeadColDynType");
			}
			if(tableHeadColDynType!=$($selectTds[a]).attr("data-tableHeadColDynType")){
				tableHeadColDynTypeSameFlag=false;
			}
			
		}
		if(tableHeadColDynTypeSameFlag){//有相同的动态类型
			var tableDynHeadDataType=$($selectTds[0]).attr("data-tableDynHeadDataType");
			var tableDynHeadDimsionName=$($selectTds[0]).attr("data-tableDynHeadDimsionName");
			var tableDynHeadYearStep=$($selectTds[0]).attr("data-tableDynHeadYearStep");
			var tableDynHeadMonthStep=$($selectTds[0]).attr("data-tableDynHeadMonthStep");
			var tableDynHeadDayStep=$($selectTds[0]).attr("data-tableDynHeadDayStep");
			var tableDynHeadPrefixStr=$($selectTds[0]).attr("data-tableDynHeadPrefixStr");
			var tableDynHeadSuffixStr=$($selectTds[0]).attr("data-tableDynHeadSuffixStr");
			if(tableHeadColDynType==null||tableHeadColDynType==undefined||tableHeadColDynType==''){
				$("input[name='tableHeadColDynType'][value='1']").iCheck('check');
				$("#tableDynHeadDataType").combobox("setValue",'1');
				$("#tableDynHeadDimsionNameDt").hide();
				$("#tableDynHeadDimsionNameDd").hide();
				$("#tableDynHeadYearStep").numberbox("setValue",'0');
				$("#tableDynHeadMonthStep").numberbox("setValue",'0');
				$("#tableDynHeadDayStep").numberbox("setValue",'0');
				$("#tableDynHeadPrefixStr").val('');
				$("#tableDynHeadSuffixStr").val('');
				
			}else if(tableHeadColDynType=='1'){
				$("input[name='tableHeadColDynType'][value='1']").iCheck('check');
				$("#tableDynHeadDimsionNameDt").hide();
				$("#tableDynHeadDimsionNameDd").hide();
				
				if(tableDynHeadDataType==null||tableDynHeadDataType==undefined||tableDynHeadDataType=='1'){
					$("#tableDynHeadDataType").combobox("setValue",'1');
					$("#tableDynHeadDayStepDt").show();
					$("#tableDynHeadDayStepDd").show();
					
				}else{
					$("#tableDynHeadDataType").combobox("setValue",tableDynHeadDataType);
					$("#tableDynHeadDayStepDt").hide();
					$("#tableDynHeadDayStepDd").hide();
				}
				
				if(tableDynHeadYearStep==null||tableDynHeadYearStep==undefined){
					$("#tableDynHeadYearStep").numberbox("setValue",'0');
				}else{
					$("#tableDynHeadYearStep").numberbox("setValue",tableDynHeadYearStep);
				}
				
				if(tableDynHeadMonthStep==null||tableDynHeadMonthStep==undefined){
					$("#tableDynHeadMonthStep").numberbox("setValue",'0');
				}else{
					$("#tableDynHeadMonthStep").numberbox("setValue",tableDynHeadMonthStep);
				}
				
				if(tableDynHeadDayStep==null||tableDynHeadDayStep==undefined){
					$("#tableDynHeadDayStep").numberbox("setValue",'0');
				}else{
					$("#tableDynHeadDayStep").numberbox("setValue",tableDynHeadDayStep);
				}
				if(tableDynHeadPrefixStr==null||tableDynHeadPrefixStr==undefined){
					$("#tableDynHeadPrefixStr").val('');
				}else{
					$("#tableDynHeadPrefixStr").val(tableDynHeadPrefixStr);
				}
				if(tableDynHeadSuffixStr==null||tableDynHeadSuffixStr==undefined){
					$("#tableDynHeadSuffixStr").val('');
				}else{
					$("#tableDynHeadSuffixStr").val(tableDynHeadSuffixStr);
				}
				
			}else if(tableHeadColDynType=='2'){
				$("input[name='tableHeadColDynType'][value='2']").iCheck('check');
				$("#tableDynHeadDimsionNameDt").show();
				$("#tableDynHeadDimsionNameDd").show();
				
				if(tableDynHeadDataType==null||tableDynHeadDataType==undefined||tableDynHeadDataType=='1'){
					$("#tableDynHeadDataType").combobox("setValue",'1');
					$("#tableDynHeadDayStepDt").show();
					$("#tableDynHeadDayStepDd").show();
					
				}else{
					$("#tableDynHeadDataType").combobox("setValue",tableDynHeadDataType);
					$("#tableDynHeadDayStepDt").hide();
					$("#tableDynHeadDayStepDd").hide();
				}
				
				if(tableDynHeadDimsionName==null||tableDynHeadDimsionName==undefined){
					$("#tableDynHeadDimsionName").combobox("setValue",'请选择');
				}else{
					$("#tableDynHeadDimsionName").combobox("setValue",tableDynHeadDimsionName);
				}
				
				if(tableDynHeadYearStep==null||tableDynHeadYearStep==undefined){
					$("#tableDynHeadYearStep").numberbox("setValue",'0');
				}else{
					$("#tableDynHeadYearStep").numberbox("setValue",tableDynHeadYearStep);
				}
				
				if(tableDynHeadMonthStep==null||tableDynHeadMonthStep==undefined){
					$("#tableDynHeadMonthStep").numberbox("setValue",'0');
				}else{
					$("#tableDynHeadMonthStep").numberbox("setValue",tableDynHeadMonthStep);
				}
				
				if(tableDynHeadDayStep==null||tableDynHeadDayStep==undefined){
					$("#tableDynHeadDayStep").numberbox("setValue",'0');
				}else{
					$("#tableDynHeadDayStep").numberbox("setValue",tableDynHeadDayStep);
				}
				if(tableDynHeadPrefixStr==null||tableDynHeadPrefixStr==undefined){
					$("#tableDynHeadPrefixStr").val('');
				}else{
					$("#tableDynHeadPrefixStr").val(tableDynHeadPrefixStr);
				}
				if(tableDynHeadSuffixStr==null||tableDynHeadSuffixStr==undefined){
					$("#tableDynHeadSuffixStr").val('');
				}else{
					$("#tableDynHeadSuffixStr").val(tableDynHeadSuffixStr);
				}
				
			}
			
		}else{//不同的动态类型
			/*
			$("input[name='tableHeadColDynType']").iCheck('uncheck');
			$("#tableDynHeadDataType").combobox("setValue",'请选择');
			$("#tableDynHeadDimsionNameDt").hide();
			$("#tableDynHeadDimsionNameDd").hide();
			$("#tableDynHeadYearStep").numberbox("setValue",'0');
			$("#tableDynHeadMonthStep").numberbox("setValue",'0');
			$("#tableDynHeadDayStep").numberbox("setValue",'0');
			$("#tableDynHeadPrefixStr").val('');
			$("#tableDynHeadSuffixStr").val('');
			*/
		
		}
	
	});
}



/** 描述：设置动态表头单元格的动态类型
	参数：
		value 值
*/
function tableHeadSetDynType(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var dynHeadList=[];
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var isSameDynTypeWithOldFlag=true;
	for(var i=0;i<$selectTds.length;i++){
		if($($selectTds[i]).attr("data-tableHeadColDynType")!=value){
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
		$($selectTds[a]).attr("data-tableHeadColDynType",value);
	}
	
	if(value=='1'){//常量
		$("#tableDynHeadDimsionNameDt").hide();
		$("#tableDynHeadDimsionNameDd").hide();
		$("#tableDynHeadDataType").combobox("setValue",'1');
		$("#tableDynHeadYearStep").numberbox("setValue",'0');
		$("#tableDynHeadMonthStep").numberbox("setValue",'0');
		$("#tableDynHeadDayStep").numberbox("setValue",'0');
		$("#tableDynHeadDayStepDt").show();
		$("#tableDynHeadDayStepDd").show();
		$("#tableDynHeadPrefixStr").val('');
		$("#tableDynHeadSuffixStr").val('');
	}else if(value=='2'){//查询条件
		$("#tableDynHeadDimsionNameDt").show();
		$("#tableDynHeadDimsionNameDd").show();
		$("#tableDynHeadDataType").combobox("setValue",'1');
		$("#tableDynHeadDimsionName").combobox("setValue",'请选择');
		$("#tableDynHeadYearStep").numberbox("setValue",'0');
		$("#tableDynHeadMonthStep").numberbox("setValue",'0');
		$("#tableDynHeadDayStep").numberbox("setValue",'0');
		$("#tableDynHeadDayStepDt").show();
		$("#tableDynHeadDayStepDd").show();
		$("#tableDynHeadPrefixStr").val('');
		$("#tableDynHeadSuffixStr").val('');
	}
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的数据类型
	参数：
		obj combobox数据对象
*/
function tableHeadSetDynDataType(obj){
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
		$($selectTds[a]).attr("data-tableDynHeadDataType",value);
		$($selectTds[a]).text("动态表头["+(value=='1'?'日':'月')+"]");
	}
	if(value=='1'){//日
		$("#tableDynHeadDayStepDt").show();
		$("#tableDynHeadDayStepDd").show();
	}else if(value=='2'){//月
		$("#tableDynHeadDayStepDt").hide();
		$("#tableDynHeadDayStepDd").hide();
	}
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
	
	
}


/** 描述：设置动态表头单元格的绑定查询条件
	参数：
		obj combobox数据对象
*/
function tableHeadSetDynDimsionName(obj){
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
		$($selectTds[a]).attr("data-tableDynHeadDimsionName",value);
	}
	
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的年偏移量
	参数：
		value 值
*/
function tableHeadSetDynYearStep(value){
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
		$($selectTds[a]).attr("data-tableDynHeadYearStep",value);
	}
	
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的月偏移量
	参数：
		value 值
*/
function tableHeadSetDynMonthStep(value){
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
		$($selectTds[a]).attr("data-tableDynHeadMonthStep",value);
	}
	
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}
/** 描述：设置动态表头单元格的日偏移量
	参数：
		value 值
*/
function tableHeadSetDynDayStep(value){
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
		$($selectTds[a]).attr("data-tableDynHeadDayStep",value);
	}
	
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的前缀字符
	参数：
		value 值
*/
function tableHeadSetDynPrefixStr(value){
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
		$($selectTds[a]).attr("data-tableDynHeadPrefixStr",value);
	}
	
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}

/** 描述：设置动态表头单元格的后缀字符
	参数：
		value 值
*/
function tableHeadSetDynSuffixStr(value){
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
		$($selectTds[a]).attr("data-tableDynHeadSuffixStr",value);
	}
	
	TableEvent.setHeadSynCol(reportId,containerId,componentId,dynHeadList,"edit",false);
}


/** 描述：修改选中单元格的值
	参数：
		componentId 组件编号
		value 值
*/				
function tableHeadColValue(value){
	
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var $selecteds = $("#selectable_"+componentId).find(".ui-selected").eq(0);
	$selecteds.html(tableFilterHtml(value));
	/*
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		$($selectTds[a]).attr("value",value);
	}
	*/
	tableSetHeadui();
}

/** 描述：点击合并按钮执行的方法
	参数：
*/
function tableHeadMergeCell(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if($("#tableHeadMergeCellButton_"+componentId).attr("disabled")=="disabled"||$("#tableHeadMergeCellButton_"+componentId).attr("disabled")==true){
		return false;
	}
	
	TableEvent.setMergeCell(reportId,containerId,componentId);
}

/** 描述：点击拆分按钮执行的方法
	参数：
*/
function tableHeadSplitCell(){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if($("#tableHeadSplitCellButton_"+componentId).attr("disabled")=="disabled"||$("#tableHeadSplitCellButton_"+componentId).attr("disabled")==true){
		return false;
	}
	TableEvent.setSplitCell(reportId,containerId,componentId);
}

//------------------表头单元格结束-------------------------------------------//
//------------------数据单元格开始-------------------------------------------//

/** 描述：设置单元格宽度（与数据行相邻表头行中的单元格）
	参数：
		value 值
*/
function tableDataSetWidth(value){
	if(value==''){
		return false;
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	if(value==''){
		value='100';
		$("#tableDataWidth").numberbox("setValue",value);
	}
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	
	var tempTableCell=null;
	var tempTableCellInd=null;
	for(var a=0;a<$selectTds.length;a++){
		tempTableCellInd=$($selectTds[a]).attr("tdInd");
		tempTableCell=tableFindLastRowCellByTdInd(componentId,tempTableCellInd);
		$(tempTableCell).attr("width",value);
		$($selectTds[a]).attr("data-tableHeadWidth",value);
	}
	tableSetHeadui();
}

/** 描述：设置数据单元格的数据类型
	参数：
		value 值
*/
function tableDataSetType(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmttype=value;
		cellInfo.datadecimal='0';
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataType",value);
	}
	if(value!='common'){//非常规，即数值或百分数
		$("#tableDataNumberStep").numberbox("setValue",0);
		$("#tableDataNumberStep").numberbox("enable");
		$("#tableDataThousand").iCheck('uncheck');
		$("#tableDataThousand").iCheck('enable');
	}else{
		$("#tableDataNumberStep").numberbox("setValue",'');
		$("#tableDataNumberStep").numberbox("disable");
		$("#tableDataThousand").iCheck('uncheck');
		$("#tableDataThousand").iCheck('disable');
	}
	TableEvent.setHeadDataType(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的小数位数（数值或百分数时设置）
	参数：
		value 值
*/
function tableDataSetNumberStep(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	if($.trim(value)==''){
		value='0';
		$("#tableDataNumberStep").numberbox("setValue",'0');
	}
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datadecimal=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataNumberStep",value);
	}
	TableEvent.setHeadDataNumberStep(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 使用千分符（,）
	参数：
		
*/
function tableDataSetThousand(){
	var value='0';
	if($("#tableDataThousand").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtthousand=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataThousand",value);
	}
	TableEvent.setHeadDataThousand(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 对齐方式
	参数：
		value 值
*/
function tableDataSetAlign(value){

	if(value=='left'){
		$("#tableDataAlignLeft").addClass("positionLeftSelect").removeClass("positionLeft");
		$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
		$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");
	}else if(value=='center'){
		$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
		$("#tableDataAlignCenter").addClass("positionCenterSelect").removeClass("positionCenter");
		$("#tableDataAlignRight").addClass("positionRight").removeClass("positionRightSelect");

	}else if(value=='right'){
		$("#tableDataAlignLeft").addClass("positionLeft").removeClass("positionLeftSelect");
		$("#tableDataAlignCenter").addClass("positionCenter").removeClass("positionCenterSelect");
		$("#tableDataAlignRight").addClass("positionRightSelect").removeClass("positionRight");
	}

	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtalign=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataAlign",value);
	}
	TableEvent.setHeadDataAlign(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 行间相邻相同数据合并
	参数：
		
*/
function tableDataSetRowMerge(){
	var value='0';
	if($("#tableDataRowMerge").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtrowmerge=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataRowMerge",value);
	}
	TableEvent.setHeadDataThousand(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的 设置边界
	参数：
		
*/
function tableDataSetBorderSetFlag(){
	var value='0';
	
	if($("#tableDataBorderSetFlag").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtisbd=value;
		cellInfo.datafmtisbdvalue='0';
		cellInfo.datafmtbdup='#00ff00';
		cellInfo.datafmtbddown='#ff0000';
		cellInfo.datafmtisarrow='0';
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataBorderSetFlag",value);
	}
	$("#tableDataBorderValue").numberbox("setValue",'0');
	$("#tableDataBorderGtColor").spectrum("set","#00ff00");
	$("#tableDataBorderLtColor").spectrum("set","#ff0000");
	$("#tableDataBorderShowUpDown").iCheck('uncheck');
	if(value=='1'){
		$("#tableDataBorderValue").numberbox("enable");
		$("#tableDataBorderGtColor").spectrum("enable");
		$("#tableDataBorderLtColor").spectrum("enable");
		$("#tableDataBorderShowUpDown").iCheck('enable');
	}else{
		$("#tableDataBorderValue").numberbox("disable");
		$("#tableDataBorderGtColor").spectrum("disable");
		$("#tableDataBorderLtColor").spectrum("disable");
		$("#tableDataBorderShowUpDown").iCheck('disable');
	}
	
	
	TableEvent.setHeadDataBorderSetFlag(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的边界值
	参数：
		value 值
*/
function tableDataSetBorderValue(value){
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	if($.trim(value)==''){
		value='0';
		$("#tableDataBorderValue").numberbox("setValue",'0');
	}
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtisbdvalue=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataBorderValue",value);
	}
	TableEvent.setHeadDataBorderValue(reportId,containerId,componentId,cellInfoList);
}

/** 描述：设置数据单元格的数据的大于边界值的颜色
	参数：
		color 颜色对象
*/
function tableDataSetBorderGtColor(color){
	var value=color.toHexString();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtbdup=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataBorderGtColor",value);
	}
	TableEvent.setHeadDataBorderGtColor(reportId,containerId,componentId,cellInfoList);
}
/** 描述：设置数据单元格的数据的小于边界值的颜色
	参数：
		color 颜色对象
*/
function tableDataSetBorderLtColor(color){
	var value=color.toHexString();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtbddown=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataBorderLtColor",value);
	}
	TableEvent.setHeadDataBorderLtColor(reportId,containerId,componentId,cellInfoList);
}
/** 描述：设置数据单元格的数据的 行间相邻相同数据合并
	参数：
		
*/
function tableDataSetBorderShowUpDown(){
	var value='0';
	if($("#tableDataBorderShowUpDown").attr("checked")!='checked'){//选中
		value='1';
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var cellInfoList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var cellInfo={};
		cellInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		cellInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		cellInfo.datafmtisarrow=value;
		cellInfoList.push(cellInfo);
		$($selectTds[a]).attr("data-tableDataBorderShowUpDown",value);
	}
	TableEvent.setHeadDataBorderShowUpDown(reportId,containerId,componentId,cellInfoList);
}

/** 描述：点击数据单元格动作类型时执行的方法，“无”：清除动作并隐藏选项，“链接”：显示链接选项，“联动”：显示联动选项
	参数：
		value 值
*/
function tableDataSetEvent(value){
	if($("input[name='tableDataEvent']:checked").val()==value){
		return false;
	}
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var isHasSameEventJsonFlag=true;
	var tableEventSelectJsonStr='';
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		}
		if(tableEventSelectJsonStr!=$($selectTds[a]).attr("data-tableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	
	if(isHasSameEventJsonFlag){
		var eventStoreList=[];
		var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
		for(var a=0;a<$selectTds.length;a++){
			var evetStoreInfo={};
			evetStoreInfo.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
			evetStoreInfo.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
			eventStoreList.push(evetStoreInfo);
			if($($selectTds[a]).attr("data-tableDataEvent")!=value){
				$($selectTds[a]).removeAttr("data-tableEventSelectJson");
			}
			$($selectTds[a]).attr("data-tableDataEvent",value);
		}
		TableEvent.setDataClearEvent(reportId,containerId,componentId,eventStoreList);
		
	}
	
	if(value=="none"){
		$("#tableDataEventLinkDiv").hide();
		$("#tableDataEventActiveDiv").hide();
	}else if(value=="link"){
		$("#tableDataEventLink").val("");
		$("#tableDataEventLinkShow").val("");
		$("#tableDataEventLinkParam").val("");
		$("#tableDataEventLinkParamShow").val("");
		$("#tableDataEventLinkDiv").show();
		$("#tableDataEventActiveDiv").hide();
		for(var a=0;a<$selectTds.length;a++){
			if($($selectTds[a]).attr("data-tableDataEvent")!=value){
				$($selectTds[a]).removeAttr("data-tableEventSelectJson");
			}
			$($selectTds[a]).attr("data-tableDataEvent",value);
		}
		
	}else if(value=='active'){
		tableDataEventSetActiveShow(reportId,containerId,componentId);
	}
}

/** 描述：点击数据单元格动作类型中的“联动”时，执行的显示部分（前台显示）的方法
	参数：
		reportId	报表id
		containerId 容器id
		componentId 组件id
*/
function tableDataEventSetActiveShow(reportId,containerId,componentId){
	var isHasSameEventJsonFlag=true;
	var tableEventSelectJsonStr='';
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		}
		if(tableEventSelectJsonStr!=$($selectTds[a]).attr("data-tableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	
	var eventList=[];
	if(isHasSameEventJsonFlag){
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		
		if(tableEventSelectJson!=null){
			eventList=tableEventSelectJson["eventList"];
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
							divHtmlStr+='<input type="checkbox" id="tableDataEventActiveCheckbox" name="tableDataEventActiveCheckbox" value="'+tempComponentId+'" eventId="'+tempEventId+'"/><strong class="eventActiveChartCommon '+classStr+'">'+tempComponentTitle+'</strong>';
							divHtmlStr+='</span>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="button" value="设置" class="eventActiveSetButtonClass" name="tableDataEventActiveButton" onclick="tableDataOpenEventActiveDialog(\''+tempComponentId+'\',\''+tempEventId+'\')" disabled="disabled"/>';
							divHtmlStr+='</span>';
							divHtmlStr+='</p>';
							divHtmlStr+='</dd>';
						}else{
							divHtmlStr+='<dt></dt>';
							divHtmlStr+='<dd>';
							divHtmlStr+='<p>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="checkbox" id="tableDataEventActiveCheckbox" name="tableDataEventActiveCheckbox" value="'+tempComponentId+'" eventId="'+tempEventId+'" checked="checked"/><strong class="eventActiveChartCommon '+classStr+'">'+tempComponentTitle+'</strong>';
							divHtmlStr+='</span>';
							divHtmlStr+='<span>';
							divHtmlStr+='<input type="button" value="设置" class="eventActiveSetButtonClass" name="tableDataEventActiveButton" onclick="tableDataOpenEventActiveDialog(\''+tempComponentId+'\',\''+tempEventId+'\')" />';
							divHtmlStr+='</span>';
							divHtmlStr+='</p>';
							divHtmlStr+='</dd>';
						}
						
					}
				}
			}
		}
	}
	$("#tableDataEventActiveDiv>dl").html(divHtmlStr);
	
	//动作类型多选框
	$("input[name='tableDataEventActiveCheckbox']").iCheck({
	    labelHover : false,
	    cursor : true,
	    checkboxClass : 'icheckbox_square-blue',
	    radioClass : 'iradio_square-blue',
	    increaseArea : '20%'
	}).on('ifClicked', function(event){
	  	tableDataEventActiveSetCheck(this);
	});
	
	
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if($($selectTds[a]).attr("data-tableDataEvent")!="active"){
			$($selectTds[a]).removeAttr("data-tableEventSelectJson");
		}
		$($selectTds[a]).attr("data-tableDataEvent","active");
	}
	$("#tableDataEventLinkDiv").hide();
	$("#tableDataEventActiveDiv").show();

}





/** 描述：打开数据单元格的选择面页的面板
	参数：
	
*/
function tableDataOpenEventLinkDialog(){
	$("#tableDataEventLinkReportId").val("");
	$("#tableDataEventLinkReportName").val("");
	tableDataEventLinkReportQuery();
	$("#tableDataEventLinkDialog").dialog("open");
	hideToolsPanel();
}

/** 描述：数据单元格的选择面页的面板中“操作”列的格式化方法
	参数：
		value	当前列数据
		rowData	行数据
	
*/
function tableDataEventLinkReportFormatter(value,rowData){
	var commentStr = '<a href="javascript:void(0);" style="text-decoration: none;margin:0 5px;" onclick="tableDataEventLinkReportCommit(\''+rowData.ID+'\',\''+rowData.NAME+'\',\''+rowData.URL+'\')">选择</a>';
	return  commentStr;
}

/** 描述：数据单元格的选择面页的面板中点击查询按钮执行的方法
	参数：
	
*/
function tableDataEventLinkReportQuery(){
	var info = {};
	info.tableDataEventLinkReportId = $("#tableDataEventLinkReportId").val();
	info.tableDataEventLinkReportName = $("#tableDataEventLinkReportName").val();
	info.tableDataEventLinkCurrentReportId=StoreData.xid;
	$("#tableDataEventLinkReportDatagrid").datagrid("load",info);
}

/** 描述：选择面页的面板中中点击完成按钮执行的方法
	参数：
		value	当前列数据
		rowData	行数据
	
*/
function tableDataEventLinkReportCommit(sourceId,sourceName,sourceUrl){
	var oldEventLink=$("#tableDataEventLink").val();
	$("#tableDataEventLinkShow").val(sourceName);
	$("#tableDataEventLink").val(sourceId);
	$('#tableDataEventLinkDialog').dialog('close');
	showToolsPanel();
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	var eventStoreList=[];
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	var tempEventId='';
	for(var a=0;a<$selectTds.length;a++){
		var tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		
		var eventStore={};
		eventStore.type='link';
		eventStore.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		eventStore.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		
		var eventList=[];
		var event={};
		event.id=LayOutUtil.uuid();
		event.source=sourceId;
		event.sourceShow=sourceName;
		var tempEventStore=tableEventSelectJson;
		if(tempEventStore["eventList"]!=null){
			var tempEventList=tempEventStore["eventList"];
			if(tempEventList.length>0){
				event.id=tempEventList[0]["id"];
				if(oldEventLink==sourceId){
					event.parameterList=tempEventList[0]["parameterList"];
					event.parameterShow=tempEventList[0]["parameterShow"];
					$("#tableDataEventLinkParamShow").val(event.parameterShow);
				}else{
					$("#tableDataEventLinkParamShow").val("");
				}
			}
		}
		
		eventList.push(event);
		eventStore.eventList=eventList;
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(eventStore));
		eventStoreList.push(eventStore);
	}
	
	TableEvent.setDataEventLink(reportId,containerId,componentId,eventStoreList);
}


/** 描述：数据单元格的联动的设置参数的面板的添加行
	参数：
*/
function tableDataOpenEventLinkParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField){
	var insertHtmlStr='';
	insertHtmlStr+='<tr>';
	insertHtmlStr+='<td width="50%">参数名:&nbsp;<input type="text" id="'+name+'" name="tableDataEventLinkParamName" dimsionId="'+dimsionId+'" style="width:120px;" value="" readonly="readonly"></td>';
	insertHtmlStr+='<td>对应数据列:&nbsp;<input name="tableDataEventLinkParamValue" value="请选择"  style="width:120px"></td>';
	insertHtmlStr+='</tr>';
	var $row = $(insertHtmlStr);
	$row.appendTo($("#tableDataEventLinkParamTable"));
	var tableDataEventLinkParamName=$row.find("input[name='tableDataEventLinkParamName']");
	tableDataEventLinkParamName.val(nameDesc);
	var tableDataEventLinkParamValue=$row.find("input[name='tableDataEventLinkParamValue']");
	tableDataEventLinkParamValue.combobox({   
	    data:valueData,   
	    valueField:valueField,   
	    textField:TextField,
	    editable:false,
	    value:value
	});  
	
}

/** 描述：数据单元格的链接的设置参数的面板的完成按钮的执行方法
	参数：
*/
function tableDataOpenEventLinkParamCommit(){
	var tableDataEventLinkParamTableTr=$("#tableDataEventLinkParamTable tr");
	var tableDataEventLinkParamShowStr='';
	var parameterList=[];
	for(var a=0;a<tableDataEventLinkParamTableTr.length;a++){
		var nameInput=$(tableDataEventLinkParamTableTr[a]).find("input[name='tableDataEventLinkParamName']");
		var valueInput=$(tableDataEventLinkParamTableTr[a]).find("input[name='tableDataEventLinkParamValue']");
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
				tableDataEventLinkParamShowStr+=nameInput.attr("value")+'='+value+';';
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
		var tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		if(tableEventSelectJson!=null){
			var eventList=tableEventSelectJson["eventList"];
			if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'&&eventList.length>0){
				var event=eventList[0];
				if(eventList!=undefined&&eventList!=null&&eventList!=''&&eventList!='null'){
					event.parameterList=parameterList;
					event.parameterShow=tableDataEventLinkParamShowStr;
				}
			}
		}
		$($selectTds[a]).attr("data-tableDataEvent",'link');
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(tableEventSelectJson));
		eventStoreList.push(tableEventSelectJson);
	}
	
	TableEvent.setDataEventLinkParameter(reportId,containerId,componentId,eventStoreList);
	$("#tableDataEventLinkParamShow").val(tableDataEventLinkParamShowStr);
	$("#tableDataEventLinkParamDialog").dialog("close");
	showToolsPanel();
}


/** 描述：设置数据单元格的联动面板中的组件是否联动
	参数：
	
*/
function tableDataEventActiveSetCheck(obj){
	var eventId=$(obj).attr("eventId");
	var eventSource=$(obj).attr("value");
	var reportId=StoreData.xid;
	var containerId=StoreData.curContainerId;
	var componentId=StoreData.curComponentId;
	
	var isHasSameEventJsonFlag=true;
	var tableEventSelectJsonStr='';
	var tableEventSelectJson=null;
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		if(a==0){
			tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		}
		if(tableEventSelectJsonStr!=$($selectTds[a]).attr("data-tableEventSelectJson")){
			isHasSameEventJsonFlag=false;
		}
	}
	var eventList=null;
	if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
		tableEventSelectJsonStr='{}';
	}
	tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
	eventList=tableEventSelectJson["eventList"];
	if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
		eventList=[];
		tableEventSelectJson.eventList=eventList;
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
		$(obj).parent().parent().parent().find("input[name='tableDataEventActiveButton']").removeAttr("disabled");
	}else{
		eventInfo={};
		eventList[eventInfoIndex]=eventInfo;
		$(obj).parent().parent().parent().find("input[name='tableDataEventActiveButton']").attr("disabled","disabled");
	}
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var eventStoreList=[];
	for(var a=0;a<$selectTds.length;a++){
		var tempEventStore=jQuery.extend(true, {}, tableEventSelectJson); 
		tempEventStore.type='cas';
		tempEventStore.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		tempEventStore.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		eventStoreList.push(tempEventStore);
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(tableEventSelectJson));
	}
	TableEvent.setDataEventActive(reportId,containerId,componentId,eventStoreList);
	
	
	

}


/** 描述：数据单元格的联动的设置参数的面板的添加行
	参数：
*/
function tableDataOpenEventActiveParamAddRow(dimsionId,name,nameDesc,value,valueData,valueField,TextField){
	var insertHtmlStr='';
	insertHtmlStr+='<tr>';
	insertHtmlStr+='<td width="50%">参数名:&nbsp;<input type="text" id="'+name+'" name="tableDataEventActiveParamName" dimsionId="'+dimsionId+'" style="width:120px;" value="" readonly="readonly"></td>';
	insertHtmlStr+='<td>对应数据列:&nbsp;<input name="tableDataEventActiveParamValue" value="请选择"  style="width:120px"></td>';
	insertHtmlStr+='</tr>';
	var $row = $(insertHtmlStr);
	$row.appendTo($("#tableDataEventActiveParamTable"));
	var tableDataEventActiveParamName=$row.find("input[name='tableDataEventActiveParamName']");
	tableDataEventActiveParamName.val(nameDesc);
	var tableDataEventActiveParamValue=$row.find("input[name='tableDataEventActiveParamValue']");
	tableDataEventActiveParamValue.combobox({   
	    data:valueData,   
	    valueField:valueField,   
	    textField:TextField,
	    editable:false,
	    value:value
	});  
}

/** 描述：数据单元格的联动的设置参数的面板的完成按钮执行的方法
	参数：
*/
function tableDataOpenEventActiveParamCommit(){
	var tableDataEventActiveParamTableTr=$("#tableDataEventActiveParamTable tr");
	var parameterList=[];
	for(var a=0;a<tableDataEventActiveParamTableTr.length;a++){
		var nameInput=$(tableDataEventActiveParamTableTr[a]).find("input[name='tableDataEventActiveParamName']");
		var valueInput=$(tableDataEventActiveParamTableTr[a]).find("input[name='tableDataEventActiveParamValue']");
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
	var tableFirstTrTh=$("#selectable_"+componentId+" tr:first>th");
	var $selectable= $("#selectable_"+componentId);
	var $selectTds=$selectable.find(".ui-selected");
	for(var a=0;a<$selectTds.length;a++){
		var tableEventSelectJsonStr=$($selectTds[a]).attr("data-tableEventSelectJson");
		if(tableEventSelectJsonStr==undefined||tableEventSelectJsonStr==''||tableEventSelectJsonStr==null||tableEventSelectJsonStr=='null'){
			tableEventSelectJsonStr='{}';
		}
		var tableEventSelectJson=$.parseJSON(tableEventSelectJsonStr);
		if(tableEventSelectJson==null){
			tableEventSelectJson={};
		}
		tableEventSelectJson.type='cas';
		tableEventSelectJson.tablerowcode=$($selectTds[a]).attr("istt").substring(2);
		tableEventSelectJson.tablecolcode=$(tableFirstTrTh[$($selectTds[a]).attr("tdInd")]).text();
		var eventList=tableEventSelectJson["eventList"];
		if(eventList==undefined||eventList==null||eventList==''||eventList=='null'){
			eventList=[];
		}
		tableEventSelectJson.eventList=eventList;
		var event=null;
		for(var x=0;x<eventList.length;x++){
			if(eventList[x]["id"]==tableCurrentEvnetEventId&&eventList[x]["source"]==tableCurrentEvnetCompenentId){
				event=eventList[x];
				break;
			}
		}
		if(event==null){
			event={};
			event["id"]=tableCurrentEvnetEventId;
			event["source"]=tableCurrentEvnetCompenentId;
			eventList.push(event);
		}
		
		event.parameterList=parameterList;
		
		$($selectTds[a]).attr("data-tableEventSelectJson",$.toJSON(tableEventSelectJson));
		eventStoreList.push(tableEventSelectJson);
	}
	
	TableEvent.setDataEventActiveParameter(reportId,containerId,componentId,eventStoreList);
	$("#tableDataEventActiveParamDialog").dialog("close");
	showToolsPanel();
	
}


//------------------数据单元格结束-------------------------------------------//

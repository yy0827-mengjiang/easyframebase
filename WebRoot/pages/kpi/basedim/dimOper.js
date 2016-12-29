$(function(){
	$(".compositeKpiCategoryFlush").on("click",function(){
		var _selected=$('#dim').tree('getSelected');
		if(_selected.attributes.kpi_parent_id!='-1'){
			$('#dim').tree('reload',$('#dim').tree('getParent', _selected.target).target);
		}
	});
	
	$(".newDimCategory").on("click",function(){
	  $('#queryPerformanceForm').attr("action","dimManagerAction.jsp");
	  var _selected=$('#dim').tree('getSelected');
	  var _cubeId = $('#cube_code').find("option:selected").val();
	  $('#eaction').val("createCategory");
	  $('#category_parent_id').val(_selected.id);
	  $('#cube_code_s').val(_cubeId);
	  $('#c_name').val("");
	  $('#c_desc').val("");
	  $('#c_ord').val("");
	  $('#createCatalogDlg').dialog('open');
	});
	
	$(".editDimCategory").on("click",function(){
		var _selected=$('#dim').tree('getSelected');
		$.ajax({
			type:'post',
			url:'dimManagerAction.jsp?eaction=queryCategoryInfo&id=' + _selected.id,
			async : false,
			success:function(data){
				var _data= $.parseJSON(data);
				if(_data!=0){
				  $('#queryPerformanceForm').attr("action","dimManagerAction.jsp");
				  $('#eaction').val("updateCategory");
				  $('#category_id').val(_data.CATEGORY_ID);
				  $('#category_parent_id').val(_data.CATEGORY_PARENT_ID);
				  $('#cube_code_s').val(_data.CUBE_CODE);
				  $('#c_name').val(_data.CATEGORY_NAME);
				  $('#c_desc').val(_data.CATEGORY_DESC);
				  $('#c_ord').val(_data.ORD);
				  $('#createCatalogDlg').dialog('open');
			}
			}
		  });
	});
	$(".delDimCategory").on("click",function(){
		var _selected=$('#dim').tree('getSelected');
		$.ajax({
			type:'post',
			url:'dimManagerAction.jsp?eaction=validChildren&id=' + _selected.id,
			async : false,
			success:function(data){
				var _data= $.parseJSON(data);
				if(_data==0){
					$.messager.confirm('确认信息','您确认要删除当前的分类吗?',function(r){
				 		if(r){
							$.ajax({
								type:'post',
								url:'dimManagerAction.jsp?eaction=delCategory&id=' + _selected.id,
								async : false,
								success:function(a){
									var _a= $.parseJSON(a);
									if(_a>0){
										 $.messager.alert('提示信息','分类删除成功!','info');
									}else{
										 $.messager.alert('提示信息','分类删除失败!','info');
									}
									$("#dim").tree("reload");
								}
							});
				 		}
					});
				}else{
					$.messager.alert('提示信息','分类下存在维度，请先删除维度后再次尝试删除分类!','info');
				}
			}
		  });
	});
	$(".createDim").on("click",function(){
		var _selected=$('#dim').tree('getSelected');
		var _param = {};
		_param.parentId = _selected.id;
		_param.cube_code = $('#cube_code').find("option:selected").val();
		$('#kpi').load("newBasedimAdd.jsp",_param,function(){
			kpiDivTitle();
		})
	});
	$(".lookDim").on("click",function(){
		
	});
	$(".editDim").on("click",function(){
		var _selected=$('#dim').tree('getSelected');
		var _param = {};
		_param.dim_code = _selected.attributes.code;
		$('#kpi').load("newBaseDimEdit.jsp?",_param,function(){
			kpiDivTitle();
				})
	});
	$(".delDim").on("click",function(){
		var _selected=$('#dim').tree('getSelected');
		var _param = {};
		_param.eaction='delDim';
		_param.dim_code = _selected.attributes.code;
		$.messager.confirm('操作确认', '您确定删除此纬度吗？', function(r){
			  if (r){
				  $.post('dimManagerAction.jsp',_param, function(data){
			            var temp = $.trim(data);
			           // alert(temp);
			            if(temp=='1'){
			            	$.messager.alert("信息","删除纬度成功","info");
			            	$("#kpi").load('../kpiManager/kpiMain.jsp?kpi_category=&cube=', '', function() {});
			    			$('#dim').tree('reload');
			            }else{
			            	$.messager.alert("信息","删除纬度失败，请联系管理员","error");
			            }
					});
			  }
		   });
	});
});
function leftContextMenu(e,node){
   e.preventDefault();
   $(this).tree('select', node.target);
   if(node.attributes.type=="dim"){
       	$('#catalogMenu').menu('show',{left:e.pageX,top:e.pageY});
   } else {
	   if(node.attributes.data_type != "2") {
			$('#dimCatalogMenu').menu('show',{left:e.pageX,top:e.pageY});
	   }else{
		   $('#dimMenu').menu('show',{left:e.pageX,top:e.pageY});
	   }
   }
}
function expandNode(node){
    var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
    if(treeOnlyExpandOneNode!='0'){
        var parent=$('#dim').tree('getParent',node.target);
        if(parent!=null){
            var children=$('#dim').tree('getChildren',parent.target);
            for(var i=0;i<children.length;i++){
                if(children[i].id!=node.id){
                    $('#dim').tree('collapse',children[i].target);
                }
            }
        }
    }
}
function kpiDivTitle(){
	var browser_width;
	browser_width = $(".kpi_guide").eq(0).width();
	$('.tit_div1').css({'width':browser_width,'left':'281px' });
	$(window).resize(function() { 
			$('.tit_div1').css({'width':browser_width,'left':'281px' });
	}); 
  }
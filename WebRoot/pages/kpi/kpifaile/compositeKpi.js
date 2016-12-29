/**
 * Created by Administrator on 2016/3/10.
 */
$(function(){
//    $('#catalogAdd').on("click",createCatalog);
    $("#compositeKpiCategoryEdit").on("click",editCategory);
    $("#compositeKpiCategoryDelete").on("click",deleteCategory);
    $("#compositeKpiNodeHistory").on("click",compositeHistory);
    $("#compositeKpiNodeSibship").on("click",compositeSibship);
    $("#baseKpiCategoryEdit").on("click",editCategory);
    $("#baseKpiCategoryDelete").on("click",deleteCategory);
    $("#baseLabelCategoryEdit").on("click",editCategory);
    $("#baseLabelCategoryDelete").on("click",deleteCategory);
    $("#baseDimCategoryEdit").on("click",editCategory);
    $("#baseDimCategoryDelete").on("click",deleteCategory);
    $("#coverage").on("click",coverage);
});

function leftContextMenu(e,node){
    e.preventDefault();
    reloadFlag="left";
    baseKpiNode = node;
    current_node = node;
    $('#category_id').val(node.id);
    $('#edit_category_id').val(node.id); 
    $("#cube_code_s").val($("#cube_code").val());
    if(node.attributes.kpi_type == undefined) {
    	$("#category_type").val("0"); //如果是基础数据的则默认给一个0
    } else {
    	$("#category_type").val(node.attributes.kpi_type);
    }
    if (null != $(this).tree('getParent', node.target)) {
        $('#category_parent_id').val($(this).tree('getParent', node.target).id);
    }
    $(this).tree('select', node.target);
    if(node.attributes.type=="compositeKpiCategory"){
        if(node.attributes.kpi_parent_id == "-1") {
        	$('#catalogMenu').menu('show',{left:e.pageX,top:e.pageY});
        } else {
        	$('#compositeKpiCategoryMenu').menu('show',{left:e.pageX,top:e.pageY});
        } 
    } else {
    	if(node.attributes.data_type == '2') {
            $('#compositeKpiNodeMenu').menu('show',{left:e.pageX,top:e.pageY});
    	}
    }
}

//function rightContextMenu(e,node){
//    e.preventDefault();
//    reloadFlag="right";
//    baseDimNode=node;
//    current_node = node;
//    $('#category_id').val(node.id);
//    $('#edit_category_id').val(node.id);
//    $("#category_type").val(node.attributes.type);
//    if (null != $(this).tree('getParent', node.target)) {
//        $('#category_parent_id').val($(this).tree('getParent', node.target).id);
//    }
//    $(this).tree('select', node.target);
//    if(node.attributes.type=="baseDimRoot"){
//        $('#catalogMenu').menu('show',{left:e.pageX,top:e.pageY});
//    }
//    if(node.attributes.type=="baseDimCategory"){
//        $('#baseDimCategoryMenu').menu('show',{left:e.pageX,top:e.pageY});
//    }
//    if(node.attributes.type=="baseDimNode"){
//        $('#baseDimNodeMenu').menu('show',{left:e.pageX,top:e.pageY});
//    }
//
//    }

function expandNode(node){
    var treeOnlyExpandOneNode='${treeOnlyExpandOneNode}';
    if(treeOnlyExpandOneNode!='0'){
        var parent=$('#tt').tree('getParent',node.target);
        if(parent!=null){
            var children=$('#tt').tree('getChildren',parent.target);
            for(var i=0;i<children.length;i++){
                if(children[i].id!=node.id){
                    $('#tt').tree('collapse',children[i].target);
                }
            }
        }
    }
}

function compositeSibship(){
    var selected=$('#tt').tree('getSelected');
    if(selected){
        window.open('relationship.jsp?kpi_key='+selected.id+"&kpi_name="+selected.text);
    }  
}

function coverage(){
	 var selected=$('#tt').tree('getSelected');
	 if(selected){
	        window.open('../coverage/coverage.jsp?kpi_key='+selected.id+"&kpi_name="+selected.text,'影响范围', 'height=480, width=1000, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
	    }
}

function compositeHistory(){
    var selected=$('#tt').tree('getSelected');
    if(selected){
        window.open('../version/kpi_version.jsp?kpi_code='+selected.attributes.code,'历史版本', 'height=480, width=800, top=60, left=300, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
    }
}









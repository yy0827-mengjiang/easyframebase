/**
 * Created by Administrator on 2016/3/10.
 */
$(function(){
    $('#win').window({
        closed:true,
        collapsible:false,
        minimizable:false,
        modal:true,
        maximizable:false
    });

    $('#show-dlg').dialog({
        title:'口径解释',
        closed:true
    });
})

function show(v,r){
    return '<a href="#" onclick="showDia('+r.V0+',\''+r.V10+'\',\''+r.V11+'\')">'+v+'</a>'
}
function showDia(kpi_key){
    window.open('../../../lookKpilist.e?kpi_key='+kpi_key);
}

function publish(){
    var selected=$('#tt').tree('getSelected');
    if(selected){
        if(selected.attributes.status!="0"){
            $.messager.alert('提示信息','['+selected.attributes.statusText+']状态下无法发布!','info');
            return false;
        }
        else{
            $.ajax({
                type:'post',
                url:'<e:url value="/pages/kpi/kpiManager/kpiManagerAction.jsp?action=pubKpi"/>',
                data:{"kpi_key":selected.id},
                async : false,
                success:function(data){
                    if(data==1){
                        $.messager.alert('提示信息','发布完成!','info');
                        $('#tt').tree('reload',$('#tt').tree('getParent', current_node.target).target);
                    }
                    else{
                        $.messager.alert('提示信息','发布失败!','info');
                    }
                }
            })
        };
    }
}

function clickNode(node){
    current_node=node;
    var kc=node.text;
    $('#kc').html(kc);
    var params={id:node.id};
    $('#kpiTable').datagrid('options').queryParams=params;
    $('#kpiTable').datagrid('reload');
}

$("#baseDimAdd").on("click",function(){
    $("#kpi").load('<e:url value="/pages/kpi/basedim/basedim.jsp?parentId="/>'+baseDimNode.id);
});

$("#baseDimEdit").on("click",function(){
    $("#kpi").load('<e:url value="/pages/kpi/basedim/editBasedim.jsp?ID="/>'+baseDimNode.id);
})
/*
 <div id="show-dlg" style="width:500px;height:400px;top:50px;"></div>
 <div id="win" style="width:1000px;height:450px;top:50px">
 <iframe id="opt" src="" style="width:100%;height:95%;border:0;" frameboder="0"/>
 </div>
 */

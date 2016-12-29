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
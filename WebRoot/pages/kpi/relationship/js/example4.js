var labelType, useGradients, nativeTextSupport, animate;

(function() {
  var ua = navigator.userAgent,
      iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
      typeOfCanvas = typeof HTMLCanvasElement,
      nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
      textSupport = nativeCanvasSupport 
        && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
  //I'm setting this based on the fact that ExCanvas provides text support for IE
  //and that as of today iPhone/iPad current text support is lame
  labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
  nativeTextSupport = labelType == 'Native';
  useGradients = nativeCanvasSupport;
  animate = !(iStuff || !nativeCanvasSupport);
})();



function init(json){
    //init data
	var json = json;
    
    //preprocess subtrees orientation
    var arr = json.children, len = arr.length;
    for(var i=0; i < len; i++) {
    	//split half left orientation
      if(arr[i].data.$orn == 'left') {
    		$jit.json.each(arr[i], function(n) {
    			n.data.$orn = 'left';
    		});
    	} else {
    	//half right
    		$jit.json.each(arr[i], function(n) {
    			n.data.$orn = 'right';
    		});
    	}
    }
    //end
    //grab radio button
    var normal = $jit.id('s-normal');
    //init Spacetree
    //Create a new ST instance
    var st = new $jit.ST({
        //id of viz container element
        injectInto: 'infovis',
        //multitree
    	  multitree: true,
        //set duration for the animation
        duration: 800,
        //set animation transition type
        transition: $jit.Trans.Quart.easeInOut,
        //set distance between node and its children
        levelDistance: 40,
        //sibling and subtrees offsets
        siblingOffset: 3,
        subtreeOffset: 3,
        Navigation: {
            enable:true,
            panning:true
        },
        //set node and edge styles
        //set overridable=true for styling individual
        //nodes or edges
        Node: {
        	 height:45,
             width: 150,
             type: 'rectangle',
             color: '#6495ED',
             overridable: true,
        },
        Edge: {
        	type: 'bezier',
            overridable: true
        },
        
        onBeforeCompute: function(node){
        },
        
        onAfterCompute: function(){
        },
        
        //This method is called on DOM label creation.
        //Use this method to add event handlers and styles to
        //your node.
        onCreateLabel: function(label, node){
            label.id = node.id;            
            label.innerHTML = node.name;
            label.ondblclick = function(){
        		$('#kpiName').html("");
            	$('#kpiVersion').html("");
            	$('#kpiType').html("");
            	$('#comment').html("");
            	$('#comment1').html("");
            	
            	$('#kpiName').html(node.data.KPI_NAME);
            	$('#kpiVersion').html(node.data.KPI_VERSION);
            	var _type = node.data.TYPE;
            	if(_type=='100'){
            		$('tr[name="kpi"]').hide();
        			$(".tha2").html("系统");
         			$(".tha4").html("创建人");
            		$('#kpiType').html('报表');
            		$(".tha9").html('创建时间');
            	}else{
            		$('tr[name="kpi"]').show(); 
         			$(".tha2").html("版本");
//         			$(".tha4").html("说明");
         			$('#kpiType').html(_type);	
            	}
            	if(node.data.KPI_CALIBER!='--'){
            		$(".tha4").parents('tr').show();
            		$('#comment').html(node.data.KPI_CALIBER);
            		$('#comment1').html(node.data.KPI_EXPLAIN);
            	}else{
            		$(".tha4").parents('tr').hide();
            	}
            	if(node.data.KPI_EXPLAIN!='--'){
            		$(".tha9").parents('tr').show();
            		$('#comment').html(node.data.KPI_CALIBER);
            		$('#comment1').html(node.data.KPI_EXPLAIN);
            	}else{
            		$(".tha9").parents('tr').hide();
            	}
            	
            	if(node.data.KPI_TABLE!='--'&&node.data.TAB_FIELD!='--'){
            		$('tr[name="kpi"]').show();
            		$('#table').html(node.data.KPI_TABLE);
                 	$('#colnum').html(node.data.TAB_FIELD);
            	}else{
            		$('tr[name="kpi"]').hide();
            	}
            	if('4'!=node.data.TYPECODE&&'100'!=node.data.TYPECODE&&undefined!=node.data.TYPECODE){
            		$('tr[name="formula"]').show();
            		$('tr[name="cond"]').show();
            		$('#formula1').html('');
            		$('#formula1').append(node.data.formula);
            		$('#cond1').html('');
            		$('#cond1').html(node.data.condstr);
            		$('span').removeClass("box_div");
            		$('strong').remove();
            		$('#cond1').find('select').css("background","transparent");
            		$('#cond1').find('select').css("border","0");
            		$('#cond1').find('select').css("width","150");
            		$('#cond1').find('select').attr("disabled","disabled");
            		$('input[type="checkbox"]').hide();
            	}else{
            		$('tr[name="formula"]').hide();
            		$('tr[name="cond"]').hide();	
            	}
            	$("#formula-dlg").dialog("open");
            
            };
            //set label styles
            var style = label.style;
            style.width = 150 + 'px';
            style.height = 45 + 'px';            
            style.cursor = 'pointer';
            style.color = '#fff';
            style.fontSize = '0.8em';
            style.textAlign= 'center';
            style.paddingTop = '1px';
        },
        
        //This method is called right before plotting
        //a node. It's useful for changing an individual node
        //style properties before plotting it.
        //The data properties prefixed with a dollar
        //sign will override the global node style properties.
        onBeforePlotNode: function(node){
            //add some color to the nodes in the path between the
            //root node and the selected node.
            if (node.selected) {
                node.data.$color = "#6495ED";
            }
            else {
                delete node.data.$color;
                //if the node belongs to the last plotted level
                if(!node.anySubnode("exist")) {
                    //count children number
                    var count = 0;
                    node.eachSubnode(function(n) { count++; });
                    //assign a node color based on
                    //how many children it has
                    node.data.$color = ['#6495ED'];                    
                }
            }
        },
        
        //This method is called right before plotting
        //an edge. It's useful for changing an individual edge
        //style properties before plotting it.
        //Edge data proprties prefixed with a dollar sign will
        //override the Edge global style properties.
        onBeforePlotLine: function(adj){
            if (adj.nodeFrom.selected && adj.nodeTo.selected) {
                adj.data.$color = "#6495ED";
                adj.data.$lineWidth = 3;
            }
            else {
                delete adj.data.$color;
                delete adj.data.$lineWidth;
            }
        }
    });
    //load json data
    st.loadJSON(json);
    //compute node positions and layout
    st.compute('end');
    st.select(st.root);
    //end
    
}

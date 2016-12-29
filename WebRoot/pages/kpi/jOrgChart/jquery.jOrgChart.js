/**
 * jQuery org-chart/tree plugin.
 *
 * Author: Wes Nolte
 * http://twitter.com/wesnolte
 *
 * Based on the work of Mark Lee
 * http://www.capricasoftware.co.uk 
 *
 * Copyright (c) 2011 Wesley Nolte
 * Dual licensed under the MIT and GPL licenses.
 *
 */
(function($) {

  $.fn.jOrgChart = function(options) {
    var opts = $.extend({}, $.fn.jOrgChart.defaults, options);
    var $appendTo = $(opts.chartElement);

    // build the tree
    $this = $(this);
    var $container = $("<div class='" + opts.chartClass + "'/>");
    if($this.is("ul")) {
      buildNode($this.find("li:first"), $container, 0, opts);
    }
    else if($this.is("li")) {
      buildNode($this, $container, 0, opts);
    }
    $appendTo.append($container);

    // add drag and drop if enabled
    if(opts.dragAndDrop){
        $('div.node').draggable({
            cursor      : 'move',
            distance    : 40,
            helper      : 'clone',
            opacity     : 0.8,
            revert      : 'invalid',
            revertDuration : 100,
            snap        : 'div.node.expanded',
            snapMode    : 'inner',
            stack       : 'div.node'
        });
        
        $('div.node').droppable({
            accept      : '.node',          
            activeClass : 'drag-active',
            hoverClass  : 'drop-hover'
        });
        
      // Drag start event handler for nodes
      $('div.node').bind("dragstart", function handleDragStart( event, ui ){
        
        var sourceNode = $(this);
        sourceNode.parentsUntil('.node-container')
                   .find('*')
                   .filter('.node')
                   .droppable('disable');
      });

      // Drag stop event handler for nodes
      $('div.node').bind("dragstop", function handleDragStop( event, ui ){

        /* reload the plugin */
        $(opts.chartElement).children().remove();
        $this.jOrgChart(opts);      
      });
    
      // Drop event handler for nodes
      $('div.node').bind("drop", function handleDropEvent( event, ui ) {    
	  
        var targetID = $(this).data("tree-node");
        var targetLi = $this.find("li").filter(function() { return $(this).data("tree-node") === targetID; } );
        var targetUl = targetLi.children('ul');
		
        var sourceID = ui.draggable.data("tree-node");		
        var sourceLi = $this.find("li").filter(function() { return $(this).data("tree-node") === sourceID; } );		
        var sourceUl = sourceLi.parent('ul');

        if (targetUl.length > 0){
  		    targetUl.append(sourceLi);
        } else {
  		    targetLi.append("<ul></ul>");
  		    targetLi.children('ul').append(sourceLi);
        }
        
        //Removes any empty lists
        if (sourceUl.children().length === 0){
          sourceUl.remove();
        }
		
      }); // handleDropEvent
        
    } // Drag and drop
  };

  // Option defaults
  $.fn.jOrgChart.defaults = {
    chartElement : 'body',
    depth      : -1,
    chartClass : "jOrgChart",
    dragAndDrop: false
  };
	
  var nodeCount = 0;
  // Method that recursively builds the tree
  function buildNode($node, $appendTo, level, opts) {
    var $table = $("<table cellpadding='0' cellspacing='0' border='0'/>");
    var $tbody = $("<tbody/>");

    // Construct the node container(s)
    var $nodeRow = $("<tr/>").addClass("node-cells");
    var $nodeCell = $("<td/>").addClass("node-cell").attr("colspan", 2);
    var $childNodes = $node.children("ul:first").children("li");
    var $nodeDiv;
    
    if($childNodes.length > 1) {
      $nodeCell.attr("colspan", $childNodes.length * 2);
    }
    // Draw the node
    // Get the contents - any markup except li and ul allowed
    var $nodeContent = $node.clone()
                            .children("ul,li")
                            .remove()
                            .end()
                            .html();
	
      //Increaments the node count which is used to link the source list and the org chart
  	nodeCount++;
  	$node.data("tree-node", nodeCount);
  	//console.log($node);
  	var div="<div id="+$node.attr("id")+">";
  	$nodeDiv = $(div).addClass("node")
                                     .data("tree-node", nodeCount)
                                     .append($nodeContent);

    // Expand and contract nodes
    if ($childNodes.length > 0) {
      $nodeDiv.dblclick(function() {
          var $this = $(this);
          var $tr = $this.closest("tr");

          if($tr.hasClass('contracted')){
            $this.css('cursor','pointer');
            $tr.removeClass('contracted').addClass('expanded');
            $tr.nextAll("tr").css('visibility', '');

            // Update the <li> appropriately so that if the tree redraws collapsed/non-collapsed nodes
            // maintain their appearance
            $node.removeClass('collapsed');
          }else{
            $this.css('cursor','pointer');
            $tr.removeClass('expanded').addClass('contracted');
            $tr.nextAll("tr").css('visibility', 'hidden');

            $node.addClass('collapsed');
          }
        });
    }
    /////
    var $msg=$('#msg');
    $nodeDiv.click(function(){
//    	var $this=$(this);
//    	var id=$this.attr("id");
//    	var type=$this.attr('class').split(" ")[1];
//    	$.getJSON("../../../sibshipMSG.e",{"id":id,"type":type},function(data){
//    		if(data!=null){
//    			if(data.type=="kpi"){
//		    		//var busi_desc="<span>参考文档内容:</span><span>"+(data.BUSI_DESC==null?'':data.BUSI_DESC)+"</span>"
//		    		var field_name="<span>来源列：</span><span>"+(data.FIELD_NAME==null?'':data.FIELD_NAME)+"</span></br>";
//		    		var tablename="<span>来源表：</span><span>"+(data.TABLENAME==null?'':data.TABLENAME)+"</span></br>";
//		    		var kpi_spec="<span>技术口径：</span><span>"+(data.KPI_SPEC==null?'':data.KPI_SPEC)+"</span></br>";
//		    		$msg.html(kpi_spec+ tablename+ field_name);
//		    		$msg.show();
//	    		}
//	    		else if(data.type=="dim"){
//	    			var field_name="<span>来源列：</span><span>"+(data.FIELD_NAME==null?'':data.FIELD_NAME)+"</span></br>";
//	    			var tablename="<span>来源表：</span><span>"+(data.TABLENAME==null?'':data.TABLENAME)+"</span></br>";
//	    			$smg.html(tablename+field_name);
//	    			$smg.show();
//	    		}
//	    		else if(data.type=="complex"){
//	    			var kpi_explain="<span>指标解释：</span><span>"+(data.KPI_EXPLAIN==null?'':data.KPI_EXPLAIN)+"</span></br>";
//	    			var kpi_caliber="<span>指标口径：</span><span>"+(data.KPI_CALIBER==null?'':data.KPI_CALIBER)+"</span></br>";
//	    			$msg.html(kpi_explain+kpi_caliber);
//	    			$msg.show();
//	    		}
//	    		
//    		}
//    	});
    });
    $nodeCell.append($nodeDiv);
    $nodeRow.append($nodeCell);
    $tbody.append($nodeRow);

    if($childNodes.length > 0) {
      // if it can be expanded then change the cursor
      $nodeDiv.css('cursor','pointer');
    
      // recurse until leaves found (-1) or to the level specified
      if(opts.depth == -1 || (level+1 < opts.depth)) { 
        var $downLineRow = $("<tr/>");
        var $downLineCell = $("<td/>").attr("colspan", $childNodes.length*2);
        $downLineRow.append($downLineCell);
        
        // draw the connecting line from the parent node to the horizontal line 
        $downLine = $("<div></div>").addClass("line down");
        $downLineCell.append($downLine);
        $tbody.append($downLineRow);

        // Draw the horizontal lines
        var $linesRow = $("<tr/>");
        $childNodes.each(function() {
          var $left = $("<td>&nbsp;</td>").addClass("line left top");
          var $right = $("<td>&nbsp;</td>").addClass("line right top");
          $linesRow.append($left).append($right);
        });

        // horizontal line shouldn't extend beyond the first and last child branches
        $linesRow.find("td:first")
                    .removeClass("top")
                 .end()
                 .find("td:last")
                    .removeClass("top");

        $tbody.append($linesRow);
        var $childNodesRow = $("<tr/>");
        $childNodes.each(function() {
           var $td = $("<td class='node-container'/>");
           $td.attr("colspan", 2);
           // recurse through children lists and items
           buildNode($(this), $td, level+1, opts);
           $childNodesRow.append($td);
        });

      }
      $tbody.append($childNodesRow);
    }

    // any classes on the LI element get copied to the relevant node in the tree
    // apart from the special 'collapsed' class, which collapses the sub-tree at this point
    if ($node.attr('class') != undefined) {
        var classList = $node.attr('class').split(/\s+/);
        $.each(classList, function(index,item) {
            if (item == 'collapsed') {
                console.log($node);
                $nodeRow.nextAll('tr').css('visibility', 'hidden');
                    $nodeRow.removeClass('expanded');
                    $nodeRow.addClass('contracted');
                    $nodeDiv.css('cursor','pointer');
            } else {
                $nodeDiv.addClass(item);
            }
        });
    }

    $table.append($tbody);
    $appendTo.append($table);
    
    /* Prevent trees collapsing if a link inside a node is clicked */
    $nodeDiv.children('a').click(function(e){
        e.stopPropagation();
    });
  };

})(jQuery);

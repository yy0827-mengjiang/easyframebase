<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>
<%@ attribute name="xid" required="true" %>
<%@ attribute name="lwidth" required="true" %>
<%@ attribute name="devemodel" required="true" %>
<%@ attribute name="cids" required="true" %>
<e:script value="/pages/xbuilder/resources/scripts/xbuilder.js"/>
<e:script value="/pages/xbuilder/pagedesigner/Script_property.js"/>
<e:if condition="${devemodel eq '1'}" var="elsedm">
<e:style value="/pages/xbuilder/resources/component/gridster/jquery.gridster.min.css"/>
<e:style value="/pages/xbuilder/resources/component/gridster/style.css"/>
<e:script value="/pages/xbuilder/resources/component/gridster/jquery.gridster.js"/>
<script>
$(function(){
var rowCount = 0;
     $(".gridster>ul>li").each(function(index,item){
         var rowIndex = parseInt($(item).attr("data-row"));
         if(rowIndex>rowCount){
         	rowCount = rowIndex;
         }
     });
     if(rowCount>10){
     	rowCount = rowCount+"";
     	rowCount = parseInt(rowCount.charAt(0))+1;
     }
    var totalBlockSize = 0;
    var perWidth = 20;
    var margin = 2;
    var realWidth = 0;
    var containerWidth = $(".gridster").width();//这个值获取的比实际的大一些
    var blockArr=[];
    var maxRowWidth=0;
    var realWidth=0;
    var maxWidthRowBlockSize=0;
    for(var i=0;i<rowCount;i++){
        totalBlockSize = 0 ;
        if(i==0){
        	blockArr = $(".gridster>ul>li[data-row='1']");
        }else{
        	blockArr=[];
        	var tempBlockArr = $(".gridster>ul>li");
        	$.each(tempBlockArr,function(index,item){
        		var rownum = $(item).attr("data-row");
        		if(rownum!="1"&&rownum.charAt(0)==i){
        			blockArr.push(item);
        		}
        	});
        }
        for (var j = 0; j < blockArr.length; j++) {
            totalBlockSize += parseInt($(blockArr[j]).attr("data-sizex"));
        };
        realWidth = totalBlockSize*perWidth+totalBlockSize*margin*2;
        if(realWidth>maxRowWidth){
            maxRowWidth=realWidth;
            maxWidthRowBlockSize = totalBlockSize;
        }
    }

    if(maxRowWidth>=containerWidth){
    	maxRowWidth =  containerWidth;
    }else{
    	var lw = screen.width-10;
		var sourceDataLw=$.ajax({url: appBase+'/getDLWidth.e?xid=${xid}',type:"POST",cache: false,async: false}).responseText;
		maxRowWidth = maxRowWidth*(lw/sourceDataLw);
		if(maxRowWidth>containerWidth){
			maxRowWidth = containerWidth;
		}
    }

    perWidth = (maxRowWidth-maxWidthRowBlockSize*margin*2-15)/maxWidthRowBlockSize;//不行就减去15像素
	gridster = $(".gridster > ul").gridster({
		widget_margins: [margin, margin],
		widget_base_dimensions: [perWidth, 20],
		autogenerate_stylesheet:true,
		avoid_overlapped_widgets: true
	}).data('gridster');
	$('.component-area').css('width','100%');
	$('.component-area').css('height','100%');
	$('.component-head').css('height','29px');
	$('.component-con').each(function(i,e){
		var tempHeight=$(e).parent().height()-30;
		//$(e).css('height',tempHeight+'px');
	});
	gridster.disable();
	$('#selectable_layout_id001 li').addClass('default-border').removeClass('selected-border');
});
<a:buildwhlt xid="${xid}" cids="${cids}"/>
</script>
</e:if>
<e:else condition="${elsedm}">
<script>
<a:setwhlt xid="${xid}" lwidth="${lwidth}"/>
	$('.component-area').css('width','100%');
	$('.component-area').css('height','100%');
	$('.component-head').css('height','29px');
	$('.component-con').each(function(i,e){
		var tempHeight=$(e).parent().height()-30;
		//$(e).css('height',tempHeight+'px');
	});
	$('#selectable_layout_id001 li').addClass('default-border').removeClass('selected-border');
});
</script>
</e:else>
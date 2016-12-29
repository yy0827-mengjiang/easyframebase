<%@ tag body-content="empty" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>

<!--//属性  -->
<%@ attribute name="id" required="true" %> <e:description>id</e:description>
<%@ attribute name="url" required="false" %> <e:description>json数据url</e:description>
<%@ attribute name="data" required="false" %> <e:description>json数组</e:description>
<%@ attribute name="checkbox" required="false" %> <e:description>是否显示多选框(true/false),默认为false</e:description>
<%@ attribute name="cascadeCheck" required="false" %> <e:description>定义是否级联检查(true/false),默认为true</e:description>
<%@ attribute name="onlyLeafCheck" required="false" %> <e:description>是否只在叶节点前显示 checkbox (true/false),默认为false,只在checkbox属性为true时有效</e:description>
<%@ attribute name="animate" required="false" %> <e:description>节点展开折叠时是否显示动画效果(true/false),默认为false</e:description>
<%@ attribute name="dnd" required="false" %> <e:description>是否启动拖放</e:description>

<!--//事件  -->
<%@ attribute name="onClick" required="false" %> <e:description>单击节点时触发,参数为节点对象node</e:description>
<%@ attribute name="onDblClick" required="false" %> <e:description>双击节点时触发,参数为节点对象node</e:description>
<%@ attribute name="onBeforeLoad" required="false" %> <e:description>当加载数据的请求发出前触发，返回 false 就取消加载动作；参数为node和param</e:description>
<%@ attribute name="onLoadSuccess" required="false" %> <e:description>当数据加载成功时触发,参数为node和data</e:description>
<%@ attribute name="onLoadError" required="false" %> <e:description>当数据加载失败时触发， arguments 参数与jQuery.ajax 的'error' 函数一样；参数为arguments</e:description>
<%@ attribute name="onBeforeExpand" required="false" %> <e:description>节点展开前触发，返回 false 就取消展开动作,参数为node</e:description>
<%@ attribute name="onExpand" required="false" %> <e:description>节点展开时触发,参数为node</e:description>
<%@ attribute name="onBeforeCollapse" required="false" %> <e:description>节点折叠前触发，返回 false 就取消折叠动作,参数为node</e:description>
<%@ attribute name="onCollapse" required="false" %> <e:description>当节点折叠时触发,参数为node</e:description>
<%@ attribute name="onCheck" required="false" %> <e:description>当用户点击 checkbox 时触发,参数为node和checked</e:description>
<%@ attribute name="onSelect" required="false" %> <e:description>当节点被选中时触发,参数为节点对象node</e:description>
<%@ attribute name="onBeforeSelect" required="false" %> <e:description>当节点被拖拽施放时触发,参数为节点对象node</e:description>
<%@ attribute name="onContextMenu" required="false" %> <e:description>当右键点击节点时触发。,参数为e和node</e:description>
<%@ attribute name="onDragEnter" required="false" %> <e:description>节点拖动到其他节点时触发事件，参数为target：DOM 对象，拖放的目标节点。source：源节点。</e:description>
<%@ attribute name="onDrop" required="false" %> <e:description>当节点被拖拽施放时触发,参数为target：DOM 对象，拖放的目标节点。source：源节点。point：表示拖放操作，可能是值是： 'append'、'top' 或 'bottom'。</e:description>
<%@ attribute name="onBeforeEdit" required="false" %> <e:description>编辑节点前触发,参数为node</e:description>
<%@ attribute name="onAfterEdit" required="false" %> <e:description>编辑节点后触发,参数为node</e:description>
<%@ attribute name="onCancelEdit" required="false" %> <e:description>当取消编辑动作时触发,参数为node</e:description>





<ul id="${id}"></ul>
<script type="text/javascript">	
	$(function(){
		//alert('${url}');
		$('#${id}').tree({
			<e:if condition="${url!=null&&url!=''}">
				url:'${url}',
			</e:if>
			<e:if condition="${data!=null&&data!=''}">
				data:${data},
			</e:if>
			checkbox: ${checkbox=='true'},
			cascadeCheck: ${cascadeCheck=='true'},
			onlyLeafCheck:${onlyLeafCheck=='true'},
			dnd:${dnd=='true'},
			
			<e:if condition="${onClick!=null&&onClick!=''}">
				onClick:${onClick},
			</e:if>
			<e:if condition="${onDblClick!=null&&onDblClick!=''}">
				onDblClick:${onDblClick},
			</e:if>
			<e:if condition="${onBeforeLoad!=null&&onBeforeLoad!=''}">
				onBeforeLoad:${onBeforeLoad},
			</e:if>
			<e:if condition="${onLoadSuccess!=null&&onLoadSuccess!=''}">
				onLoadSuccess:${onLoadSuccess},
			</e:if>
			<e:if condition="${onLoadError!=null&&onLoadError!=''}">
				onLoadError:${onLoadError},
			</e:if>
			<e:if condition="${onBeforeExpand!=null&&onBeforeExpand!=''}">
				onBeforeExpand:${onBeforeExpand},
			</e:if>
			<e:if condition="${onExpand!=null&&onExpand!=''}">
				onExpand:${onExpand},
			</e:if>
			<e:if condition="${onBeforeCollapse!=null&&onBeforeCollapse!=''}">
				onBeforeCollapse:${onBeforeCollapse},
			</e:if>
			<e:if condition="${onCollapse!=null&&onCollapse!=''}">
				onCollapse:${onCollapse},
			</e:if>
			<e:if condition="${onCheck!=null&&onCheck!=''}">
				onCheck:${onCheck},
			</e:if>
			<e:if condition="${onSelect!=null&&onSelect!=''}">
				onSelect:${onSelect},
			</e:if>
			<e:if condition="${onBeforeSelect!=null&&onBeforeSelect!=''}">
				onBeforeSelect:${onBeforeSelect},
			</e:if>
			<e:if condition="${onContextMenu!=null&&onContextMenu!=''}">
				onContextMenu:${onContextMenu},
			</e:if>
			<e:if condition="${onDragEnter!=null&&onDragEnter!=''}">
				onDragEnter:${onDragEnter},
			</e:if>
			<e:if condition="${onDrop!=null&&onDrop!=''}">
				onDrop:${onDrop},
			</e:if>
			<e:if condition="${onBeforeEdit!=null&&onBeforeEdit!=''}">
				onBeforeEdit:${onBeforeEdit},
			</e:if>
			<e:if condition="${onAfterEdit!=null&&onAfterEdit!=''}">
				onAfterEdit:${onAfterEdit},
			</e:if>
			<e:if condition="${onCancelEdit!=null&&onCancelEdit!=''}">
				onCancelEdit:${onCancelEdit},
			</e:if>
			animate:${animate=='true'}
			
		});
	});
</script>

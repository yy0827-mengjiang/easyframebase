<%@ tag body-content="scriptless" dynamic-attributes="dynattrs" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e" %>

<%@ attribute name="id" required="true" %>				<e:description>组件id</e:description>
<%@ attribute name="theme" required="false" %>			<e:description>主题切换</e:description>
<%@ attribute name="fontsize" required="false" %>		<e:description>字体大小</e:description>
<%@ attribute name="uppercase" required="false" %>	<e:description>转换大写</e:description>
<%@ attribute name="lowercases" required="false" %>	<e:description>转换小写</e:description>
<%@ attribute name="undo" required="false" %>	<e:description>撤销</e:description>
<%@ attribute name="redo" required="false" %>	<e:description>重做</e:description>
<%@ attribute name="clazz" required="false" %>	<e:description>样式</e:description>

<!--字体大小-->

<e:if condition="${uppercase==true}">
	<input type="button" value="a→A" class="${clazz }" onclick="touppercase()"/>
</e:if>
<e:if condition="${lowercases==true}">
	<input type="button" value="A→a" class="${clazz }" onclick="tolowercases()"/>
</e:if>
<e:if condition="${undo==true}">
	<input type="button" value="撤销" class="${clazz }" onclick="toundo()"/>
</e:if>
<e:if condition="${redo==true}">
	<input type="button" value="重做" class="${clazz }" onclick="toredo()"/>
</e:if>
字体<e:if condition="${fontsize==true}">
	<select onchange="selectFont()" id="fontsize_${id}">
	    <option>11</option>
	    <option selected>13</option>
	    <option>15</option>
	    <option>17</option>
	    <option>19</option>
	    <option>21</option>
	    <option>23</option>
	    <option>25</option>
	    <option>27</option>
	    <option>29</option>
	    <option>31</option>
	</select>
</e:if>
<!--主题-->
主题<e:if condition="${theme==true}">
	<select onchange="selectTheme()" id="select_${id}">
	    <option selected>default</option>
	    <option>3024-day</option>
	    <option>3024-night</option>
	    <option>abcdef</option>
	    <option>ambiance</option>
	    <option>base16-dark</option>
	    <option>base16-light</option>
	    <option>bespin</option>
	    <option>blackboard</option>
	    <option>cobalt</option>
	    <option>colorforth</option>
	    <option>dracula</option>
	    <option>eclipse</option>
	    <option>elegant</option>
	    <option>erlang-dark</option>
	    <option>hopscotch</option>
	    <option>icecoder</option>
	    <option>isotope</option>
	    <option>lesser-dark</option>
	    <option>liquibyte</option>
	    <option>material</option>
	    <option>mbo</option>
	    <option>mdn-like</option>
	    <option>midnight</option>
	    <option>monokai</option>
	    <option>neat</option>
	    <option>neo</option>
	    <option>night</option>
	    <option>paraiso-dark</option>
	    <option>paraiso-light</option>
	    <option>pastel-on-dark</option>
	    <option>railscasts</option>
	    <option>rubyblue</option>
	    <option>seti</option>
	    <option>solarized dark</option>
	    <option>solarized light</option>
	    <option>the-matrix</option>
	    <option>tomorrow-night-bright</option>
	    <option>tomorrow-night-eighties</option>
	    <option>ttcn</option>
	    <option>twilight</option>
	    <option>vibrant-ink</option>
	    <option>xq-dark</option>
	    <option>xq-light</option>
	    <option>yeti</option>
	    <option>zenburn</option>
	</select>
</e:if>

<script type="text/javascript">
	//切换主题
    function selectTheme() {
		var theme_${id} = document.getElementById("select_${id}");
   	 	var theme = theme_${id}.options[theme_${id}.selectedIndex].textContent;
    	editor.setOption("theme", theme);
  	}
  	//改变字体大小
  	function selectFont(){
  		//设置文本编辑区域的字体
		var fontsize_${id} = document.getElementById("fontsize_${id}");
  		var fontSize = fontsize_${id}.options[fontsize_${id}.selectedIndex].textContent+'px';
  		$(".CodeMirror-lines").css('font-size',fontSize);
 	}
 	//大写
 	function touppercase(){
 		var uppercase = editor.getSelection().toUpperCase();
 		editor.replaceSelection(uppercase);
 	}
 	//小写
 	function tolowercases(){
 		var lowercases = editor.getSelection().toLowerCase();
 		editor.replaceSelection(lowercases);
 		
 	}
 	//撤销
 	function toundo(){
 		editor.undo();
 	}
 	//重做
 	function toredo(){
 		editor.redo();
 	}
</script>
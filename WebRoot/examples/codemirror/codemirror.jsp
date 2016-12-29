<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@taglib prefix="a" tagdir="/WEB-INF/tags/app" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<!--jquery-->
<script type="text/javascript" src="http://www.jeasyui.com/easyui/jquery.min.js"></script>
<!--基础-->
<script src="../../resources/component/codemirror/lib/codemirror.js"></script>
<link rel="stylesheet" href="../../resources/component/codemirror/lib/codemirror.css"/>
<!--搜索-->
<link rel="stylesheet" href="../../resources/component/codemirror/addon/dialog/dialog.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/addon/search/matchesonscrollbar.css"/>
<script src="../../resources/component/codemirror/addon/dialog/dialog.js"></script>
<script src="../../resources/component/codemirror/addon/search/searchcursor.js"></script>
<script src="../../resources/component/codemirror/addon/search/search.js"></script>
<script src="../../resources/component/codemirror/addon/scroll/annotatescrollbar.js"></script>
<script src="../../resources/component/codemirror/addon/search/matchesonscrollbar.js"></script>
<script src="../../resources/component/codemirror/addon/search/jump-to-line.js"></script>
<!--提示和补全-->
<link rel="stylesheet" href="../../resources/component/codemirror/addon/hint/show-hint.css" />
<script src="../../resources/component/codemirror/addon/hint/show-hint.js"></script>
<script src="../../resources/component/codemirror/addon/hint/sql-hint.js"></script>
<!--sql高亮-->
<script src="../../resources/component/codemirror/mode/sql/sql.js"></script>
<!--匹配括号-->
<script src="../../resources/component/codemirror/addon/edit/matchbrackets.js"></script>
<!--光标行加深-->
<script src="../../resources/component/codemirror/addon/selection/active-line.js"></script>
<!--全屏模式-->
<link rel="stylesheet" href="../../resources/component/codemirror/addon/display/fullscreen.css"/>
<script src="../../resources/component/codemirror/addon/display/fullscreen.js"></script>
<!--主题-->
<link rel="stylesheet" href="../../resources/component/codemirror/theme/3024-day.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/3024-night.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/abcdef.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/ambiance.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/base16-dark.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/bespin.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/base16-light.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/blackboard.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/cobalt.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/colorforth.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/dracula.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/eclipse.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/elegant.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/erlang-dark.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/hopscotch.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/icecoder.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/isotope.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/lesser-dark.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/liquibyte.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/material.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/mbo.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/mdn-like.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/midnight.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/monokai.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/neat.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/neo.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/night.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/paraiso-dark.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/paraiso-light.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/pastel-on-dark.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/railscasts.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/rubyblue.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/seti.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/solarized.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/the-matrix.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/tomorrow-night-bright.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/tomorrow-night-eighties.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/ttcn.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/twilight.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/vibrant-ink.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/xq-dark.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/xq-light.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/yeti.css"/>
<link rel="stylesheet" href="../../resources/component/codemirror/theme/zenburn.css"/>

<title>codemirror通用语法编辑器</title>

</head>
<body>
	
	
	<a:codemirrortool id="codetool" theme="true" fontsize="true" lowercases="true" uppercase="true" redo="true" undo="true"></a:codemirrortool>
	<a:codemirror id="code" mode="text/x-sql" smartIndent="true" lineWrapping="true" lineNumbers="true" matchBrackets="true" autocomplete="Ctrl-0" fullScreen="F7"/>
</body>
</html>
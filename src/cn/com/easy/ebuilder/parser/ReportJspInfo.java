package cn.com.easy.ebuilder.parser;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;

public class ReportJspInfo {

	private String pageInfoSql = "SELECT T.REPORT_NAME PAGEDESC FROM SYS_REPORT_INFO T WHERE T.REPORT_ID = #reportId#";
	private String dimSql = "SELECT REPORT_ID,DIM_VAR_NAME,DIM_VAR_DESC,DIM_TABLE,DIM_COL_CODE,DIM_COL_DESC,DIM_COL_ORD,DIM_ORD "+
                            " FROM SYS_REPORT_VAR_DIM t where t.report_id = #reportId# and t.dim_var_name = #dimvar#";
	public String getHeadHtml() {
		StringBuffer sourceCode = new StringBuffer();
		sourceCode.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		sourceCode.append("<%@page import=\"java.net.URLDecoder\"%>").append("\n");
		sourceCode.append("<%@page import=\"java.net.URLEncoder\"%>").append("\n");
		sourceCode.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">").append("\n");
		sourceCode.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		sourceCode.append("<%@ taglib prefix=\"u\" tagdir=\"/WEB-INF/tags/ebuilder\"%>").append("\n");
		sourceCode.append("<c:resources type=\"easyui,highchart,app\" style=\"b\"/>").append("\n");
		sourceCode.append("<jsp:include page=\"/pages/ebuilder/usepage/common/CommonScript.jsp\" flush=\"true\"/>").append("\n");
		sourceCode.append("<%@ taglib prefix='a' tagdir='/WEB-INF/tags/app'%>").append("\n");
		return sourceCode.toString();
	}
	/**
	 * 
	 * @param reportId 报表ID
	 * @param pagestate 预览OR保存  0 是预览   1是保存
	 * @return
	 * @throws SQLException
	 */
	public String getCommonScript(String reportId,String pagestate) throws SQLException {
		String formpath = "<e:url value=\"/pages/ebuilder/usepage/temp/"+reportId+"/Temp_"+reportId+".jsp\"/>";
		if(pagestate !=null  && pagestate.equals("1")){
			 formpath = "<e:url value=\"/pages/ebuilder/usepage/formal/"+reportId+"/Formal_"+reportId+".jsp\"/>";
		}else{
			formpath = "<e:url value=\"/pages/ebuilder/usepage/temp/"+reportId+"/Temp_"+reportId+".jsp\"/>";
		}
		StringBuffer sourceCode = new StringBuffer();
		//sourceCode.append("<e:style value=\"/pages/ebuilder/pagedesigner/resources/css/formal_page.css\" />").append("\n");//页面生成后样式文件
		//sourceCode.append("<e:script value=\"/pages/ebuilder/pagedesigner/resources/scripts/ebuilder.js\" />").append("\n");//页面生成后JS文件
		//sourceCode.append("<e:style value=\"/pages/ebuilder/pagedesigner/resources/css/main.css\" />").append("\n");//页面生成后样式文件
		//sourceCode.append("<e:script value=\"/pages/ebuilder/pagedesigner/resources/scripts/niceforms.js\" />").append("\n");//页面生成后样式文件
		sourceCode.append("<script type=\"text/javascript\">").append("\n");
		sourceCode.append("   function f_query_"+reportId+"(){").append("\n");
		sourceCode.append("     var path = '"+formpath+"';").append("\n");
		sourceCode.append("     var formParams = \"\";").append("\n");
		sourceCode.append("     var localAddrPathParams = window.location.href;").append("\n");
		sourceCode.append("     if(localAddrPathParams.indexOf(\"?\")!=-1){").append("\n");
		sourceCode.append("        var params = localAddrPathParams.split(\"?\");").append("\n");
		sourceCode.append("        formParams = '?' + params[1];").append("\n");
		sourceCode.append("     }").append("\n");
		sourceCode.append("     path = path + formParams;").append("\n");
		sourceCode.append("     moreSelectSetStringValue();").append("\n");
		sourceCode.append("     $(\"#page_form_"+reportId+"\").attr('action',path);").append("\n");
		sourceCode.append("     $(\"#page_form_"+reportId+"\").attr('method','post');").append("\n");
		sourceCode.append("     $(\"#page_form_"+reportId+"\").submit();").append("\n");
		sourceCode.append("   }").append("\n");
		sourceCode.append("</script>").append("\n");
		return sourceCode.toString();
	}
	public String getPageDesc(String reportId,SqlRunner runner,String report_name) throws SQLException {
		Map parameterMap = new HashMap();
//		parameterMap.put("reportId", reportId);
//		Map Pagers = runner.queryForMap(pageInfoSql, parameterMap);
		StringBuffer sourceCode = new StringBuffer();
//		if(Pagers != null){
//			sourceCode.append(""+Pagers.get("PAGEDESC")).append("\n");
//			sourceCode.append("<title>"+Pagers.get("PAGEDESC")+"</title>").append("\n");
//		}else{
		    sourceCode.append("<html>").append("\n");
			sourceCode.append("<head>").append("\n");
			sourceCode.append("").append("\n").append("<title>"+report_name+"</title>").append("\n").append("");
			
			sourceCode.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">").append("\n");
			sourceCode.append("<meta http-equiv=\"pragma\" content=\"no-cache\">").append("\n");
			sourceCode.append("<meta http-equiv=\"cache-control\" content=\"no-cache\">").append("\n");
			sourceCode.append("<meta http-equiv=\"expires\" content=\"0\">").append("\n");
			sourceCode.append("<meta http-equiv=\"keywords\" content=\"keyword1,keyword2,keyword3\">").append("\n");
			sourceCode.append("<meta http-equiv=\"description\" content=\"This is my page\">").append("\n");
			
			sourceCode.append("</head>").append("\n");
			//sourceCode.append(report_name).append("\n");页面标题先去掉。
//		}
		return sourceCode.toString();
	}
	public String getPageDim(String reportId,SqlRunner runner,String dimhtml,List<Map<String, String>> ResultSets) throws SQLException {
		StringBuffer sourceCode = new StringBuffer();//查询条件 名称去掉title=\"&nbsp;&nbsp;查询条件\"
		sourceCode.append("<body>").append("\n");
		sourceCode.append(" <form id=\"page_form_"+reportId+"\" name=\"page_form_"+reportId+"\">").append("\n");
		sourceCode.append("    <div id=\"dim\" class=\"searchBox1\">").append("\n");
		sourceCode.append("       "+dimhtml).append("\n");
		if(dimhtml.indexOf("CommonReportUploadFile.jsp")>-1){
			String allDatasourceNameStr="";
			String datasourceName=null;
			for (Map<String, String> ResultSet : ResultSets) {
				datasourceName = ResultSet.get("dataSourceName")+"";
				//if (datasourceName != null && !datasourceName.equals("") && !datasourceName.trim().equals("") && !datasourceName.trim().toUpperCase().equals("NULL")){
					if(allDatasourceNameStr.indexOf(datasourceName)==-1){
						allDatasourceNameStr+=datasourceName+"#";
					}
				//}
			}
			if(allDatasourceNameStr.length()>0){
				allDatasourceNameStr = allDatasourceNameStr.substring(0, allDatasourceNameStr.lastIndexOf("#"));
			}
			sourceCode.append("<input type='hidden' id='extdsHidden' value='"+allDatasourceNameStr+"' />");
		}
		sourceCode.append("       <div class=\"Advanced-search-foot\">").append("\n");
		sourceCode.append("         <p><input class=\"easyui-linkbutton\" type=\"button\" onclick=\"f_query_"+reportId+"();\" value=\"查询\"/></p>").append("\n");
		sourceCode.append("       </div>").append("\n");
		sourceCode.append("    </div>").append("\n");
		sourceCode.append("    </div>").append("\n");
		sourceCode.append(" </form>").append("\n");
		return sourceCode.toString();
	}
	public String getPageElement(String reportId,SqlRunner runner,String pagehtml) throws SQLException {
		StringBuffer sourceCode = new StringBuffer();
		String pageSource = pagehtml;
		pageSource = pagehtml.replaceAll("pages/ebuilder/pagedesigner/layout/Style.css", "pages/ebuilder/pagedesigner/resources/css/formal_page.css");
		sourceCode.append(pageSource).append("\n");
		return sourceCode.toString();
	}
	public String getPageDescription(String reportId){
		StringBuffer sourceCode = new StringBuffer();
		//页面信息指标解释
		sourceCode.append("<div id = \"getPageDescription").append(reportId).append("\"></div>").append("\n");
		//对标信息
		sourceCode.append("<div id = \"getDataDbInfo").append(reportId).append("\"></div>").append("\n");
		//页面访问日志
		sourceCode.append("<div id = \"getPageAcLog").append(reportId).append("\"></div>").append("\n");
		//页面评论
		sourceCode.append("<div id = \"getReview").append(reportId).append("\"></div>").append("\n");
		sourceCode.append("<script>").append("\n");
		sourceCode.append("$(function(){").append("\n");
		sourceCode.append("     var info = {};").append("\n");
		sourceCode.append("     info.reportid = '").append(reportId).append("';").append("\n");
		//页面信息指标解释
		sourceCode.append("     $(\"#getPageDescription"+reportId+"\").load('<e:url value=\"/pages/ebuilder/usepage/common/CommonReportDesc.jsp\"/>',info,function(){").append("\n");
		sourceCode.append("  	   $.parser.parse($(\"#getPageDescription").append(reportId).append("\"));").append("\n");
		sourceCode.append("     });").append("\n");
		//对标信息
		sourceCode.append("     var CityDuiBiao"+reportId+" = '${applicationScope[\"CityDuiBiao\"] }';").append("\n");
		sourceCode.append("     if(CityDuiBiao"+reportId+" !=null && CityDuiBiao"+reportId+" !=''&& CityDuiBiao"+reportId+"=='1'){").append("\n");
		sourceCode.append("          $(\"#getDataDbInfo"+reportId+"\").load('<e:url value=\"/pages/ebuilder/usepage/common/CityDuiBiao.jsp\"/>',info,function(){").append("\n");
		sourceCode.append("       	   $.parser.parse($(\"#getDataDbInfo").append(reportId).append("\"));").append("\n");
		sourceCode.append("          });").append("\n");
		sourceCode.append("     }").append("\n");
		//页面访问日志
		sourceCode.append("     var isAccess"+reportId+" = '${applicationScope[\"AcLog\"] }';").append("\n");
		sourceCode.append("     if(isAccess"+reportId+" !=null && isAccess"+reportId+" !=''&& isAccess"+reportId+"=='1'){").append("\n");
		sourceCode.append("          $(\"#getPageAcLog"+reportId+"\").load('<e:url value=\"/pages/ebuilder/usepage/common/CommonReportViewLog.jsp\"/>',info,function(){").append("\n");
		sourceCode.append("       	   $.parser.parse($(\"#getPageAcLog").append(reportId).append("\"));").append("\n");
		sourceCode.append("          });").append("\n");
		sourceCode.append("     }").append("\n");
		//页面评论
		sourceCode.append("     var isReview"+reportId+" = '${applicationScope[\"Review\"] }';").append("\n");
		sourceCode.append("     if(isReview"+reportId+" !=null && isReview"+reportId+" !=''&& isReview"+reportId+"=='1'){").append("\n");
		sourceCode.append("          $(\"#getReview"+reportId+"\").load('<e:url value=\"/pages/ebuilder/usepage/common/CommonReportBbs.jsp\"/>',info,function(){").append("\n");
		sourceCode.append("       	   $.parser.parse($(\"#getReview").append(reportId).append("\"));").append("\n");
		sourceCode.append("          });").append("\n");
		sourceCode.append("     }").append("\n");
		
		sourceCode.append("  });").append("\n");
		sourceCode.append("</script>").append("\n");
		
		
		return sourceCode.toString();
	}
	public String getPageEndTag(){
		StringBuffer sourceCode = new StringBuffer();
		sourceCode.append("</body>").append("\n");
		sourceCode.append("</html>").append("\n");
		return sourceCode.toString();
	}
}

package cn.com.easy.xbuilder.parser;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import net.sf.json.JSONArray;

import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.mbuilder.utils.StringUtil;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Condition;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Dynheadcol;
import cn.com.easy.xbuilder.element.Dynheadstore;
import cn.com.easy.xbuilder.element.Event;
import cn.com.easy.xbuilder.element.Eventstore;
import cn.com.easy.xbuilder.element.Info;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Layout;
import cn.com.easy.xbuilder.element.Legend;
import cn.com.easy.xbuilder.element.Parameter;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.Weblink;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.element.YAxis;
import cn.com.easy.xbuilder.service.CrossService;
import cn.com.easy.xbuilder.service.DataSetService;
import cn.com.easy.xbuilder.service.component.ComponentBaseService;
import cn.com.easy.xbuilder.service.component.CrossTableService;
import cn.com.easy.xbuilder.service.component.DatagridService;
import cn.com.easy.xbuilder.service.component.TreegridService;

public class XGenerateCompPC implements XGenerateComp {
	private final Report report;
	private final String type;
	private final SqlRunner runner;
	private StringBuffer error = new StringBuffer();// 错误信息，如校验错误等
	private final String actionUrl;
	private final Map<Integer, String> num2Abc;// 将excel的列和数字对应，key为数字，值为excel列
	private final String[] defaultColors = new String[]{"#1ea3d5","#d34737","#3b5998", "#1ea3d5","#d34737","#3b5998","#1ea3d5","#d34737","#3b5998","#1ea3d5"};
	private Map<String, String> comp2cont = new HashMap<String, String>();//组件id和容器id对应关系
	public XGenerateCompPC(Report report,String type,SqlRunner runner){
		this.report = report;
		this.type = type;
		this.runner = runner;
		this.actionUrl = "/pages/xbuilder/usepage/" + this.type + "/" + this.report.getId() + "/" + this.type + "_" + this.report.getId() + "Action.jsp?eaction=";
		this.num2Abc = new HashMap<Integer, String>();
		String[] a_z = new String[] { "A", "B", "C", "D", "E", "F", "G", "H",
				"I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
				"U", "V", "W", "X", "Y", "Z" };
		for (int a = 0; a < a_z.length; a++) {
			this.num2Abc.put(a, a_z[a]);
		}
		for (int th_i = 0; th_i < 5; th_i++) {
			for (int th_j = 0; th_j < 26; th_j++) {
				this.num2Abc.put((th_i + 1) * 26 + th_j, a_z[th_i] + a_z[th_j]);
			}
		}
	}
	
	
	// 生成jsp头
	private String generateJspHead() {
		StringBuffer head = new StringBuffer();
		head.append("<%@ page language=\"java\" pageEncoding=\"UTF-8\"%>").append("\n");
		head.append("<%@page import=\"cn.com.easy.ebuilder.parser.CommonTools\"%>").append("\n");
		head.append("<%@ taglib prefix=\"e\" uri=\"http://www.bonc.com.cn/easy/taglib/e\"%>").append("\n");
		head.append("<%@ taglib prefix=\"c\" uri=\"http://www.bonc.com.cn/easy/taglib/c\"%>").append("\n");
		head.append("<%@ taglib prefix=\"a\" tagdir='/WEB-INF/tags/app'%>").append("\n");
		XGenerateAction xga = new XGenerateAction(this.report,this.type,false);
		String transcoding = xga.transformSqlParamURI(xga.getReportDataSet());
		head.append(transcoding);
		DataSetService ser = new DataSetService();
	    String urlParam=ser.getResString(this.report.getId());
	    head.append(urlParam).append("\n");
		return head.toString();
	}
	
	// 生成c:npie
	private String generatePieTag(Component comp) {
		StringBuffer pie = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
		Kpi kpi = comp.getKpiList().get(0);
		
		String colors = comp.getColors();
		String[] customColors = null;
		if(colors != null && !colors.equals("")){
			customColors = colors.split(",");
		}else{
			customColors = this.defaultColors.clone();
		}
		
		String ringSize = comp.getType().toLowerCase().equals("ring")?"40%":"";
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		pie.append("<c:npie ");
		pie.append(this.joinProp(comp.getId(), "id"));
		
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		pie.append(this.joinProp(downParamString, "downParams"));
		
		pie.append(this.joinProp("2", "tipfmt"));
		pie.append(this.joinProp(ringSize, "innerSize"));
		if("1".equals(showTitle)){
			pie.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		if(comp.getYaxisList()!=null&&comp.getYaxisList().size()>0){
			pie.append(this.joinProp(comp.getYaxisList().get(0).getUnit(),"unit"));
		}
		pie.append(this.joinProp("100%", "width"));
		pie.append(this.joinProp(comp.getHeight(), "height"));
		pie.append(this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
			XExtColumn xec = new XExtColumn(this.report);
			String name = xec.getExtColName(kpi.getExtcolumnid());
			pie.append(this.joinProp(name,name));
		}else{
			pie.append(this.joinProp(kpi.getName(),kpi.getField()));
		}
		pie.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		pie.append(this.joinProp("['"+StringUtils.join(customColors,"','")+"']", "colors"));
		pie.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendVerticalAlign","legendLayout"));
		pie.append("/>\n");
		
		return pie.toString();
	}

	// 生成c:nline
	private String generateLineTag(Component comp) {
		StringBuffer line = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		line.append("<c:nline ");
		line.append(this.joinProp(comp.getId(), "id"));
		
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		line.append(this.joinProp(downParamString, "downParams"));

		if("1".equals(showTitle)){
			line.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		line.append(this.joinProp(this.actionUrl+comp.getId()+"${urlParam}", "url"));
		line.append(this.joinProp("100%", "width"));
		line.append(this.joinProp(comp.getHeight(), "height"));
		line.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		line.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout"));
		line.append(this.generateYAxisAndKpi(comp));
		line.append("/>\n");
		
		return line.toString();
	}
	
	// 生成c:nbar
	private String generateBarTag(Component comp) {
		StringBuffer column = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		column.append("<c:nbar ");
		column.append(this.joinProp(comp.getId(), "id"));
		
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		column.append(this.joinProp(downParamString, "downParams"));
		
		if("1".equals(showTitle)){
			column.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		column.append(joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		column.append(this.joinProp("100%", "width"));
		column.append(this.joinProp(comp.getHeight(), "height"));
		column.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		column.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendVerticalAlign","legendLayout"));
		column.append(this.generateYAxisAndKpi(comp) + "/>"+"\n");
		
		return column.toString();
	}

	// 生成c:ncolumn
	private String generateColumnTag(Component comp) {
		StringBuffer column = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		column.append("<c:ncolumn ");
		column.append(this.joinProp(comp.getStacking(), "stacking"));
		column.append(this.joinProp(comp.getId(), "id"));
		
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		column.append(this.joinProp(downParamString, "downParams"));
		
		if("1".equals(showTitle)){
			column.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		column.append(joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		column.append(this.joinProp("100%", "width"));
		column.append(this.joinProp(comp.getHeight(), "height"));
		column.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		column.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout"));
		column.append(this.generateYAxisAndKpi(comp) + "/>"+"\n");
		
		return column.toString();
	}
	// 生成c:catter，指标颜色为#fff时，不设置颜色；非#fff时，替换数组里对应的下标
	private String generateCatterTag(Component comp) {
		StringBuffer catter = new StringBuffer();
		String colors = comp.getColors();
		if(colors == null || colors.equals("")){
			colors = "rgba(255,97,3,.5);rgba(61,145,64,.5);rgba(255,215,0,.5);rgba(107,142,35,.5);rgba(112,128,105,.5);rgba(128,138,135.5)";
		}
		XAxis xAxis = comp.getXaxis();
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		catter.append("<c:scatter ");
		catter.append(this.joinProp(comp.getId(), "id"));
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		catter.append(this.joinProp(downParamString, "downParams"));
		if("1".equals(showTitle)){
			catter.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		catter.append(this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		catter.append(this.joinProp("100%", "width"));
		catter.append(this.joinProp(comp.getHeight()+"px", "height"));
		catter.append(this.generateChatLegend(comp.getLegend(),"showLegend","legendAlign","legendVerticalAlign","legendLayout"));
		catter.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		
		List<YAxis> yaxisList = comp.getYaxisList();
		List<Kpi> kpiList = comp.getKpiList();
		String xaxisText="",indicatorX="",unitX="",yaxisText="",indicatorY="",unitY="";
		XExtColumn xec = new XExtColumn(this.report);
		for(int y=0;y<yaxisList.size();y++){
			YAxis yAxis = yaxisList.get(y);
			if(yAxis.getId().toUpperCase().equals("X")){
				xaxisText = yAxis.getTitle();
				unitX = yAxis.getUnit();
			}else if(yAxis.getId().toUpperCase().equals("Y")){
				yaxisText = yAxis.getTitle();
				unitY = yAxis.getUnit();
			}
			
			Kpi kpi = kpiList.get(y);
			if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
				if(kpi.getYaxisid().toUpperCase().equals("X")){
					indicatorX = xec.getExtColName(kpi.getExtcolumnid());
				}else if(kpi.getYaxisid().toUpperCase().equals("Y")){
					indicatorY = xec.getExtColName(kpi.getExtcolumnid());
				}
			}else{
				if(kpi.getYaxisid().toUpperCase().equals("X")){
					indicatorX = kpi.getField();
				}else if(kpi.getYaxisid().toUpperCase().equals("Y")){
					indicatorY = kpi.getField();
				}
			}
		}
		catter.append(this.joinProp(colors, "colors"));
		catter.append(this.joinProp(indicatorX, "indicatorX")).append(this.joinProp(indicatorY, "indicatorY"));
		catter.append(this.joinProp(xaxisText, "xaxisText")).append(this.joinProp(yaxisText, "yaxisText"));
		catter.append(this.joinProp(unitX, "unitX")).append(this.joinProp(unitY, "unitY")).append("/>\n");
		
		return catter.toString();
	}
	
	// 生成c:ncolumnline
	private String generateCollineTag(Component comp) {
		StringBuffer colline = new StringBuffer();
		XAxis xAxis = comp.getXaxis();
		
		//取标题是否显示（1:是,0:否,默认为1）
		String showTitle = comp.getShowTitle();
		
		colline.append("<c:ncolumnline ");
		colline.append(this.joinProp(comp.getStacking(), "stacking"));
		colline.append(this.joinProp(comp.getId(), "id"));
		
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		colline.append(this.joinProp(downParamString, "downParams"));
		
		if("1".equals(showTitle)){
			colline.append(this.joinProp(comp.getChartTitle(), "title"));
		}
		colline.append(this.joinProp(this.actionUrl + comp.getId()+ "${urlParam}", "url"));
		colline.append(this.joinProp("100%", "width"));
		colline.append(this.joinProp(comp.getHeight(), "height"));
		colline.append(this.joinProp(xAxis.getDimfield(), "dimension"));
		colline.append(this.generateChatLegend(comp.getLegend(),"legend","legendAlign","legendValign","legendLayout"));
		colline.append(this.generateYAxisAndKpi(comp) + "/>");
		colline.append("\n");
		
		return colline.toString();
	}
	
	//通用，生成多轴及指标c:nline,c:ncolum,c:nbar,c:ncolumnline
	private String generateYAxisAndKpi(Component comp) {
		//yaxis="title:一轴,unit:元,min:0;title:二轴,unit:戶;title:三轴,unit:万"
		String colors = comp.getColors();
		String[] customColors = null;
		if(colors != null && !colors.equals("")){
			customColors = colors.split(",");
		}else{
			customColors = this.defaultColors.clone();
		}
		StringBuffer yAxisAndKpiBuf = new StringBuffer();
		yAxisAndKpiBuf.append("yaxis=\"");
		List<YAxis> yAxisList = comp.getYaxisList();
		Map<String,Integer> yAxisOrd = new HashMap<String,Integer>();
		for(int y=0;y<yAxisList.size();y++){
			YAxis yAxis = yAxisList.get(y);
			yAxisOrd.put(yAxis.getId(),y);
			yAxisAndKpiBuf.append(delComma(this.joinPropAll(yAxis.getTitle(), "title")
					+ this.joinPropAll(yAxis.getUnit(), ",unit")
					+ this.joinProps(yAxis.getMin(), ",min")
					+ this.joinProps(yAxis.getMax(), ",max")
					+ this.joinPropAll(yAxis.getColor(), ",color"))
					+";"
			);
		}
		yAxisAndKpiBuf.deleteCharAt(yAxisAndKpiBuf.length()-1).append("\" ");
		List<Kpi> kpis = comp.getKpiList();
		XExtColumn xec = new XExtColumn(this.report);
		for (int i = 0; i < kpis.size(); i++) {
			Kpi kpi = kpis.get(i);
			
			if(null != kpi.getExtcolumnid() && !"".equals(kpi.getExtcolumnid())){
				String name = xec.getExtColName(kpi.getExtcolumnid());
				yAxisAndKpiBuf.append(name + "=\"name:" + name+this.joinProps(String.valueOf(yAxisOrd.get(kpi.getYaxisid())), ",yaxis")+this.joinProps(kpi.getType(), ",type")+this.joinProps(kpi.getColor(), ",color") + "\" ");
			}else{
				yAxisAndKpiBuf.append(kpi.getField() + "=\"name:" + kpi.getName()+this.joinProps(String.valueOf(yAxisOrd.get(kpi.getYaxisid())), ",yaxis")+this.joinProps(kpi.getType(), ",type")+this.joinProps(kpi.getColor(), ",color") + "\" ");
			}
			
			String color = kpi.getColor();
			if(color != null && !color.equals("") && !color.toLowerCase().equals("#fff")){
				customColors[i] = color;
			}
		}
		yAxisAndKpiBuf.append(this.joinProp("['"+StringUtils.join(customColors,"','")+"']", "colors"));
		return yAxisAndKpiBuf.toString();
	}
	
	//通用，图形生成图例
	//attr1 是否显示；attr2 左右对齐legendAlign；attr3 上下对齐verticalAlign；attr4 图例展示方式layout
	private String generateChatLegend(Legend legend,String attr1,String attr2,String attr3,String attr4) {
		if(legend != null){
			//top/bottom/left/right
			StringBuffer legendBuf = new StringBuffer();
			legendBuf.append(this.joinProp(legend.getIsShow(), attr1));
			if(legend.getIsShow().equals("true")){
				String position = legend.getPosition();
				if(position.equals("top")){
					legendBuf.append(this.joinProp("center",attr2));
					legendBuf.append(this.joinProp("top",attr3));
					legendBuf.append(this.joinProp("horizontal",attr4));
				}else if(position.equals("bottom")){
					legendBuf.append(this.joinProp("center",attr2));
					legendBuf.append(this.joinProp("bottom",attr3));
					legendBuf.append(this.joinProp("horizontal",attr4));
				}else if(position.equals("left")){
					legendBuf.append(this.joinProp("left",attr2));
					legendBuf.append(this.joinProp("middle",attr3));
					legendBuf.append(this.joinProp("vertical",attr4));
				}else if(position.equals("right")){
					legendBuf.append(this.joinProp("right",attr2));
					legendBuf.append(this.joinProp("middle",attr3));
					legendBuf.append(this.joinProp("vertical",attr4));
				}
			}
			return legendBuf.toString();
		}
		return "";
	}

	// 生成c:datagrid
	private String generateDatagridTag(Component comp) {
		//定义列
		String column="";
		StringBuffer datagrid = new StringBuffer();
		String lockNum = comp.getTablecollock().equals("1")?comp.getTablecollocknum():"";
		String pagination = comp.getTablepagi();
		String download = comp.getTableexport();
		String theight = (comp.getHeight() != null && !comp.getHeight().equals(""))?comp.getHeight()+"px":"auto";
		String subtotal = comp.getTableshowrowtotal();
		
		String dgurl = subtotal !=null && subtotal.equals("1")?"/datagridsubtotal.e?xid="+this.report.getId()+"&type="+this.type+"&compid=" + comp.getId() + "${urlParam}":this.actionUrl + comp.getId() + "${urlParam}";
		
		lockNum = (lockNum == null || lockNum.equals("")) ? "" : lockNum;
		pagination = (pagination != null && pagination.equals("1"))? "true" :"false";
		download = (download == null || download.equals("0"))?"":comp.getTitle().equals("")?"表格数据下载":comp.getTitle();
		
		//20160602增加自定义分页条数
		String pSize = comp.getTablepaginum();
		String pList = ",10,15,20,25,30,40,50,";
		if(pagination.equals("true") && null != pSize && !"".equals(pSize)){
			pList = pList.indexOf(","+pSize+",")>-1?pList:","+pSize+pList;
			pList = pList.substring(1, pList.length()-1);
		}else{
			pSize = null;
		}
		
		String mergerFields = "";
		List<Datacol> datacols = comp.getDatastore().getDatacolList();
		for(int d=0;d<datacols.size();d++){
			Datacol datacol = datacols.get(d);
			String v = datacol.getDatafmtrowmerge();
			mergerFields += v.equals("1")?datacol.getDatacolcode()+",":"";
		}
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());
		if("temp".equals(type)){//预览时生成标签内容：一直可以导出，不做权限控制
			datagrid.append("<c:datagrid alwaysAllowDown=\"1\" downParams=\""+downParamString+"\" remoteSort=\"true\" fitColumns=\"false\" style=\"width:auto;height:"+theight+";\" id=\""+ comp.getId()+ "\" "
					+ this.joinProp(dgurl,"url")
					+ this.joinProp(pSize,"pageSize")
					+ this.joinProp(pList,"pageList")
					+ this.joinProp(pagination,"pagination")
					+ this.joinProp(download,"download")
					+ this.joinProp(mergerFields,"mergerFields")
					//+ this.joinProp(comp.getWidth(), "width", "grid")
					//+ this.joinProp(comp.getHeight(), "height", "grid")
					+ "select=\"row\" >");
		}else{//保存时生成标签内容
			datagrid.append("<c:datagrid downParams=\""+downParamString+"\" remoteSort=\"true\" fitColumns=\"false\" style=\"width:auto;height:"+theight+";\" id=\""+ comp.getId()+ "\" "
					+ this.joinProp(dgurl,"url")
					+ this.joinProp(pSize,"pageSize")
					+ this.joinProp(pList,"pageList")
					+ this.joinProp(pagination,"pagination")
					+ this.joinProp(download,"download")
					+ this.joinProp(mergerFields,"mergerFields")
					//+ this.joinProp(comp.getWidth(), "width", "grid")
					//+ this.joinProp(comp.getHeight(), "height", "grid")
					+ "select=\"row\" >");
		}
		
		Map<String, String> heads = this.str2Head(comp);
		//获得上一个方法的iscolspan的值（1有，0无）
//		String iscolspan = heads.get("iscolspan");
//		String isrowspan = heads.get("isrowspan");
		//判断是否有锁定列
		if(!"".equals(lockNum)&&lockNum!=null){
			//获得数据源datacol
			List<Datacol> list = comp.getDatastore().getDatacolList();
			//锁定列的形式 column ： {title:'地市编号',field:'AREA_NO',width:100}
			column = joinColCode(list,lockNum,heads,comp);
		}
		datagrid.insert(datagrid.length()-1, " "+this.joinProp(column, "frozenColumns")+" ");
		datagrid.append(heads.get("head").replaceAll("<table>", "").replaceAll(
				"</table>", "").replace("rowspan=\"1\"", "").replace(
				"colspan=\"1\"", ""));
		datagrid.append("</c:datagrid>").append("\n");

		datagrid.insert(0, "</script>\n");
		datagrid.insert(0, heads.get("script"));
		datagrid.insert(0, "<script language=\"javascript\">\n");

		return datagrid.toString();
	}

	// 生成c:treegrid
	private String generateTreegridTag(Component comp) {
		StringBuffer treegrid = new StringBuffer();

		List<Subdrill> subdrills = new ArrayList<Subdrill>(comp.getSubdrills().getSubdrillList());
		ComparatorSubDrill csd = new ComparatorSubDrill();
		Collections.sort(subdrills, csd); 
		
		String dDim = "";
		String hasHeJiDim = comp.getHastotalflag();//是否为虚拟合计
		if(hasHeJiDim != null && hasHeJiDim.equals("1")){
			dDim = "all";
		}
		StringBuffer drill = new StringBuffer();
		if (subdrills != null && subdrills.size() > 0) {
			Map<String,StringBuffer> group = new HashMap<String,StringBuffer>();
/*			for (Subdrill subdrill : subdrills) {
				if (subdrill.getIsdefault().equals("1")) {
					dDim += "," + subdrill.getDrillcode();
				}
				String groupName = subdrill.getGroup();
				if(groupName == null || groupName.equals("")){
					drill.append("<c:dimension label=\"" + subdrill.getDrillcoltitle()
							+ "\" field=\"" + subdrill.getDrillcode()
							+ "\" "
							+ this.joinProp(subdrill.getLevel(), "level")
							+ "></c:dimension>").append("\n");
				}else{
					StringBuffer tmpBuf = group.get(groupName);
					if(tmpBuf != null && tmpBuf.length()>0){
						tmpBuf.append("<c:dimension group= \""+groupName+"\" label=\"" + subdrill.getDrillcoltitle()
								+ "\" field=\"" + subdrill.getDrillcode()
								+ "\" "
								+ this.joinProp(subdrill.getLevel(), "level")
								+ "></c:dimension>").append("\n");
					}else{
						StringBuffer newBuf = new StringBuffer();
						newBuf.append("<c:dimensionGroup label=\""+groupName+"\" menuWidth=\"140\">");
						newBuf.append("<c:dimension group= \""+groupName+"\" label=\"" + subdrill.getDrillcoltitle()
								+ "\" field=\"" + subdrill.getDrillcode()
								+ "\" "
								+ this.joinProp(subdrill.getLevel(), "level")
								+ "></c:dimension>").append("\n");
						group.put(groupName, newBuf);
					}
				}
			}*/
			Map<Integer,String> subdrillMap = new HashMap<Integer,String>();
			int num = -1;
			for (Subdrill subdrill : subdrills) {
				if (subdrill.getIsdefault().equals("1")) {
					dDim += "," + subdrill.getDrillcode();
				}
				
				String groupName = subdrill.getGroup();
				if(groupName == null || groupName.equals("")){
					StringBuffer tmpBuff = new StringBuffer();
					tmpBuff.append("<c:dimension label=\"" + subdrill.getDrillcoltitle()
							+ "\" field=\"" + subdrill.getDrillcode()
							+ "\" "
							+ this.joinProp(subdrill.getLevel(), "level")
							+ "></c:dimension>").append("\n");
					num++;
					subdrillMap.put(num, tmpBuff.toString());
				}else{
					StringBuffer tmpBuf = group.get(groupName);
					if(tmpBuf != null && tmpBuf.length()>0){
						tmpBuf.append("<c:dimension group= \""+groupName+"\" label=\"" + subdrill.getDrillcoltitle()
								+ "\" field=\"" + subdrill.getDrillcode()
								+ "\" "
								+ this.joinProp(subdrill.getLevel(), "level")
								+ "></c:dimension>").append("\n");
					}else{
						StringBuffer newBuf = new StringBuffer();
						newBuf.append("<c:dimensionGroup label=\""+groupName+"\" menuWidth=\"140\">");
						newBuf.append("<c:dimension group= \""+groupName+"\" label=\"" + subdrill.getDrillcoltitle()
								+ "\" field=\"" + subdrill.getDrillcode()
								+ "\" "
								+ this.joinProp(subdrill.getLevel(), "level")
								+ "></c:dimension>").append("\n");
						group.put(groupName, newBuf);
						num++;
						subdrillMap.put(num, "☆"+groupName);
					}
				}
			}
			if(group.values().size()>0){
				for(StringBuffer v:group.values()){
					v.append("</c:dimensionGroup>").append("\n");
				}
			}
			for(int d=0;d<=num;d++){
				String str = subdrillMap.get(d);
				if(str.startsWith("☆")){
					drill.append(group.get(str.substring(1)));
				}else{
					drill.append(str);
				}
			}
		}
		dDim = dDim.equals("")?subdrills.get(0).getDrillcode():dDim;
		String download = (comp.getTableexport()== null || comp.getTableexport().equals("0"))?"":comp.getTitle().equals("")?"下钻数据下载":comp.getTitle();
		Map<String, String> heads = this.str2Head(comp);
		
		DataSetService ser = new DataSetService();
		String downParamString=ser.getResDimsionString(report.getId());

		if("temp".equals(type)){//预览时生成标签内容：一直可以导出，不做权限控制
			treegrid.append("<c:treegrid id=\""
					+ comp.getId()
					+ "\" downParams=\""+downParamString+"\" idField=\""+comp.getIdfield()+"\" treeField=\""+comp.getTreefield()+"\" "
					+ this.joinProp(comp.getTreefieldtitle(), "treeFieldTitle")
					+ this.joinProp(comp.getFieldwidth(), "treeFieldWidth")
					+ this.joinProp(this.actionUrl + comp.getId() + "${urlParam}","url") + " defaultDim=\""+ dDim + "\" "
					+ this.joinProp(download,"download")
					+ this.joinProp(comp.getContextmenuwidth(), "menuWidth") + " alwaysAllowDown=\"1\" >");
			treegrid.insert(0,heads.get("head"));
			treegrid.append(drill.toString());
			treegrid.append("</c:treegrid>\n");
			
			if(!"".equals(download)){
				treegrid.append("<c:export id=\""+comp.getId()+"\" fileName=\""+download+"\" alwaysAllowDown=\"1\" />\n");
			}
		}else{//保存时生成标签内容
			treegrid.append("<c:treegrid id=\""
					+ comp.getId()
					+ "\" downParams=\""+downParamString+"\" idField=\""+comp.getIdfield()+"\" treeField=\""+comp.getTreefield()+"\" "
					+ this.joinProp(comp.getTreefieldtitle(), "treeFieldTitle")
					+ this.joinProp(comp.getFieldwidth(), "treeFieldWidth")
					+ this.joinProp(this.actionUrl + comp.getId() + "${urlParam}","url") + " defaultDim=\""+ dDim + "\" "
					+ this.joinProp(download,"download")
					+ this.joinProp(comp.getContextmenuwidth(), "menuWidth") + " >");
			treegrid.insert(0,heads.get("head"));
			treegrid.append(drill.toString());
			treegrid.append("</c:treegrid>\n");
			
			if(!"".equals(download)){
				treegrid.append("<c:export id=\""+comp.getId()+"\" fileName=\""+download+"\"/>\n");
			}
		}
		treegrid.insert(0, "</script>\n");
		treegrid.insert(0, heads.get("script"));
		treegrid.insert(0, "<script language=\"javascript\">\n");
		return treegrid.toString();
	}
	
	//处理Condition
	public String transCondition(List<Condition> list){
		String tmp = "";
		for(int i=0;i<list.size();i++){
			Condition condi = list.get(i);
			String cnd = condi.getCond();
			if(!"".equals(cnd)){
				if(i==0){
					tmp+="?"+cnd;
				}else{
					tmp+="&"+cnd;
				}
			}
		}
		return tmp;
	}
	
	//生成页面模版
	public String generateWebLateTag(Component comp){
		StringBuffer webLate = new StringBuffer();
		//用户输入的url
		String userUrl = comp.getUserUrl();
		//取weblink
		Weblink weblink = comp.getWeblink();
		//iframe属性id
		String id = comp.getId();
		//iframe属性width
		String width = comp.getWidth();
		//String w = String.valueOf(Math.ceil(Integer.parseInt(width)*1.19));
		//iframe属性height
		String height = comp.getHeight();
		//iframe属性scrolling
		String scrolling = "auto";
		//iframe属性frameborder
		String frameborder = "0";
		if(weblink!=null){
			List<Condition> list = weblink.getCondition();
			String cnd = this.transCondition(list);
			if(!"".equals(cnd)){
				userUrl+=cnd;
			}
		}
		webLate.append("<iframe ");
		webLate.append("id='"+id+"' ");
		webLate.append("src='"+userUrl+"' ");
		webLate.append("width='100%' ");
		webLate.append("height='"+height+"' ");
		webLate.append("scrolling='"+scrolling+"' ");
		webLate.append("frameborder='"+frameborder+"' ");
		webLate.append("</iframe>");
		return webLate.toString();
	}
	
	
	//生成旋转表方法
	@SuppressWarnings("unchecked")
	public Map<String,String> generateCrossTableTag(Component comp,String sql,Map<String,String> paramMap,String reportId ){
		//返回的值
		Map<String,String> crosstab = new HashMap<String,String>();
		String title ="";
		String jsonData = "";
		String rowsData="";
		String rowType ="";
		String style="";
		String script="";
		String width = comp.getWidth();
		String height = comp.getHeight();
		Map dataMap = new HashMap();
		try{
			style="width:"+width+";height:"+height;
			//交叉表生成方法
			CrossService cross = new CrossService(comp,reportId,this.type,paramMap);
			//执行sql
			List<Map> resList = (List<Map>) runner.queryForMapList(sql,paramMap);
			//1列表，2树形
			rowType = comp.getRowtype();
			
			if("1".equals(rowType)){
				Map titleMap = cross.createTitle(comp,resList);
				title = (String)titleMap.get("title");
				List<String> kpiValue = (List<String>) titleMap.get("kpiValue");
				script = (String)titleMap.get("script");
				rowsData = cross.getRowsData(comp);
				dataMap = cross.getDataJson(comp, resList,kpiValue);
				//json格式字符串
				String jsonStr = (String)dataMap.get("jsonStr");
				//listMap格式
				List<Map> jsonList = (List<Map>) dataMap.get("jsonList");
				
				JSONArray json = JSONArray.fromObject(jsonList);
				jsonData = json.toString();
				
			}else if("2".equals(rowType)){
				
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}

		crosstab.put("style", style);
		crosstab.put("rowType", rowType);
		crosstab.put("rowsData", rowsData);
		crosstab.put("jsonData", jsonData);
		crosstab.put("title", title);
		crosstab.put("script", script);
		crosstab.put("height", height);
		return crosstab;
	}
	
	
	
	// 生成所有组件，根据类型调用具体的每个组件生成方法。
	private boolean generateTag() {
		boolean code = true;
		List<Component> comps = new ArrayList<Component>();
		List<Container> containers = this.report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			String popId = container.getPop();
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				String w = containers.get(c).getWidth();
				String h = (Integer.parseInt(containers.get(c).getHeight())-40)+"";
				for(int p=0;p<components.size();p++){
					if(popId.equals(components.get(p).getId())){
						components.get(p).setWidth("780");
						components.get(p).setHeight("445");
					}else{
						if("treegrid".equals(components.get(p).getType().toLowerCase())&&("1".equals(components.get(p).getTableexport()))){//下钻表格并且有导出时，把导出行（30像素）留出来
							components.get(p).setWidth(w);
							components.get(p).setHeight((Integer.parseInt(h)-46)+"");
						}else{
							components.get(p).setWidth(w);
							components.get(p).setHeight((Integer.parseInt(h)-10)+"");
						}
						
					}
					this.comp2cont.put(components.get(p).getId(), container.getId());
				}
				comps.addAll(components);
			}
		}
		if (comps == null || comps.size() <= 0) {
			return false;
		}
		
		StringBuffer tag = new StringBuffer();
		String jspheadString = this.generateJspHead();
		for (Component comp : comps) {
			tag.append(jspheadString);
			//tag.append("<div class=\"mbuliderC\">\n");
			//tag.append(this.joinTitle(comp.getTitle())).append("\n");
			tag.append("<div>\n");
			
			String type = this.getCompKind(comp.getType().toLowerCase());
			//废弃水印
//			String pcWaterMark = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("XPCWaterMark"));
//			if(null != pcWaterMark && !"".equals(pcWaterMark) && pcWaterMark.equals("1")){
//				tag.append("<a:watermark id=\""+comp.getId()+"\"/>\n");
//			}
			
			if (type.equals("pie")) {
				tag.append(this.generatePieTag(comp));
			} else if (type.equals("line")) {
				tag.append(this.generateLineTag(comp));
			} else if (type.equals("bar")) {
				tag.append(this.generateBarTag(comp));
			} else if (type.equals("column")) {
				tag.append(this.generateColumnTag(comp));
			} else if (type.equals("scatter")) {
				tag.append(this.generateCatterTag(comp));
			} else if (type.equals("columnline")) {
				tag.append(this.generateCollineTag(comp));
			} else if (type.equals("datagrid")) {
				//跟据源数据datastore中的DatacolList中的tablecolcode排序
				Collections.sort(comp.getDatastore().getDatacolList(),new TableColCode());
				tag.append(this.generateDatagridTag(comp));
			} else if (type.equals("treegrid")) {
				tag.append(this.generateTreegridTag(comp));
			} else if (type.equals("crosstable111")) {
				//未实现
			} else if(type.equals("weblate")){
				tag.append(this.generateWebLateTag(comp));
			}
			//tag.append("</div></div>\n");
			tag.append("</div>\n");
			String root = this.getClass().getClassLoader().getResource("/").getPath().replace("WEB-INF/classes/", "/");
			String path = "pages/xbuilder/usepage/" + this.type + "/" + this.report.getId() + "/comp_" + comp.getId() + ".jsp";
			boolean opt = this.newFile(root + path, tag.toString(),"comp_" + comp.getId() + ".jsp");
			if(!opt){
				code = false;
				this.error.append("||||生成"+comp.getTitle()+"_"+comp.getType()+"组件时发生错误");
				break;
			}else{
				tag.delete(0, tag.length()-1);
			}
		}
		return code;
	}
	
	
	/**
	 * 表格使用。将xml中头源数据，解析为组件可用的头代码。 1、删除掉没使用的td 2、剃掉td中所有的class和style样式。
	 * 3、将设置的td属性，添加进来，如宽度，格式化等。 4、删除掉没使用的tr 2014-10-31 修改：返回为map，包含表头和列的格式化函数
	 */
	private Map<String, String> str2Head(Component comp) {

		/**
		 * 将所有列添加到map中，这样只需要循环一次。
		 */
		Map<String, Datacol> datacolMaps = new HashMap<String, Datacol>();
		List<Datacol> datacols = comp.getDatastore().getDatacolList();
		Map<String, String> codes = new HashMap<String, String>();
		
		for (Datacol datacol : datacols) {
			datacolMaps.put(Integer.parseInt(datacol.getTablerowcode())-1 + "_"+ datacol.getTablecolcode(), datacol);
		}

		String compType = comp.getType();
		StringBuffer formatterbuff = new StringBuffer();
		StringBuffer formWidth = new StringBuffer();
		StringBuffer head = new StringBuffer();
		StringBuffer script = new StringBuffer();
		if(compType.toLowerCase().equals("datagrid")){
			head.append("<table><thead>");
		}else{
			head.append("<table id=\""+comp.getId()+"\" style=\"width:auto;height:"+comp.getHeight()+"px;\"><thead>");
		}
		
		Document doc = Jsoup.parse("<table>" + comp.getHeadui().getText()+ "</table>");
		Elements trs = doc.select("tr");
		String lockNum = comp.getTablecollock().equals("1")?comp.getTablecollocknum():"";
		lockNum = (lockNum == null || lockNum.equals("")) ? "" : lockNum;
		int num =0;
		//开关 用于下一个方法判断是否有合并（1有，0无）
		String iscolspan="0";
		//判断是否有锁定列
		if(!"".equals(lockNum)&&lockNum!=null){
			num = Integer.valueOf(lockNum);
		}
		// 删除无用的td和添加td属性
		Pattern p = Pattern.compile("\\s*|\t|\r|\n");
		String isrowspan = "";
		for (Element tr : trs) {
			tr.select("th").remove();
			Elements tds = tr.select("td");
			for (Element td : tds) {
				Matcher m = p.matcher(td.text());
				if (this.notNull(m.replaceAll("")) && this.notNull(td.attr("ishead")) && td.attr("ishead").equals("1")) {
					td.removeAttr("class").removeAttr("style");
					String col = td.attr("tdInd");
					
					if(compType.toLowerCase().equals("treegrid") && col.equals("1")){
						td.remove();
						continue;
					}
					
					String rows = td.attr("istt").replaceAll("td", "");
					String rowspan = td.attr("rowspan");
					//存入判断列锁定
					isrowspan+=rowspan;
					String colspan = td.attr("colspan");
					if(rowspan != null && !rowspan.equals("")){
						int rowtmp = Integer.parseInt(rowspan)-1;
						rows = String.valueOf(rowtmp+Integer.parseInt(rows));
					}
					col = this.num2Abc.get(Integer.parseInt(col) - 1);
					Datacol datacol = datacolMaps.get(rows+ "_" + col);
					
					if("".equals(rowspan)){
						
					}
					
					//锁定列移出（如果有合并，锁定列不做操作）
					if(!"".equals(colspan)&&colspan!=null){
						int colint = Integer.valueOf(colspan);
						if(colint>1){
							//设定有合并
							iscolspan="1";
						}else{
							if(num>0){
								td.remove();
							}
						}
					}else{
						if(num>0){
							td.remove();
						}
					}
					num--;
					
					String tmptxt = td.text();
					if(tmptxt.indexOf("<")>0){
						Pattern pattern = Pattern.compile("<.*(?i)(br)+.*>");
						Matcher matcher = pattern.matcher(tmptxt);
						td.text(matcher.replaceAll("（BR）"));
					}
					
					if (datacol == null) {
						continue;
					}
					
					//String tdWidth = datacol.getTableheadwidth();
					String filed = datacol.getDatacolcode();
					String align = datacol.getDatafmtalign();
					
/*					if (notNull(tdWidth)) {
						td.attr("width", tdWidth);
					}*/

					if (notNull(filed)) {
						//td.attr("field", filed.toUpperCase());
						td.attr("field", filed);
						if(compType.toLowerCase().equals("datagrid")){
							String isSort = (String)EasyContext.getContext().get("xremotesort");
							if(null != isSort && "1".equals(isSort)){
								td.attr("sortable","true");
							}
						}
						if(compType.toLowerCase().equals("treegrid")){
							td.attr("sortable","true");
						}
					}
					if (notNull(align)) {
						td.attr("align", align);
					}else{
						if(datacol.getDatacoltype().equals("dim")) {
							td.attr("align", "center");
						}else{
							td.attr("align", "right");
						}
					}
					
					//设置宽度
					String width = td.attr("width");
					if(!"".equals(width) && width!=null){
						formWidth.append(datacol.getDatacolcode()+","+width+";");
					}
					String styleStr = td.attr("style");
					if(("".equals(width) || width==null) && ("".equals(styleStr) || styleStr==null || styleStr.indexOf("width")<=0)){
						td.attr("width", "100");
					}
					

					// 以下四者有其一选中，需要生成格式化函数
					boolean isFmtBD = notNull(datacol.getDatafmtisbd())	&& datacol.getDatafmtisbd().toLowerCase().equals("1");// 格式化数据：是否设置边界判断
					boolean dFmtT = !datacol.getDatafmttype().equals("common");// 格式化数据类型
					boolean dFmtTD = notNull(datacol.getDatafmtthousand())&& datacol.getDatafmtthousand().toLowerCase().equals("1");// 格式化数据：是否显示千位符
					boolean dArrow = notNull(datacol.getDatafmtisarrow())&& datacol.getDatafmtisarrow().toLowerCase().equals("1");// 格式化数据：是否显示增减箭头
					boolean event = (datacol.getEventstore() != null && datacol.getEventstore().getEventList() != null&& datacol.getEventstore().getEventList().size() >0)?true:false;//联动
					
					String suffixUP = dArrow ? "&uarr;" : "";// ↑
					String suffixDW = dArrow ? "&darr;" : "";// ↓
					if (isFmtBD || dFmtTD || dArrow || dFmtT || event) {
						String fun1 = datacol.getTablecolcode() + "_"+comp.getId();
						td.attr("formatter", fun1);
						//格式化
						formatterbuff.append(datacol.getDatacolcode()+","+fun1+";");
						
						script.append("function getQParams_"+comp.getId()+"(node, params){").append("\n");
						script.append("params[node.DIM] = node."+comp.getIdfield()+";").append("\n");
						script.append("var parent = $('#"+comp.getId()+"').treegrid('getParent',node."+comp.getIdfield()+");").append("\n");
						script.append("if(parent!=null){").append("\n");
						script.append("getQParams_"+comp.getId()+"(parent, params);").append("\n");
						script.append("}").append("\n");
						script.append("}").append("\n");
						
						script.append("function " + fun1 + "(val,obj){").append("\n");
						script.append("var v = val;").append("\n");
						if(dFmtT){
							if (datacol.getDatafmttype().equals("percent")) {
								script.append("v = transformValue(obj." + filed + ","+ datacol.getDatadecimal()+ ",100,'%'," + dFmtTD + ");").append("\n");
							} else {
								script.append("v = transformValue(obj." + filed + ","+ datacol.getDatadecimal()+ ",1,''," + dFmtTD + ");").append("\n");
							}
						}
						if (isFmtBD) {
							script.append("if(obj." + filed + " >= "+ datacol.getDatafmtisbdvalue()+ "){").append("\n");
							script.append("v='<font color="+ datacol.getDatafmtbdup()+ ">'+v+'" + suffixUP+ "</font>';").append("\n");
							script.append("}else{").append("\n");
							script.append("v='<font color="+ datacol.getDatafmtbddown()+ ">'+v+'" + suffixDW+ "</font>';").append("\n");
							script.append("}").append("\n");
						}
						script.append("return v;}");
						
						if(event){
							DataSetService ser = new DataSetService();
							Map<String,String> parammap = ser.getResObj(this.report.getId());
							Eventstore eventstore = datacol.getEventstore();
							Map<String,StringBuffer> paraMap = new HashMap<String,StringBuffer>();
							StringBuffer paraObj_Value = new StringBuffer();
							StringBuffer paraValue = new StringBuffer();
							StringBuffer paraStrs = new StringBuffer();
							List<Event> events = eventstore.getEventList();
							String fieldexd = "";
							if(this.report.getInfo().getType().equals("2")){
								fieldexd = "_CODE";
							}
							String allParam =",";//取出重复的参数
							for(int e=0;e<events.size();e++){
								StringBuffer paraObj = new StringBuffer();
								List<Parameter> parameters = events.get(e).getParameterList();
								if(parameters != null && parameters.size()>0){
									for(int para=0;para<parameters.size();para++){
										String value = parameters.get(para).getValue()+fieldexd;
										if(value != null && !value.equals("")){
											String pname = parameters.get(para).getName();
											paraObj.append(pname+":"+value+",");
											if(parammap.containsKey(pname)){
												parammap.remove(pname);
											}
											if(allParam.indexOf(","+value+",")<0){
												paraObj_Value.append("\\''+obj."+value+"+'\\',");
												paraValue.append(value+",");
												paraStrs.append(pname+"='+"+value+"+'&");
												allParam += value+",";
											}
										}
									}
									if(paraObj.length()>0){
										paraObj.deleteCharAt(paraObj.length()-1).insert(0,"{").append("}");
										paraMap.put(events.get(e).getSource(), paraObj);
									}
								}else{
									paraMap.put(events.get(e).getSource(), paraObj);
								}
							}
							allParam=null;
							if(paraObj_Value.length()>0){
								paraObj_Value.deleteCharAt(paraObj_Value.length()-1);
								paraValue.deleteCharAt(paraValue.length()-1);
								paraStrs.deleteCharAt(paraStrs.length()-1);
							}
							script.delete(script.length()-10, script.length());
							if(compType.toLowerCase().equals("treegrid")){
								String tmpArgs = paraObj_Value.length()>0?paraObj_Value.toString()+",":"";
								script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event("+tmpArgs+"\\''+obj."+comp.getIdfield()+"+'\\');\">");
								script.append("'+v+'</a>';").append("\n}").append("\n");
								String tmpArgs2 = paraValue.length()>0?paraValue.toString()+",":"";
								script.append("function F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event("+tmpArgs2+comp.getIdfield()+"){").append("\n");
							}else{
								script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event("+paraObj_Value.toString()+");\">");
								script.append("'+v+'</a>';").append("\n}").append("\n");
								script.append("function F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event("+paraValue.toString()+"){").append("\n");
							}

							
							StringBuffer treegridJs = new StringBuffer();
							if(compType.toLowerCase().equals("treegrid")){
								treegridJs.append("var node = $('#"+comp.getId()+"').treegrid('find',"+comp.getIdfield()+"),dim = {},dimStr = '&';");
								treegridJs.append("if(node){getQParams_"+comp.getId()+"(node,dim);$.each(dim, function(k,v){dimStr += k+'='+v+'&';});dimStr+='c=1';}else {alert('请选择要连接或联动的数据！');}").append("\n");
							}else{
								treegridJs.append("var dimStr = '&c=1';").append("\n");
							}
							script.append(treegridJs);
							
							String type = datacol.getEventstore().getType();
							if(type.equals("link")){
								String linkurl = events.get(0).getSource();
								script.append("window.open(appBase+'/pages/xbuilder/usepage/formal/"+ linkurl+ "/formal_"+ linkurl + ".jsp?a=1'+dimStr+'&"+paraStrs.toString()+"${urlParam}');");
							}else if(type.equals("cas")){
								for(String key:paraMap.keySet()){
									//StringBuffer paras = paraMap.get(key);
									String queryParam = "";
									if(parammap.size()>0){
										for(String pkey:parammap.keySet()){
											//queryParam += ","+pkey+":'"+parammap.get(pkey);
											queryParam += "&"+pkey+"="+parammap.get(pkey).replaceAll("'","");
										}
									}
									//String postparams = paras.length()>0?paras.insert(paras.length()-1,queryParam).toString():"{}";
									script.append("var divHeadLi_"+key+"=$('#div_head_li_"+this.comp2cont.get(key)+"_"+key+"');\n");
									script.append("if(divHeadLi_"+key+".parent().attr('ultype')=='r'){//切换\n");
									script.append("$('#div_head_li_"+this.comp2cont.get(key)+"_"+key+"').addClass('selected-tab-r').attr('selectLi','true').siblings('li').removeClass('selected-tab-r').removeAttr('selectLi');\n");
									script.append("}else if(divHeadLi_"+key+".parent().attr('ultype')=='l'){//选项卡\n");
									script.append("$('#div_head_li_"+this.comp2cont.get(key)+"_"+key+"').attr('selectLi','true').find('a').addClass('selected-tab-l').parent().siblings('li').removeAttr('selectLi').find('a').removeClass('selected-tab-l');\n");
									script.append("}\n$('#div_body_"+this.comp2cont.get(key)+"').html('');\n");
									script.append("$('#div_body_"+this.comp2cont.get(key)+"').load(appBase+'/pages/xbuilder/usepage/"+this.type+"/"+this.report.getId()+"/comp_"+key+".jsp"+"?componentId="+key+"&containerId="+this.comp2cont.get(key)+"'+dimStr+'&"+paraStrs.toString()+queryParam+"',function(data){\n");
									script.append("$.parser.parse($('#div_body_"+this.comp2cont.get(key)+"'));});\n");
								}
							}
							script.append("\n}");
						}
					}
				} else {
					td.remove();
				}
			}
		}

		// 删除无用的tr
		for (int i = 0; i < trs.size(); i++) {
			Element tr = trs.get(i);
			Elements tds = tr.select("td");
			if (tds == null || tds.size() <= 0) {
				trs.remove(i);
				i--;
			}else{
				for (Element td : tds){
					Dynheadstore dynheadstore = comp.getDynheadstore();
					String headId = td.attr("data-dynheadid");
					if(!"".equals(headId)&&headId!=null){
						if(dynheadstore!=null){
							List<Dynheadcol> dynList = dynheadstore.getDynheadcolList();
							for(Dynheadcol headcol:dynList){
								String id = headcol.getId();
								if(id.equals(headId)){
									String dimsionname = "";
									if("2".equals(headcol.getBindingtype())){
										dimsionname = "${"+headcol.getDimsionname()+"}";
									}
									td.text("<a:dynamic bindingtype=\""+headcol.getBindingtype()+"\" datatype=\""+headcol.getDatatype()+"\" dimsionname=\""+dimsionname+"\" yearstep=\""+headcol.getYearstep()+"\" monthstep=\""+headcol.getMonthstep()+"\" daystep=\""+headcol.getDaystep()+"\" prefixstr=\""+headcol.getPrefixstr()+"\" suffixstr=\""+headcol.getSuffixstr()+"\"></a:dynamic>");
								}
							}
						}
					}
				}
			}
		}
		head.append(trs.toString().replaceAll("<td ", "<th ").replaceAll("</td>","</th>").replaceAll("（BR）","<br/>").replaceAll("&lt;", "<").replaceAll("&quot;", "'").replaceAll("&gt;", ">"));
		head.append("</thead></table>");
		//System.out.println(head.toString());
		
		codes.put("head", head.toString());
		codes.put("script", script.toString());
		codes.put("iscolspan", iscolspan);
		codes.put("isrowspan", isrowspan);
		codes.put("formatter", formatterbuff.toString());
		codes.put("formWidth", formWidth.toString());
		return codes;
	}
	
	// 工具方法，拼接所有组件的title，title需要特殊处理
	private String joinTitle(String title) {
		if (this.notNull(title)) {
			return "<h3><b class=\"icon\"></b>" + title + "</h3>\n";
		} else {
			return "";
		}
	}

	// 工具方法，判断字符串是否为空，剔空格
	private boolean notNull(String s) {
		try {
			if (s != null && !s.equals("") && s.trim().length() > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			return false;
		}
	}
	
	//工具方法，拼装锁定列
	private String joinColCode(List<Datacol> list,String lockNum,Map<String,String> heads,Component comp){
		StringBuffer json = new StringBuffer();
		int num = Integer.valueOf(lockNum);
		//格式化参数转map
		String formatter = heads.get("formatter");
		Map<String,String> col2funmap = new HashMap<String,String>();
		if(formatter !=null && !"".equals(formatter) && formatter.split(";").length>0){
			String [] col2funs = formatter.split(";");
			for(String v:col2funs){
				String[] col2fun =  v.split(",");
				col2funmap.put(col2fun[0], col2fun[1]);
			}
		}
		
		//设置width转map
		String formWidth = heads.get("formWidth");
		Map<String,String> mapWidth = new HashMap<String,String>();
		if(formWidth !=null && !"".equals(formWidth) && formWidth.split(";").length>0){
			String [] width = formWidth.split(";");
			for(String w:width){
				String [] val = w.split(",");
				if(!"".equals(val[1]) && val[1] !=null){
					mapWidth.put(val[0], val[1]);
				}else{
					mapWidth.put(val[0], "100");
				}
				
			}
		}
		//取headui中的锁定列的值
		List<String> LockName = this.getHeaduilockName(comp,num); 
		String tmp = "";
		json.append("[[");
		for(int i=0;i<num;i++){
			Datacol col = list.get(i);
			String datacolcode = col.getDatacolcode();
			String datacoldesc = col.getDatacoldesc();
			String title = LockName.get(i);
			if(!"".equals(title)&&title!=null){
				datacoldesc = title;
			}
			if(col2funmap.get(datacolcode) != null){
				tmp+="{title:'"+datacoldesc+"',field:'"+datacolcode+"',width:"+mapWidth.get(datacolcode)+",formatter:"+col2funmap.get(datacolcode)+"},";
			}else{
				if(mapWidth.get(datacolcode)!=null){
					tmp+="{title:'"+datacoldesc+"',field:'"+datacolcode+"',width:"+mapWidth.get(datacolcode)+"},";
				}else{
					tmp+="{title:'"+datacoldesc+"',field:'"+datacolcode+"'},";
				}
				
			}
			
		}
		tmp = tmp.substring(0,tmp.length()-1);
		json.append(tmp);
		json.append("]]");
		return json.toString();
	}
	
	//取headui中的锁定列的值
	private List<String> getHeaduilockName(Component comp,int num){
		List<String> resList = new ArrayList<String>();
		Document doc = Jsoup.parse("<table>" + comp.getHeadui().getText()+ "</table>");
		Elements trs = doc.select("tr");
		for(int x=0;x<num;x++){
			lable:for(int i=trs.size()-1;i>=0;i--){
				if(i!=trs.size()-1){
					Element tr = trs.get(i);
					Elements tds = tr.select("td");
					for (Element td : tds){
						String tdind = td.attr("tdind");
						String key = String.valueOf(x+1);
						if(key.equals(tdind)){
							resList.add(x,td.text());
							break lable;
						}
					}
				}
			}
		}
		return resList;
	}
	
	// 工具方法，拼接组件的属性值，非空时
	private String joinProp(String v, String k) {
		if (!this.notNull(v)) {
			return k.equals("width") ? k + "=\"auto\" "
					: k.equals("height") ? k + "=\"225\" " : "";
		} else {
			return k + "=\"" + v + "\" ";
		}
	}

	// 工具方法，拼接组件的属性值，非空时
	private String joinProp(String v, String k, String t) {
		if (!this.notNull(v)) {
			if (t.equals("char")) {
				return k.equals("width") ? k + "=\"auto\" " : k
						.equals("height") ? k + "=\"225\" " : "";
			} else if (t.equals("grid")) {
				return "";
			}
			return "";
		} else {
			return k + "=\"" + v + "\" ";
		}
	}

	// 工具方法，拼接组件的属性值，非空时
	private String joinProps(String v, String k) {
		if (!this.notNull(v)) {
			return k.equals("width") ? k + ":auto" : k.equals("height") ? k
					+ ":225" : "";
		} else {
			if (k.equals(",color") && v.equals("#fff")) {
				return "";
			}
			return k + ":" + v;
		}
	}
	// 工具方法，拼接组件的属性值
	private String joinPropAll(String v, String k) {
		return k + ":" + v;
	}

	// 工具方法，处理多余的逗号
	private String delComma(String s) {
		if (this.notNull(s)) {
			if (s.startsWith(",")) {
				s = s.substring(1);
				delComma(s);
			}
			if (s.endsWith(",")) {
				s = s.substring(0, s.length() - 1);
				delComma(s);
			}
			return s;
		} else {
			return "";
		}
	}
	// 返回图形模板类型
	public String getCompKind(String name){
		String[] pies = {"pie","ring"};
		String[] lines = {"line","line2","line3"};
		String[] bars = {"bar","bar2","bar3"};
		String[] columns = {"column","column2","column3"};
		String[] columnline = {"columnline","columnline2","columnline3"};
		String[] scatters = {"scatter"};
		
		String kind = ArrayUtils.contains(pies, name)?"pie":ArrayUtils.contains(lines, name)?"line":ArrayUtils.contains(columns, name)?"column":ArrayUtils.contains(columnline, name)?"columnline":ArrayUtils.contains(bars, name)?"bar":ArrayUtils.contains(scatters, name)?"scatter":name;
		return kind;
	}
	
	private class ComparatorSubDrill implements Comparator{
		public int compare(Object arg0, Object arg1) {
			Subdrill subdrill1 = (Subdrill)arg0,subdrill2 = (Subdrill)arg1;
		
			String v1 = subdrill1.getLevel(),v2 = subdrill2.getLevel();
			return (v1.toLowerCase()).compareTo(v2.toLowerCase());
		}
	}
	
	private boolean tagVerify() {
		try {
			// 验证基本信息和布局等。
			if(StringUtil.getStringValue(report.getId()).equals("")){
				this.error.append("||||<e >严重错误:").append("报表ID获取错误。</e>").append("<br/>\n");
			}
			Info info = this.report.getInfo();
			if(info == null){
				this.error.append("||||<e >严重错误:").append("报表信息初使化错误。</e>").append("<br/>\n");
			}
			if(StringUtil.getStringValue(info.getName()).equals("")){
				this.error.append("||||<e>严重错误:").append("报表报表名称尚未填写。</e>").append("<br/>\n");
			}
			//Dimsions dimsions = this.report.getDimsions();
			Layout layout = this.report.getLayout();
			Datasources datasources = this.report.getDatasources();
			//Query query = this.report.getQuery();
			List<Container> containers = this.report.getContainers().getContainerList();
			//if(containers == null || datasources ==null || query==null||dimsions==null||layout==null)
			if(containers == null || datasources ==null || layout==null)
				this.error.append("||||<e >严重错误:").append("报表源数据初使出错。</e>").append("<br/>\n");
			if(datasources !=null && (datasources.getDatasourceList() ==null || datasources.getDatasourceList().size()<=0)){
				this.error.append("||||<e >严重错误:").append("尚未配置数据集。</e>").append("<br/>\n");
			}
			/*
			if(dimsions !=null && (dimsions.getDimsionList() ==null || dimsions.getDimsionList().size()<=0)){
				errorMessage.append("<e >严重错误:").append("尚未配置数据集。</e>").append("<br/>\n");
			}*/
			if(layout !=null){
				String lv = layout.getValue();
				if(lv == null || lv.equals("")){
					this.error.append("||||<e >严重错误:").append("尚未设置布局或者设置过程中出错。</e>").append("<br/>\n");
				}
			}
		} catch (Exception e) {
			this.error.append("||||"+e.getMessage() + "\n");
		}

		// 是否包含有效组件。
		List<Component> comps = new ArrayList<Component>();
		List<Container> containers = this.report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				comps.addAll(components);
			}
		}
		if (comps.size()==0) {
			this.error.append("||||没有找到组件\n");
		}

/*		try {
			// 验证数据集和维度
			DataSetService dss = new DataSetService();
			String dssresult = dss.validate(this.report);
			if (!dssresult.equals("")) {
				this.error.append(dssresult + "\n");
			}
		} catch (Exception e) {
			this.error.append(e.getMessage() + "\n");
		}*/

		try {
			// 验证所有组件
			for (Component comp : comps) {
				String type = comp.getType().toLowerCase();
				if (type.equals("datagrid")) {
					
					//验证表格方法
					DatagridService val = new DatagridService();
					String res = val.validateComponent(this.report,comp);
					if(!"".equals(res)){
						this.error.append(res+"\n");
					}
				} else if (type.equals("treegrid")) {
					TreegridService cbs = new TreegridService();
					String result = cbs.validateComponent(this.report, comp);
					if (!result.equals("")) {
						this.error.append(result + "\n");
					}
				}else if(type.equals("crosstable")){
					CrossTableService crossService = new CrossTableService();
					String res = crossService.validateComponent(this.report,comp);
					if(!"".equals(res)){
						this.error.append(res+"\n");
					}
				}else{
					ComponentBaseService cbs = new ComponentBaseService();
					String cbsresult = cbs.validateAllChartComponent(this.report, comp);
					if (!cbsresult.equals("")) {
						this.error.append(cbsresult + "\n");
					}
				}
			}
		} catch (Exception e) {
			this.error.append("||||"+e.getMessage() + "\n");
		}
		if(this.error.length()>0){
			return false;
		}else{
			return true;
		}
	}
	// 生成jsp文件
	private boolean newFile(String path, String content,String name) {
		FileOutputStream fos = null;
		try {
			File file = new File(path);
			if (file.exists()) {
				file.delete();
			} else {
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}
			}

			fos = new FileOutputStream(path);
			OutputStreamWriter osw = new OutputStreamWriter(fos, "UTF-8");
			osw.write(content);
			osw.flush();
			this.compList.put(name, content);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			this.error.append("||||"+e.getMessage() + "\n");
			return false;
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
					this.error.append("||||"+e.getMessage() + "\n");
				}
			}
		}
	}
	@Override
	public String comp(XGenerateHtml xhtml) {
		if (!this.tagVerify()) {
			return this.error.toString();
		}
		if(!this.generateTag()){
			return this.error.toString();
		}
		if(!xhtml.saveToFile()){
			return this.error.append("||||生成"+this.report.getInfo().getName()+"报表时失败").toString();
		}
		return "success";
	}
}
package cn.com.easy.xbuilder.service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.servlet.http.HttpServletRequest;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ebuilder.parser.CommonTools;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Components;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Containers;
import cn.com.easy.xbuilder.element.Crosscol;
import cn.com.easy.xbuilder.element.Crosscolstore;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Event;
import cn.com.easy.xbuilder.element.Eventstore;
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Extcolumns;
import cn.com.easy.xbuilder.element.Info;
import cn.com.easy.xbuilder.element.Param;
import cn.com.easy.xbuilder.element.Parameter;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.SortcolStore;
import cn.com.easy.xbuilder.parser.XExtColumn;
public class DataCrossService {

	private String[] colDimArr = null;//列维度
	private String[] rowDimArr = null;//行维度
	private String[] rowDimDescArr = null;//行维度描述
	private String[] kpiArr = null;//指标列
	private String[] kpiDescArr = null;//指标列描述
	private boolean sumRow = false;//是否合计行
	private boolean sumColumn = false;//是否合计列
	private String rowsumposition = "top";//行合计位置
	private String rowSumName = "行合计";
	private String colSumName = "列合计";
	private List<LinkedHashMap<String, String>> originalData = null;//原始数据
	public Map<String,String> preOrderedDimMap=null;//获取下一行表头时参照上一行的维度顺序的map
	//行维度 宽度和对齐方式
	private Map<String,String> dimWidthAlign = new HashMap<String,String>();
	//指标列 宽度和对齐方式
	private Map<String,String> kpiWidthAlign = new HashMap<String,String>();
	//条件map
	private Map<String,String> pMap = new HashMap<String,String>();
	private SqlRunner runner;
	private String reportId="";
	private String fileType="";
	private Component comp;
	private Report report;
	//格式化
	private String script="";
	private List<LinkedHashMap<String, String>> gridList;//执行后的sql结果集
	private String linkFlg = "0";//联动标示
	//构造方法
	public DataCrossService(Component comp,String reportId,String fileType,Map<String,String> paramMap,SqlRunner runner,Report report){
		this.runner = runner;
		this.comp = comp;
		this.report = report;
		this.colDimArr = this.getDataCol(comp);
		this.rowDimArr = this.getDataRow(comp);
		this.rowDimDescArr = this.getDescRow(comp);
		this.kpiArr = this.getDataKpi(comp);
		this.kpiDescArr = this.getDescKpi(comp);
		this.reportId = reportId;
		this.fileType = fileType;
		this.originalData = this.getOriginalData(report, comp, paramMap);
		this.dimWidthAlign = this.getDimWidthAlign(comp);
		this.kpiWidthAlign = this.getKpiWidthAlign(comp);
		this.sumRow = this.getSumRow(comp);
		this.sumColumn = this.getSumColumn(comp);
		this.pMap = this.mapNotNull(paramMap);
		this.rowsumposition = comp.getRowsumposition();
		this.rowSumName = comp.getRowSumName();
		this.colSumName = comp.getColSumName();
	}
	
	/**
	 * 主方法
	 */
	@SuppressWarnings("unchecked")
	public Map<String,String> generateCrossTableTag(Component comp){
		//返回的值
		Map<String,String> crosstab = new HashMap<String,String>();
		String title ="";
		String jsonData = "";
		String rowsData="";
		String rowType ="";
		String style="";
		String width = comp.getWidth();
		String height = comp.getHeight();
		//1列表，2树形
		rowType = comp.getRowtype();
		
		if("1".equals(rowType)){
			title = getTableHead();//获取表头HTML代码
			List<LinkedHashMap> finalData = getTableData();//获取表数据
			rowsData = this.getRowsData(comp);
			//设置联动没得到的参数
			if("1".equals(linkFlg)){
				this.setLinkPageGrid(finalData);
			}
			jsonData = "{'total':'"+finalData.size()+"','rows':"+Functions.java2json(finalData)+"}";
			
		}else if("2".equals(rowType)){
			Map<String,Object> resmap = new HashMap<String,Object>();
			resmap = getTreeTableHead();
			title = (String)resmap.get("headHtml");//获取表头HTML代码
			List<LinkedHashMap> finalData = getTableData();//获取表数据
			//格式化
			List<LinkedHashMap> resList = this.dataFormatTreeJson(finalData);
			
			//判断是否除法计算
			if(isExtcolumns()){
				List tiList = (List)resmap.get("list");
				this.againSum(tiList,resList);
			}
			//System.out.println(resList);
			rowsData=rowDimArr[0];
			jsonData = "{\"total\":"+finalData.size()+",\"rows\":"+Functions.java2json(resList)+"}";
		}
		style="width:"+width+"px;height:"+height+"px;";
		crosstab.put("rowsData", rowsData);
		crosstab.put("script", script);
		crosstab.put("rowType", rowType);
		crosstab.put("title", title);
		crosstab.put("jsonData", jsonData);
		crosstab.put("style", style);
		crosstab.put("height", height);
		return crosstab;
	}
	
	/**
	 * 获取原始数据(旋转前的数据) 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<LinkedHashMap<String, String>> getOriginalData(Report report,Component comp,Map<String,String> paramMap){
		//返回值
		List<LinkedHashMap<String, String>> resList = new ArrayList<LinkedHashMap<String, String>>();
		//源数据中取sql并转换成map形式[id,sql]
		Datasources datasources = report.getDatasources();
		List<Datasource> datasourceList = datasources.getDatasourceList();
		Map<String,String> sqlMap = new HashMap<String,String>();
		//扩展数据源
		Map<String,String> sqlExtds = new HashMap<String,String>();
		for(Datasource datasoruce: datasourceList){
			String id = datasoruce.getId();
			String sqlvale = datasoruce.getSql();
			String extdsValue = datasoruce.getExtds();
			sqlMap.put(id, sqlvale);
			//扩展数据源
			sqlExtds.put(id, extdsValue);
		}
		String datasorceid = comp.getDatasourceid();
		String sql = sqlMap.get(datasorceid);
		Info info = report.getInfo();
		String infoType = info.getType();
		//判断是指标，还是自定义SQL{自定义sql(1)；指标库(2)；立方体(3)}
		if("1".equals(infoType)){
			//获得sql语句中{}的部分 替换为空
			String dataSourceName = sqlExtds.get(datasorceid);
			String tempSql = this.getMeasuresInFormula(sql,paramMap,report,dataSourceName);
			//获得源数据中的sql对象并进行拼装
			sql = this.getSqlByGroup(comp, tempSql);
		}else if("2".equals(infoType)){
			sql = sqlMap.get(datasorceid);
		}
		//把Map对象中value为空的去掉
		Map<String,String> notNullParamMap = this.mapNotNull(paramMap);
		
		try{
			String extds = sqlExtds.get(datasorceid);
			if(!"".equals(extds) && extds!=null){
				//执行sql
				
				resList = (List<LinkedHashMap<String, String>>) runner.queryForMapList(extds,sql,notNullParamMap);
			}else{
				//执行sql
				
				resList = (List<LinkedHashMap<String, String>>) runner.queryForMapList(sql,notNullParamMap);
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		gridList = resList;
		return resList;
	}
	
	/**
	 * 获取表头JSON数据：格式如下
	 * [
	 *	{1月:{1月:1},2月:{2月:1},3月:{3月:1}},
	 *	{1月:{1日:1,2日:1,3日:1},2月:{1日:1,2日:1,3日:1}},
	 *	{1月_1日：{C网:1,宽带:1},1月_2日：{C网:1,宽带:1}},
	 *	{1月_1日_C网:{指标1:1,指标2:1},1月_1日_宽带:{指标1:1,指标2:1}},
	 * ]
	 */
	@SuppressWarnings({ "unchecked"})
	public List<LinkedHashMap<String,LinkedHashMap>> getHeadData(){
		//originalData = getOriginalData();
		List<LinkedHashMap<String,LinkedHashMap>> headDataList = new ArrayList<LinkedHashMap<String,LinkedHashMap>>(); 
		//先初始化所有的表头行，每行为一个空的map
		for(int i=0;i<=colDimArr.length;i++){
			headDataList.add(new LinkedHashMap<String,LinkedHashMap>());
		}
		Map tempOriginalMap;//原始数据行Map
		String tableHeadMapKey; 
		for(int i=0;i<originalData.size();i++){
			tempOriginalMap = originalData.get(i);
			for(int j=0;j<=colDimArr.length;j++){//表头行数=colDimArr.length+1，即列维度个数+指标行个数1
                LinkedHashMap headRowMap = headDataList.get(j);	
                tableHeadMapKey = getTableHeadMapKey(j,tempOriginalMap,colDimArr);
                if(!headRowMap.containsKey(tableHeadMapKey)){//表头行map不存在该key，就put进去
                	headRowMap.put(tableHeadMapKey, new LinkedHashMap<String,Integer>());
            	}
                if(j<colDimArr.length){//列维度行
                    	((LinkedHashMap)headRowMap.get(tableHeadMapKey)).put(tempOriginalMap.get(colDimArr[j]),1);//1为colspan，初始时都设置为1
                }else{//指标行,循环所有指标列,put到行map
                	for(int k=0;k<kpiArr.length;k++){
                		((LinkedHashMap)headRowMap.get(tableHeadMapKey)).put(kpiArr[k],1);
                	}
                }
			}
		}
		//计算colspan的值
		for(int i=headDataList.size()-1;i>0;i--){
			caculateColspan(headDataList.get(i-1),headDataList.get(i));
		}
		//String nodesJson = Functions.java2json(headDataList);
	    //System.out.println("****************旋转后的表头JSON数据:\n"+nodesJson);
	    return headDataList;
	}
	
	
	/**
	 * 获取完整的表头HTML代码
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String getTableHead(){
		String headHtml = "";
		List<LinkedHashMap<String,LinkedHashMap>> headDataList = getHeadData();
		boolean isKpiRow = false;//是否是表头的指标行，即最后一行
		List tempRowDataList;
		for(int i=0;i<headDataList.size();i++){
			isKpiRow = i==headDataList.size()-1;
			tempRowDataList = getHeadRowHtml(headDataList.get(i),preOrderedDimMap,isKpiRow);
			headHtml += (String)tempRowDataList.get(0);//0为本行html
			preOrderedDimMap = (Map)tempRowDataList.get(1);//1为下一次参照的顺序map
		}
		//System.out.println("****************表头HTML代码：\n"+headHtml);
		return headHtml;
	}
	
	/**
	 * 获取完整的表头HTML代码
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Map<String,Object> getTreeTableHead(){
		String headHtml = "";
		List<LinkedHashMap<String,LinkedHashMap>> headDataList = getHeadData();
		boolean isKpiRow = false;//是否是表头的指标行，即最后一行
		List tempRowDataList = new ArrayList();
		for(int i=0;i<headDataList.size();i++){
			isKpiRow = i==headDataList.size()-1;
			tempRowDataList = getTreeHeadRowHtml(headDataList.get(i),preOrderedDimMap,isKpiRow);
			headHtml += (String)tempRowDataList.get(0);//0为本行html
			preOrderedDimMap = (Map)tempRowDataList.get(1);//1为下一次参照的顺序map
		}
		//System.out.println(tempRowDataList);
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("headHtml", headHtml);
		map.put("list", tempRowDataList);
		return map;
	}
	
	/**
     * 获取一行表头的html
     * @param curRowMap 当前循环行的数据
     * @param preRowDimMap 上一行维度的排序map，本行参照该map的顺序
     * @return
     */
	@SuppressWarnings({ "unchecked", "unchecked", "unchecked" })
	public List getHeadRowHtml(Map curRowMap,Map preRowDimMap,boolean isKpiRow){
		String html = "<tr class='ui-th'>";
		Map orderedMap = new LinkedHashMap();
		Iterator<Map.Entry<String, Map>> preDimRowMapEntry ;
		Iterator<Map.Entry<String, Integer>> curDimMapEntry ;
		if(preRowDimMap == null){//上一维度等于null说明是第一行
			for(int i=0;i<rowDimArr.length;i++){//拼接行维度表头
				Map<String,String> fmt = this.strDimHead(comp, rowDimArr[i], i);
				String flg = fmt.get("flg");
				script+=fmt.get("script");
				if("true".equals(flg)){
					html += "<th halign='center'  rowspan='"+(colDimArr.length+1)+"' field='"+rowDimArr[i]+"' "+dimWidthAlign.get(rowDimArr[i])+"  "+fmt.get("tdFmt")+" >"+rowDimDescArr[i]+"</th>";
				}else{
					html += "<th halign='center'  rowspan='"+(colDimArr.length+1)+"' field='"+rowDimArr[i]+"' "+dimWidthAlign.get(rowDimArr[i])+" >"+rowDimDescArr[i]+"</th>";
				}
				
			}
			if(sumRow){
				html += "<th halign='center' width='100' align='center' rowspan='"+(colDimArr.length+1)+"' field='sumValue' >"+rowSumName+"</th>";
			}
			preDimRowMapEntry = curRowMap.entrySet().iterator();
			while (preDimRowMapEntry.hasNext()) {
				curDimMapEntry = preDimRowMapEntry.next().getValue().entrySet().iterator();
				while(curDimMapEntry.hasNext()){
					Map.Entry<String, Integer> tempEntry = curDimMapEntry.next();
					if(isKpiRow){
						html+="<th halign='center' field='"+String.valueOf(tempEntry.getKey())+"' >"+String.valueOf(tempEntry.getKey()) +"</th>" ;
					}else{
						html+="<th halign='center' colspan='"+String.valueOf(tempEntry.getValue())+"'>"+String.valueOf(tempEntry.getKey()) +"</th>" ;
					}
					orderedMap.put(tempEntry.getKey(), tempEntry.getKey());//将key值orderedMap中作为下一次循环参照的顺序
				}
			}
		}else{
			preDimRowMapEntry = preRowDimMap.entrySet().iterator();
			Map tempCurRowMap;
			String preRowDimMapKey;
			int j=0;
			while (preDimRowMapEntry.hasNext()) {
				preRowDimMapKey = String.valueOf(preDimRowMapEntry.next().getKey());
				tempCurRowMap = (Map)curRowMap.get(preRowDimMapKey);
				curDimMapEntry = tempCurRowMap.entrySet().iterator();
				while(curDimMapEntry.hasNext()){
					Map.Entry<String, Integer> tempEntry = curDimMapEntry.next();
					if(isKpiRow){//说明是表头最后一行，即指标行，拼接field
						//是否有格式化
						Map<String,String> fmt = this.strKpiHead(comp, tempEntry.getKey(),preRowDimMapKey+"_"+tempEntry.getKey(),j);
						String flg = fmt.get("flg");
						script+=fmt.get("script");
						if("true".equals(flg)){
							html+="<th halign='center' field='"+toHexString(preRowDimMapKey+"_"+tempEntry.getKey())+"' "+kpiWidthAlign.get(tempEntry.getKey())+" "+fmt.get("tdFmt")+" >"+getKpiDescByKpiCode(tempEntry.getKey()) +"</th>" ;
						}else{
							//System.out.println(preRowDimMapKey+"_"+tempEntry.getKey());
							html+="<th halign='center' field='"+toHexString(preRowDimMapKey+"_"+tempEntry.getKey())+"' "+kpiWidthAlign.get(tempEntry.getKey())+" >"+getKpiDescByKpiCode(tempEntry.getKey()) +"</th>" ;
						}
						
					}else{
						html+="<th halign='center' colspan='"+tempEntry.getValue()+"'>"+tempEntry.getKey() +"</th>"  ;
					}
					orderedMap.put(preRowDimMapKey+"_"+tempEntry.getKey(), preRowDimMapKey+"_"+tempEntry.getKey());
					j++;
				}
			}
		}
		html+="</tr>";
		List resultList = new ArrayList();
		resultList.add(html);
		resultList.add(orderedMap);
		return resultList;
	}
	
	/**
	 * 根据指标字段名查找指标描述名
	 * @param code
	 * @return
	 */
	private String getKpiDescByKpiCode(String code){
		String kpiDesc = "";
		for(int i=0;i<kpiArr.length;i++){
			if(kpiArr[i].equals(code)){
				kpiDesc = kpiDescArr[i];
			}
		}
		return kpiDesc;
	}
	
	/**
     * 获取一行表头的html
     * @param curRowMap 当前循环行的数据
     * @param preRowDimMap 上一行维度的排序map，本行参照该map的顺序
     * @return
     */
	@SuppressWarnings({ "unchecked", "unchecked", "unchecked" })
	public List getTreeHeadRowHtml(Map curRowMap,Map preRowDimMap,boolean isKpiRow){
		String html = "<tr class='ui-th'>";
		Map orderedMap = new LinkedHashMap();
		Iterator<Map.Entry<String, Map>> preDimRowMapEntry ;
		Iterator<Map.Entry<String, Integer>> curDimMapEntry ;
		if(preRowDimMap == null){//上一维度等于null说明是第一行
			Report report = new Report();
			XBaseService base = new XBaseService();
			report = base.readFromXmlByViewId(reportId);
			Info info = report.getInfo();
			String ltype = info.getLtype();
			//ltype 1PC模式，非1手机模式
			if("1".equals(ltype)){
				for(int i=0;i<1;i++){//拼接行维度表头
					Map<String,String> fmt = this.strDimHead(comp, rowDimDescArr[i], i);
					String flg = fmt.get("flg");
					script+=fmt.get("script");
					if("true".equals(flg)){
						html += "<th halign='center'  rowspan='"+(colDimArr.length+1)+"' field='"+rowDimArr[i]+"' "+dimWidthAlign.get(rowDimArr[i])+"  "+fmt.get("tdFmt")+" >"+rowDimDescArr[i]+"</th>";
					}else{
						html += "<th halign='center'  rowspan='"+(colDimArr.length+1)+"' field='"+rowDimArr[i]+"' "+dimWidthAlign.get(rowDimArr[i])+" >"+rowDimDescArr[i]+"</th>";
					}
				}
			}
			if(sumRow){
				html += "<th halign='center' width='50' align='center' rowspan='"+(colDimArr.length+1)+"' field='sumValue' >"+rowSumName+"</th>";
			}
			preDimRowMapEntry = curRowMap.entrySet().iterator();
			while (preDimRowMapEntry.hasNext()) {
				curDimMapEntry = preDimRowMapEntry.next().getValue().entrySet().iterator();
				while(curDimMapEntry.hasNext()){
					Map.Entry<String, Integer> tempEntry = curDimMapEntry.next();
					if(isKpiRow){
						html+="<th halign='center' field='"+tempEntry.getKey()+"' >"+tempEntry.getKey() +"</th>" ;
					}else{
						html+="<th halign='center' colspan='"+tempEntry.getValue()+"'>"+tempEntry.getKey() +"</th>" ;
					}
					orderedMap.put(tempEntry.getKey(), tempEntry.getKey());//将key值orderedMap中作为下一次循环参照的顺序
				}
			}
		}else{
			preDimRowMapEntry = preRowDimMap.entrySet().iterator();
			Map tempCurRowMap;
			String preRowDimMapKey;
			int j=0;
			while (preDimRowMapEntry.hasNext()) {
				preRowDimMapKey = preDimRowMapEntry.next().getKey();
				tempCurRowMap = (Map)curRowMap.get(preRowDimMapKey);
				curDimMapEntry = tempCurRowMap.entrySet().iterator();
				while(curDimMapEntry.hasNext()){
					Map.Entry<String, Integer> tempEntry = curDimMapEntry.next();
					if(isKpiRow){//说明是表头最后一行，即指标行，拼接field
						//是否有格式化
						Map<String,String> fmt = this.strKpiHead(comp, tempEntry.getKey(),preRowDimMapKey+"_"+tempEntry.getKey(),j);
						String flg = fmt.get("flg");
						script+=fmt.get("script");
						if("true".equals(flg)){
							html+="<th halign='center' field='"+toHexString(preRowDimMapKey+"_"+tempEntry.getKey())+"' "+kpiWidthAlign.get(tempEntry.getKey())+" "+fmt.get("tdFmt")+" >"+getKpiDescByKpiCode(tempEntry.getKey()) +"</th>" ;
						}else{
							//System.out.println(preRowDimMapKey+"_"+tempEntry.getKey());
							html+="<th halign='center' field='"+toHexString(preRowDimMapKey+"_"+tempEntry.getKey())+"' "+kpiWidthAlign.get(tempEntry.getKey())+" >"+getKpiDescByKpiCode(tempEntry.getKey()) +"</th>" ;
						}
						
					}else{
						html+="<th halign='center' colspan='"+tempEntry.getValue()+"'>"+tempEntry.getKey() +"</th>"  ;
					}
					orderedMap.put(preRowDimMapKey+"_"+tempEntry.getKey(), preRowDimMapKey+"_"+tempEntry.getKey());
					j++;
				}
			}
		}
		html+="</tr>";
		List resultList = new ArrayList();
		resultList.add(html);
		resultList.add(orderedMap);
		return resultList;
	}
	
	
	
	/**
	 * 获取表头行map的key值
	 * @param curRowIndex 当前要获取行的行下标
	 * @param rowDataMap 当前行的数据map
	 * @param colDimArr 列维度数组
	 * @return
	 */
	public String getTableHeadMapKey(int curRowIndex,Map<String,String> rowDataMap,String[] colDimArr){
		String resultKey = "";
		if(colDimArr.length>0){
			if(curRowIndex == 0){
				resultKey = String.valueOf(rowDataMap.get(colDimArr[0]));
			}else{
				for(int i=0;i<curRowIndex;i++){
					resultKey+=String.valueOf(rowDataMap.get(colDimArr[i]))+"_";//当前行数据中map的key值为所有当前维度的上级维度值的拼接，如当前维度是acct_day，则key值为acct_month_acct_day
				}
				resultKey = resultKey.substring(0,resultKey.lastIndexOf("_"));
			}
		}else{
			resultKey = "KPI";
		}
		
		return resultKey;
	}
	
	/**
	 * 根据下一行数据计算出本行th合并多少个单元格
	 * @param curRowMap 当前要计算的行的数据map
	 * @param nextRowMap 当前行的下一行数据map
	 */
	@SuppressWarnings({ "unchecked" })
	public void caculateColspan(Map curRowMap,Map nextRowMap){
		Iterator<Map.Entry<String, Map>> curRowEntries = curRowMap.entrySet().iterator();
		String curRowKey;
		Map temCurRowpMap;
		String curRowInnerEntryKey;
		Map tempNextRowMap;
		while (curRowEntries.hasNext()) {
		    Map.Entry<String, Map> curRowEntry = curRowEntries.next();
		    curRowKey = curRowEntry.getKey();
		    temCurRowpMap = curRowEntry.getValue();
		    Iterator<Map.Entry<String, Integer>> curRowInnerEntries = temCurRowpMap.entrySet().iterator();
		    while (curRowInnerEntries.hasNext()) {
		    	Map.Entry<String, Integer> curRowInnerEntry = curRowInnerEntries.next();
		    	curRowInnerEntryKey = String.valueOf(curRowInnerEntry.getKey());
		    	tempNextRowMap = (Map)nextRowMap.get(curRowKey+"_"+curRowInnerEntryKey);//从下一行map中取个数，本行外层map的key值拼接上里层map的key值即为下一行外层map的key值，循环下一行内层map，并将下一行内层map的colspan相加，即得到本行的colspan值
		    	if(tempNextRowMap==null){//
		    		tempNextRowMap = (Map)nextRowMap.get(curRowKey);//第一行和第二行key值相同，特殊处理
		    	}
		    	Iterator<Map.Entry<String, Integer>> nextRowInnerEntries = tempNextRowMap.entrySet().iterator();
		    	int colspan = 0;
		    	while (nextRowInnerEntries.hasNext()) {
		    		Map.Entry<String, Integer> nextRowInnerEntry = nextRowInnerEntries.next();
		    		colspan+=nextRowInnerEntry.getValue();
		    	}
		    	curRowInnerEntry.setValue(colspan);
		    }
		}
	}
	
	
	/**
	 * 获取旋转后的表格数据
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<LinkedHashMap> getTableData(){
		//originalData = getOriginalData();
		List<LinkedHashMap> resultDataList = new ArrayList<LinkedHashMap>();
		Map tempDataMap;
		Map allRowDimDataMap = new HashMap();
		String tempRowDimKey="";
		String resultRowDimKey="";
		String kpiFieldName="";
		for(int i=0;i<originalData.size();i++){
			tempDataMap=originalData.get(i);
			tempRowDimKey = "";
			for(int j=0;j<rowDimArr.length;j++){
				tempRowDimKey += tempDataMap.get(rowDimArr[j])+"_";
			}
			tempRowDimKey = tempRowDimKey.lastIndexOf("_")!=-1?tempRowDimKey.substring(0,tempRowDimKey.lastIndexOf("_")):tempRowDimKey;
			if(!allRowDimDataMap.containsKey(tempRowDimKey)){
				allRowDimDataMap.put(tempRowDimKey, tempRowDimKey);
				resultDataList.add(new LinkedHashMap());
				for(int k=0;k<rowDimArr.length;k++){
					resultDataList.get(resultDataList.size()-1).put(rowDimArr[k],tempDataMap.get(rowDimArr[k]));
				}
			}
			for(Map resultRowMap : resultDataList){
				resultRowDimKey="";
				for(int k=0;k<rowDimArr.length;k++){
					resultRowDimKey += resultRowMap.get(rowDimArr[k])+"_";
				}
				resultRowDimKey = resultRowDimKey.lastIndexOf("_")!=-1?resultRowDimKey.substring(0,resultRowDimKey.lastIndexOf("_")):resultRowDimKey;
				if(tempRowDimKey.equals(resultRowDimKey)){
					kpiFieldName = "";
					for(int n=0;n<colDimArr.length;n++){
						kpiFieldName+=tempDataMap.get(colDimArr[n])+"_";
					}
					for(int m = 0;m<kpiArr.length; m++){
						resultRowMap.put(toHexString(kpiFieldName+kpiArr[m]), tempDataMap.get(kpiArr[m]));
						//resultRowMap.put(kpiFieldName+kpiDescArr[m], tempDataMap.get(kpiArr[m]));
					}
				}
			}
		}
		//被0方法
//		List<LinkedHashMap<String,LinkedHashMap>> headDataList = getHeadData();
//		System.out.println(headDataList.get(headDataList.size()-1));
//		System.out.println(resultDataList);
//		LinkedHashMap<String,LinkedHashMap> titleMap = headDataList.get(headDataList.size()-1);
		
		//行合计
		if(sumRow){
			String sum = "0";
			String tempKey;
			for(LinkedHashMap tempMap : resultDataList){
					sum = "0";
				    Iterator<Map.Entry<String, String>> entries = tempMap.entrySet().iterator();
				    while (entries.hasNext()) {
				    	Map.Entry<String, String> entry = entries.next();
				    	tempKey = entry.getKey();
				    	int i=0;
				    	for(;i<rowDimArr.length;i++){
				    		if(tempKey.equals(rowDimArr[i])){
				    			break;
				    		}
				    	}
				    	if(i==rowDimArr.length){
				    		Object obj = entry.getValue();
				    		if(obj!=null){
				    			String s = String.valueOf(obj);
				    			BigDecimal tValue = new BigDecimal(s);
				    			BigDecimal sValue = new BigDecimal(sum);
					    		sum = sValue.add(tValue).toString();
				    		}
				    	}
				    }
				    tempMap.put("sumValue", sum);
			}
		}
		//列合计
		if(sumColumn){
			LinkedHashMap<String,Object> sumColMap = new LinkedHashMap();
			String tempKey;
			for(LinkedHashMap<String,String> tempMap : resultDataList){
				    Iterator<Map.Entry<String, String>> entries = tempMap.entrySet().iterator();
				    while (entries.hasNext()) {
				    	Map.Entry<String, String> entry = entries.next();
				    	tempKey = entry.getKey();
				    	int i=0;
				    	for(;i<rowDimArr.length;i++){
				    		if(tempKey.equals(rowDimArr[i])){
				    			break;
				    		}
				    	}
				    	if(i==rowDimArr.length){
				    		if(!sumColMap.containsKey(tempKey)){
				    			String tmpVlaue = tempMap.get(tempKey)==null?"0":String.valueOf(tempMap.get(tempKey));
				    			sumColMap.put(tempKey, tmpVlaue);
				    		}else{
				    			String tmpVlaue = tempMap.get(tempKey)==null?"0":String.valueOf(tempMap.get(tempKey));
				    			String tmpSumVlaue = sumColMap.get(tempKey)==null?"0":String.valueOf(sumColMap.get(tempKey));
				    			//保留2位小数
				    			//DecimalFormat df = new DecimalFormat("#.00");  
				    			BigDecimal tValue = new BigDecimal(tmpVlaue);
				    			BigDecimal sValue = new BigDecimal(tmpSumVlaue);
				    			//Float s = (Float.parseFloat(tmpSumVlaue) + Float.parseFloat(tmpVlaue));
				    			String sum = tValue.add(sValue).toString();
				    			sumColMap.put(tempKey, sum);
				    		}
				    	}
				    }
			}
			if(rowDimArr.length>0){
				sumColMap.put(rowDimArr[rowDimArr.length-1], colSumName);
			}
			
			//System.out.println("sumColMap=="+sumColMap);
			//判断是否除法计算
			if(isExtcolumns()){
				//this.againSum(tiList,resList);
				Extcolumns extcolumns = report.getExtcolumns();
				if(null!=extcolumns && extcolumns.getExtcolumnList()!=null){
					List<Extcolumn> extcolumnList = extcolumns.getExtcolumnList();
					for(Extcolumn extcolumn:extcolumnList){
						String formula = extcolumn.getFormula();
						if(formula.indexOf("/")!=-1){
							this.calculationSum(sumColMap, extcolumn, null);
						}
					}
				}
			}
			
			//合计位置
			if("top".equals(rowsumposition)){
				resultDataList.add(0,sumColMap);
			}else{
				resultDataList.add(sumColMap);
			}
			
		}
		//System.out.println("****************最终数据为:\n"+Functions.java2json(resultDataList));
		return resultDataList;
	}
	
	
	/**
	 *  获得 列维度，行维度，行维度描述，指标列，指标列描述
	 */
	//列维度
	public String[] getDataCol(Component comp){
		String[] data = null;
		List<String> list = new ArrayList<String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol cross:crosscolList){
			String type = cross.getType();
			if("2".equals(type)){
				list.add(cross.getDimfield());
			}
		}
		if(list!=null&&list.size()>0){
			data = (String[])list.toArray(new String[list.size()]);
		}
		return data;
	}
	
	//获得行维度
	public String[] getDataRow(Component comp){
		String[] data = null;
		List<String> list = new ArrayList<String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			String type = cross.getType();
			if("1".equals(type)){
				list.add(cross.getDimfield());
			}
		}
		if(list!=null&&list.size()>0){
			data = (String[])list.toArray(new String[list.size()]);
		}
		return data;
	}
	
	//行维度描述
	public String[] getDescRow(Component comp){
		String[] data = null;
		List<String> list = new ArrayList<String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol cross:crosscolList){
			String type = cross.getType();
			if("1".equals(type)){
				list.add(cross.getDimdesc());
			}
		}
		if(list!=null&&list.size()>0){
			data = (String[])list.toArray(new String[list.size()]);
		}
		return data;
	}
	
	//获得指标
	public String[] getDataKpi(Component comp){
		String[] data = null;
		List<String> list = new ArrayList<String>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			list.add(datacol.getDatacolcode());
		}
		if(list!=null&&list.size()>0){
			data = (String[])list.toArray(new String[list.size()]);
		}
		return data;
	}
	
	//获得指标描述
	public String[] getDescKpi(Component comp){
		String[] data = null;
		List<String> list = new ArrayList<String>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			list.add(datacol.getTablecoldesc());
		}
		if(list!=null&&list.size()>0){
			data = (String[])list.toArray(new String[list.size()]);
		}
		return data;
	}
	
	//去掉Map对象为空的值
	@SuppressWarnings("static-access")
	public Map<String,String> mapNotNull(Map<String,String> paramMap){
		CommonTools commontools_type = new CommonTools();
		Map<String,String> res = new HashMap<String,String>();
		String istranscode = String.valueOf(EasyContext.getContext().getServletcontext().getAttribute("xtranscode"));
		for(Map.Entry<String, String> map : paramMap.entrySet()){
			String isMessyCode_type="";
			String isMessyCode_type_type="";
			if(map.getValue()!=null&&!"".equals(map.getValue())){
				
				if(null != istranscode && "1".equals(istranscode)){
					try{
						isMessyCode_type = map.getValue();
						isMessyCode_type = isMessyCode_type!=null?new String(isMessyCode_type.getBytes("ISO-8859-1"),"UTF-8"):"";
						isMessyCode_type_type = map.getValue();
						isMessyCode_type_type = isMessyCode_type_type!=null?new String(isMessyCode_type_type.getBytes("ISO-8859-1"),"gb2312"):"";
					}catch(Exception e){
						e.printStackTrace();
					}
					//转码
					if(!commontools_type.isMessyCode(isMessyCode_type)){
						res.put(map.getKey(),isMessyCode_type);
					}
					else if(!commontools_type.isMessyCode(isMessyCode_type_type)){
						res.put(map.getKey(),isMessyCode_type_type);
					}
				}else{
					res.put(map.getKey(),map.getValue());
				}
				
			}
		}
		return res;
	}
	
	//获得sql语句中{}的部分 替换为空
	public String getMeasuresInFormula(String formula,Map<String,String> paramMap,Report report,String dataSourceName) {
		String condtype = paramMap.get("condtype");
		if(!"1".equals(condtype)){
			//设置默认值
			paramMap = this.setDefaultvalue(paramMap, report);
		}
		List<String> measures = new ArrayList<String>();
		Pattern p = Pattern.compile("\\{(.*?)\\}");  
		//替换回车，制表符
		String sql = this.replaceBlank(formula);
		Matcher m = p.matcher(sql.replaceAll("\r\n", ""));  
		while(m.find()){  
			measures.add(m.group(1));  
		}
		if(measures!=null&&measures.size()>0){
			for(int i=0;i<measures.size();i++){
				String condition = measures.get(i);
				//System.out.println("condition==>"+condition);
				for(Map.Entry<String, String> map : paramMap.entrySet()){
					//System.out.println("map.getKey==="+map.getKey());
					String key = "#"+this.getDragDimsion(map.getKey())+"#";//"#"+map.getKey()+"#";
					String val = map.getValue();
					//System.out.println("key==>"+key);
					//System.out.println("val==>"+val);
					if("".equals(val) || val==null || val=="null"){
						if(condition.indexOf(key)!=-1){
							formula = formula.replace(condition, "");
							break;
						}
					} else {//判断是in的情况
						if(condition.indexOf(key) !=-1) {
							if(isMultiple(report,map.getKey())) {
								String dimtype = getDimsionVarType(key);
								if(null != dimtype && dimtype.equalsIgnoreCase("upload")){//判断上传方法
									String varString = condition.toUpperCase().trim().replaceAll("OR", "").replaceAll("AND", "").replaceAll(key.toUpperCase(), "").replaceAll("=", " ");
									StringBuffer exists = new StringBuffer();
									//判断oracle和行云
									String dsname = CommonTools.getDataSource(dataSourceName).getDataSourceDB();
									if(null != dsname && "" != dsname && dsname.length()>0 && dsname.equalsIgnoreCase("xcloud")){
										exists.append("and "+varString+" in ");
										exists.append("(SELECT a.DATA_CON UUCOLDV  FROM x_report_upload_data a ");
										exists.append("WHERE a.log_id = '"+val+"' ");
										exists.append("and a.DATA_CON = "+varString+" ) ");
									}else{
										exists.append("and exists (");
										exists.append("SELECT a.DATA_CON UUCOLDV  FROM x_report_upload_data a ");
										exists.append("WHERE a.log_id = '"+val+"' ");
										//exists.append("and a.STATE = '1' ");
										exists.append("and a.DATA_CON = "+varString+") ");
									}
									
									formula = formula.replace(condition, exists.toString());
								}else{
									val = "'" + val.replaceAll(",", "','") + "'";
									formula = formula.replace(key, val);
								}
							}
						}
					}
				}
			}
		}
		return formula;
	}
	
	/**
	 * 获是元数据的类型 UPLOAD,INPUT 等 
	 * @param varName
	 * @return
	 */
	public String getDimsionVarType(String varName){
		varName = varName.replaceAll("#", "");
		List<Dimsion> dims = this.report.getDimsions().getDimsionList();
		for (Dimsion dim : dims) {
			if(dim.getVarname().trim().equalsIgnoreCase(varName.trim())){
				return dim.getType().trim();
			}
		}
		return null;
	}
	
	/**
	 * 拖过来的查询条件
	 * @param varname
	 * @return
	 */
	public String getDragDimsion(String str){
		String key = str;
		Dimsions dimsions = this.report.getDimsions();
		List<Dimsion> dims = null != dimsions?dimsions.getDimsionList():null;
		for(Dimsion dim : dims){
			if(dim.getConditiontype().equals("1")){
				if(str.equals(dim.getVarname())){
					Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
				    Matcher matcher = pattern.matcher(dim.getVardesc()); 
				    if(matcher.find()){//中文
				    	key = dim.getVarname();
				    }else{//英文
				    	key = dim.getVardesc();
				    }
				}
			}else{
				key = str;
			}
		}
		return key;
	}
	
	/**
	 * 判断当前查询条件是否是多选
	 * @param report
	 * @param varName
	 * @return
	 */
	public boolean isMultiple(Report report,String varName) {
		Dimsions dimsions = this.report.getDimsions();
		List<Dimsion> dims = null != dimsions?dimsions.getDimsionList():null;
		if(null == dims || dims.size()<=0){
			return false;
		}
		for(Dimsion dim:dimsions.getDimsionList()){
			if(!"1".equals(dim.getIsselectm())) {
				return true;
			}
		}
		return false;
	}
	//查询条件去掉特殊符
	public String replaceBlank(String sql){
		String s="";
		Pattern p = Pattern.compile("\t|\r|\n");
		Matcher m = p.matcher(sql);	
		s = m.replaceAll("");
		return s;
	}
	
	/**
	 * 设置默认值
	 * @param paramMap
	 * @param report
	 */
	public Map<String,String> setDefaultvalue(Map<String,String> paramMap,Report report){
		Dimsions dimsions = report.getDimsions();
		String javaStr = Functions.java2json(paramMap);
		if(dimsions!=null&&dimsions.getDimsionList()!=null){
			List<Dimsion> dimsionList = dimsions.getDimsionList();
			for(Dimsion dim:dimsionList){
				String key = dim.getVarname();
				String val = dim.getDefaultvalue();
				if(!"".equals(val)&&null!=val){
					String tmp = paramMap.get(key);
					if(!"".equals(tmp)&&null!=tmp){
						String str = "\""+key+"\":\""+tmp+"\",";
						paramMap = new HashMap<String,String>();
						javaStr = javaStr.substring(1,javaStr.length());
						javaStr = "{"+str+javaStr;
						paramMap = (Map<String, String>) Functions.json2java(javaStr);
						//paramMap.put(key, tmp);
					}else{
						String temp = paramMap.get(key);
						if("".equals(temp)){
							String valType = dim.getDefaultValueType();
							if("1".equals(valType)){
								paramMap.put(key, val);
							}else{
								HttpServletRequest req = EasyContext.getContext().getRequest();
								Map<String, String> sessionMap = (Map<String, String>) req.getSession().getAttribute("UserInfo");
								String valTmp = sessionMap.get(key);
								paramMap.put(key, valTmp);
							}
						}else{
							String str = "\""+key+"\":\""+val+"\",";
							System.out.println(str);
							paramMap = new HashMap<String,String>();
							javaStr = javaStr.substring(1,javaStr.length());
							javaStr = "{"+str+javaStr;
							paramMap = (Map<String, String>) Functions.json2java(javaStr);
						}
					}
				}
			}
		}
		return paramMap;
		
	}
	
	//取当前Map中的 sql 并 拼装SQL语句
	public String getSqlByGroup(Component comp,String sqlMap){
		StringBuffer sql = new StringBuffer();
		//维度列（用于sql）
		String dimValue = this.getDimValue(comp);
		//指标列（用于sql）
		String kpiValue = this.getKpiValue(comp);
		sql.append("select "+dimValue+","+kpiValue+" ");
		sql.append("from( ");
		sqlMap = sqlMap.replaceAll("\\{", "");
		sqlMap = sqlMap.replaceAll("\\}", "");
		sql.append(sqlMap);
		sql.append(" ) aa ");
		sql.append(" group by "+dimValue+" ");
		//排序
		String order = this.getOrderValue(comp);
		if(!"".equals(order) && order!=null){
			sql.append("order by "+order+" ");
		}
		return sql.toString();
	}
	
	//获得select语句中的维度
	public String getDimValue(Component comp){
		String dim = "";
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol col:crosscolList){
			dim += col.getDimfield()+",";
		}
		
		SortcolStore sorts = comp.getSortcolStore();
		if(sorts!=null){
			List<Sortcol> sortcolList = sorts.getSortcolList();
			if(sortcolList!=null && sortcolList.size()>0){
				for(Sortcol sortcol:sortcolList){
					String extcolumnid = sortcol.getExtcolumnid();
					String orderVal = sortcol.getCol();
					if("".equals(extcolumnid)){
						if("dim".equals(sortcol.getKpitype())){
							if(dim.indexOf(orderVal)==-1){
								dim+=orderVal+",";
							}
						}
					}
				}
			}
		}
		
		
		if(!"".equals(dim)&&dim.length()>0){
			dim = dim.substring(0,dim.length()-1);
		}
		return dim;
	}
	
	//获得select语句中的指标
	public String getKpiValue(Component comp){
		String kpi="";
		String kpitmp = "";
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			kpitmp+= datacol.getDatacolcode()+",";
			//计算列
			String ext = datacol.getExtcolumnid()==null?"":datacol.getExtcolumnid();
			if("".equals(ext)){
				kpi += "sum("+datacol.getDatacolcode()+")  \""+datacol.getDatacolcode()+"\",";
			}else{
				kpi += this.addKpiVale(datacol.getDatacolcode(),ext,report,"col");
			}
		}
		SortcolStore sorts = comp.getSortcolStore();
		if(sorts!=null){
			List<Sortcol> sortcolList = sorts.getSortcolList();
			if(sortcolList!=null && sortcolList.size()>0){
				for(Sortcol sortcol:sortcolList){
					String extcolumnid = sortcol.getExtcolumnid();
					String orderVal = sortcol.getCol();
					String[] kpiArray = kpitmp.split(",");
					if("".equals(extcolumnid)){
						if("kpi".equals(sortcol.getKpitype())){
							if(isInclude(kpiArray,orderVal)){
								kpi+="sum("+orderVal+") \""+orderVal+"\",";
							}
						}
					}else{
						if(isInclude(kpiArray,orderVal)){
							kpi+=this.addKpiVale(orderVal,extcolumnid,report,"col");
						}
						
					}
					
				}
			}
		}
		
		
		
		if(!"".equals(kpi)&&kpi.length()>0){
			kpi = kpi.substring(0,kpi.length()-1);
		}
		return kpi;
	}
	
	//包含指标
	public boolean isInclude(String[]array,String kpi){
		boolean flg = true;
		for(String str:array){
			if(str.equals(kpi)){
				flg = false;
			}
		}
		return flg;
	}
	
	//获得计算列的kpi
	public String getKpiFormulate(Component comp,Report report){
		String kpi="";
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			//计算列
			String ext = datacol.getExtcolumnid()==null?"":datacol.getExtcolumnid();
			if("".equals(ext)){
				kpi += "sum("+datacol.getDatacolcode()+")  \""+datacol.getDatacolcode()+"\",";
			}else{
				kpi += this.addKpiVale(datacol.getDatacolcode(),ext,report,"col");
			}
		}
		if(!"".equals(kpi)&&kpi.length()>0){
			kpi = kpi.substring(0,kpi.length()-1);
		}
		return kpi;
	}
	
	//获得增加的计算列  type＝ord 表示排序 需要加sum
	public String addKpiVale(String datacol,String ext,Report report,String type){
		String kpi="";
		StringBuffer kpiTmp = new StringBuffer();
		String paramRange="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		Map<String,String> map = this.getParamMap(ext, report);
		Map<String,String> resMap = new HashMap<String,String>();
		Extcolumns extcolumns = report.getExtcolumns();
		XExtColumn xec = new XExtColumn(this.report);
		if(extcolumns!=null){
			List<Extcolumn> extcolumnList = extcolumns.getExtcolumnList();
			if(extcolumnList!=null){
				for(Extcolumn column:extcolumnList){
					if(ext.equals(column.getId())){
						String formula = column.getFormula();
						for(int i=0;i<formula.length();i++){
							char tempChar  = formula.charAt(i);
							if(paramRange.indexOf(tempChar+"")!=-1){
								kpi+="sum("+map.get(tempChar+"")+")";
								resMap.put(tempChar+"", "sum("+map.get(tempChar+"")+")");
							}else{
								kpi+=tempChar;
							}
						}
						kpiTmp = xec.divisor2decode(formula, resMap, false,datacol);
					}
				}
			}
		}
		kpi = kpiTmp.toString();
		if("ord".equals(type)){
			kpi = "sum("+kpi+")";
		}else{
			kpi = kpi+",";
		}
		return kpi;
	}
	
	
	//把param的值转换成map对象
	public Map<String,String> getParamMap(String ext,Report report){
		Map<String,String> map = new HashMap<String,String>();
		Extcolumns extcolumns = report.getExtcolumns();
		if(extcolumns!=null){
			List<Extcolumn> extcolumnList = extcolumns.getExtcolumnList();
			if(extcolumnList!=null){
				for(Extcolumn column:extcolumnList){
					if(ext.equals(column.getId())){
						List<?> paramList = column.getParamList();
						if(paramList!=null){
							for(int p=0;p<paramList.size();p++){
								Object param = paramList.get(p);
								if(param instanceof Param){
									map.put(((Param)param).getName(),((Param)param).getValue());
								}else{
									map.put(((Map<String,String>)param).get("name"),((Map<String,String>)param).get("value"));
								}
							}
						}
					}
				}
			}
		}
		return map;
	}
	
	
	//计算列拼装
	public String getSqlFormulate(Component comp,String sql,Report report){
		StringBuffer fsql = new StringBuffer();
		//维度列（用于sql）
		String dimValue = this.getDimValue(comp);
		//指标列（用于计算列）
		String kpiValue = this.getKpiFormulate(comp,report);
		fsql.append("select "+dimValue+","+kpiValue+" ");
		fsql.append("from ("+sql+") x where 1=1 ");
		
		return fsql.toString();
	}
	
	
	//填加没有存在的排序
	public Map<String,String> addColumnValue(Component comp,String dimValue,String kpiValue){
		Map<String,String> sqlAddMap = new HashMap<String,String>();
		SortcolStore sorts = comp.getSortcolStore();
		String column = dimValue+","+kpiValue;
		if(sorts!=null){
			List<Sortcol> sortcolList = sorts.getSortcolList();
			if(sortcolList!=null && sortcolList.size()>0){
				for(Sortcol sortcol:sortcolList){
					String extcolumnid = sortcol.getExtcolumnid();
					String orderVal = sortcol.getCol();
					if(column.indexOf(orderVal)==-1){
						if("".equals(extcolumnid)){
							if("dim".equals(sortcol.getKpitype())){
								dimValue+=","+orderVal;
							}else if("kpi".equals(sortcol.getKpitype())){
								kpiValue+=",sum("+orderVal+") "+orderVal+" ";
							}
						}else{
							String orderby = this.addKpiVale(orderVal, extcolumnid, report, "ord");
							kpiValue+=","+orderby;
						}
					}
					
				}
			}
		}
		sqlAddMap.put("dimValue", dimValue);
		sqlAddMap.put("kpiValue", kpiValue);
		return sqlAddMap;
	}
	
	//获得select语句中的 排序
	public String getOrderValue(Component comp){
		String order="";
		SortcolStore sorts = comp.getSortcolStore();
		if(sorts!=null){
			List<Sortcol> sortcolList = sorts.getSortcolList();
			if(sortcolList!=null && sortcolList.size()>0){
				for(Sortcol sortcol:sortcolList){
					order += "\""+sortcol.getCol()+"\" "+sortcol.getType()+",";
				}
				if(!"".equals(order)&&order.length()>0){
					order = order.substring(0,order.length()-1);
				}
			}
		}
		return order;
	}
	
	//获得维度dimWidthAlign
	public Map<String,String> getDimWidthAlign(Component comp){
		Map<String,String> map = new LinkedHashMap<String,String>();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			String tmp = "width='"+cross.getTableheadwidth()+"' align='"+cross.getTableheadalign()+"' ";
			map.put(cross.getDimfield(), tmp);
		}
		return map;
	}
	
	//获得指标kpiWidthAlign
	public Map<String,String> getKpiWidthAlign(Component comp){
		Map<String,String> map = new LinkedHashMap<String,String>();
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			String tmp = "width='"+datacol.getTableheadwidth()+"' align='"+datacol.getDatafmtalign()+"' ";
			map.put(datacol.getDatacolcode(), tmp);
		}
		return map;
	}
	
	//是否有行合计
	public boolean getSumRow(Component comp){
		boolean flag = false;
		//合计方式(合计方式:0:不合计、1:行合计、2:列合计、3:行列都合计;默认为0不合计)
		String sumtype = comp.getSumtype();
		if("1".equals(sumtype) || "3".equals(sumtype)){
			flag = true;
		}
		
		return flag;
	}
	
	//是否有行合计
	public boolean getSumColumn(Component comp){
		boolean flag = false;
		//合计方式(合计方式:0:不合计、1:行合计、2:列合计、3:行列都合计;默认为0不合计)
		String sumtype = comp.getSumtype();
		if("2".equals(sumtype) || "3".equals(sumtype)){
			flag = true;
		}
		
		return flag;
	}
	
	//存联动ID
	public Map<String,String> getComp2cont(String reportId,String sourceId){
		Map<String,String> resMap = new HashMap<String,String>();
		XBaseService base = new XBaseService();
		Report report = base.readFromXmlByViewId(reportId);
		Containers containers = report.getContainers();
		List<Container> containerList = containers.getContainerList();
		for(Container container:containerList){
			String containerId= container.getId();
			Components components = container.getComponents();
			List<Component> componentList =components.getComponentList();
			for(Component component :componentList){
				String componentId = component.getId();
				if(sourceId.equals(componentId)){
					resMap.put(sourceId, containerId);
				}
			}
		}
		
		return resMap;
	}
	
	//获得行合并的值
	public String getRowsData(Component comp){
		String rows="";
		String []rowData = null;
		rowData = this.getRowDimKpi(comp);
		if(rowData!=null){
			for(int i=0;i<rowData.length;i++){
				rows += rowData[i]+",";
			}
		}
		if(!"".equals(rows)&&rows!=null){
			rows = rows.substring(0, rows.length()-1);
		}
		return rows;
	}
	
	//获得需要合并的行维度与指标
	public String[] getRowDimKpi(Component comp){
		String[] data = null;
		List<String> list = new ArrayList<String>();
		//维度
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(int i=0;i<crosscolList.size();i++){
			Crosscol cross = crosscolList.get(i);
			String type = cross.getType();
			if("1".equals(type)){
				String datafmtrowmerge = cross.getDatafmtrowmerge();
				if("1".equals(datafmtrowmerge)){
					list.add(cross.getDimfield());
				}
			}
		}
		//指标
		Datastore datastore = comp.getDatastore();
		List<Datacol> datacolList = datastore.getDatacolList();
		for(Datacol datacol:datacolList){
			String datafmtrowmerge = datacol.getDatafmtrowmerge();
			if("1".equals(datafmtrowmerge)){
				list.add(datacol.getDatacolcode());
			}
		}
		if(list!=null&&list.size()>0){
			data = (String[])list.toArray(new String[list.size()]);
		}
		return data;
	}
	
	
	//获取查询条件为js对象
	public Map<String,String> getResObj(String reportId){
		Report report = XContext.getEditView(reportId);
		Map<String,String> parammap = new HashMap<String,String>();
		if(report.getDimsions()!=null&&report.getDimsions().getDimsionList()!=null&&report.getDimsions().getDimsionList().size()>0){
		   for(Dimsion dim : report.getDimsions().getDimsionList()){
			   if (dim.getIsparame().equals("0")) {
				   String value = pMap.get(dim.getVarname());
				   if(value!=null&&!"".equals(value)){
					   parammap.put(dim.getVarname(),value);
				   }
				   
			   }
		   }
		}
		return parammap;
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
	
	/**
	 * 格式化维度
	 */
	private Map<String,String>strDimHead(Component comp,String key,int i){
		Map<String,String> map = new HashMap<String,String>();
		String flg = "";
		String tdFmt="";
		StringBuffer script = new StringBuffer();
		Crosscolstore crosscolstores = comp.getCrosscolstore();
		List<Crosscol> crosscolList = crosscolstores.getCrosscolList();
		for(Crosscol cro:crosscolList){
			String field = cro.getDimfield();
			if(key.equals(field)){
				//联动维度 有没有连动
				boolean event = (cro.getEventstore()!=null && cro.getEventstore().getEventList()!=null && cro.getEventstore().getEventList().size()>0)?true:false;
				if(event){
					this.linkFlg = "1";
					flg="true";
					String fun1 = key + "_"+cro.getId()+i;
					tdFmt = "formatter='"+fun1+"'";
					//拼script方法
					script.append("function " + fun1 + "(val,obj){").append("\n");
					script.append("var v = val;").append("\n");
					
					Map<String,String> parammap = this.getResObj(reportId);
					Eventstore eventstore = cro.getEventstore();
					Map<String,StringBuffer> paraMap = new HashMap<String,StringBuffer>();
					StringBuffer paraObj_Value = new StringBuffer();
					StringBuffer paraValue = new StringBuffer();
					StringBuffer paraStrs = new StringBuffer();
					List<Event> events = eventstore.getEventList();
					Map<String,String> comp2cont = new HashMap<String,String>();
					String fieldexd = "";
					
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
									paraObj_Value.append("\\''+obj."+value+"+'\\',");
									paraValue.append(value+",");
									paraStrs.append(pname+"='+"+value+"+'&");
								}
							}
							if(paraObj.length()>0){
								paraObj.deleteCharAt(paraObj.length()-1).insert(0,"{").append("}");
								paraMap.put(events.get(e).getSource(), paraObj);
								comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
							}
						}else{
							paraMap.put(events.get(e).getSource(), paraObj);
							comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
						}
					}
					if(paraObj_Value.length()>0){
						paraObj_Value.deleteCharAt(paraObj_Value.length()-1);
						paraValue.deleteCharAt(paraValue.length()-1);
						paraStrs.deleteCharAt(paraStrs.length()-1);
					}
					
					script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ cro.getDimfield()+"_event("+paraObj_Value.toString()+");\">");
					script.append("'+v+'</a>';").append("\n}").append("\n");
					script.append("function F"+comp.getId() + "_"+ cro.getDimfield()+"_event("+paraValue.toString()+"){").append("\n");
					
					String type = cro.getEventstore().getType();
					
					if(type.equals("link")){
						String linkurl = events.get(0).getSource();
						String[] parArray = paraValue.toString().split(",");
						if(parArray!=null){
							for(String s:parArray){
								if(!"".equals(s)&&s!=null){
									script.append("if("+s+"=='undefined'){"+s+"=''}");
								}
							}
						}
						script.append("var dimStr= '';");
						script.append("window.open(appBase+'/pages/xbuilder/usepage/formal/"+ linkurl+ "/formal_"+ linkurl + ".jsp?a=1'+dimStr+'&"+paraStrs.toString()+"');");
					}else if(type.equals("cas")){
						for(String k:paraMap.keySet()){
							String queryParam = "";
							if(parammap.size()>0){
								for(String pkey:parammap.keySet()){
									queryParam += "&"+pkey+"="+parammap.get(pkey).replaceAll("'","");
								}
							}
							script.append("var dimStr = '&c=1';").append("\n");
							script.append("var divHeadLi_"+k+"=$('#div_head_li_"+comp2cont.get(k)+"_"+k+"');\n");
							script.append("if(divHeadLi_"+k+".parent().attr('ultype')=='r'){//切换\n");
							script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').addClass('selected-tab-r').attr('selectLi','true').siblings('li').removeClass('selected-tab-r').removeAttr('selectLi');\n");
							script.append("}else if(divHeadLi_"+k+".parent().attr('ultype')=='l'){//选项卡\n");
							script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').attr('selectLi','true').find('a').addClass('selected-tab-l').parent().siblings('li').removeAttr('selectLi').find('a').removeClass('selected-tab-l');\n");
							script.append("}\n$('#div_body_"+comp2cont.get(k)+"').html('');\n");
							script.append("$('#div_body_"+comp2cont.get(k)+"').load(appBase+'/pages/xbuilder/usepage/"+this.fileType+"/"+this.reportId+"/comp_"+k+".jsp"+"?componentId="+k+"&containerId="+comp2cont.get(k)+"'+dimStr+'&"+paraStrs.toString()+queryParam+"',function(data){\n");
							script.append("$.parser.parse($('#div_body_"+comp2cont.get(k)+"'));});\n");
						}
					}
					script.append("\n}");
					
				}
			}
		}
		
		map.put("script", script.toString());
		map.put("tdFmt", tdFmt);
		map.put("flg",flg);
		return map;
	}
	
	/**
	 * 格式化指标
	 */
	private Map<String, String> strKpiHead(Component comp,String key,String filed,int i){
		Map<String,String> map = new HashMap<String,String>();
		String flg = "";
		String tdFmt="";
		Datastore datastore = comp.getDatastore();
		StringBuffer script = new StringBuffer();
		List<Datacol> datacolList = datastore.getDatacolList();
		
		Report report = new Report();
		XBaseService base = new XBaseService();
		report = base.readFromXmlByViewId(reportId);
		Info info = report.getInfo();
		String ltype = info.getLtype();
		
		for(Datacol datacol:datacolList){
			//String datacode = datacol.getDatacolcode();
			String datacode = datacol.getDatacolcode();
			if(key.equals(datacode)){
				// 格式化数据：是否设置边界判断
				boolean isFmtBD = notNull(datacol.getDatafmtisbd())	&& datacol.getDatafmtisbd().toLowerCase().equals("1");
				// 格式化数据类型
				boolean dFmtT = !datacol.getDatafmttype().equals("common");
				// 格式化数据：是否显示千位符
				boolean dFmtTD = notNull(datacol.getDatafmtthousand())&& datacol.getDatafmtthousand().toLowerCase().equals("1");
				// 格式化数据：是否显示增减箭头
				boolean dArrow = notNull(datacol.getDatafmtisarrow())&& datacol.getDatafmtisarrow().toLowerCase().equals("1");
				//联动指标 有没有连动
				boolean event = (datacol.getEventstore() != null && datacol.getEventstore().getEventList() != null&& datacol.getEventstore().getEventList().size() >0)?true:false;//联动
				
				String suffixUP = dArrow ? "&uarr;" : "";// ↑
				String suffixDW = dArrow ? "&darr;" : "";// ↓
				
				//判断是否存在格式化
				if(isFmtBD || dFmtTD || dArrow || dFmtT ||event){
					flg="true";
					String fun1 = toHexString(key) + "_"+comp.getId()+i;
					tdFmt = "formatter='"+fun1+"'";
					//拼script方法
					if("1".equals(ltype)){//1PC;非1手机
						script.append("function " + fun1 + "(val,obj){").append("\n");
						script.append("var v = val;").append("\n");
						script.append("if(v==undefined){v='';}");
					}else{
						script.append("function " + fun1 + "(obj){").append("\n");
						script.append("var v = obj."+toHexString(filed)+";").append("\n");
					}
					
					if(dFmtT){
						if (datacol.getDatafmttype().equals("percent")) {
							script.append("v = transformValue(obj['" + toHexString(filed) + "'],"+ datacol.getDatadecimal()+ ",100,'%'," + dFmtTD + ");").append("\n");
						} else {
							script.append("v = transformValue(obj['" + toHexString(filed) + "'],"+ datacol.getDatadecimal()+ ",1,''," + dFmtTD + ");").append("\n");
						}
					}
					if (isFmtBD) {
						script.append("if(obj['" + toHexString(filed) + "'] >= "+ datacol.getDatafmtisbdvalue()+ "){").append("\n");
						script.append("v='<font color="+ datacol.getDatafmtbdup()+ ">'+v+'" + suffixUP+ "</font>';").append("\n");
						script.append("}else{").append("\n");
						script.append("v='<font color="+ datacol.getDatafmtbddown()+ ">'+v+'" + suffixDW+ "</font>';").append("\n");
						script.append("}").append("\n");
					}
					script.append("return v;}");
					
					if(event){
						Map<String,String> parammap = this.getResObj(reportId);
						Eventstore eventstore = datacol.getEventstore();
						Map<String,StringBuffer> paraMap = new HashMap<String,StringBuffer>();
						StringBuffer paraObj_Value = new StringBuffer();
						StringBuffer paraValue = new StringBuffer();
						StringBuffer paraStrs = new StringBuffer();
						List<Event> events = eventstore.getEventList();
						Map<String,String> comp2cont = new HashMap<String,String>();
						String fieldexd = "";
						
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
										//十六进制
										if(key.equals(value)){
											paraObj_Value.append("\\''+obj."+toHexString(filed)+"+'\\',");
										}else{
											paraObj_Value.append("\\''+obj."+value+"+'\\',");
										}
										paraValue.append(value+",");
										paraStrs.append(pname+"='+"+value+"+'&");
									}
								}
								if(paraObj.length()>0){
									paraObj.deleteCharAt(paraObj.length()-1).insert(0,"{").append("}");
									paraMap.put(events.get(e).getSource(), paraObj);
									comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
								}
							}else{
								paraMap.put(events.get(e).getSource(), paraObj);
								comp2cont = this.getComp2cont(reportId, events.get(e).getSource());
							}
						}
						
						if(paraObj_Value.length()>0){
							paraObj_Value.deleteCharAt(paraObj_Value.length()-1);
							paraValue.deleteCharAt(paraValue.length()-1);
							paraStrs.deleteCharAt(paraStrs.length()-1);
						}
						script.delete(script.length()-10, script.length());
						
						//判断是树还是表格
						String rowType = comp.getRowtype();
						if("1".equals(rowType)){
							script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event"+i+"("+paraObj_Value.toString()+");\">");
						}else{
							String obj = "\\''+obj."+rowDimArr[0]+"+'\\'";
							script.append("return '<a href=\"javascript:void(0);\"  style=\"text-decoration:underline;\" onclick=\"F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event"+i+"("+obj+");\">");
						}
						
						script.append("'+v+'</a>';").append("\n}").append("\n");
						
						script.append("function F"+comp.getId() + "_"+ datacol.getDatacolcode()+"_event"+i+"("+paraValue.toString()+"){").append("\n");
						
						String type = datacol.getEventstore().getType();
						
						if(type.equals("link")){
							String linkurl = events.get(0).getSource();
							String[] parArray = paraValue.toString().split(",");
							if(parArray!=null){
								for(String s:parArray){
									if(!"".equals(s)&&s!=null){
										script.append("if("+s+"=='undefined'){"+s+"=''}");
									}
								}
							}
							script.append("var dimStr= '';");
							script.append("window.open(appBase+'/pages/xbuilder/usepage/formal/"+ linkurl+ "/formal_"+ linkurl + ".jsp?a=1'+dimStr+'&"+paraStrs.toString()+"&${urlParam}');");
						}else if(type.equals("cas")){
							for(String k:paraMap.keySet()){
								String queryParam = "";
								if(parammap.size()>0){
									for(String pkey:parammap.keySet()){
										queryParam += "&"+pkey+"="+parammap.get(pkey).replaceAll("'","");
									}
								}
								script.append("var dimStr = '&c=1';").append("\n");
								script.append("var divHeadLi_"+k+"=$('#div_head_li_"+comp2cont.get(k)+"_"+k+"');\n");
								script.append("if(divHeadLi_"+k+".parent().attr('ultype')=='r'){//切换\n");
								script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').addClass('selected-tab-r').attr('selectLi','true').siblings('li').removeClass('selected-tab-r').removeAttr('selectLi');\n");
								script.append("}else if(divHeadLi_"+k+".parent().attr('ultype')=='l'){//选项卡\n");
								script.append("$('#div_head_li_"+comp2cont.get(k)+"_"+k+"').attr('selectLi','true').find('a').addClass('selected-tab-l').parent().siblings('li').removeAttr('selectLi').find('a').removeClass('selected-tab-l');\n");
								script.append("}\n$('#div_body_"+comp2cont.get(k)+"').html('');\n");
								script.append("$('#div_body_"+comp2cont.get(k)+"').load(appBase+'/pages/xbuilder/usepage/"+this.fileType+"/"+this.reportId+"/comp_"+k+".jsp"+"?componentId="+k+"&containerId="+comp2cont.get(k)+"'+dimStr+'&"+paraStrs.toString()+queryParam+"',function(data){\n");
								script.append("$.parser.parse($('#div_body_"+comp2cont.get(k)+"'));});\n");
							}
						}
						script.append("\n}");
						
					}
				}
			}
		}
		map.put("script", script.toString());
		map.put("tdFmt", tdFmt);
		map.put("flg",flg);
		return map;
	}
	
	//转换十六进制
	public String toHexString(String s) {
		String str = "";
		for (int i = 0; i < s.length(); i++) {
			int ch = (int) s.charAt(i);
			String s4 = Integer.toHexString(ch);
			str = str + s4;
		}
		return "a" + str;//0x表示十六进制
		//return s;
	}
	
	
	/**
	 * 树型用的方法
	 */
	//格式化 json变成treejson
	@SuppressWarnings("unchecked")
	public List<LinkedHashMap> dataFormatTreeJson(List<LinkedHashMap> resultDataList){
		if(sumColumn){
			if("top".equals(this.rowsumposition)){
				LinkedHashMap lastMap = resultDataList.get(0);
				resultDataList.remove(0);
				resultDataList.add(lastMap);
			}
		}
		List<LinkedHashMap> newResultDataList = new ArrayList<LinkedHashMap>();
		Map<String,String> rootKeyMap = new HashMap<String,String>();
		String tmpRowDimKey;
		LinkedHashMap curAddLinkMap ;
		LinkedHashMap childrenMap = null;
		Iterator<Map.Entry<String, String>> rowEntries;
		String tempKey;
		for(Map resultRowMap : resultDataList){
				tmpRowDimKey = resultRowMap.get(rowDimArr[0])+"";
				if(!rootKeyMap.containsKey(tmpRowDimKey)){
					rootKeyMap.put(tmpRowDimKey, tmpRowDimKey);
					curAddLinkMap = new LinkedHashMap();
					newResultDataList.add(curAddLinkMap);
					curAddLinkMap.put("id", UUID.randomUUID().toString().replaceAll("-", ""));
					curAddLinkMap.put(rowDimArr[0],resultRowMap.get(rowDimArr[0]));
					curAddLinkMap.put("state","closed");
					rowEntries = resultRowMap.entrySet().iterator();
					while (rowEntries.hasNext()) {
						Map.Entry<String, String> entry = rowEntries.next();
						tempKey = entry.getKey();
						if(isKpiColumn(tempKey)){
							curAddLinkMap.put(entry.getKey(),entry.getValue());
						}
					}
					childrenMap = curAddLinkMap;
					for(int j=1;j<rowDimArr.length;j++){
						childrenMap = addMapChildren(j,childrenMap,resultRowMap);
					}
				}else{
					for(LinkedHashMap newResultRowMap : newResultDataList){
						if(newResultRowMap.get(rowDimArr[0]).equals(tmpRowDimKey)){
							rowEntries = resultRowMap.entrySet().iterator();
							while (rowEntries.hasNext()) {
								Map.Entry<String, String> entry = rowEntries.next();
								tempKey = entry.getKey();
								if(isKpiColumn(tempKey)){
									try{
										Object obj = entry.getValue();
										String sValue ="";
										String uValue = "";
										if(!"".equals(obj)&&obj!=null&&!"null".equals(obj)){
											sValue = String.valueOf(obj);
										}else{
											sValue="0";
										}
										if(!"".equals(newResultRowMap.get(entry.getKey()))&&newResultRowMap.get(entry.getKey())!=null){
											Object obju = newResultRowMap.get(entry.getKey());
											if(!"".equals(obju)&&obju!=null&&!"null".equals(obju)){
												uValue = String.valueOf(obju);
											}else{
												uValue="0";
											}
										}else{
											uValue = "0";
										}
						    			BigDecimal btValue = new BigDecimal(uValue);
						    			BigDecimal bsValue = new BigDecimal(sValue);
						    			String sum=btValue.add(bsValue).toString();
										newResultRowMap.put(entry.getKey(),sum);
									}catch(Exception e){
										e.printStackTrace();
									}
								}
							}
							childrenMap = newResultRowMap;
							break;
						}
					}
					for(int j=1;j<rowDimArr.length;j++){
						childrenMap = addMapChildren(j,childrenMap,resultRowMap);
					}
				}
		}
		if(sumColumn){
			if("top".equals(this.rowsumposition)){
				LinkedHashMap sumMap = newResultDataList.get(newResultDataList.size()-1);
				sumMap.put(rowDimArr[0], colSumName);
				sumMap.remove("children");
				sumMap.remove("state");
				newResultDataList.add(0,sumMap);
				newResultDataList.remove(newResultDataList.size()-1);
			}else{
				LinkedHashMap sumMap = newResultDataList.get(newResultDataList.size()-1);
				sumMap.put(rowDimArr[0], colSumName);
				sumMap.remove("children");
				sumMap.remove("state");
			}
			
		}
		return newResultDataList;
	}
	
	
	//去掉重复维度列
	@SuppressWarnings("unchecked")
	public List<String[]> resRepeat(List<LinkedHashMap> resList,String lastStr){
		List<Map> tempList = new ArrayList<Map>();
		List<Map> list = new ArrayList<Map>();
		List<String[]> res = new ArrayList<String[]>();
		for(int i=0;i<resList.size();i++){
			Map map = resList.get(i);
			Map<String,String> maptmp = new HashMap<String,String>();
			if(null!=map.get(lastStr)){
				maptmp.put(lastStr, (String)map.get(lastStr));
			}
			list.add(maptmp);
		}
		for(Map m:list){
			 if(!tempList.contains(m)){
				 tempList.add(m);
			 }
		 }
		for(int j=0;j<tempList.size();j++){
			Map<String,String> map = tempList.get(j);
			for(Map.Entry<String, String> data : map.entrySet()){
				String[] arr = new String[2];
				arr[0]=data.getKey();
				arr[1]=data.getValue();
				res.add(arr);
			}
		}
	    return res;
	}
	
	//复制Map对象
	@SuppressWarnings("unchecked")
	public LinkedHashMap copyResultMap(LinkedHashMap<String,String> map){
		LinkedHashMap resMap = new LinkedHashMap<String,String>();
		for(Map.Entry<String, String> res : map.entrySet()){
			String key=res.getKey();
			Object obj = res.getValue();
			String value=String.valueOf(obj);
			resMap.put(key, value);
		}
		
		return resMap;
	}
	
	//获得上一级id
	@SuppressWarnings("unchecked")
	public void getParentId(LinkedHashMap resMap,String pName,List<LinkedHashMap> tempList){
		for(int i=0;i<tempList.size();i++){
			LinkedHashMap map = tempList.get(i);
			if(map.get("pName")!=null){
				String tmpName = (String)map.get("pName");
				if(pName.equals(tmpName)){
					resMap.put("_parentId", map.get("id"));
				}
			}
		}
	}
	
	//查下一级
	public boolean isKpiColumn(String key){
		int i=0;
    	for(;i<rowDimArr.length;i++){
    		if(key.equals(rowDimArr[i])){
    			break;
    		}
    	}
    	if(i==rowDimArr.length){
    		return true;
    	}
    	return false;
	}
	
	//添加子类
	@SuppressWarnings("unchecked")
	public LinkedHashMap addMapChildren(int index,LinkedHashMap childrenMap,Map resultRowMap){
		LinkedHashMap newLinkHashMap = null;
		ArrayList<LinkedHashMap> childrenList;
		String rowDimValue = resultRowMap.get(rowDimArr[index])+"";
		String rootKey = rowDimArr[0];
		Iterator<Map.Entry<String, String>> rowEntries = resultRowMap.entrySet().iterator();
		String tempKey;
		if(childrenMap.get("children")==null){
			childrenList = new ArrayList();
			childrenMap.put("children",childrenList);
			newLinkHashMap = new LinkedHashMap();
			newLinkHashMap.put("id", UUID.randomUUID().toString().replaceAll("-", ""));
			newLinkHashMap.put(rootKey, rowDimValue);
			if(index<rowDimArr.length-1)
				newLinkHashMap.put("state","closed");
			childrenList.add(newLinkHashMap);
			while (rowEntries.hasNext()) {
				Map.Entry<String, String> entry = rowEntries.next();
				tempKey = entry.getKey();
				if(isKpiColumn(tempKey)){
					newLinkHashMap.put(entry.getKey(),entry.getValue());
				}
			}
		}else{
			childrenList = (ArrayList<LinkedHashMap>)childrenMap.get("children");
			int size = 0;
			for(LinkedHashMap tempHashMap : childrenList){
				if(rowDimValue.equals(tempHashMap.get(rootKey))){
					newLinkHashMap = tempHashMap;
					while (rowEntries.hasNext()) {
						Map.Entry<String, String> entry = rowEntries.next();
						tempKey = entry.getKey();
						if(isKpiColumn(tempKey)){
							String key = "0";
							if(newLinkHashMap.get(entry.getKey())!=null){
								key = newLinkHashMap.get(entry.getKey())+"";
							}
							BigDecimal btValue = new BigDecimal(key);
			    			BigDecimal bsValue = new BigDecimal(String.valueOf(entry.getValue()));
			    			String sum = btValue.add(bsValue).toString();
							newLinkHashMap.put(entry.getKey(),sum);
							//newLinkHashMap.put(entry.getKey(),Float.parseFloat(newLinkHashMap.get(entry.getKey())+"")+(Float.parseFloat(String.valueOf(entry.getValue()))));
						}
					}
					size++;
					break;
				}
			}
			if(size == 0){
				newLinkHashMap = new LinkedHashMap();
				newLinkHashMap.put("id", UUID.randomUUID().toString().replaceAll("-", ""));
				newLinkHashMap.put(rootKey, rowDimValue);
				if(index<rowDimArr.length-1)
					newLinkHashMap.put("state","closed");
				childrenList.add(newLinkHashMap);
				while (rowEntries.hasNext()) {
					Map.Entry<String, String> entry = rowEntries.next();
					tempKey = entry.getKey();
					if(isKpiColumn(tempKey)){
						newLinkHashMap.put(entry.getKey(),entry.getValue());
					}
				}
			}
		}
		
		return newLinkHashMap;
	}
	
	/**
	 * 判断是否有除号
	 * @return
	 */
	public boolean isExtcolumns(){
		boolean flg = false;
		Extcolumns extcolumns = report.getExtcolumns();
		if(null!=extcolumns && extcolumns.getExtcolumnList()!=null){
			List<Extcolumn> extcolumnList = extcolumns.getExtcolumnList();
			lable:for(Extcolumn extcolumn:extcolumnList){
				String formula = extcolumn.getFormula();
				if(formula.indexOf("/")!=-1){
					flg = true;
					break lable;
				}
			}
		}
		return flg;
	}
	
	/**
	 * 重写合计
	 * @param tlist
	 * @param resList
	 */
	@SuppressWarnings("unchecked")
	public void againSum(List tlist,List<LinkedHashMap> resList){
		Map<String,String> tmap = (Map<String,String>)tlist.get(1);
		Extcolumns extcolumns = report.getExtcolumns();
		if(null!=extcolumns && extcolumns.getExtcolumnList()!=null){
			List<Extcolumn> extcolumnList = extcolumns.getExtcolumnList();
			for(Extcolumn extcolumn:extcolumnList){
				String formula = extcolumn.getFormula();
				if(formula.indexOf("/")!=-1){
					for(int i=0;i<resList.size();i++){
						LinkedHashMap<String,Object> map = resList.get(i);
						this.calculationSum(map, extcolumn,tmap);
					}
				}
			}
		}
	}
	
	/**
	 * 解map重新计算
	 * @param map
	 * @param extcolumn
	 * @param tmap
	 * @return
	 */
	public List<String> calculationSum(LinkedHashMap<String,Object> map,Extcolumn extcolumn,Map<String,String> tmap){
		List<String> reslist = new ArrayList<String>();
		String name = extcolumn.getName();
		name = this.toHexString(name);
		name = name.substring(1,name.length()-1);
		String formula = extcolumn.getFormula(); 
		for (Map.Entry<String, Object> entry : map.entrySet()){
			String key = entry.getKey();
			if(!"children".equals(key)){
				if(key.indexOf(name)!=-1){
					try{
						List<Param> paramList = extcolumn.getParamList();
						String str = this.replaceFormula(paramList, formula,map,key,name);
						ScriptEngineManager factory = new ScriptEngineManager();
						ScriptEngine engine = factory.getEngineByName("JavaScript");
						double v = (Double)engine.eval(str);
						String val = String.valueOf(v);
						if("NaN".equals(val)){
							map.put(key, "0");
						}else if("Infinity".equals(val)){
							map.put(key, "0");
						}else if("-Infinity".equals(val)){
							map.put(key, "0");
						}else{
							map.put(key, String.valueOf(v));
						}
						
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			}else{
				List<LinkedHashMap> childrenList = (List<LinkedHashMap>)map.get("children");
				for(int i=0;i<childrenList.size();i++){
					LinkedHashMap<String,Object> linkmap = childrenList.get(i);
					this.calculationSum(linkmap, extcolumn, tmap);
				}
			}
		}
		return reslist;
	}
	
	/**
	 * 替换公式
	 * @param paramList
	 * @param formula
	 * @return
	 */
	public String replaceFormula(List<Param> paramList,String formula,LinkedHashMap<String,Object> map,String key,String keyName){
		for(Param par :paramList){
			String name = par.getName();
			String val = par.getValue();
			val = this.toHexString(val);
			val = val.substring(1,val.length());
			//System.out.println(key);
			String mapkey = key.replace(keyName, val);
			if(mapkey.length()>19){
				mapkey = mapkey.substring(0,mapkey.length()-1);
			}
			//System.out.println(mapkey);
			formula = formula.replaceAll(name, "("+String.valueOf((Object)map.get(mapkey))+")");
		}
		return formula;
	}
	
	/**
	 * 设置DataGrid表格
	 * @param finalData
	 */
	public void setLinkPageGrid(List<LinkedHashMap> finalData){
		for(int i=0;i<finalData.size();i++){
			LinkedHashMap map = finalData.get(i);
			Map<String, String> dataMap = gridList.get(i);
			for(int j=0;j<colDimArr.length;j++){
				map.put(colDimArr[j], dataMap.get(colDimArr[j]));
			}
		}
	}
	
}

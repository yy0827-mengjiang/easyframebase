package cn.com.easy.xbuilder.parser;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import javax.servlet.http.HttpServletRequest;

import cn.com.easy.core.EasyContext;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Datastore;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Report;

public class XGenerateDgst {
	private final SqlRunner runner;
	private final HttpServletRequest request;
	private final Report report;
	
	private Map<String, String> params;
	private Map<String, Map<String,String>> extcols;
	private List<String> dims;
	private Map<String, String> kpis;
	private String isTotal;
	private String pos;
	private int dimsLen;

	private Map<String,Map<String,Object>> cacheSubTotal;
	private int total = 0;
	public XGenerateDgst(Report report,Map<String, String> params,SqlRunner runner,HttpServletRequest request) {
		ReportConverteContext reportConverter = new ReportConverteContext();
		this.report = reportConverter.converter(report);
		this.params = params;
		this.runner = runner;
		this.request = request;
	}

	private List<Map> queryData() {
		Map<String,Object> datamap = new HashMap<String,Object>();
		List<Map> basicdatas = null;
		try {
			boolean isFy = true;
			String fySql = "";
			String basicSql = params.get("basicSql");
			String extds = params.get("dataSourceName");
			String paramSql = params.get("paramSql");

			int page = 1;//Integer.parseInt((String) params.get("page"));
			int rows = 0;//Integer.parseInt((String) params.get("rows"));
			if("true".equals(params.get("is_down_table")) || "2".equals(report.getInfo().getLtype())){
				rows = 10000000;
			}else{
				Object pageOO = params.get("page");
				Object rowsOO = params.get("rows");
				if(null == rowsOO || "".equals(rowsOO)){
					isFy = false;
					rows = 10000000;
				}else{
					page = Integer.parseInt((String)pageOO);
					rows = Integer.parseInt((String)rowsOO);
				}
			}
			int allnum = 0;
			int start = (page - 1) * rows;
			int end = (page - 1) * rows + rows;
			CommonTools tools = new CommonTools();
			
			if (extds != null && extds.length() > 0) {
				if(isFy){
					Map all = runner.queryForMap(extds, "select count(*) allnum from("+ paramSql + ") dgst", params);
					allnum = Integer.parseInt(String.valueOf(all.get("ALLNUM")));
				}
				
				if(isFy){
					fySql = tools.getPageSql(extds, paramSql,start,allnum);
				}else{
					fySql = paramSql;
				}
				//String fySql = "select * from (select rownum num, init.* from("+ paramSql + ") init where rownum <= " + allnum+ ") dgst where num > " + start;
				basicdatas = (List<Map>) runner.queryForMapList(extds, fySql,params);
			} else {
				Map all = runner.queryForMap("select count(*) allnum from("+ paramSql + ") dgst", params);
				allnum = Integer.parseInt(String.valueOf(all.get("ALLNUM")));
				//String fySql = "select * from (select rownum num, init.* from("+ paramSql + ") init where rownum <= " + allnum+ ") dgst where num > " + start;
				
				if(isFy){
					fySql = tools.getPageSql(extds, paramSql,start,allnum);;
				}else{
					fySql = paramSql;
				}
				basicdatas = (List<Map>) runner.queryForMapList(fySql, params);
			}
			total = allnum;
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
		return basicdatas;
	}
	public List<Map> queryFYData() {
		Map<String,Object> datamap = new HashMap<String,Object>();
		List<Map> basicdatas = null;
		try {
			boolean isFy = true;
			String fySql = "";
			String extds = params.get("dataSourceName");
			String paramSql = params.get("paramSql");
			
			int page = 1;//Integer.parseInt((String) params.get("page"));
			int rows = 0;//Integer.parseInt((String) params.get("rows"));
			if("true".equals(params.get("is_down_table")) || "2".equals(report.getInfo().getLtype())){
				rows = 10000000;
			}else{
				Object pageOO = params.get("page");
				Object rowsOO = params.get("rows");
				if(null == rowsOO || "".equals(rowsOO)){
					isFy = false;
					rows = 10000000;
				}else{
					page = Integer.parseInt((String)pageOO);
					rows = Integer.parseInt((String)rowsOO);
				}
			}
			int start = (page - 1) * rows;
			int end = (page - 1) * rows + rows;
			CommonTools tools = new CommonTools();
			//String fySql = "select * from (select rownum num, init.* from("+ paramSql + ") init where rownum <= " + end+ ") dgst where num > " + start;
			if(isFy){
				fySql = tools.getPageSql(extds, paramSql,start,end);
			}else{
				fySql = paramSql;
			}
			if (extds != null && extds.length() > 0) {
				Map all = runner.queryForMap(extds, "select count(*) allnum from("+ paramSql + ") dgst", params);
				total = Integer.parseInt(String.valueOf(all.get("ALLNUM")));
				basicdatas = (List<Map>) runner.queryForMapList(extds, fySql,params);
			} else {
				Map all = runner.queryForMap("select count(*) allnum from("+ paramSql + ") dgst", params);
				total = Integer.parseInt(String.valueOf(all.get("ALLNUM")));
				basicdatas = (List<Map>) runner.queryForMapList(fySql, params);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
		return basicdatas;
	}
	
	private boolean buildCache(){
		List<Map> basicdatas = this.queryData();
		int dl = basicdatas.size();
		boolean flag = false;
		cacheSubTotal = new HashMap<String,Map<String,Object>>();
		Map<String,BigDecimal> leiJiKpi = new HashMap<String,BigDecimal>();//key=维度列_指标列
		for(int x=0;x<dl;x++){
			Map<String,Object> currowdata = basicdatas.get(x);
			Map<String,Object> prerowdata = x>0?basicdatas.get(x-1):null;
			
			//20161101将合计从行小计中去除
			String tmpDimV = dims.get(0);
			if(currowdata.get(tmpDimV).equals(params.get("totalname")) || (null != prerowdata && prerowdata.get(tmpDimV).equals(params.get("totalname")))){
				continue;
			}
			
			int offset=-1;//同一行中，有多个维度需要小计
			for(int d=dimsLen-2;d>=0;d--){
			//for(int d=dimsLen-2;d>=dimsLen-2;d--){
				String curdim = dims.get(d).toUpperCase();
				String curdimv = String.valueOf(currowdata.get(curdim));
				String predimv = prerowdata!=null?String.valueOf(prerowdata.get(curdim)):null;
				if(prerowdata != null){
					if(predimv.equals(curdimv)){
						for(String key:kpis.keySet()){
							key = key.toUpperCase();
							BigDecimal tmpljv = leiJiKpi.get(curdim+"☆"+key);
							//BigDecimal tmpkpiv = new BigDecimal(String.valueOf(currowdata.get(key)));
							BigDecimal tmpkpiv =(String.valueOf(currowdata.get(key)).toLowerCase().equals("null")||String.valueOf(currowdata.get(key)).toLowerCase().equals(""))?new BigDecimal("0"):new BigDecimal(String.valueOf(currowdata.get(key)));
							BigDecimal ljv = null != tmpljv?tmpljv:new BigDecimal("0");
							BigDecimal kpiv = null != tmpkpiv?tmpkpiv:new BigDecimal("0");
							BigDecimal ljnewv = ljv.add(kpiv);
							leiJiKpi.put(curdim+"☆"+key,ljnewv);
						}
					}else{//结束小计
						//拼接维度
						offset++;
						Map<String,Object> jsonmap = new HashMap<String,Object>();
						boolean vflag = false;
						for(String dim:dims){
							dim = dim.toUpperCase();
							//String v = dim.equals(curdim)?"小计":"--";//String.valueOf(currowdata.get(dim))
							if(vflag){
								jsonmap.put(dim,"--");
							}else{
								if(dim.equals(curdim)){
									vflag = true;
									jsonmap.put(dim,"小计");
								}else{
									//jsonmap.put(dim,String.valueOf(currowdata.get(dim)));
									jsonmap.put(dim,String.valueOf(prerowdata.get(dim)));
								}
							}
						}
						
						Map<String,BigDecimal> cloneLJK = new HashMap<String,BigDecimal>(leiJiKpi);
						for(String ljkey:cloneLJK.keySet()){
							if(ljkey.startsWith(curdim+"☆")){
								String[] dks = ljkey.split("☆");
								jsonmap.put(dks[1], cloneLJK.get(ljkey));
								leiJiKpi.remove(ljkey);
							}
						}
						
						for(String key:prerowdata.keySet()){
							if(jsonmap.get(key) == null){
								jsonmap.put(key, prerowdata.get(key));
							}
						}
						
						StringBuffer curdimstr = new StringBuffer();
						for(int m=d;m>=0;m--){
							String tmpcurdim = dims.get(m).toUpperCase();
							String tmppredimv = String.valueOf(prerowdata.get(tmpcurdim));					
							curdimstr.append(tmppredimv).append("☆");
						}
						cacheSubTotal.put(curdimstr.toString(), jsonmap);
						for(String key:kpis.keySet()){
							key = key.toUpperCase();
							//BigDecimal tmpkpiv = new BigDecimal(String.valueOf(currowdata.get(key)));
							BigDecimal tmpkpiv =(String.valueOf(currowdata.get(key)).toLowerCase().equals("null")||String.valueOf(currowdata.get(key)).toLowerCase().equals(""))?new BigDecimal("0"):new BigDecimal(String.valueOf(currowdata.get(key)));
							BigDecimal kpiv = null != tmpkpiv?tmpkpiv:new BigDecimal("0");
							leiJiKpi.put(curdim+"☆"+key,kpiv);
						}
					}
					if(x == (dl-1)){//结束小计
						offset++;
						Map<String,Object> jsonmap = new HashMap<String,Object>();
						for(String dim:dims){
							dim = dim.toUpperCase();
							String v = dim.equals(curdim)?"小计":"--";
							jsonmap.put(dim, v);
						}
						
						Map<String,BigDecimal> cloneLJK = new HashMap<String,BigDecimal>(leiJiKpi);
						for(String ljkey:cloneLJK.keySet()){
							if(ljkey.startsWith(curdim+"☆")){
								String[] dks = ljkey.split("☆");
								jsonmap.put(dks[1], cloneLJK.get(ljkey));
								leiJiKpi.remove(ljkey);
							}
						}
						StringBuffer curdimstr = new StringBuffer();
						for(int m=d;m>=0;m--){
							String tmpcurdim = dims.get(m).toUpperCase();
							String tmpcurdimv = String.valueOf(currowdata.get(tmpcurdim));					
							curdimstr.append(tmpcurdimv).append("☆");
						}
						cacheSubTotal.put(curdimstr.toString(), jsonmap);
					}
				}else{
					//第一条记录，将值放入累计ma即可
					for(String key:kpis.keySet()){
						key = key.toUpperCase();
						BigDecimal tmpljv = leiJiKpi.get(curdim+"☆"+key);
						//BigDecimal tmpkpiv = new BigDecimal(String.valueOf(currowdata.get(key)));
						BigDecimal tmpkpiv =(String.valueOf(currowdata.get(key)).toLowerCase().equals("null")||String.valueOf(currowdata.get(key)).toLowerCase().equals(""))?new BigDecimal("0"):new BigDecimal(String.valueOf(currowdata.get(key)));
						BigDecimal ljv = null != tmpljv?tmpljv:new BigDecimal("0");
						BigDecimal kpiv = null != tmpkpiv?tmpkpiv:new BigDecimal("0");
						BigDecimal ljnewv = ljv.add(kpiv);
						leiJiKpi.put(curdim+"☆"+key,ljnewv);
					}
				}
				
			}
		}
		return true;
	}
	private Map<String,Object> addSubtotal(){
		Map<String,Object> subtotalmap = new HashMap<String,Object>();
		
		List<Map> basicdatas = ("true".equals(params.get("is_down_table"))||"2".equals(report.getInfo().getLtype()))?this.queryData():this.queryFYData();
		subtotalmap.put("data", basicdatas);
		subtotalmap.put("total",total);
		
		if(null == basicdatas){
			return subtotalmap;
		}
		
		int dl = basicdatas.size();
		if(dl<=1){
			return subtotalmap;
		}
		
		int offset=-1;
		Map<Integer,Map<String,Object>> insertst = new TreeMap<Integer,Map<String,Object>>();//插入的小计
		Map<String,String> cacheused = new HashMap<String,String>();//缓存使用记录
		for(int x=0;x<dl;x++){
			Map<String,Object> currowdata = basicdatas.get(x);
			Map<String,Object> prerowdata = x>0?basicdatas.get(x-1):null;
			
			for(int d=dimsLen-2;d>=0;d--){
				StringBuffer curdimstr = new StringBuffer();
				for(int m=d;m>=0;m--){
					String tmpcurdim = dims.get(m).toUpperCase();
					String tmpcurdimv = String.valueOf(currowdata.get(tmpcurdim));
					curdimstr.append(tmpcurdimv).append("☆");
				}
				
				//查看是否有缓存
				Map<String,Object> cache  = cacheSubTotal.get(curdimstr.toString());
				if(null != cache){
					if(cacheused.get(curdimstr.toString()) != null){
						continue;
					}
					offset++;
					insertst.put(x+offset,cache);
					cacheused.put(curdimstr.toString(), curdimstr.toString());
					continue;
				}
			}
		}
		subtotalmap.put("subtotal",insertst);
		return subtotalmap;
	}

	private String isNull(Object v){
		String namev = String.valueOf(v);
		if(null == namev || "NULL".equals(namev.toUpperCase().trim()) || "UNDEFINED".equals(namev.toUpperCase().trim()) || namev.trim().length()<=0){
			return "";
		}
		return namev.trim();
	}
	private void getDataGridDimCols(Report report,String compid,Map<String, String> extkpiinfo){
		List<String> dims = new ArrayList<String>();
		Map<String,String> kpis = new HashMap<String,String>();
		List<Container> containers = report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			String popId = container.getPop();
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				for(int p=0;p<components.size();p++){
					Component component = components.get(p);
					if(compid.equals(component.getId())){
						Datastore datastore = component.getDatastore();
						if(datastore != null && datastore.getDatacolList().size()>0){
							List<Datacol> basicDatacols = datastore.getDatacolList();
							List<Datacol> datacols = new ArrayList<Datacol>();
							for(int d=0;d<basicDatacols.size();d++){
								Datacol datacol = basicDatacols.get(d);
								if(datacol.getDatacoltype().equals("dim")){
									datacols.add(datacol);
								}else{
									kpis.put(datacol.getDatacolcode(),datacol.getDatacolcode());
								}
							}
							ComparatorDatacols csd = new ComparatorDatacols();
							Collections.sort(datacols, csd);
							for(int l=0;l<datacols.size();l++){
								Datacol datacol = datacols.get(l);
								dims.add(datacol.getDatacolcode());
							}
						}
					}
				}
			}
		}
		if(null != extkpiinfo && extkpiinfo.size()>0){
			kpis.putAll(extkpiinfo);
		}
		this.dimsLen = dims.size();
		this.dims=dims;
		this.kpis=kpis;
	}
	private class ComparatorDatacols implements Comparator{
		public int compare(Object arg0, Object arg1) {
			Datacol datacol = (Datacol)arg0,Datacol2 = (Datacol)arg1;
		
			String v1 = datacol.getTablecolcode(),v2 = Datacol2.getTablecolcode();
			return (v1.toLowerCase()).compareTo(v2.toLowerCase());
		}
	}
	private String noSubTatol(){
		List<Map> basicdatas = null;
		String datajson = null;
		if("true".equals(params.get("is_down_table"))){
			request.getSession().setAttribute("down_c_talbe_list", this.queryFYData());
			return null;
		}else if("2".equals(report.getInfo().getLtype())){
			basicdatas = this.queryData();
		}else{
			basicdatas = this.queryFYData();
		}
		if("2".equals(report.getInfo().getLtype())){
			datajson = Functions.java2json(basicdatas);
		}else{
			Map<String,Object> subtotalmap = new HashMap<String,Object>();
			subtotalmap.put("rows", basicdatas);
			subtotalmap.put("total",total);
			datajson = Functions.java2json(subtotalmap);
		}
		return datajson;
	}
	private String buildParams() throws UnsupportedEncodingException{
		Map<String,?> user = (Map<String,?>)EasyContext.getContext().getRequest().getSession().getAttribute("UserInfo");
		if(null != user){
			for(String key:user.keySet()){
				String dv = String.valueOf(user.get(key));
				if(null != dv && !dv.trim().equals("") && !dv.trim().equalsIgnoreCase("null")){
					if(dv.indexOf(",")>-1){
						dv = dv.replaceAll(",","','");
					}
					params.put(key,dv);
				}
			}
		}
		String seskey = params.get("compid")+"☆";
		StringBuffer paramBuff = new StringBuffer();
		Dimsions dimsions = report.getDimsions();
		if(dimsions != null && dimsions.getDimsionList() != null && dimsions.getDimsionList().size()>0){
			List<Dimsion> dimlist = dimsions.getDimsionList();
			for(int l=0;l<dimlist.size();l++){
				Dimsion dimsion = dimlist.get(l);
				String name = dimsion.getVarname();
				String namev = params.get(name);
				namev = this.isNull(namev);
				if(namev.equals("")){
					namev = this.isNull(request.getAttribute(name));
				}
				if(namev.equals("")){
					namev = this.isNull(request.getSession().getAttribute(name));
				}
				if(!namev.equals("")){
					namev = namev!=null?new String(namev.getBytes("ISO-8859-1"),"UTF-8"):"";
				}
				if(!namev.equals("") && !namev.equals("-1")){
					params.put(name, namev);
				}
				paramBuff.append(namev+"☆");
			}
			seskey += paramBuff.toString();
			cacheSubTotal = null;//(Map<String,Map<String,Object>>)request.getSession().getAttribute(seskey);
		}
		
		XGenerateAction xgAction = null;
		if(null !=params.get("sort") && null != params.get("order") && params.get("sort").trim().length()>0 && params.get("order").trim().length()>0){
			xgAction = new XGenerateAction(report,params.get("type"),true,params.get("sort"),params.get("order"),params.get("compid"));
		}else{
			xgAction = new XGenerateAction(report,params.get("type"),true);
		}
		
		Map<String, Map<String,?>> sqlInfoMap = xgAction.getDataSetSqlByCompid(params.get("compid"));
		Map<String, String> sqlInfo = (Map<String, String>) sqlInfoMap.get("DataSetSqlMap");
		this.isTotal = String.valueOf(sqlInfoMap.get("IsTotal").get("Total"));
		this.pos = String.valueOf(sqlInfoMap.get("IsTotal").get("Pos"));
		Map<String, String> extkpiinfo = (Map<String, String>) sqlInfoMap.get("ExtColKpimap");
		extcols = (Map<String, Map<String,String>>) sqlInfoMap.get("ExtColMap");
		params.putAll(sqlInfo);
		String paramSql = xgAction.buildSqlByParam(sqlInfo.get("sql"), "{}", params);
		params.put("paramSql",paramSql);
		
		this.getDataGridDimCols(report, params.get("compid"),extkpiinfo);
		return seskey;
	}
	
	public String getDownLoadSql(){
		XGenerateAction xgAction = new XGenerateAction(report,params.get("type"),true);
		Map<String, Map<String,?>> sqlInfoMap = xgAction.getDataSetSqlByCompid(params.get("compid"));
		Map<String, String> sqlInfo = (Map<String, String>) sqlInfoMap.get("DataSetSqlMap");
		extcols = (Map<String, Map<String,String>>) sqlInfoMap.get("ExtColMap");
		String paramSql = xgAction.buildSqlByParam(sqlInfo.get("sql"), "{}", params);
		return paramSql;
	}
	
	public String getJson() throws UnsupportedEncodingException{
		String seskey = this.buildParams();
		
		if(dims.size()<2){
			return this.noSubTatol();
		}
		if(cacheSubTotal == null){
			this.buildCache();
		}
		Map<String,Object> info = this.addSubtotal();
		Map<Integer,Map<String,Object>> subtotal = (Map<Integer,Map<String,Object>>)info.get("subtotal");
		Map<Integer,Map<String,Object>> subtotalNew = null != subtotal?new TreeMap<Integer,Map<String,Object>>(subtotal):null;//插入的小计
		List<Map> subdata = (List<Map>)info.get("data");
		int total = Integer.parseInt(String.valueOf(info.get("total")));
		
		if(null != subtotal && subtotal.size()>0){
			int tmpDl = dimsLen;
			if(tmpDl>1){
				List<Integer> allKeyList = new ArrayList<Integer>();
				for(int key:subtotal.keySet()){
					allKeyList.add(key);
				}
				List<Integer> tmpstkeylst = new ArrayList<Integer>();
				int tmpnum = -1;
				for(int key:subtotal.keySet()){
					tmpnum++;
					tmpDl--;
					if(tmpDl == 0){
						int tmpstkeylstSize = tmpstkeylst.size();
						if(tmpstkeylstSize<4){
							int tem1key = tmpstkeylst.get(0);
							int tem2key = tmpstkeylst.get(tmpstkeylstSize-1);
							Map<String,Object> tmp1 = subtotalNew.get(tem1key);
							Map<String,Object> tmp2 = subtotalNew.get(tem2key);
							subtotalNew.put(tem1key, tmp2);
							subtotalNew.put(tem2key, tmp1);
						}else{
							jiaohuanweizhi(tmpstkeylst,subtotalNew);
						}
						tmpstkeylst = null;
						tmpstkeylst = new ArrayList<Integer>();
						tmpstkeylst.add(key);
						int tmpnumcopy = tmpnum;
						for(int m=0;m<dimsLen-1;m++){
							if(++tmpnumcopy < allKeyList.size()){
								if((key+1) != allKeyList.get(tmpnumcopy)){
									tmpDl = m+1;
									break;
								}
							}else{
								if(tmpnum == tmpstkeylstSize-1){
									if(tmpstkeylstSize<4){
										int tem1key = tmpstkeylst.get(0);
										int tem2key = tmpstkeylst.get(tmpstkeylstSize-1);
										Map<String,Object> tmp1 = subtotalNew.get(tem1key);
										Map<String,Object> tmp2 = subtotalNew.get(tem2key);
										subtotalNew.put(tem1key, tmp2);
										subtotalNew.put(tem2key, tmp1);
									}else{
										jiaohuanweizhi(tmpstkeylst,subtotalNew);
									}
								}else{
									tmpDl = m+1;
								}
								break;
							}
						}
						
					}else{
						tmpstkeylst.add(key);
						if(tmpnum == allKeyList.size()-1){
							if(tmpstkeylst.size()<4){
								int tem1key = tmpstkeylst.get(0);
								int tem2key = tmpstkeylst.get(tmpstkeylst.size()-1);
								Map<String,Object> tmp1 = subtotalNew.get(tem1key);
								Map<String,Object> tmp2 = subtotalNew.get(tem2key);
								subtotalNew.put(tem1key, tmp2);
								subtotalNew.put(tem2key, tmp1);
							}else{
								jiaohuanweizhi(tmpstkeylst,subtotalNew);
							}
						}
					}
				}
			}
			
			for(int key:subtotalNew.keySet()){
				Map<String,Object> datainfo = subtotalNew.get(key);
				//小计中添加计算列
				if(null != extcols && extcols.size()>0){
					for(String colname : extcols.keySet()){
						if(null != datainfo.get(colname)){
							Map<String,String> extinfo = extcols.get(colname);
							String formula = extinfo.get("formula");
							String[] kpis = extinfo.get("kpi").split(",");
							for(int k=0;k<kpis.length;k++){
								formula = formula.replaceAll(kpis[k],"("+String.valueOf(datainfo.get("SUM("+kpis[k]+")"))+")");
							}

					        ScriptEngineManager factory = new ScriptEngineManager();
					        ScriptEngine engine = factory.getEngineByName("JavaScript");
					        String strv = "0";
							try {
								double v = (Double)engine.eval(formula);
								if(v == Double.POSITIVE_INFINITY || "NaN".equals(String.valueOf(v))){
									v = 0;
								}
								strv = new java.text.DecimalFormat("#.0000").format(v);
							} catch (ScriptException e) {
								e.printStackTrace();
							}
							
							BigDecimal bdmp = new BigDecimal(strv);
							datainfo.put(colname, bdmp);
						}
					}
				}
				subdata.add(key,datainfo);
			}
		}
		//20160513修改小计的位置：小计换成维度，--换小计，一条路只换一次
		int dimlen = this.dims.size();
		if(dimlen>0){
			String dimkey0 = this.dims.get(0);
			String dimkey1 = 1<dimlen?this.dims.get(1):null;
			String dimkey2 = 2<dimlen?this.dims.get(2):null;
			String dimkey3 = 3<dimlen?this.dims.get(3):null;
			String dimkey4 = 4<dimlen?this.dims.get(4):null;
			String dimkey5 = 5<dimlen?this.dims.get(5):null;
			String dimkey6 = 6<dimlen?this.dims.get(6):null;
			String dimkey7 = 7<dimlen?this.dims.get(7):null;
			String dimkey8 = 8<dimlen?this.dims.get(8):null;
			String dimkey9 = 9<dimlen?this.dims.get(9):null;
			String dimkey10 = 10<dimlen?this.dims.get(10):null;
			for(int sb=0;sb<subdata.size();sb++){
				Map<String,Object> datamap = subdata.get(sb);
				if(null != dimkey1 && null != datamap.get(dimkey0) && datamap.get(dimkey0).equals("小计")){
					datamap.put(dimkey0, subdata.get(sb+1).get(dimkey0));
					datamap.put(dimkey1,"小计");
				} else if(null != dimkey1 && null != datamap.get(dimkey1) && datamap.get(dimkey1).equals("小计")){
					datamap.put(dimkey1, subdata.get(sb+1).get(dimkey1));
					if(null != dimkey2){ datamap.put(dimkey2,"小计");}
				} else if(null != dimkey2 && null != datamap.get(dimkey2) && datamap.get(dimkey2).equals("小计")){
					datamap.put(dimkey2, subdata.get(sb+1).get(dimkey2));
					if(null != dimkey3){ datamap.put(dimkey3,"小计");}
				} else if(null != dimkey3 && null != datamap.get(dimkey3) && datamap.get(dimkey3).equals("小计")){
					datamap.put(dimkey3, subdata.get(sb+1).get(dimkey3));
					if(null != dimkey4){ datamap.put(dimkey4,"小计");}
				} else if(null != dimkey4 && null != datamap.get(dimkey4) && datamap.get(dimkey4).equals("小计")){
					datamap.put(dimkey4, subdata.get(sb+1).get(dimkey4));
					if(null != dimkey5){ datamap.put(dimkey5,"小计");}
				} else if(null != dimkey5 && null != datamap.get(dimkey5) && datamap.get(dimkey5).equals("小计")){
					datamap.put(dimkey5, subdata.get(sb+1).get(dimkey5));
					if(null != dimkey6){ datamap.put(dimkey6,"小计");}
				} else if(null != dimkey6 && null != datamap.get(dimkey6) && datamap.get(dimkey6).equals("小计")){
					datamap.put(dimkey6, subdata.get(sb+1).get(dimkey6));
					if(null != dimkey7){ datamap.put(dimkey7,"小计");}
				} else if(null != dimkey7 && null != datamap.get(dimkey7) && datamap.get(dimkey7).equals("小计")){
					datamap.put(dimkey7, subdata.get(sb+1).get(dimkey7));
					if(null != dimkey8){ datamap.put(dimkey8,"小计");}
				} else if(null != dimkey8 && null != datamap.get(dimkey8) && datamap.get(dimkey8).equals("小计")){
					datamap.put(dimkey8, subdata.get(sb+1).get(dimkey8));
					if(null != dimkey9){ datamap.put(dimkey9,"小计");}
				}else if(null != dimkey9 && null != datamap.get(dimkey9) && datamap.get(dimkey9).equals("小计")){
					datamap.put(dimkey9, subdata.get(sb+1).get(dimkey9));
					if(null != dimkey10 && null != datamap.get(dimkey10)){ datamap.put(dimkey10,"小计");}
				}
			}
		}
		String datajson = null;
/*		if("1".equals(this.isTotal)){
			if("top".equals(this.pos)){
				subdata.remove(0);
			}else if("bottom".equals(this.pos)){
				String dsname = CommonTools.getDataSource(params.get("dataSourceName")).getDataSourceDB();
				if(null != dsname && "" != dsname && dsname.length()>0 && !dsname.equalsIgnoreCase("db2")){
					Map totalTmp = subdata.remove(0);
					subdata.add(totalTmp);
				}
			}
		}*/
		if("2".equals(report.getInfo().getLtype())){
			datajson = Functions.java2json(subdata);
		}else{
			Map map = new HashMap();
			map.put("total",total);
			map.put("rows",subdata);
			datajson = Functions.java2json(map);
		}

		request.getSession().removeAttribute(seskey);
		request.getSession().setAttribute(seskey,cacheSubTotal);
		if("true".equals(params.get("is_down_table"))){
			request.getSession().setAttribute("down_c_talbe_list",subdata);
			return null;
		}
		return datajson;
	}
	private void jiaohuanweizhi(List<Integer> tmpstkeylst,Map<Integer,Map<String,Object>> subtotalNew){
		int tmpstkeylstSize = tmpstkeylst.size();
		if(tmpstkeylstSize>1){
			Map<String,Object> tmp1 = subtotalNew.get(tmpstkeylst.get(0));
			Map<String,Object> tmp2 = subtotalNew.get(tmpstkeylst.get(tmpstkeylstSize-1));
			subtotalNew.put(tmpstkeylst.get(0), tmp2);
			subtotalNew.put(tmpstkeylst.get(tmpstkeylstSize-1), tmp1);
			tmpstkeylst.remove(tmpstkeylstSize-1);
			tmpstkeylst.remove(tmpstkeylst.get(0));
			jiaohuanweizhi(tmpstkeylst,subtotalNew);
		}
	}
}
/******************************************************************************
 * 
 * 
 * 
 * 
 ******************************************************************************/
package cn.com.easy.kpi.parser;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import org.apache.log4j.Logger;

import net.sf.ezmorph.bean.MorphDynaBean;
import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


import cn.com.easy.exception.JaxbException;
import cn.com.easy.jaxb.domain.Ebinding;
import cn.com.easy.jaxb.parser.DefaultJaxbParse;
import cn.com.easy.jaxb.parser.JaxbParse;
import cn.com.easy.jaxb.parser.metadata.ClassParser;
import cn.com.easy.kpi.element.*;

public  class  GenerateKpi {
	private final  String CLASSPATH = GenerateKpi.class.getResource("/").getPath();
	private final  String PATH = CLASSPATH.substring(0, CLASSPATH.indexOf("WEB-INF/classes"));
	private String kpiPath = PATH+"pages/kpi/custom/formal/";
	private String kpiTmpPath = PATH+"pages/kpi/custom/temp/";
	private Kpi kpiXmlTemp;
	private String filePath;
	private final String suffix=".xml";
	
	/*
	 * 描述：保存指标到xml文件中去 参数： xmlPath xml文件路径 Kpi指标对象实例 返回值：无
	 */
	public  void writeKpiTemplate(String xmlPath, Kpi kpi) throws Exception {
		kpiXmlTemp=kpi;
		filePath=kpiTmpPath+xmlPath;
		JaxbParse jaxb = null;
		try {
			jaxb = new DefaultJaxbParse();
			File file = new File(filePath+suffix);
			if (!file.exists()) {
				if (!file.getParentFile().exists()) {
					file.getParentFile().mkdirs();
				}
				file.createNewFile();
			}
			jaxb.write(Kpi.class, kpi, filePath+suffix);
		} catch (JaxbException e) {
			throw new Exception(e);
		} catch (IOException e) {
			throw new Exception(e);
		}
	}

	/*
	 * 描述：从xml文件中读取指标对象 参数： xmlPath xml文件路径 返回值：指标对象实例
	 */
	public  Kpi readKpiTemplate(String xmlPath) throws Exception {
		JaxbParse jaxb = null;
		Kpi kpi = null;
		try {
			jaxb = new DefaultJaxbParse();
			kpi = jaxb.read(Kpi.class, xmlPath);
		} catch (JaxbException e) {
			throw new Exception(e);
		}
		return kpi;
	}	
	protected Kpi readKpiInfo(Kpi kpi, boolean isFormal) throws Exception {
		return null;
	}	
	/**
	 * 
	 * @Description: TODO 返回Kpi对象下的所有属性成员。
	 *
	 */
	public Dimensions getDimensions(){
		return kpiXmlTemp.getDimensions();
	}
	public List<Dimension> getDimensionList(){
		return this.getDimensions().getDimensionList();
	}
	public List<Dictionary> getDictionary(){
		List<Dictionary> dictionaryList=new LinkedList<Dictionary>();
		List<Dimension> dimensionList=this.getDimensionList();
		Iterator<Dimension> iterator=dimensionList.iterator();
		while(iterator.hasNext()){
			dictionaryList.add(iterator.next().getDictionary());
		}
	return dictionaryList;
	}	
	
	public Measures getMeasures(){
		return kpiXmlTemp.getMeasures();
	}
	public List<Measure> getMeasure(){
		return this.getMeasures().getMeasureList();
	}
	public List<ForeignKeyLink> getForeignKeyLink(){
		List<ForeignKeyLink> foreignKeyLinkList=new LinkedList<ForeignKeyLink>();
		List<Measure> measureList=this.getMeasure();
		Iterator<Measure> iterator=measureList.iterator();
		while(iterator.hasNext()){
			foreignKeyLinkList.add(iterator.next().getForeignKeyLink());
		}
		return foreignKeyLinkList;
	}
	
	public Formulas getFormulas(){
		return kpiXmlTemp.getFormulas();
	}
	public Formula getFormula(){
		return this.getFormulas().getFormula();
	}
	/*public List<Measure> getFormulaMeasure(){
		return this.getFormula().getMeasure();
	}*/
	/*public Relation getFormulaRelation(){
		return this.getFormula().getRelation();
	}*/
	
	public Conditions getConditions(){
		return kpiXmlTemp.getConditions();
	}
	public List<Condition> getCondition(){
		return this.getConditions().getConditionList();
	}
	/*public List<Compose> getCompose(){
		List<Compose> composeList=new LinkedList<Compose>();
		List<Condition> conditionList=this.getCondition();
		Iterator<Condition> iterator=conditionList.iterator();
		while(iterator.hasNext()){
			composeList.add(iterator.next().getCompose());
		}
		return composeList;
	}*/
	public List<Relation> getConditionRelation(){
		List<Relation> relationList=new LinkedList<Relation>();
		List<Condition> conditionList=this.getCondition();
		Iterator<Condition> iterator=conditionList.iterator();
		while(iterator.hasNext()){
			relationList.add(iterator.next().getRelation());
		}
		return relationList;
	}
	public Kpi getKpiXmlTemp() {
		return kpiXmlTemp;
	}
	public void setKpiXmlTemp(Kpi kpiXmlTemp) {
		this.kpiXmlTemp = kpiXmlTemp;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}	
	public static byte[] toByteArrayFromInputStream(InputStream in) throws Exception {
		if (in == null) {
			return null;
		}
		ByteArrayOutputStream bos = new ByteArrayOutputStream();
		try {
			int buf_size = 1024;
			byte[] buffer = new byte[buf_size];
			int len = 0;
			while (-1 != (len = in.read(buffer, 0, buf_size))) {
				bos.write(buffer, 0, len);
			}
			return bos.toByteArray();
		} catch (Exception e) {
			throw new Exception(e);
		} finally {
			in.close();
			bos.close();
		}
	}

	public String getKpiPath() {
		return kpiPath;
	}

	public String getKpiTmpPath() {
		return kpiTmpPath;
	}

	public String getSuffix() {
		return suffix;
	}
}

package cn.com.easy.xbuilder.service.component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import cn.com.easy.annotation.Service;
import cn.com.easy.taglib.function.Functions;
import cn.com.easy.xbuilder.XContext;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Condition;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Weblink;
@Service
public class WebLateService extends ComponentBaseService{
	
	/*设置标题*/
	@SuppressWarnings("unchecked")
	public void setTitle(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setTitle(element.get("title"));
		saveToXmlByObj(reportObj);
		//System.out.println(validateAllChartComponent(reportObj,component));
	}
	
	/*设置用户输入的url*/
	@SuppressWarnings("unchecked")
	public void setUrl(String reportId,String containerId,String componentId,String jsonString) {
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		component.setUserUrl(element.get("userUrl"));
		saveToXmlByObj(reportObj);
		//System.out.println(validateAllChartComponent(reportObj,component));
	}
	
	/*设置用户输入的参数名*/
	@SuppressWarnings("unchecked")
	public void setVarname(String reportId,String containerId,String componentId,String jsonString){
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		//页面参数
		Map<String,String> element=(Map)Functions.json2java(jsonString);
		//设置页面参数
		String varname = element.get("varname");
		Condition cond = new Condition();
		cond.setVarname(varname);
		
		//查询源数据
		List<Condition> clist = component.getWeblink().getCondition();
		
		if(clist.size()<0){
			Weblink weblink = new Weblink();
			List<Condition> condlist = new ArrayList<Condition>();
			condlist.add(cond);
			weblink.setCondition(condlist);
			//component.setWeblink();
			saveToXmlByObj(reportObj);
		}else{
			
			
		}
	}
	
	/*回带userUrl的值*/
	public String getWebLinkUserUrl(String reportId,String containerId,String componentId){
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		String userUrl = component.getUserUrl();
		return userUrl;
	}
	
	/*填加源数据weblink*/
	@SuppressWarnings("unchecked")
	public void addWeblinkOrCondition(String reportId,String containerId,String componentId,String jsonString){
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		Map<String,Object> element = (Map)Functions.json2java(jsonString);
		Weblink web = new Weblink();
		List cList=new ArrayList();
		cList=(ArrayList)element.get("clist");
		List<Condition> vlist = getConditionValue(component);
		vlist.clear();
		for(int i=0;i<cList.size();i++){
			Map<String,String> tempMap=(Map<String,String>)cList.get(i);
			Condition condition = new Condition();
			String varname = tempMap.get("ser_name");
			String desname = tempMap.get("ser_value");
			String cond = "";
			condition.setId(""+i);
			condition.setVarname(varname);
			condition.setDesname(desname);
			if(!"".equals(varname) && !"".equals(desname)){
				cond=varname+"=${"+desname+"}";
				
			}
			condition.setCond(cond);
			vlist.add(condition);
		}
		web.setCondition(vlist);
		component.setWeblink(web);
		saveToXmlByObj(reportObj);
	}
	
	/*校验组件内各元素有效性
	 * @param reportId
	 * @param containerId		
	 * @param componentId		
	 * @return String
	 * */
	public String validateWebLate(Report report,Component component){
		StringBuffer str = new StringBuffer();
		String userUrl = component.getUserUrl();
		if(!"".equals(userUrl) && userUrl!=null){
			str.append("");
		}else{
			str.append("||||页面模版：页面模版“地址”不能为空！<br/>\n");
		}
		return str.toString();
	}
	
	
	/*还原编辑weblink*/
	public String getWeblinkJsonData(String reportId,String containerId,String componentId,String jsonString){
		Report reportObj=XContext.getEditView(reportId);
		Component component=getOrCreateComponet(reportObj,containerId,componentId);
		return Functions.java2json(component);
	}
	
	
	public Weblink getWeblinkValue(List<Condition> vlist){
		Weblink web = new Weblink();
		web.setCondition(vlist);
		return web;
	}
	
	public List<Condition> getConditionValue(Component component){
		Weblink web = component.getWeblink();
		List<Condition> clist = new ArrayList<Condition>();
		if(web!=null){
			clist = web.getCondition();
		}else{
			web = new Weblink();
		}
		component.setWeblink(web);
		return clist;
	}
	
}

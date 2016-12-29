package cn.com.easy.xbuilder.kpi;

import java.util.List;
import java.util.Map;

import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Report;

/**
 * 指标库相关接口
 * @author zuobin
 *
 */
public interface KpiInterface {
	
	/**
	 * 获取指标库的维度和指标数据
	 * @param paramMap：pid：父节点编码[虚拟根-1]，userid：用户编码session.user_id，type：dim为维度，kpi为指标，keyword：查询条件
	 * @return List<Map<String, String>>:map中应包含 id，pid，name，column，isleaf，type：1日/基础、2月/组合、3其他
	 */
	public List<Map<String, String>> getDimKpiData(Map<String,String> paramMap);
	
	/**
	 * 根据选择的维度和指标生成SQL语句
	 * @param paramMap:dim：维度list<id>；kpi：指标list<id>；where：list<Map<String,String>>其中key为：id，formula即维度id和条件表达式，如>=，like等；orders：list<Map<String,String>>其中key为：id，ord：desc/asc; alias Map<String,String> 其中key为码表中对应key和value的别名
	 * @return map：[result:'success or fail',content:'sql语句 or 错误信息']
	 */
	//public Map<String, String> getSql(Map<String,Object> paramMap);
	public Map<String, String> getSql(List<String> dims,List<String> kpis,List<Map<String,String>> where,List<Map<String,String>> orders,Map<String,String> alias);
	
	/**
	 * 根据选择的维度和指标生成SQL语句
	 * @param paramMap:dim：维度list<id>；kpi：指标list<id>；where：list<Map<String,String>>其中key为：id，formula即维度id和条件表达式，如>=，like等；orders：list<Map<String,String>>其中key为：id，ord：desc/asc; alias Map<String,String> 其中key为码表中对应key和value的别名
	 * @return map：[result:'success or fail',content:'sql语句 or 错误信息']
	 */
	//public Map<String, String> getSql(Map<String,Object> paramMap);
	public Map<String, String> getSql(List<String> dims,List<Map<String,String>> kpis,List<Map<String,String>> where,List<Map<String,String>> orders,Map<String,String> alias,Report report,Component component);
	
}

package cn.com.easy.xbuilder.kpi;

import java.util.HashMap;
import java.util.Map;

public class KpiService {
	
	/**
     * 指标引用情况
     * @param paramMap kpiId:指标id
     * @return [menuname：菜单名字，pagename：报表名字，url：报表地址，publish：0未使用，1使用中，username：使用人，time：使用时间，pagedemo：报表描述] 
     */
	public Map<String, String> kpiReferenceInfo(Map<String,String> paramMap){
		
		Map<String, String> resultMap = new HashMap<String,String>();
		
		return resultMap;
	}
	
}

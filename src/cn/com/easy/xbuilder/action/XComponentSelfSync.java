package cn.com.easy.xbuilder.action;

import java.util.HashMap;
import java.util.Map;

import cn.com.easy.annotation.Component;
import cn.com.easy.core.EasyContext;
import cn.com.easy.xbuilder.parser.XGenerateSync;

@Component("XGenerateSelfSync")
public class XComponentSelfSync{
	public void init() {
		String devMode = (String)EasyContext.getContext().getServletcontext().getAttribute("xbuilderDeployMode");
		if(null == devMode || devMode.length()<=0 || devMode.equalsIgnoreCase("single")){
			return;
		}
		System.out.println(">>>>系统重启，XBuilder自我同步最新jsp代码");
        XGenerateSync xgenerateSync = new XGenerateSync();
        Map<String,String> params = new HashMap<String,String>();
        String meRmi = (String)EasyContext.getContext().getServletcontext().getAttribute("localRmiLocation");
        params.put("reportId", "all");
        params.put("from", meRmi);
        params.put("to", meRmi);
        params.put("createUser","system");
        xgenerateSync.syncEvt(params);
	}
}
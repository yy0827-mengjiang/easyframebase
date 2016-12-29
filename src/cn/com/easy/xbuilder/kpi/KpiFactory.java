package cn.com.easy.xbuilder.kpi;

import cn.com.easy.core.EasyContext;

public class KpiFactory {
	
	private static String className = null;
	
	public static String EXT_DS = null;

	public static KpiInterface getCls() throws InstantiationException,
			IllegalAccessException, ClassNotFoundException {
		if (className == null) {
			className = EasyContext.getContext().getString("kpiclass");
		}
		return (KpiInterface) Class.forName(className).newInstance();
	}

//	static {
//		EXT_DS = EasyContext.getContext().getString("ext_ds");
//	}
}
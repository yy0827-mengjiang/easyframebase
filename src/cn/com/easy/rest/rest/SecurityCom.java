package cn.com.easy.rest.rest;

import java.util.HashMap;
import java.util.Map;

import cn.com.easy.annotation.Component;
import cn.com.easy.web.filter.Application;
import cn.com.easy.web.filter.SecurityInformationComponent;

@Component("restful.security.information.component")
public class SecurityCom extends SecurityInformationComponent {
	
	@Override
	public void init() {
		Map<String, String> app = new HashMap<String,String>();
		app.put("key", "EASYETL");
		app.put("pwd", "BONCETL");
		app.put("ip", "localhost,127.0.0.1");
		Application application = map2app(app);
		addApplication(application);
	}

	private Application map2app(Map<String, String> map) {
		Application application = new Application();
		application.setAppkey(map.get("key"));
		application.setAppsecret(map.get("pwd"));
		String[] addresses = map.get("ip").split(",");
		for (int i = 0, len = addresses.length; i < len; i++) {
			application.addAddress(addresses[i]);
		}
		return application;
	}
	
}
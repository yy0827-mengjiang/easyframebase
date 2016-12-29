package cn.com.easy.sso.client.impl;

import java.util.Map;

import cn.com.easy.ext.DefaultLogin;

import com.bonc.sso.client.IAuthHandle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EasyAuthHandleImpl implements IAuthHandle {
	
	public boolean onSuccess(HttpServletRequest request,HttpServletResponse response, String loginId) {
		if ((request != null) && (loginId != null) && (loginId.trim().length() > 0)) {
			HttpSession session = request.getSession(true);
			session.setAttribute("userReqIp", request.getLocalAddr());
			Map user = (Map) session.getAttribute("UserInfo");
			if (user != null && loginId.equals(user.get("LOGIN_ID"))) {
				return true;
			}
			user = new DefaultLogin().PortalLogin(loginId, request);
			if (user != null && user.size()>0) {
				return true;
			}
		}
		return false;
	}
}
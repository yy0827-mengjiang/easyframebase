package cn.com.easy.down.server;

import java.util.Iterator;
import java.util.PropertyResourceBundle;
import java.util.Set;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class TransferServerListener implements ServletContextListener {
	/**
	 * 自动启动下载服务端socket
	 */
	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		
            new Thread(new Runnable() {
				@Override
				public void run() {
					PropertyResourceBundle propertyFileResource=(PropertyResourceBundle) PropertyResourceBundle.getBundle("framework");
					boolean isServerFlag=false;//是否是下载服务器
					Set<String> keySet=propertyFileResource.keySet();
					if(keySet==null){
						return;
					}
					Iterator<String> iterator=keySet.iterator();
					if(iterator==null){
						return;
					}
					String tempIteratorString=null;
					Object downLoadSocketServerPort=null;
					while(iterator.hasNext()){
						tempIteratorString=iterator.next();
						if("DownLoadSocketServerPort".equals(tempIteratorString)){
							downLoadSocketServerPort=propertyFileResource.getObject("DownLoadSocketServerPort");
							if(downLoadSocketServerPort!=null&&(!("".equals(String.valueOf(downLoadSocketServerPort))))||(!("null".equals(String.valueOf(downLoadSocketServerPort).toLowerCase())))){
								isServerFlag=true;
							}
						}
					}
					if(!isServerFlag){//不是下载服务器
						return ;
					}
		            int serverPort = Integer.parseInt(propertyFileResource.getString("DownLoadSocketServerPort").trim());
					try {
						new TransferServer(serverPort).service();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}).start();
	}

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		
	}
}

package cn.com.easy.xbuilder.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.PropertyResourceBundle;

import cn.com.easy.core.EasyContext;

public class ClobDbUtil {
	private PropertyResourceBundle jdbcProperties = (PropertyResourceBundle) PropertyResourceBundle.getBundle("jdbc");
	private Connection clobConn;
	@SuppressWarnings("unused")
	public Connection openClobConnection(){
		Connection sourceConnection;
		try {
			sourceConnection = EasyContext.getContext().getDataSource().getConnection();
			final String productVersion=sourceConnection.getMetaData().getDatabaseProductVersion();
			if(productVersion!=null&&productVersion.toLowerCase().indexOf("oracle")>-1){
				if((!(sourceConnection.isClosed()))){
					sourceConnection.close();
				}
				final Properties props = new Properties();
				props.put("user", jdbcProperties.getString("jdbc.username"));
				props.put("password", jdbcProperties.getString("jdbc.password"));
				props.put("SetBigStringTryClob", "true");
				Class.forName(jdbcProperties.getString("jdbc.driverClassName"));
				this.clobConn = DriverManager.getConnection(jdbcProperties.getString("jdbc.url"),props);     
			}else{
				this.clobConn=sourceConnection;
			}
		} catch (final SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		} catch (final ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		return clobConn;
		
	}
	@SuppressWarnings("unused")
	public void closeClobConnection(){
		try {
			if(this.clobConn!=null&&(!(this.clobConn.isClosed()))){
				clobConn.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

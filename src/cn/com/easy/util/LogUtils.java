package cn.com.easy.util; 

import org.apache.log4j.Logger;

public class LogUtils {
	
	static Logger logger = Logger.getLogger(LogUtils.class);
	

	public static void debugFormat(String info, Object... args){
		logger.debug("**********  " + String.format(info, args));
	}
	
	public static void errorFormat(String info, Object... args){
		logger.debug("**********  " + String.format(info, args));
	}
	
	public static void debugLine(String info){
		logger.debug(String.format("====================%s====================", info));
	}
	
	public static void errorLine(String info){
		logger.debug(String.format("====================%s====================", info));
	}
	
	public static void debugLineStart(String info){
		logger.debug(String.format("====================%s Start ====================", info));
	}
	
	public static void debugLineEnd(String info){
		logger.debug(String.format("====================%s End   ====================", info));
	}
	
	public static void debug(String info){
		logger.debug("**********  " + info);
	}
	
	public static void error(String error){
		logger.error("!!!!!!!!!!  " + error);
	}
	
}
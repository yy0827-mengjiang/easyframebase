package cn.com.easy.ext;

public class LoginFactory {
	public static AbstractLogin getLogin(String className) throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		return (AbstractLogin) Class.forName(className).newInstance();
	}
}
package cn.com.easy.xbuilder.parser;

import java.util.Comparator;
import cn.com.easy.xbuilder.element.Datacol;

/**
 * 对象排序类（只能排tablecolcode）
 * @author Administrator
 * 邢政
 */
public class TableColCode implements Comparator{

	@Override
	public int compare(Object o1, Object o2) {
		Datacol s1 = (Datacol) o1;
		Datacol s2 = (Datacol) o2;
		if(s1.getTablecolcode().length()>s2.getTablecolcode().length()){
			return 1;
		}else if(s1.getTablecolcode().length()<s2.getTablecolcode().length()){
			
			return -1;
		}else{
			if (s1.getTablecolcode().compareTo(s2.getTablecolcode()) < 0){
				return -1;
			}
			else if (s1.getTablecolcode().compareTo(s2.getTablecolcode()) > 0) {
				return 1;
			}
		}
		return 0;
	}
	
}

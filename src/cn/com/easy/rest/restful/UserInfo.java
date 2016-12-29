package cn.com.easy.rest.restful;

import java.util.List;

public class UserInfo {

	private String id;
	private String name;
	private int age;
	private List arr;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public List getArr() {
		return arr;
	}

	public void setArr(List arr) {
		this.arr = arr;
	}

}

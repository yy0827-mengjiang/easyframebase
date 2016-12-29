package cn.com.easy.rest.rest;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;

import cn.com.easy.restful.data.RESTString;

@Path("etljob")
public class EtlJobRest {
	
	@Path("startJob/{pid}/{pname}")
	@POST
	@GET
	public Person startJob(String pid,String pname,HttpServletRequest request) {
		
		System.out.println(pid+"============"+pname);
		Person person=new Person();
		person.setPid(pid);
		person.setPname(pname);
		
		return person;
		//http://localhost:8080/eframe_oracle/restful/etljob/startJob?timestamp=20161026084853&appkey=EASYETL&sign=A6B123740DAB61230392827D3CCDE103&jobId=123&etlAccountId=456
	}
	
}

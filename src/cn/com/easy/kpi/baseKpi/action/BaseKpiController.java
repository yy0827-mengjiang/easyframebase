package cn.com.easy.kpi.baseKpi.action;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.ext.DownLoad;
import cn.com.easy.kpi.baseKpi.domain.BaseKpi;
import cn.com.easy.kpi.baseKpi.domain.KpiInfo;
import cn.com.easy.kpi.baseKpi.service.BaseKpiService;
import cn.com.easy.kpi.baseKpi.service.FileUploadUtil;
import cn.com.easy.kpi.baseKpi.service.FormulaKpiUtil;
import cn.com.easy.util.StringUtils;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2016/2/2.
 */
@Controller
public class BaseKpiController {
	private SqlRunner runner;
    private BaseKpiService baseKpiService = new BaseKpiService();

    @Action("addBaseKpi")
    public void addBaseKpi(HttpServletRequest request, HttpServletResponse response) {
    	String parentId =request.getParameter("kpi_category");
        try {
        	Map user= (Map) request.getSession().getAttribute("UserInfo");
            KpiInfo kpiInfo = baseKpiService.addBaseKpi();
            String baseType=request.getParameter("baseType");
            kpiInfo.getBaseKpi().setCreate_user_id(user.get("USER_ID").toString());
            kpiInfo.getBaseKpi().setBaseType(baseType);
            kpiInfo.getBaseKpi().setKpi_category(parentId);
            request.setAttribute("kpiInfo", JSONObject.fromObject(kpiInfo));
            request.setAttribute("action", "insert"); 
            String cube_code = (String) request.getParameter("cube_code");
            String serverClass = (String) request.getParameter("server_class"); 
            try {
                request.getRequestDispatcher("pages/kpi/baseKpi/baseKpi.jsp?cube_code=" + cube_code + "&operFlag=add&serverClass="+serverClass).forward(request, response);
                //response.sendRedirect("pages/kpi/baseKpi/baseKpi.jsp?cube_code=" + cube_code + "&operFlag=add&serverClass="+serverClass+"&baseType="+baseType);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    @Action("draftBaseKpi")
    public void draftBaseKpi(HttpServletRequest request, HttpServletResponse response) throws InvocationTargetException, IllegalAccessException {
        BaseKpi baseKpi=new BaseKpi();
        Map parameter = new HashMap();
        int i=0;
        JSONObject jsonObject=new JSONObject();
        try {
        	baseKpiService = new BaseKpiService(runner);
            new FileUploadUtil().fileUpload(request,parameter);
            if (parameter==null||parameter.isEmpty())return;
            String cube_code =(String) request.getParameter("cube_code");
            parameter.put("cube_code", cube_code);
            BeanUtils.populate(baseKpi,parameter);
            String kpiOrigin[] = parameter.get("kpi_origin_stc").toString().split("\\.");
            String kpiVersion = parameter.get("kpi_version").toString();
            //指标业务编码
            if("1".equals(new FormulaKpiUtil().getServerNum(parameter.get("baseType").toString(), runner))){
	            int key = 0;
	            if("update".equals(parameter.get("operation"))){
	            	if(parameter.get("codeId") == null || "".equals(parameter.get("codeId").toString())){
		    			key = new FormulaKpiUtil().getKpiInfoSeq(runner);
	            	} else {
		    			key = Integer.parseInt(parameter.get("codeId").toString());
	            	}
	    		}else{
	    			key = new FormulaKpiUtil().getKpiInfoSeq(runner);
	    		}
	            String kpiCode = "";
	            List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	            for(Map<String,String> map:li){
	            	kpiCode += parameter.get(map.get("CLASS_NAME")).toString();
	            }
	            String codeId = parameter.get("codeId").toString();
	            if(StringUtils.isEmpty(codeId)){
	            	codeId =new FormulaKpiUtil().getSeq(runner);
	            }
	            baseKpi.setKpi_code(kpiCode+codeId);
            }else{
            	baseKpi.setKpi_code("");
            }
            baseKpi.setKpi_version(kpiVersion);
            baseKpi.setKpi_origin_schema(kpiOrigin[0]);
            baseKpi.setKpi_origin_table(kpiOrigin[1]);
            baseKpi.setKpi_origin_column(kpiOrigin[2]);
            baseKpi.setKpi_state("1");
            Map user= (Map) request.getSession().getAttribute("UserInfo");
            parameter.put("user", user.get("USER_ID"));
            baseKpiService.getKpiInfo().setBaseKpi(baseKpi);
            String operation= parameter.get("operation").toString() ;
//            if(!parameter.get("isPublish").equals("true")){
                if(operation.equals("insert")){
                	String id = new FormulaKpiUtil().getInfoSql(runner);
//                	baseKpiService.insertBaseKpiHis(id);
                    i=baseKpiService.insertBaseKpi(id);
                }
                else if(operation.equals("update")){
//                	baseKpiService.updateBaseKpiHis();
                    i=baseKpiService.updateBaseKpi();
//                  baseKpiService.updateHis();
                }
                new FormulaKpiUtil().saveAttr(parameter, runner);
//            }
//            else
//                i=baseKpiService.publishBaseKpi();
            jsonObject.put("success",i);
            jsonObject.put("action",operation);
            response.getWriter().write(jsonObject.toString());
           // response.sendRedirect("pages/kpi/kpiManager/newKpiManager.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Action("editBaseKpi")
    public void editBaseKpi(HttpServletRequest request,HttpServletResponse response,String id){//String base_key,String version) {
        //baseKpiService.getKpiInfo().getBaseKpi().setBase_key(base_key);
        //baseKpiService.getKpiInfo().getBaseKpi().setKpi_version(version);
    	baseKpiService = new BaseKpiService(runner);
        String cube_code = (String) request.getParameter("cube_code");
        baseKpiService.getKpiInfo().getBaseKpi().setId(id);
        KpiInfo kpiInfo = baseKpiService.editBaseKpi();
        kpiInfo.getBaseKpi().setKpi_version(Integer.parseInt(kpiInfo.getBaseKpi().getKpi_version())+1+"");
        String serviceCode = kpiInfo.getBaseKpi().getKpi_code();
        String baseType = kpiInfo.getBaseKpi().getBaseType();
        request.setAttribute("kpiInfo", JSONObject.fromObject(kpiInfo));
        request.setAttribute("action", "update");
        request.setAttribute("baseKey", kpiInfo.getBaseKpi().getBase_key());
        try {
        	if("1".equals(new FormulaKpiUtil().getServerNum(kpiInfo.getBaseKpi().getBaseType(), runner))){
	        	Map<String,String> code = new HashMap<String,String>();
	        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	        	int start = 0;
	        	if(StringUtils.isNotEmpty(serviceCode)){
		        	for(int i =0;i<li.size();i++){
		        		start = i*2;
		        		code.put(li.get(i).get("CLASS_NAME"), serviceCode.substring(start, start+2));
		        	}
		        	code.put("codeId", serviceCode.substring(start+2, serviceCode.length()));
		        	request.setAttribute("serviceCode", JSONObject.fromObject(code));
	        	}else{
	        		request.setAttribute("serviceCode", "");
	        	}
        	}else{
        		Map<String,String> code = new HashMap<String,String>();
        		request.setAttribute("serviceCode", "");
        	}
            request.getRequestDispatcher("pages/kpi/baseKpi/baseKpi.jsp?cube_code=" + cube_code+ "&operFlag=add&baseType=" + kpiInfo.getBaseKpi().getBaseType()).forward(request, response);
//            response.sendRedirect("pages/kpi/baseKpi/baseKpi.jsp?cube_code=" + cube_code+ "&operFlag=add&baseType=" + kpiInfo.getBaseKpi().getBaseType());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Action("lookBaseKpi")
    public void lookBaseKpi(HttpServletRequest request,HttpServletResponse response,String id){//String base_key,String version) {
        //baseKpiService.getKpiInfo().getBaseKpi().setBase_key(base_key);
        //baseKpiService.getKpiInfo().getBaseKpi().setKpi_version(version);
    	baseKpiService = new BaseKpiService(runner);
        String cube_code = (String) request.getParameter("cube_code");
        String lookUpFlag = (String) request.getParameter("lookUpFlag");
        baseKpiService.getKpiInfo().getBaseKpi().setId(id);
        KpiInfo kpiInfo = baseKpiService.editBaseKpi();
        String serviceCode = kpiInfo.getBaseKpi().getKpi_code();
        String baseType = kpiInfo.getBaseKpi().getBaseType();
        request.setAttribute("kpiName", kpiInfo.getBaseKpi().getKpi_name());
        request.setAttribute("kpiInfo", JSONObject.fromObject(kpiInfo));
        request.setAttribute("action", "update");
        request.setAttribute("baseKey", kpiInfo.getBaseKpi().getBase_key());
        request.setAttribute("lookUpFlag", lookUpFlag);
        try {
        	if("1".equals(new FormulaKpiUtil().getServerNum(kpiInfo.getBaseKpi().getBaseType(), runner))){
	        	Map<String,String> code = new HashMap<String,String>();
	        	List<Map<String,String>> li = new FormulaKpiUtil().getCodeName(runner);
	        	int start = 0;
	        	if(StringUtils.isNotEmpty(serviceCode)){
		        	for(int i =0;i<li.size();i++){
		        		start = i*2;
		        		code.put(li.get(i).get("CLASS_NAME"), serviceCode.substring(start, start+2));
		        	}
		        	code.put("codeId", serviceCode.substring(start, serviceCode.length()));
		        	request.setAttribute("serviceCode", JSONObject.fromObject(code));
	        	}else{
	        		request.setAttribute("serviceCode", "");
	        	}
        	}else{
        		Map<String,String> code = new HashMap<String,String>();
        		request.setAttribute("serviceCode", "");
        	}
            request.getRequestDispatcher("pages/kpi/baseKpi/baseKpiLook.jsp?cube_code=" + cube_code+ "&operFlag=add&baseType=" + kpiInfo.getBaseKpi().getBaseType()).forward(request, response);
//            response.sendRedirect("pages/kpi/baseKpi/baseKpiLook.jsp?cube_code=" + cube_code+ "&operFlag=add&baseType=" + kpiInfo.getBaseKpi().getBaseType());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Action("validateSTC")
    public void validateSTC(HttpServletRequest request,HttpServletResponse response){
        response.setHeader("Charset", "UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        BaseKpi baseKpi=new BaseKpi();
        String kpiOrigin[]=request.getParameter("STC").toString().split("\\.");
        baseKpi.setKpi_origin_schema(kpiOrigin[0]);
        baseKpi.setKpi_origin_table(kpiOrigin[1]);
        baseKpi.setKpi_origin_column(kpiOrigin[2]);
        String kpi_eds=request.getParameter("kpi_eds").toString();
        baseKpi.setKpi_eds(kpi_eds);
    	baseKpiService.getKpiInfo().setBaseKpi(baseKpi);
        Map map=baseKpiService.validateSTC();
        if(map!=null&&map.isEmpty()){
            map.put("msg","列不存在!");
        }
    	try {
			PrintWriter pw=response.getWriter();
			pw.write(String.valueOf(JSONObject.fromObject(map)));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    @Action("validateBaseKpiName")
    public void validateBaseKpiName(HttpServletRequest request,HttpServletResponse response){
        response.setHeader("Charset", "UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        BaseKpi baseKpi=new BaseKpi();
        String kpi_name = (String) request.getParameter("kpi_name");
        String cube_code = (String) request.getParameter("cube_code");
        baseKpi.setKpi_name(kpi_name);
        baseKpi.setCube_code(cube_code); 
    	baseKpiService.getKpiInfo().setBaseKpi(baseKpi);
        Map<String,String> map=baseKpiService.validateBaseKpiName();
    	try {
			PrintWriter pw=response.getWriter();
			pw.write(String.valueOf(JSONObject.fromObject(map)));
		} catch (IOException e) {
			e.printStackTrace();
		}
    }
    @Action("deleteBaseKpi")
    public void deleteBaseKpi(HttpServletRequest request,HttpServletResponse response){
    	baseKpiService = new BaseKpiService(runner);
    	response.setHeader("Charset", "UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        BaseKpi baseKpi=new BaseKpi();
        String base_key = (String) request.getParameter("kpi_code");
        Map user= (Map) request.getSession().getAttribute("UserInfo");
        baseKpi.setEdit_user_id(user.get("USER_ID").toString());
        baseKpi.setBase_key(base_key);
    	baseKpiService.getKpiInfo().setBaseKpi(baseKpi);
    	try {
    		Map<String,String> map=baseKpiService.deleteBaseKpi();
			PrintWriter pw=response.getWriter();
			pw.write(String.valueOf(map.get("msg")));
		} catch (Exception e) {
			e.printStackTrace();
		}
    }
    @Action("downloadExcelFile")
	public void downloadFile(String doc_type,HttpServletRequest request, HttpServletResponse response) {
		try {
			String excelName="";
			if("dim".equals(doc_type)){
				excelName="纬度表(X_KPI_DIM_CODE)";
			}else if("dim_r".equals(doc_type)){
				excelName="魔方和纬度关系表(X_KPI_RAL_DIM)";
			}else if("attr_r".equals(doc_type)){
				excelName="魔方和属性关系表(X_KPI_RAL_ATTR)";
			}else if("key_r".equals(doc_type)){
				excelName="魔方和主键关系表(X_KPI_RAL_KEY)";
			}
			System.out.println("doc_type:-"+doc_type);
			DownLoad dl = new DownLoad();
			dl.downloadFile(request, response, request.getSession().getServletContext().getRealPath("/") + "/pages/kpi/cube/download/" +doc_type+ ".xlsx",excelName);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
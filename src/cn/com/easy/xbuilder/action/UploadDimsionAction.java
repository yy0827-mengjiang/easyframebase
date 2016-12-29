package cn.com.easy.xbuilder.action;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import cn.com.easy.annotation.Action;
import cn.com.easy.annotation.Controller;
import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.xbuilder.parser.CommonTools;
import cn.com.easy.xbuilder.service.XBaseService;
import cn.com.easy.xbuilder.utils.FileUtil;

@Controller
public class UploadDimsionAction extends XBaseService{
	private SqlRunner runner;
	private String classPath = this.getClass().getClassLoader().getResource("/").getPath();
	@SuppressWarnings("unchecked")
	@Action("xbuilderUploadDimsion")
	public String uploadFile(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String path = classPath.replaceAll("WEB-INF/classes/", "") + "pages/download/";
		java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHH24mmssSSS"); 
		java.util.Date currentTime = new java.util.Date();
		String sqId = formatter.format(currentTime);
		String extds = "";
		String logId="";
		String fieldName = "";
		String reportId="";
		try {
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			String fileName = "", fileType = "",fileFactName = "";
			FileItem item;
			
			if (isMultipart) {
				FileItemFactory factory = new DiskFileItemFactory();
				String charset = request.getCharacterEncoding();
				ServletFileUpload upload = new ServletFileUpload(factory);
				List items = upload.parseRequest(request);
				Iterator iter = items.iterator();
				int step = 4;
				String[] para = new String[step];
				int i = 0;
				while (iter.hasNext()) {
					item = (FileItem) iter.next();
					if (item.isFormField()) {
						para[i] = item.getString(charset);
						i++;
					    if(item.getFieldName().startsWith("extds")){
					    	extds = item.getString();
					    } 
					    if(item.getFieldName().startsWith("dim")){
					    	fieldName = item.getString();
					    }
					    if(item.getFieldName().equals("reportId")){
					    	reportId = item.getString();
					    }
					    
					} else {
						if (item.getName() != null&& (!"".equals(item.getName()))) {
							String tempstr = item.getName().substring(item.getName().lastIndexOf("\\") + 1);
							fileFactName = tempstr;
							int stp = tempstr.indexOf(".");
							if(stp == -1){
								fileType = "";
							}else{
								fileType = tempstr.substring(tempstr.lastIndexOf("."));
							}
							fileName= sqId + "_REPORT" + fileType;
							i++;
							File file = new File(path + fileName);
							item.write(file);
						}
					}
				}
			}
			
			response.setHeader("Charset", "UTF-8");
			response.setContentType("text/html;charset=UTF-8");
			logId = insertData(request,fileName,fileFactName,reportId,"0",extds,fieldName);
			request.setAttribute("ok", "ok");
			if(logId != null && logId.equals("xlserror")){
				response.getWriter().write("<script>alert('上传文件条数不可超过60000条，请重试！');<script>");
				request.setAttribute("xlserror", "xlserror");
				File file = new File(fileName);
				file.delete();
			}
		} catch (Exception e) {
			response.getWriter().write("<script>alert('上传过程中出错');<script>");
			request.setAttribute("error", "error");
			e.printStackTrace();
		}
		return "/pages/xbuilder/usepage/common/CommonReportUploadFile.jsp?ok=ok&reportId="+reportId+"&logId="+logId+"&fieldName="+fieldName;
	}
	/**
	 * 
	 * @param request
	 * @param fileName 文件名称
	 * @param fileFactName 文件实际名称
	 * @param reportId 报表ID
	 * @param state 0 通过上传调用  1 通过选择文件功能去调用
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	public String insertData(HttpServletRequest request,String fileName,String fileFactName,String reportId,String state,String extds,String fieldName) throws Exception{
		String path = classPath.replaceAll("WEB-INF/classes/", "") + "pages/download/";
		String dir = path;
		if(reportId == null || reportId.trim().equals("")|| reportId.trim().toLowerCase().equals("null")){
			reportId = "";
		}
		path = path + fileName;
		
		List<String> xlsDataList = FileUtil.readExcel(path);
		if(xlsDataList != null && xlsDataList.size() > 60000){
			return "xlserror";
		}
		
		String[] extdsArr = null;
		if(extds!=null&&!extds.equals("")){
			extdsArr = extds.split("#");
		}
		
		/*
		String checkExistUploadTableSQL = " select count(*) TB_COUNT from user_tables where table_name = 'SYS_REPORT_UPLOAD_DATA' ";
		String createUploadTableSQL = " CREATE TABLE SYS_REPORT_UPLOAD_DATA (DATA_ID VARCHAR2(20 BYTE) , DATA_CON VARCHAR2(2000 BYTE) , UPLOAD_USER VARCHAR2(20 BYTE) , UPLOAD_USERNAME VARCHAR2(200 BYTE) , REPORT_ID VARCHAR2(50 BYTE) , FILE_FACT_NAME VARCHAR2(200 BYTE) , FIELD_NAME VARCHAR2(200 BYTE)) ";
		if(extdsArr!=null){
			for(int i=0;i<extdsArr.length;i++){
				if("null".equals(extdsArr[i]))
					continue;
				Map tbCountMap = runner.queryForMap(extdsArr[i], checkExistUploadTableSQL, new HashMap());
				if(tbCountMap!=null){
				    int size = Integer.parseInt(tbCountMap.get("TB_COUNT")+"");
				    if(size==0){
				    	runner.execute(extdsArr[i], createUploadTableSQL,new HashMap());
				    }
				}
			}
		}*/
		String userId = "" + ((Map)(request.getSession().getAttribute("UserInfo"))).get("USER_ID");
		Map<String, String> logIdMap=runner.queryForMap("SELECT 'LOG' || X_REPORT_UPLOAD_DATA_SEQ.nextval LOG_ID FROM DUAL");
		String logId=logIdMap.get("LOG_ID");
		
		//注入日志
		if(state !=null && state.equals("0")){
			StringBuffer insertXlsSqlLog = new StringBuffer(" INSERT INTO X_REPORT_UPLOAD_DATA_LOG (LOG_ID, FILE_PATH, UPLOAD_DATE, UPLOAD_USER,REPORT_ID,FILE_NAME,FILE_FACT_NAME,FIELD_NAME) values ");
			insertXlsSqlLog.append(" (#logId#, ");
			insertXlsSqlLog.append(" #file_path#, ");
			insertXlsSqlLog.append(" sysdate, ");
			insertXlsSqlLog.append(" #USER_ID#, ");
			insertXlsSqlLog.append(" #reportId#,");
			insertXlsSqlLog.append(" #FILE_NAME#,");
			insertXlsSqlLog.append(" #FILE_FACT_NAME#,");
			insertXlsSqlLog.append(" #FIELD_NAME# )");
			Map parameterMap = new HashMap();
			parameterMap.put("USER_ID", userId);
			parameterMap.put("logId", logId);
			parameterMap.put("reportId", reportId);
			parameterMap.put("file_path", dir);
			parameterMap.put("FILE_NAME", fileName);
			parameterMap.put("FILE_FACT_NAME", fileFactName);
			parameterMap.put("FIELD_NAME", fieldName);
			runner.execute(insertXlsSqlLog.toString(),parameterMap);
		}
		
		//删除临时表里数据
		StringBuffer delsql = new StringBuffer(" DELETE FROM X_REPORT_UPLOAD_DATA T WHERE T.LOG_ID=#logId#");
		//StringBuffer xcloubDelsql = new StringBuffer("UPDATE X_REPORT_UPLOAD_DATA SET STATE='0' WHERE LOG_ID=#logId#");
		Map paramMap = new HashMap();
		paramMap.put("logId", logId);
		if(extdsArr!=null){
			for(int i=0;i<extdsArr.length;i++){
				if("null".equals(extdsArr[i])){
					runner.execute(delsql.toString(), paramMap);
				}else if("xcloud".equals(CommonTools.getDataSource(extdsArr[i]).getDataSourceDB().toLowerCase())){
					//runner.execute(extdsArr[i],xcloubDelsql,delparamMap);
				}else{
					runner.execute(extdsArr[i],delsql.toString(), paramMap);
				}
			}
		}
		
		if(extdsArr!=null){
			String inserXlsSql="INSERT INTO X_REPORT_UPLOAD_DATA (DATA_CON,LOG_ID) VALUES(#data#,#logId#)";
			//int executeNum=1000;
			for(int i=0;i<extdsArr.length;i++){
				try {
					if((!("null".equals(extdsArr[i])))&&CommonTools.getDataSource(extdsArr[i])!=null&&"xcloud".equals(CommonTools.getDataSource(extdsArr[i]).getDataSourceDB().toLowerCase())){
						File csvFile=new File(path+".csv");
						if(csvFile.exists()){
							csvFile.delete();
						}
						FileOutputStream o=null;  
						o = new FileOutputStream(csvFile);  
						for (String xlsData : xlsDataList) {
							if(xlsData!=null&&(!"".equals(xlsData.trim()))&&(!"null".equals(xlsData.trim().toLowerCase()))){
								o.write((xlsData+";"+logId+"\r\n").getBytes("gb2312"));  
							}
							
						}
						o.close();
						long start=System.currentTimeMillis();
						runner.execute(extdsArr[i],"@Client '"+csvFile.getAbsolutePath()+"' insert into X_REPORT_UPLOAD_DATA(DATA_CON,LOG_ID)",paramMap);
						System.out.println(System.currentTimeMillis()-start);
						continue;
					}
					for (String xlsData : xlsDataList) {
						paramMap.put("data", xlsData);
						if("".equals(xlsData)||xlsData==null||xlsData.trim().equals("")){
							continue;
						}
						if("null".equals(extdsArr[i])){
							if(xlsData!=null&&(!"".equals(xlsData.trim()))&&(!"null".equals(xlsData.trim().toLowerCase()))){
								runner.execute(null,inserXlsSql,paramMap);
							}
						/*}else if("xcloud".equals(CommonTools.getDataSource(extdsArr[i]).getDataSourceDB().toLowerCase())){
							runner.execute(extdsArr[i],xcloudInsertXlsSql,xlsData,logId,dateState);*/
						}else{
							if(xlsData!=null&&(!"".equals(xlsData.trim()))&&(!"null".equals(xlsData.trim().toLowerCase()))){
								runner.execute(extdsArr[i],inserXlsSql,paramMap);
							}
							
						}
					}
					/*Connection connection=null;
					if("null".equals(extdsArr[i])){
						connection=EasyContext.getContext().getDataSource().getConnection();
					}else{
						connection=EasyContext.getContext().getDataSource(extdsArr[i]).getConnection();
					}
					PreparedStatement pstmt = connection.prepareStatement(inserXlsSql);
					int n=0;
					for (String xlsData : xlsDataList) {
						n++;
						if(xlsData==null||"".equals(xlsData)){
							continue;
						}
						pstmt.setString(1, xlsData);
						pstmt.setString(2, logId);
						pstmt.addBatch();
						if(n==executeNum||xlsData==null){
							n=0;
							pstmt.executeBatch();
							pstmt.clearBatch();
						}
					}
					if(n!=0){
						n=0;
						pstmt.executeBatch();
						pstmt.clearBatch();
					}
					pstmt.close();
					connection.close();*/
				} catch (Exception e) {
					// TODO: handle exception
					System.err.println("请检查数据源（"+extdsArr[i]+"）下是否有数据表X_REPORT_UPLOAD_DATA");
					throw new Exception(e.getMessage());
				}
			}
		}
		
		
		return logId;
	}
	/**
	 * 删除单个文件
	 * @param request
	 * @param response
	 * @param logId 文件日志ID
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	@Action("xbuilderDelSelectFile")
	public void delSelectFile(HttpServletRequest request,
			HttpServletResponse response, String logId) throws SQLException {
		String curSql = "SELECT LOG_ID \"LOG_ID\", FILE_PATH \"FILE_PATH\", UPLOAD_DATE \"UPLOAD_DATE\", UPLOAD_USER \"UPLOAD_USER\", REPORT_ID \"REPORT_ID\", FILE_NAME \"FILE_NAME\" FROM X_REPORT_UPLOAD_DATA_LOG T WHERE T.LOG_ID = #logId#";
		
		Map paramMap = new HashMap();
		paramMap.put("logId", logId);
		Map rsMap = runner.queryForMap(curSql,paramMap);
		String file_path = "",file_name = "";
		if(rsMap != null && rsMap.size() > 0){
			file_path = "" + rsMap.get("FILE_PATH");
			file_name = "" + rsMap.get("FILE_NAME");
		}
		File file = new File(file_path + file_name);
		if(file.exists()){
			file.delete();
		}
		String delSQL = "DELETE FROM X_REPORT_UPLOAD_DATA_LOG T WHERE T.LOG_ID = #logId#";
		runner.execute(delSQL, paramMap);
		String delDataSql = "DELETE FROM X_REPORT_UPLOAD_DATA T WHERE T.LOG_ID = #logId#";
		//String xcloubDelDataSql = "UPDATE X_REPORT_UPLOAD_DATA SET STATE='0' WHERE LOG_ID=#logId#";
		Map parameterMap = new HashMap();
		parameterMap.put("logId", logId);
		String extds = request.getParameter("extds");
		String[] extdsArr = null;
		if(extds!=null&&!extds.equals("")){
			extdsArr = extds.split("#");
		}
		if(extdsArr!=null){
			for(int i=0;i<extdsArr.length;i++){
				if("null".equals(extdsArr[i])){
					runner.execute(delDataSql,parameterMap);
				}else if("xcloud".equals(CommonTools.getDataSource(extdsArr[i]).getDataSourceDB().toLowerCase())){
					//runner.execute(extdsArr[i],xcloubDelDataSql,parameterMap);
				}else{
					runner.execute(extdsArr[i], delDataSql,parameterMap);
				}
			}
		}
		
	}
	
	/**
	 * 选择上传过的文件
	 * @param request
	 * @param response
	 * @param reportId
	 * @param logId
	 * @throws SQLException
	 
	@SuppressWarnings("unchecked")
	@Action("selectFile")
	public void selectFile(HttpServletRequest request,
			HttpServletResponse response, String reportId,String logId) throws SQLException{
		String curSql = "SELECT LOG_ID, FILE_PATH, UPLOAD_DATE, UPLOAD_USER, REPORT_ID, FILE_NAME,FILE_FACT_NAME,FIELD_NAME FROM SYS_REPORT_UPLOAD_DATA_LOG T WHERE T.LOG_ID = #LOG_ID#";
		Map paramMap = new HashMap();
		paramMap.put("LOG_ID", logId);
		Map rsMap = runner.queryForMap(curSql,paramMap);
		@SuppressWarnings("unused")
		String file_path = "",file_name = "",file_fact_name = "",field_name="";
		if(rsMap != null && rsMap.size() > 0){
			file_path = "" + rsMap.get("FILE_PATH");
			file_name = "" + rsMap.get("FILE_NAME");
			file_fact_name = "" + rsMap.get("FILE_FACT_NAME");
			field_name = "" + rsMap.get("FIELD_NAME");
		}
		insertData(request,file_name,file_fact_name,reportId,"2",request.getParameter("extds"),field_name);
	}
	*/
	/**
	 * 清空所有选择文件
	 * @param request
	 * @param response
	 * @param reportId
	 * @throws SQLException
	 
	@SuppressWarnings("unchecked")
	@Action("deleleData")
	public void deleleData(HttpServletRequest request,
			HttpServletResponse response,String reportId,String fieldName) throws SQLException{
		String path = classPath.replaceAll("WEB-INF/classes/", "") + "pages/download/";
		String userId = "" + ((Map)(request.getSession().getAttribute("UserInfo"))).get("USER_ID");
		Map paramMap = new HashMap();
		paramMap.put("reportId", reportId);
		paramMap.put("userId", userId);
		paramMap.put("fieldName", fieldName);
		String fileListSql = "SELECT LOG_ID, FILE_PATH, UPLOAD_DATE, UPLOAD_USER, REPORT_ID, FILE_NAME FROM SYS_REPORT_UPLOAD_DATA_LOG T WHERE T.UPLOAD_USER = #userId# AND T.REPORT_ID = #reportId# and T.FIELD_NAME=#fieldName#";
		List<Map> fileList = (List<Map>) runner.queryForMapList(fileListSql,paramMap);
		for(Map fileMap : fileList){
			File file = new File(path + fileMap.get("FILE_NAME"));
			if(file.exists())
				file.delete();
		}
		String dataSql = "DELETE FROM SYS_REPORT_UPLOAD_DATA T WHERE T.UPLOAD_USER = #userId# AND T.REPORT_ID = #reportId# and FIELD_NAME=#fieldName#";
		String dataLogSql = "DELETE FROM SYS_REPORT_UPLOAD_DATA_LOG T WHERE T.UPLOAD_USER = #userId# AND T.REPORT_ID = #reportId# and FIELD_NAME=#fieldName#";
		runner.execute(dataSql, paramMap);
		runner.execute(dataLogSql, paramMap);
	}
	*/
}
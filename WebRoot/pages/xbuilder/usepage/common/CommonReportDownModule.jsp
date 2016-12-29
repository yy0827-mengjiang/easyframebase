<%@page language="java" contentType="application/x-msdownload"
	pageEncoding="UTF-8"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.net.URLEncoder"%>
<%
	response.reset();
	response.setContentType("application/x-download");
	String filedownload = request.getRealPath("/") + "/pages/xbuilder/usepage/common/downloadfile/templete.xls";
	String filedisplay = "上传模板.xls";
	filedisplay = URLEncoder.encode(filedisplay, "UTF-8");
	response.addHeader("Content-Disposition", "attachment;filename=" + new String(filedisplay.getBytes("UTF-8"), "iso8859-1"));
	OutputStream outp = null;
	FileInputStream in = null;
	try {
		outp = response.getOutputStream();
		in = new FileInputStream(filedownload);

		byte[] b = new byte[1024];
		int i = 0;

		while ((i = in.read(b)) > 0) {
			outp.write(b, 0, i);
		}
		outp.flush();
	} catch (Exception e) {

	} finally {
		out.clear(); 
		out = pageContext.pushBody();
		if (in != null) {
			in.close();
		}
		if (outp != null) {
			out.clear(); 
		out = pageContext.pushBody();
			outp.close();
		}
	}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="a" tagdir="/WEB-INF/tags/app"%>
<e:switch value="${param.eaction}">
	<e:case value="LIST">
		<e:if var="reportListIfFlag" condition="${xsavedmode=='1'}">
			<c:tablequery>
				<e:sql name="xbuilder.reportManager.reportListWithXSavedModeAccount"/>
	   		</c:tablequery>
		</e:if>
		<e:else condition="${reportListIfFlag }">
			<c:tablequery>
				<e:sql name="xbuilder.reportManager.reportListAccount"/>
	   		</c:tablequery>
		</e:else>
	</e:case>
	<e:case value="CURREPORT">
		<e:q4o var="currentReportCount" sql="xbuilder.reportManager.currentReportCount"/>${currentReportCount.TOTAL }
	</e:case>
	<e:case value="RTREE">
		<e:if condition="${param.id==null || param.id ==''}" var="is_tree_null">
			<e:q4l var="menuList" sql="xbuilder.reportManager.menuListWhenIdIsNull"/>${e:java2json(menuList.list) }
		</e:if>
		<e:else condition="${is_tree_null}">
			<e:q4l var="menuList" sql="xbuilder.reportManager.menuListWhenIdIsNotNull"/>${e:java2json(menuList.list) }
		</e:else>
	</e:case>
	<e:case value="SAVE">
		<e:q4o var="menuIdObj" sql="xbuilder.reportManager.menuIdObj"/>	
		<e:update var="insertMenu1"  sql="xbuilder.reportManager.insertMenu"/>
		<e:update var="insertMenu2" sql="xbuilder.reportManager.insertMenuUserPermission"/>
		<e:update var="insertMenu3" sql="xbuilder.reportManager.insertMenuReportRel"/>
		<e:update var="insertMenu4" sql="xbuilder.reportManager.updateReportState"/>
		<e:if var="addMenuResultFlag" condition="${insertMenu1==0||insertMenu2==0||insertMenu3==0||insertMenu4==0 }">
			<e:set var="res_save">0</e:set>
		</e:if>
		<e:else condition="${addMenuResultFlag }">
			<e:set var="res_save">1</e:set>
		</e:else>${res_save }
	</e:case>
	
	<e:case value="fileList">
		<c:tablequery>
			<e:sql name="xbuilder.reportManager.fileList"/>
   		</c:tablequery>
	</e:case>

	<e:case value="addFile">
		<e:set var="res_save">0</e:set>
		<e:parseRequest />
		<e:if condition="${uploadFile!=null&&uploadFile!=''}">
			<e:set var="initFileName">${uploadFile.name}</e:set>
			<e:set var="tempfileName"><%=System.currentTimeMillis()%></e:set>
			<e:copy file="${uploadFile}"
				tofile="/pages/download/reportpagedir/${tempfileName}${uploadFile.suffix}" />
			<e:set var="filePath">/pages/download/reportpagedir/${tempfileName}${uploadFile.suffix}</e:set>
			<e:update var="res_save" sql="xbuilder.reportManager.addFileInFileList"/>
		</e:if>${res_save}
	</e:case>
	
	<e:case value="deleteFile">
		<%
		String rpath = request.getParameter("filePath");
		String dir = request.getSession().getServletContext().getRealPath("/").replaceAll("\\\\", "/");
		rpath = dir + rpath.substring(1,rpath.length());
		java.io.File file = new java.io.File(rpath);
		file.delete();
		%>
		<e:update var="res_del" sql="xbuilder.reportManager.deleteFileInFileList"/>${res_del}
	</e:case>
	<e:case value="DELETEALLRP">
		<e:update var="deleteReport1" sql="xbuilder.reportManager.deleteReport"/>
		<e:update var="deleteReport2" sql="xbuilder.reportManager.deleteReportDim"/>
		<e:update var="deleteReport3" sql="xbuilder.reportManager.deleteReportUserPermission"/>
		<e:update var="deleteReport4" sql="xbuilder.reportManager.deleteMenu"/>
		<e:update var="deleteReport5" sql="xbuilder.reportManager.deleteReportMenuRel"/>
		<e:update var="deleteReport6" sql="xbuilder.reportManager.deleteReportColumns"/>
		<e:update var="deleteReport7" sql="xbuilder.reportManager.deleteReportSql"/>
		<e:update var="deleteReport8" sql="xbuilder.reportManager.deleteReportDescribe"/>
		<e:if condition="${CityDuiBiao=='1'}">
			<e:update var="deleteReport9" sql="xbuilder.reportManager.deleteReportDuiBiao"/>
		</e:if>
		<e:if var="deleteReportResultFlag" condition="${deleteReport1==0}">
			<e:set var="rs_del">0</e:set>
		</e:if>
		<e:else condition="${deleteReportResultFlag }">
			<e:set var="rs_del">1</e:set>
		</e:else>${rs_del }
		<e:if condition="${rs_del>0}">
			<e:delete file="pages/ebuilder/usepage/formal/${param.report_id}" />
			<e:delete file="pages/ebuilder/usepage/temp/${param.report_id}" />
		</e:if>
		<a:operationlog reportid="${param.report_id}" operate="6" content="删除报表及文件...." result="1"/>
	</e:case>
	<e:case value="stopUseReport">
		<e:update var="stopVisitReport1" sql="xbuilder.reportManager.updateReportStateTo2"/>
		<e:update var="stopVisitReport2" sql="xbuilder.reportManager.deleteReportUserPermission"/>
		<e:update var="stopVisitReport3" sql="xbuilder.reportManager.deleteMenu"/>
		<e:update var="stopVisitReport4" sql="xbuilder.reportManager.deleteReportMenuRel"/>
		<e:if var="stopVisitReportResultFlag" condition="${stopVisitReport1==0}">
			<e:set var="rs_del">0</e:set>
		</e:if>
		<e:else condition="${stopVisitReportResultFlag }">
			<e:set var="rs_del">1</e:set>
		</e:else>${rs_del }
		<a:operationlog reportid="${param.report_id}" operate="5" content="报表下架操作成功" result="1"/>
	</e:case>
	
	<e:case value="REPORTLOAD">
		<e:q4l var="report_load" sql="xbuilder.reportManager.discribeInfo"/>${e:java2json(report_load.list) }
	</e:case>
	<e:case value="USERLIST">
		<c:tablequery>
			<e:sql name="xbuilder.reportManager.discribeUserList"/>
		</c:tablequery>
	</e:case>
	<e:case value="DEPTREE">
		<e:if condition="${param.id eq '' || param.id == null}" var="isDepNull">
			<e:q4l var="departs" sql="xbuilder.reportManager.discribeDepartListWhenIdIsNull"/>${e:java2json(departs.list)}
		</e:if>
		<e:else condition="${isDepNull}">
			<e:q4l var="departs" sql="xbuilder.reportManager.discribeDepartListWhenIdIsNotNull"></e:q4l>${e:java2json(departs.list)}
		</e:else>
	</e:case>
	<e:case value="INSERTREPORT">
		<e:q4o var="reportIdInDiscribe" sql="xbuilder.reportManager.reportIdInDiscribe"/>
		<e:update var="updateReportName" sql="xbuilder.reportManager.updateReportName"></e:update>
		<e:if condition="${reportIdInDiscribe.REPORT_ID==null || reportIdInDiscribe.REPORT_ID eq ''}" var="isflag">
			<e:update var="updateReportDiscribe" sql="xbuilder.reportManager.insertReportDiscribe"/>${updateReportDiscribe}
		</e:if>
		<e:else condition="${isflag}">
			<e:update var="updateReportDiscribe" sql="xbuilder.reportManager.updateReportDiscribe"/>${updateReportDiscribe}
		</e:else>
	</e:case>
	
	<e:case value="examin">
		<e:q4o var="reportInfoSo">
			select * from x_report_info t where t.id = #exreportid#
		</e:q4o>
		<e:update var="examincount">
			begin
				delete from x_report_edit_examin t where t.report_id = #exreportid# and (t.creator = '${reportInfoSo.CREATOR }' or t.creator is null) and t.examin_state = '0' and examin_user = '${sessionScope.UserInfo.USER_ID}';
				insert into x_report_edit_examin
				  (id,
				   report_id,
				   report_name,
				   creator,
				   creator_name,
				   examin_user,
				   examin_user_name,
				   examin_state,
				   start_date,
				   EXAMIN_CONTENT
				   ) values
				  ('E'||to_char(sysdate,'yyyymmddhh24missSSS'),
				   #exreportid#,
				   '${reportInfoSo.REPORT_NAME }',
				   '${reportInfoSo.CREATOR }',
				   '${reportInfoSo.CREATOR_NAME }',
				   '${sessionScope.UserInfo.USER_ID}',
				   '${sessionScope.UserInfo.USER_NAME}',
				   '0',
				   sysdate,
				   #examcon#
				  );
			end;
		</e:update>${examincount}
	</e:case>
	<e:case value="examList">
		<c:tablequery>
			SELECT t.ID,
			       t.REPORT_ID,
			       t.REPORT_NAME,
			       t.CREATOR,
			       t.CREATOR_NAME,
			       t.EXAMIN_USER,
			       t.EXAMIN_USER_NAME,
			       t.EXAMIN_STATE,
			       t.EXAMIN_CONTENT,
			       t.AGREE_CONTENT,
			       TO_CHAR(t.START_DATE, 'YYYY-MM-DD HH24:MI:SS') START_DATE,
			       TO_CHAR(t.END_DATE, 'YYYY-MM-DD HH24:MI:SS') END_DATE,
			       '' opt,
	 			   DECODE(t.EXAMIN_STATE,'1','通过','未通过') STATE,
	 			   t1.STATE REPORT_STATE
			  FROM x_report_edit_examin T , x_report_info t1
			 WHERE t.REPORT_ID = t1.id 
			   and T.CREATOR = '${sessionScope.UserInfo.USER_ID}'
			   and t.EXAMIN_STATE = '0'
			   <e:if
				condition="${param.report_name != null && param.report_name ne ''}">
					and t.report_name like '%${param.report_name}%'
				</e:if>
			<e:if condition="${param.sq_name != null && param.sq_name ne ''}">
					and (t.EXAMIN_USER like '%${param.sq_name}%' or t.EXAMIN_USER_NAME like '%${param.sq_name}%')
				</e:if>
			<e:if
				condition="${param.create_name != null && param.create_name ne ''}">
					and (t.CREATOR like '%${param.create_name}%' or t.CREATOR_NAME like '%${param.create_name}%')
				</e:if>
			<e:if condition="${param.sq_date != null && param.sq_date ne ''}">
					and to_char(t.START_DATE,'yyyy-mm-dd') like '%${param.sq_date}%'
				</e:if>
			<e:if condition="${param.state != null && param.state ne ''}">
					and t.EXAMIN_STATE like '%${param.state}%'
				</e:if>
		</c:tablequery>
	</e:case>
	<e:case value="examinupdate">
		<e:update var="examinupdatec">
			begin
				update x_report_edit_examin t
				   set t.agree_content = #agree_content#, t.end_date = sysdate, t.examin_state = #state#
				 where t.id = #id#;
			end;
		</e:update>${examinupdatec}
	</e:case>
	<e:case value="examedList">
		<c:tablequery>
			SELECT t.ID,
			       t.REPORT_ID,
			       t.REPORT_NAME,
			       t.CREATOR,
			       t.CREATOR_NAME,
			       t.EXAMIN_USER,
			       t.EXAMIN_USER_NAME,
			       t.EXAMIN_STATE,
			       t.EXAMIN_CONTENT,
			       t.AGREE_CONTENT,
			       TO_CHAR(t.START_DATE, 'YYYY-MM-DD HH24:MI:SS') START_DATE,
			       TO_CHAR(t.END_DATE, 'YYYY-MM-DD HH24:MI:SS') END_DATE,
			       '' opt,
	 			   DECODE(t.EXAMIN_STATE,'1','通过','未通过') STATE,
	 			   t1.STATE REPORT_STATE
			  FROM x_report_edit_examin T , x_report_info t1
			 WHERE t.REPORT_ID = t1.id 
			   and T.EXAMIN_USER = '${sessionScope.UserInfo.USER_ID}'
			   and t.EXAMIN_STATE = '1'
			   <e:if
				condition="${param.report_name != null && param.report_name ne ''}">
					and t.report_name like '%${param.report_name}%'
				</e:if>
			<e:if condition="${param.sq_name != null && param.sq_name ne ''}">
					and (t.EXAMIN_USER like '%${param.sq_name}%' or t.EXAMIN_USER_NAME like '%${param.sq_name}%')
				</e:if>
			<e:if
				condition="${param.create_name != null && param.create_name ne ''}">
					and (t.CREATOR like '%${param.create_name}%' or t.CREATOR_NAME like '%${param.create_name}%')
				</e:if>
			<e:if condition="${param.sq_date != null && param.sq_date ne ''}">
					and to_char(t.START_DATE,'yyyy-mm-dd') like '%${param.sq_date}%'
				</e:if>
			<e:if
				condition="${param.state != null && param.state ne ''&& param.state ne '-1'}">
					and t.EXAMIN_STATE like '%${param.state}%'
				</e:if>
		</c:tablequery>
	</e:case>
	<e:case value="checkexamin">
		<e:q4l var = "checkSo">
			select id,
			       report_id,
			       report_name,
			       creator,
			       creator_name,
			       examin_user,
			       examin_user_name,
			       examin_state,
			       examin_content,
			       agree_content,
			       start_date,
			       end_date
			  from x_report_edit_examin t
			 where t.report_id = #reportId#
			   and t.examin_user = '${sessionScope.UserInfo.USER_ID}'
			 order by start_date
		</e:q4l>
		<e:set var="check">N</e:set>
		<e:forEach items="${checkSo.list}" var="item">
			<e:if condition="${item.examin_state !=null && item.examin_state eq '2' || item.examin_state eq '0'}">
				<e:set var="check">N</e:set>
			</e:if>
			<e:if condition="${item.examin_state !=null && item.examin_state eq '1'}">
				<e:set var="check">Y</e:set>
			</e:if>
		</e:forEach>
	</e:case>${check}
</e:switch>

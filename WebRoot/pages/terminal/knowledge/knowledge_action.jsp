<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction }">
	<e:case value="load1">
		<c:tablequery >
			select "FILE_NAME","FILE_TYPE","URL","LOAD_USER","LOAD_DATE","ID"  
			from "DIM_KNOWLEDGE" 
			<e:if condition="${sessionScope.UserInfo.AREA_NO != '' && sessionScope.UserInfo.AREA_NO != null && sessionScope.UserInfo.AREA_NO != '-1'}" var="selectifa">
		   	   where "AREA_NO" = '${sessionScope.UserInfo.AREA_NO }'
		   	   <e:if condition="${sessionScope.UserInfo.CITY_NO != '' && sessionScope.UserInfo.CITY_NO != null && sessionScope.UserInfo.CITY_NO != '-1'}" var="selectifb">
			   	   AND "CITY_NO" = '${sessionScope.UserInfo.CITY_NO }'
			   	   <e:if condition="${param.file_name != null && param.file_name ne '' && param.file_name != ''}" var="selectifc">
				       and "FILE_NAME" like '%${param.file_name}%'
				       <e:if condition="${param.file_type!=null && param.file_type ne '' && param.file_type != ''}">
				             and "FILE_TYPE" like '%${param.file_type}%'
				        </e:if>	
			        </e:if>
			        <e:else condition="${selectifc }">
			        	<e:if condition="${param.file_type!=null && param.file_type ne '' && param.file_type != ''}">
				           and "FILE_TYPE" like '%${param.file_type}%'
				        </e:if>		
			        </e:else>
		        </e:if>	
		        <e:else condition="${selectifb }">
		        	<e:if condition="${param.file_name != null && param.file_name ne '' && param.file_name != ''}" var="selectifd">
				       and "FILE_NAME" like '%${param.file_name}%'
				       <e:if condition="${param.file_type!=null && param.file_type ne '' && param.file_type != ''}">
				             and "FILE_TYPE" like '%${param.file_type}%'
				        </e:if>	
			        </e:if>
			        <e:else condition="${selectifd }">
			        	<e:if condition="${param.file_type!=null && param.file_type ne '' && param.file_type != ''}">
				           and "FILE_TYPE" like '%${param.file_type}%'
				        </e:if>		
			        </e:else>
		        </e:else>
		    </e:if>
		    <e:else condition="${selectifa }">
		    	<e:if condition="${param.file_name != null && param.file_name ne '' && param.file_name != ''}" var="selectife">
			       where "FILE_NAME" like '%${param.file_name}%'
			       <e:if condition="${param.file_type!=null && param.file_type ne '' && param.file_type != ''}">
			             and "FILE_TYPE" like '%${param.file_type}%'
			        </e:if>	
		        </e:if>
		        <e:else condition="${selectife }">
		        	<e:if condition="${param.file_type!=null && param.file_type ne '' && param.file_type != ''}">
			           where "FILE_TYPE" like '%${param.file_type}%'
			        </e:if>		
		        </e:else>
		    </e:else>
						                
		   order by "LOAD_DATE" desc  
		</c:tablequery>
	</e:case>
	<e:case value="Deletes">
		<e:update var="count">
			delete from "DIM_KNOWLEDGE" where "ID"='${param.ID }'
		</e:update>${count }
	</e:case>
</e:switch>
		
    
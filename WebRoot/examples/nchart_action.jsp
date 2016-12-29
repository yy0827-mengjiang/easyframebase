<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:switch value="${param.eaction}">
	<e:case value="npie">
		<c:chartquery>
			select AREA_NO,
			       sum(VALUE1) a,
			       sum(VALUE2) b,
			       sum(VALUE1+VALUE2) c,
			       sum(VALUE1*2) d
			  from (
			 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
				UNION ALL
				SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
				UNION ALL
				SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
			  
			  )
			 group by AREA_NO
			 order by AREA_NO
		</c:chartquery>
	</e:case>
	<e:case value="ndonutpie">
		<c:chartquery>
			select AREA_DESC,CITY_DESC,
		         sum(VALUE1) A,
		         sum(VALUE2) B,
		         sum(VALUE1+VALUE2) C,
		         sum(VALUE1*2) D
		    from (
		     SELECT '431' AREA_NO,'长春' AREA_DESC,'43101' CITY_NO,'朝阳区' CITY_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '431' AREA_NO,'长春' AREA_DESC,'43102' CITY_NO,'二道区' CITY_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '431' AREA_NO,'长春' AREA_DESC,'43103' CITY_NO,'开发区' CITY_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '432' AREA_NO,'吉林' AREA_DESC,'43201' CITY_NO,'龙潭区' CITY_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '432' AREA_NO,'吉林' AREA_DESC,'43202' CITY_NO,'昌邑区' CITY_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '432' AREA_NO,'吉林' AREA_DESC,'43203' CITY_NO,'丰满区' CITY_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '437' AREA_NO,'辽源' AREA_DESC,'43701' CITY_NO,'东辽区' CITY_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '437' AREA_NO,'辽源' AREA_DESC,'43702' CITY_NO,'东丰区' CITY_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
		    UNION ALL
		    SELECT '437' AREA_NO,'辽源' AREA_DESC,'43703' CITY_NO,'龙山区' CITY_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
		    
		    )
		   group by AREA_DESC,CITY_DESC
		</c:chartquery>
	</e:case>
	
	<e:case value="npieClick">
		<c:chartquery>
			select '<input type="hidden" value="'||AREA_NO||'"/>'||AREA_DESC AREA_DESC,
			       sum(VALUE1) a,
			       sum(VALUE2) b,
			       sum(VALUE1+VALUE2) c,
			       sum(VALUE1*2) d
			  from (
			 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
				UNION ALL
				SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
				UNION ALL
				SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
			  
			  )
			 group by AREA_NO,AREA_DESC
			 order by AREA_NO,AREA_DESC
		</c:chartquery>
	</e:case>
	
	
	<e:case value="nline">
		<c:chartquery>
			select AREA_NO,
			       sum(VALUE1) a,
			       sum(VALUE2) b,
			       sum(VALUE1+VALUE2) c,
			       sum(VALUE1*2) d
			  from (
			 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
				UNION ALL
				SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
				UNION ALL
				SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
			  
			  )
			 group by AREA_NO
			 order by AREA_NO
		</c:chartquery>
	
	</e:case>
	<e:case value="nlineClick">
		<c:chartquery>
			
			select '<a href="javascript:clickTime('''||AREA_NO||''')">'||AREA_DESC||'</a>' AREA_DESC,
			       sum(VALUE1) a,
			       sum(VALUE2) b,
			       sum(VALUE1+VALUE2) c,
			       sum(VALUE1*2) d
			  from (
			 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
				UNION ALL
				SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
				UNION ALL
				SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
			  
			  )
			 group by AREA_NO,AREA_DESC
			 order by AREA_NO,AREA_DESC
		</c:chartquery>
	
	</e:case>
	<e:case value="ncolumn">
		<c:chartquery>
			select AREA_NO,
			       sum(VALUE1) a,
			       sum(VALUE2) b,
			       sum(VALUE1+VALUE2) c,
			       sum(VALUE1*2) d
			  from (
			 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
				UNION ALL
				SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
				UNION ALL
				SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
			  
			  )
			 group by AREA_NO
			 order by AREA_NO
		</c:chartquery>
	
	</e:case>
	<e:case value="ncolumnClick">
		<c:chartquery>
			select '<input type="hidden" value="'||AREA_NO||'"/>'||AREA_DESC AREA_DESC,
			       sum(VALUE1) a,
			       sum(VALUE2) b,
			       sum(VALUE1+VALUE2) c,
			       sum(VALUE1*2) d
			  from (
			 	SELECT '431' AREA_NO,'长春' AREA_DESC,111 VALUE1, 334 VALUE2 FROM DUAL
				UNION ALL
				SELECT '432' AREA_NO,'吉林' AREA_DESC,121 VALUE1, 327 VALUE2 FROM DUAL
				UNION ALL
				SELECT '437' AREA_NO,'辽源' AREA_DESC,331 VALUE1, 533 VALUE2 FROM DUAL
			  
			  )
			 group by AREA_NO,AREA_DESC
			 order by AREA_NO,AREA_DESC
		</c:chartquery>
	
	</e:case>
	<e:case value="speedometer">
		<c:chartquery>
			select floor(dbms_random.value(30,50)) used from dual
		</c:chartquery>
	
	</e:case>
	
	<e:case value="scatter">
		<c:chartquery>
			 select AREA_NO,AREA_DESC,VALUE1,VALUE2,VALUE3 from 
				(
				SELECT '431' AREA_NO, '长春' AREA_DESC,161.2 VALUE1, 51.6 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,167.5 VALUE1, 59.0 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,159.5 VALUE1, 49.2 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,157.0 VALUE1, 63.0 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,155.8 VALUE1, 53.6 VALUE2,108 VALUE3  from dual union all
                SELECT '431' AREA_NO, '长春' AREA_DESC,170.0 VALUE1, 59.0 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,159.1 VALUE1, 47.6 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,166.0 VALUE1, 69.8 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,176.2 VALUE1, 66.8 VALUE2,128 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,160.2 VALUE1, 75.2 VALUE2,108 VALUE3  from dual union all   
                SELECT '431' AREA_NO, '长春' AREA_DESC,172.5 VALUE1, 55.2 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,170.9 VALUE1, 54.2 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,172.9 VALUE1, 62.5 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,153.4 VALUE1, 42.0 VALUE2,118 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,160.0 VALUE1, 50.0 VALUE2,108 VALUE3  from dual union all   
                SELECT '431' AREA_NO, '长春' AREA_DESC,147.2 VALUE1, 49.8 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,168.2 VALUE1, 49.2 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,175.0 VALUE1, 73.2 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,157.0 VALUE1, 47.8 VALUE2,118 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,167.6 VALUE1, 68.8 VALUE2,108 VALUE3  from dual union all   
                SELECT '431' AREA_NO, '长春' AREA_DESC,159.5 VALUE1, 50.6 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,175.0 VALUE1, 82.5 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,166.8 VALUE1, 57.2 VALUE2,108 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,176.5 VALUE1, 87.8 VALUE2,128 VALUE3  from dual union all SELECT '431' AREA_NO, '长春' AREA_DESC,170.2 VALUE1, 72.8 VALUE2,108 VALUE3  from dual   
                union all
				SELECT '432' AREA_NO, '吉林' AREA_DESC,174.0 VALUE1, 65.6 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,175.3 VALUE1, 71.8 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,193.5 VALUE1, 80.7 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,186.5 VALUE1, 72.6 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,187.2 VALUE1, 78.8 VALUE2,32 VALUE3  from dual union all
                SELECT '432' AREA_NO, '吉林' AREA_DESC,181.5 VALUE1, 74.8 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,184.0 VALUE1, 86.4 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,184.5 VALUE1, 78.4 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,175.0 VALUE1, 62.0 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,184.0 VALUE1, 81.6 VALUE2,32 VALUE3  from dual union all   
                SELECT '432' AREA_NO, '吉林' AREA_DESC,180.0 VALUE1, 76.6 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,177.8 VALUE1, 83.6 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,192.0 VALUE1, 90.0 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,176.0 VALUE1, 74.6 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,174.0 VALUE1, 71.0 VALUE2,32 VALUE3  from dual union all   
                SELECT '432' AREA_NO, '吉林' AREA_DESC,184.0 VALUE1, 79.6 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,192.7 VALUE1, 93.8 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,171.5 VALUE1, 70.0 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,173.0 VALUE1, 72.4 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,176.0 VALUE1, 85.9 VALUE2,32 VALUE3  from dual union all   
                SELECT '432' AREA_NO, '吉林' AREA_DESC,176.0 VALUE1, 78.8 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,180.5 VALUE1, 77.8 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,172.7 VALUE1, 66.2 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,176.0 VALUE1, 86.4 VALUE2,32 VALUE3  from dual union all SELECT '432' AREA_NO, '吉林' AREA_DESC,173.5 VALUE1, 81.8 VALUE2,32 VALUE3  from dual   
				)
		      t
		</c:chartquery>
	</e:case>
	
</e:switch>

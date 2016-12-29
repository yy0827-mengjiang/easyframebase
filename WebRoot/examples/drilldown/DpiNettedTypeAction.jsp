<%@ page language="java" pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="e" uri="http://www.bonc.com.cn/easy/taglib/e"%>
<%@ taglib prefix="c" uri="http://www.bonc.com.cn/easy/taglib/c"%>
<e:q4l var="dataList">
	<c:treetablesql dimField="a1">
		select  t.app_code ID,
				a.app_desc C1,
				to_char(sum(users_num),'fm9999999999990')||'-'||'USERS_NUM' users_num,
				to_char(sum(hits),'fm9999999999990')||'-'||'HITS' hits,
				to_char(decode(sum(users_num),0,0,sum(hits)/sum(users_num)),'fm9999999990.00')||'-'||'HF' hf,
				to_char(sum(flow),'fm9999999999990.00')||'-'||'FLOW' flow,
				to_char(decode(sum(users_num),0,0,sum(flow)/sum(users_num)),'fm9999999990.00')||'-'||'HL' hl
		from ${DM }.dma_d_to_dpi_netted_type t,${CODE }.code_to_dpi_app a
		where   t.app_code = a.app_id
				and t.acct_day = '${param.acct_day }'
				<e:if condition="${param.area_no != null && param.area_no ne ''}">
					and t.area_no = '${param.area_no }'
				</e:if>
		group by t.app_code,a.app_desc
		order by t.app_code
	</c:treetablesql>
	<c:treetablesql dimField="a2">
		select  t.app_code||'-'||t.bus_code ID,
				a.bus_desc C1,
				to_char(sum(users_num),'fm9999999999990')||'-'||'USERS_NUM' users_num,
				to_char(sum(hits),'fm9999999999990')||'-'||'HITS' hits,
				to_char(decode(sum(users_num),0,0,sum(hits)/sum(users_num)),'fm9999999990.00')||'-'||'HF' hf,
				to_char(sum(flow),'fm9999999999990.00')||'-'||'FLOW' flow,
				to_char(decode(sum(users_num),0,0,sum(flow)/sum(users_num)),'fm9999999990.00')||'-'||'HL' hl
		from ${DM }.dma_d_to_dpi_netted_type t,${CODE }.code_to_dpi_appbus a
		where   t.bus_code = a.bus_id
				and t.acct_day = '${param.acct_day }'
				<e:if condition="${param.area_no != null && param.area_no ne ''}">
					and t.area_no = '${param.area_no }'
				</e:if>
				and t.app_code = #a1#
		group by t.app_code,t.bus_code,a.bus_desc
		order by t.app_code,t.bus_code
	</c:treetablesql>
</e:q4l>
${e:replace(e:java2json(dataList.list),'ICONCLS','iconCls')}

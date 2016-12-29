package cn.com.easy.xbuilder.parser;
/*
 * 生成jsp时，对添加的扩展查询条件，需要将用户原sql进行转换
 */
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import cn.com.easy.xbuilder.element.Datasource;
import cn.com.easy.xbuilder.element.Datasources;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Report;

public class ReportConverteHandlerChangeSql extends ReportConverteHandler {

	/*
	 * 是否需要转换判定条件
	 */
	@Override
	protected Boolean getHandlerCondition(Report report) {
		Datasources datasources = report.getDatasources();
		if(null == datasources || null == datasources.getDatasourceList() || datasources.getDatasourceList().size()<=0){
			return false;
		}
		
		Dimsions dimsions = report.getDimsions();
		if(null == dimsions || null == dimsions.getDimsionList() || dimsions.getDimsionList().size()<=0){
			return false;
		}
		List<Dimsion> dimsionList = dimsions.getDimsionList();
		List<Datasource> datasourceList = datasources.getDatasourceList();
		for(Datasource datasource:datasourceList){
			String dsid = datasource.getId();
			List<String> conds = new ArrayList<String>();
			for(Dimsion dimsion:dimsionList){
				if(null != dimsion.getConditiontype() && "1".equals(dimsion.getConditiontype()) && null != dimsion.getDatasourceid() && dsid.equals(dimsion.getDatasourceid())){
					return true;
				}
			}
		}
		return false;
	}

	/*
	 * 将用户sql括一层，转换为select * from (用户sql) where 1=1 { and 条件=#条件#}
	 */
	@Override
	protected Report converte(Report report) {
		Datasources datasources = report.getDatasources();
		Dimsions dimsions = report.getDimsions();
		List<Dimsion> dimsionList = dimsions.getDimsionList();
		List<Datasource> datasourceList = datasources.getDatasourceList();
		
		for(Datasource datasource:datasourceList){
			String dsid = datasource.getId();
			List<String> conds = new ArrayList<String>();
			Pattern pattern = Pattern.compile("[\u4e00-\u9fa5]");
			for(Dimsion dimsion:dimsionList){
				if(null != dimsion.getConditiontype() && "1".equals(dimsion.getConditiontype()) && null != dimsion.getDatasourceid() && dsid.equals(dimsion.getDatasourceid())){
			       Matcher matcher = pattern.matcher(dimsion.getVardesc()); 
			       if(matcher.find()){
			    	   conds.add(" { and "+dimsion.getVardesc()+"=#"+dimsion.getVarname()+"#} ");
			       }else{
			    	   conds.add(" { and "+dimsion.getVardesc()+"=#"+dimsion.getVardesc()+"#} ");
			       }
				}
			}
			if(conds.size()>0){
				String basic = datasource.getSql();
				StringBuffer condBuf = new StringBuffer();
				condBuf.append("select * from("+basic+") extconds where 1=1 ");
				for(String cond:conds){
					condBuf.append(cond);
				}
				datasource.setSql(condBuf.toString());
			}
		}
		
		return report;
	}
}

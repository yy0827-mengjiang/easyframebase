package cn.com.easy.xbuilder.meta;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.com.easy.core.sql.SqlRunner;
import cn.com.easy.xbuilder.element.Component;
import cn.com.easy.xbuilder.element.Container;
import cn.com.easy.xbuilder.element.Crosscol;
import cn.com.easy.xbuilder.element.Datacol;
import cn.com.easy.xbuilder.element.Dimsion;
import cn.com.easy.xbuilder.element.Dimsions;
import cn.com.easy.xbuilder.element.Extcolumn;
import cn.com.easy.xbuilder.element.Extcolumns;
import cn.com.easy.xbuilder.element.Kpi;
import cn.com.easy.xbuilder.element.Kpistore;
import cn.com.easy.xbuilder.element.KpistoreCol;
import cn.com.easy.xbuilder.element.Param;
import cn.com.easy.xbuilder.element.Report;
import cn.com.easy.xbuilder.element.Sortcol;
import cn.com.easy.xbuilder.element.SortcolStore;
import cn.com.easy.xbuilder.element.Subdrill;
import cn.com.easy.xbuilder.element.XAxis;
import cn.com.easy.xbuilder.parser.XGenerateCompPC;

public class XMeta{
	private final Report report;
	private final String type;
	private final SqlRunner runner;
	private StringBuffer meta = new StringBuffer();
	public XMeta(Report report,String type,SqlRunner runner){
		this.report = report;
		this.type = type;
		this.runner = runner;
	}
	public void meta(){
		if("2".equals(this.report.getInfo().getType())){
			this.usedKpi();
		}
	}
	private void usedKpi() {
		meta.append("begin delete from X_META_INFO where report_id='"+this.report.getId()+"';delete from x_meta_kpi where report_id='"+this.report.getId()+"';insert into X_META_INFO(report_id,report_type,report_ltype,screen) values('"+this.report.getId()+"','"+this.report.getInfo().getType()+"','"+this.report.getInfo().getLtype()+"','"+String.valueOf(Integer.parseInt(this.report.getLayout().getWidth())+10)).append("');");
		Map<String,String[]> metaKpi = new HashMap<String,String[]>();
		List<Component> comps = new ArrayList<Component>();
		List<Container> containers = this.report.getContainers().getContainerList();
		for(int c=0;c<containers.size();c++){
			Container container = containers.get(c);
			List<Component> components = container.getComponents().getComponentList();
			if(components != null && components.size()>0){
				comps.addAll(components);
			}
		}
		if (comps == null || comps.size() <= 0) {
			return;
		}
		XGenerateCompPC xgc = new XGenerateCompPC(this.report,this.type,this.runner);
		for (Component comp : comps) {
			String type = xgc.getCompKind(comp.getType().toLowerCase());
			if (type.equals("pie") || type.equals("line") || type.equals("bar") || type.equals("column") || type.equals("scatter") || type.equals("columnline")) {
				XAxis xAxis = comp.getXaxis();
				String dim = xAxis.getDimfield();
				String dimId = xAxis.getDimFiledId();
				String dimType = "dim";
				String dimDesc = "";
				
				metaKpi.put(dimId, new String[]{dimId,dim,dimDesc,dimType});
				
				String sort = xAxis.getSortfield();
				String sortId = xAxis.getSortFiledId();
				String sortType = xAxis.getSortkpitype();
				String sortDesc = "";
				
				metaKpi.put(sortId, new String[]{sortId,sort,sortDesc,sortType});
				
				if(type.equals("scatter")){
					String scatterDim = xAxis.getScatterDimField();
					String scatterDimId = xAxis.getScatterDimFieldId();
					String scatterDimType = "dim";
					String scatterDimDesc = "";
					metaKpi.put(scatterDimId, new String[]{scatterDimId,scatterDim,scatterDimDesc,scatterDimType});
				}
				List<Kpi> kpis = comp.getKpiList();
				for (int i = 0; i < kpis.size(); i++) {
					Kpi kpiInfo = kpis.get(i);
					String kpi = kpiInfo.getField();
					String kpiId = kpiInfo.getKpiId();
					String kpiType = "kpi";
					String kpiDesc = kpiInfo.getName();
					metaKpi.put(kpiId, new String[]{kpiId,kpi,kpiDesc,kpiType});
				}
			} else{
				SortcolStore sortcolStore = comp.getSortcolStore();
				List<Sortcol> Sortcols = null != sortcolStore?sortcolStore.getSortcolList():null;
				if(null != Sortcols && Sortcols.size()>0){
					for(int s=0;s<Sortcols.size();s++){
						Sortcol sortcol = Sortcols.get(s);
						if(null == sortcol.getExtcolumnid() || "".equals(sortcol.getExtcolumnid())){
							String sort = sortcol.getCol();
							String sortId = sortcol.getId();
							String sortType = sortcol.getKpitype();
							String sortDesc = sortcol.getDesc();
							metaKpi.put(sortId, new String[]{sortId,sort,sortDesc,sortType});
						}
					}
				}
				List<Datacol> datacols = comp.getDatastore().getDatacolList();
				for(int d=0;d<datacols.size();d++){
					Datacol datacol = datacols.get(d);
					if(null == datacol.getExtcolumnid() || "".equals(datacol.getExtcolumnid())){
						String dim = datacol.getDatacolcode();
						String dimId = datacol.getDatacolid();
						String dimType = datacol.getDatacoltype();
						String dimDesc = datacol.getDatacoldesc();
						metaKpi.put(dimId, new String[]{dimId,dim,dimDesc,dimType});
					}
				}
				if(type.equals("crosstable")){
					List<Crosscol> crosscols = comp.getCrosscolstore().getCrosscolList();
					for(int d=0;d<crosscols.size();d++){
						Crosscol crosscol = crosscols.get(d);
						String dim = crosscol.getDimfield();
						String dimId = crosscol.getDimid();
						String dimType = "dim";
						String dimDesc = crosscol.getDimdesc();
						metaKpi.put(dimId, new String[]{dimId,dim,dimDesc,dimType});
					}
				}else{
					if (type.equals("treegrid")) {
						List<Subdrill> subdrills = new ArrayList<Subdrill>(comp.getSubdrills().getSubdrillList());
						if (null != subdrills && subdrills.size() > 0) {
							Map<String,StringBuffer> group = new HashMap<String,StringBuffer>();
							for (Subdrill subdrill : subdrills) {
								String drill = subdrill.getDrillcolcode();
								String drillId = subdrill.getDrillcolcodeid();
								String drillType = "dim";
								String drillDesc = subdrill.getDrillcoldesc();
								metaKpi.put(drillId, new String[]{drillId,drill,drillDesc,drillType});
							}
						}
					}
				}
			}
			Dimsions dimsions = this.report.getDimsions();
			List<Dimsion> dims = null != dimsions?dimsions.getDimsionList():null;
			
			if (null != dims && dims.size() > 0) {
				for (Dimsion dimInfo : dims) {
					String dim = dimInfo.getVarname();
					String dimId = dimInfo.getFieldid();
					String dimType = dimInfo.getFieldtype();
					String dimDesc = dimInfo.getDesc();
					metaKpi.put(dimId, new String[]{dimId,dim,dimDesc,dimType});
				}
			}
			Extcolumns extcolumn = this.report.getExtcolumns();
			List<Extcolumn> extcolumns = null != extcolumn?extcolumn.getExtcolumnList():null;
			if (null != extcolumns && extcolumns.size() > 0) {
				for (Extcolumn extcol : extcolumns) {
					List<Param> params = extcol.getParamList();
					for (Param param : params) {
						String[] col = this.getKpi("spaling", param.getValue());
						if(null != col){
							metaKpi.put(col[0],col);
						}
					}
				}
			}
		}
		int colSize = metaKpi.keySet().size();
		if(colSize>0){
			if(colSize>50){
				int n = 1;
				for(String[] col:metaKpi.values()){
					n++;
					colSize--;
					this.meta.append("insert into x_meta_kpi(kpi_id, kpi_column, kpi_desc, kpi_type, report_id) values('"+col[0]+"', '"+col[1]+"','"+col[2]+"','"+col[3]+"','"+this.report.getId()+"')").append(";");
					if(n == 50 || colSize == 0){
						this.meta.append(";end;");
						this.save();
						n = 0;
					}
				}
			}else{
				for(String[] col:metaKpi.values()){
					this.meta.append("insert into x_meta_kpi(kpi_id, kpi_column, kpi_desc, kpi_type, report_id) values('"+col[0]+"', '"+col[1]+"','"+col[2]+"','"+col[3]+"','"+this.report.getId()+"')").append(";");
				}
				this.meta.append("end;");
				this.save();
				//调用保存
			}
		}
	}
	private String[] getKpi(String id,String column){
		List<Kpistore> kpistores = this.report.getKpistores().getKpistoreList();
		for(Kpistore kpistore:kpistores){
			List<KpistoreCol> kpistoreCol = kpistore.getKpistorecolList();
			for(KpistoreCol col:kpistoreCol){
				if(id.equals(col.getKpiid())){
					return new String[]{col.getKpiid(),col.getKpicolumn(),col.getKpidesc(),col.getKpitype()};
				}
				if(column.equals(col.getKpicolumn())){
					return new String[]{col.getKpiid(),col.getKpicolumn(),col.getKpidesc(),col.getKpitype()};
				}
			}
		}
		return null;
	}
	private boolean save(){
		try {
			int num = this.runner.execute(this.meta.toString(),new HashMap());
			this.meta = null;
			this.meta = new StringBuffer("begin ");
			return num>0?true:false;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
}
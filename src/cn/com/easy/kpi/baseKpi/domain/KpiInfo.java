package cn.com.easy.kpi.baseKpi.domain;

import java.util.List;

/**
 * Created by Administrator on 2016/2/2.
 */
public class KpiInfo {
    private List<KpiSelect> kpiUnit;
    private BaseKpi baseKpi=new BaseKpi();
    private List<KpiSelect> eds;

    public List<KpiSelect> getEds() {
        return eds;
    }

    public void setEds(List<KpiSelect> eds) {
        this.eds = eds;
    }

    public List<KpiSelect> getKpiUnit() {
        return kpiUnit;
    }

    public void setKpiUnit(List<KpiSelect> kpiUnit) {
        this.kpiUnit = kpiUnit;
    }

    public BaseKpi getBaseKpi() {
        return baseKpi;
    }

    public void setBaseKpi(BaseKpi baseKpi) {
        this.baseKpi = baseKpi;
    }

}

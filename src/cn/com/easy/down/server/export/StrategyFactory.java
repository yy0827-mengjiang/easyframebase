package cn.com.easy.down.server.export;

public class StrategyFactory {
	public static Strategy build(ArgsBean args){
		if("table".equalsIgnoreCase(args.getCommentType())){//表格
			if("1".equals(args.getDataType())){//调用sql 生成方法
				if(args.getFileType().equalsIgnoreCase("excel")){//excel文件
					return new ExcelTableBySQL();
				}else if(args.getFileType().equalsIgnoreCase("xlsx")){//excel文件
					return new ExcelTableBigDataBySQL();
				}else{//其它（pdf）
					return new PdfTableBySQL();
				}
			}else if("2".equalsIgnoreCase(args.getDataType())){//调用json数据 生成方法
				if(args.getFileType().equalsIgnoreCase("excel")){//excel文件
					return new ExcelTableByJson();
				}else if(args.getFileType().equalsIgnoreCase("xlsx")){//excel文件
					return new ExcelTableBigDataByJson();
				}else{//其它（pdf）
					return new PdfTableByJson();
				}
			}
		}else if("chart".equalsIgnoreCase(args.getCommentType().toLowerCase())){//图形
			args.setSvgCode(args.getSvgCode().replaceAll("stroke=\"rgba(.*?)\"", "").replaceAll("fill=\"rgba(.*?)\"", "").replaceAll("fill=\"transparent\"", ""));
			if("image/png".equalsIgnoreCase(args.getFileType())){//png文件
				return new PngChartBySvgCode();
		    }else if("image/jpeg".equalsIgnoreCase(args.getFileType())){//jpg文件
		    	return new JpegChartBySvgCode();
		    }else if("application/pdf".equalsIgnoreCase(args.getFileType())){//pdf文件
		    	return new PdfChartBySvgCode();
		    }else if("application/vnd.ms-excel".equalsIgnoreCase(args.getFileType())){//excel文件
		    	return new ExcelChartBySvgCode();
		    }
		}
		return null;
	}
}
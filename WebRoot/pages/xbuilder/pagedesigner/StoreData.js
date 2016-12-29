var StoreData = {
	userId:"",
	xid:"",
	name:"",
	theme:"",
	themeCache:"",
	lwidth:"",
	dsType:"",//数据集类型
	typeExt:"",//数据集扩展类型（3数据集）
	colorJson:[],
	color:[],
	currentColor:"",
	lhtml:"",
	ltype:"",//1为pc、2为手机
	layoutTem:"",//布局模板
	curContainerId:"",//当前选择的容器id
	curComponentId:"",//当前选择的组件id
	components:{},//当前添加的组件信息，key为组件id。//{id:LayOutUtil.uuid(),compid:comId,title:text,url:url,type:type,propertyUrl:propertyUrl,createType:"new",viewId:StoreData.xid,icon:icon};
	containers:{},//当前选择的组件
	cubeId:"-1"
};
Service = {};
Service.Factory = {};
Service.Factory.service= function(kind,settings,callback) {
	if(!kind) {
		log.error("kind is undefined", true);
		return;
	}
	if(!Service.Factory.builders[kind]){
		throw Error(kind + " is not a valid Entity type");
	}
	return Service.Factory.builders[kind](settings,callback);
};
Service.Factory.builders = [];


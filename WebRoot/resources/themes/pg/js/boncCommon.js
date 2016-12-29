/* Function Name  */
   $(function(){
       $(".mainMenu li a").click(
           //菜单索引
           function(){
               $(this).addClass("selected").parent("li").siblings("li").find("a").removeClass("selected");
               $(this).siblings("ul").slideToggle();
               $(this).siblings("b").toggleClass("subscriptOver");
               $(this).parent("li").siblings("li").find("ul").slideUp().siblings("b").removeClass("subscriptOver");
           } );
       //插入下标
       $(".mainMenu li").each(function(i){
           if($(this).find("a").parent("li").has("ul").length > 0) {
               $(this).append("<b class='subscript'></b>");
           }
       });
       //切换三级菜单
       $(".mainMenu li ul li ul li a").click(
           function(){
               $(".mainMenu li a").parent("li").siblings("li").find("ul").slideUp();
               $(".mainMenu li .subscript").removeClass("subscriptOver");
           } );

   })

/**
 * 初始化省份、地市、品牌、型号下拉选
 */
$(function(){
    var proOption = "<option value='0'>全国</option><option value='hb'>河北省</option><option value='jl'>吉林省</option>" +
        "<option value='ln'>辽宁省</option><option value='hlj'>黑龙江</option><option value='gd'>广东省</option>" +
        "<option value='fj'>福建省</option>";
    var brandOption = "<option value='0'>全部</option><option value='xm'>小米</option><option value='hw'>华为</option>" +
        "<option value='zx'>中兴</option><option value='pg'>苹果</option><option value='sx'>三星</option>" +
        "<option value='mz'>魅族</option><option value='vivo'>vivo</option>";
    var option = "<option value='qxz'>--请选择--</option>";
    //市场
    $("#province").append(proOption);
    $("#city").append(option);
    $("#brandA").append(brandOption);
    $("#versionA").append(option);
    $("#brandB").append(brandOption);
    $("#versionB").append(option);
    $("#brandC").append(brandOption);
    $("#versionC").append(option);
    //用户
    $("#provinceY").append(proOption);
    $("#cityY").append(option);
    $("#brandAY").append(brandOption);
    $("#versionAY").append(option);
    $("#brandBY").append(brandOption);
    $("#versionBY").append(option);
    $("#brandCY").append(brandOption);
    $("#versionCY").append(option);
    //换机
    $("#provinceH").append(proOption);
    $("#cityH").append(option);
    $("#brandAH").append(brandOption);
    $("#versionAH").append(option);
    $("#brandBH").append(brandOption);
    $("#versionBH").append(option);
    $("#brandCH").append(brandOption);
    $("#versionCH").append(option);
});
//省份、地市级联操作
function provinceChange(pt){
    var pro = '';
    var cityFlag = '';
    if(pt=='sc'){
        pro=$("#province").val();
        cityFlag = "city";
        $("#city").empty();
        $("#city").append("<option value='0'>--请选择--</option>");
    }else if(pt=='yh'){
        pro=$("#provinceY").val();
        cityFlag = "cityY";
        $("#cityY").empty();
        $("#cityY").append("<option value='0'>--请选择--</option>");
    }else if(pt=='hj'){
        pro=$("#provinceH").val();
        cityFlag = "cityH";
        $("#cityH").empty();
        $("#cityH").append("<option value='0'>--请选择--</option>");
    }

    //var pro=$("#province").val();
    //$("#city").empty();
    //$("#city").append("<option value='0'>--请选择--</option>");


    if(pro=="hb"){
        $("#"+cityFlag).append("<option value='sjz'>石家庄市</option>").append("<option value='ts'>唐山市</option>")
            .append("<option value='qhd'>秦皇岛市</option>").append("<option value='hd'>邯郸市</option>")
            .append("<option value='bd'>保定市</option>").append("<option value='zjk'>张家口市</option>")
            .append("<option value='cd'>承德市</option>").append("<option value='cz'>沧州市</option>")
            .append("<option value='lf'>廊坊市</option>").append("<option value='hs'>衡水市</option>");
    }else if(pro=="jl"){
        $("#"+cityFlag).append("<option value='cc'>长春市</option>").append("<option value='jl'>吉林市</option>")
            .append("<option value='sp'>四平市</option>").append("<option value='ly'>辽源市</option>")
            .append("<option value='th'>通化市</option>").append("<option value='bs'>白山市</option>")
            .append("<option value='bc'>白城市</option>").append("<option value='sy'>松原市</option>")
            .append("<option value='yj'>延吉市</option>");
    }else if(pro=="ln"){
        $("#"+cityFlag).append("<option value='sy'>沈阳市</option>").append("<option value='dl'>大连市</option>")
            .append("<option value='as'>鞍山市</option>").append("<option value='fs'>抚顺市</option>")
            .append("<option value='bx'>本溪市</option>").append("<option value='dd'>丹东市</option>")
            .append("<option value='jz'>锦州市</option>").append("<option value='yk'>营口市</option>")
            .append("<option value='fx'>阜新市</option>").append("<option value='ly'>辽阳市</option>")
            .append("<option value='pj'>盘锦市</option>").append("<option value='tl'>铁岭市</option>")
            .append("<option value='cy'>朝阳市</option>").append("<option value='hld'>葫芦岛市</option>");
    }else if(pro=="hlj"){
        $("#"+cityFlag).append("<option value='heb'>哈尔滨市</option>").append("<option value='qqhe'>齐齐哈尔市</option>")
            .append("<option value='jms'>佳木斯市</option>").append("<option value='hg'>鹤岗市</option>")
            .append("<option value='dq'>大庆市</option>").append("<option value='jx'>鸡西市</option>")
            .append("<option value='sys'>双鸭山市</option>").append("<option value='yc'>伊春市</option>")
            .append("<option value='mdj'>牡丹江市</option>").append("<option value='hh'>黑河市</option>")
            .append("<option value='qth'>七台河市</option>").append("<option value='sh'>绥化市</option>")
            .append("<option value='dxal'>大兴安岭地区</option>");
    }else if(pro=="gd"){
        $("#"+cityFlag).append("<option value='gz'>广州市</option>").append("<option value='sz'>深圳市</option>")
            .append("<option value='zh'>珠海市</option>").append("<option value='st'>汕头市</option>")
            .append("<option value='fs'>佛山市</option>").append("<option value='sg'>韶关市</option>")
            .append("<option value='zj'>湛江市</option>").append("<option value='zs'>中山市</option>")
            .append("<option value='jm'>江门市</option>").append("<option value='dg'>东莞市</option>");
    }else if(pro=="fj"){
        $("#"+cityFlag).append("<option value='fz'>福州市</option>").append("<option value='sm'>三明市</option>")
            .append("<option value='np'>南平市</option>").append("<option value='ly'>龙岩市</option>")
            .append("<option value='zz'>漳州市</option>").append("<option value='nd'>宁德市</option>")
            .append("<option value='pt'>莆田市</option>").append("<option value='qz'>泉州市</option>")
            .append("<option value='xm'>厦门市</option>");
    }
}
//品牌、型号级联操作
function phoneChange(type){
    var brand=$("#brand"+type).val();
    $("#version"+type).empty();
    $("#version"+type).append("<option value='0'>--请选择--</option>");
    if(brand=="xm"){
        $("#version"+type).append("<option value='xm1'>5系列</option>").append("<option value='xm2'>红米Note3</option>")
            .append("<option value='xm3'>Max系列</option>").append("<option value='xm4'>红米3s</option>")
            .append("<option value='xm5'>4系列</option>").append("<option value='xm6'>Note系列</option>")
            .append("<option value='xm7'>3系列</option>").append("<option value='xm8'>4C系列</option>")
            .append("<option value='xm9'>红米Note2</option>").append("<option value='xm10'>4S系列</option>");
    }else if(brand=="hw"){
        $("#version"+type).append("<option value='hw1'>P9系列</option>").append("<option value='hw2'>Mate8系列</option>")
            .append("<option value='hw3'>P9 Plus系列</option>").append("<option value='hw4'>P8系列</option>")
            .append("<option value='hw5'>G9青春版</option>").append("<option value='hw6'>畅享5S</option>")
            .append("<option value='hw7'>麦芒5系列</option>").append("<option value='hw8'>Mate 7系列</option>")
            .append("<option value='hw9'>麦芒4系列</option>").append("<option value='hw10'>Ascend P7系列</option>");
    }else if(brand=="zx"){
        $("#version"+type).append("<option value='zx1'>天机7系列</option>").append("<option value='zx2'>星星1号系列</option>")
            .append("<option value='zx3'>中兴V5系列</option>").append("<option value='zx4'>Axon Mini系列</option>")
            .append("<option value='zx5'>Blade A1（全网通）</option>").append("<option value='zx6'>Blade A2</option>")
            .append("<option value='zx7'>星星2号系列</option>").append("<option value='zx8'>远航4系列</option>")
            .append("<option value='zx9'>威武3系列</option>").append("<option value='zx10'>Axon天机系列</option>");
    }else if(brand=="pg"){
        $("#version"+type).append("<option value='pg1'>iPhone 6S系列</option>").append("<option value='pg2'>iPhone 6 Plus系列</option>")
            .append("<option value='pg3'>iPhone 6系列</option>").append("<option value='pg4'>iPhone SE</option>")
            .append("<option value='pg5'>iPhone 6S Plus系列</option>").append("<option value='pg6'>iPhone 5S系列</option>")
            .append("<option value='pg7'>iPhone 4S系列</option>").append("<option value='pg8'>iPhone 5C系列</option>")
            .append("<option value='pg9'>iPhone5系列</option>");
    }else if(brand=="sx"){
        $("#version"+type).append("<option value='sx1'>GALAXY S7系列</option>").append("<option value='sx2'>GALAXY Note 7系列</option>")
            .append("<option value='sx3'>GALAXY Note 5系列</option>").append("<option value=4'sx'>GALAXY S6系列</option>")
            .append("<option value='sx5'>GALAXY A9系列</option>").append("<option value='sx6'>GALAXY Note 3系列</option>")
            .append("<option value='sx7'>GALAXY S5系列</option>").append("<option value='sx8'>GALAXY A7系列</option>")
            .append("<option value='sx9'>GALAXY Note 4系列</option>").append("<option value='sx10'>2016版GALAXY A7系列</option>");
    }else if(brand=="mz"){
        $("#version"+type).append("<option value='mz1'>魅蓝Note 3系列</option>").append("<option value='mz2'>魅蓝3S系列</option>")
            .append("<option value='mz3'>MX5系列</option>").append("<option value='mz4'>魅蓝3系列</option>")
            .append("<option value='mz5'>MX4系列</option>").append("<option value='mz6'>魅蓝Note系列</option>")
            .append("<option value='mz7'>MX4 Pro系列</option>").append("<option value='mz8'>魅蓝metal系列</option>")
            .append("<option value='mz9'>魅蓝Note 2系列</option>").append("<option value='mz10'>魅蓝系列</option>");
    }else if(brand=="vivo"){
        $("#version"+type).append("<option value='vivo1'>Xplay 5系列</option>").append("<option value='vivo2'>V3系列</option>")
            .append("<option value='vivo3'>X6系列</option>").append("<option value='vivo4'>V3Max系列</option>")
            .append("<option value='vivo5'>Y51系列</option>").append("<option value='vivo6'>Y13L系列</option>")
            .append("<option value='vivo7'>X6 Plus系列</option>").append("<option value='vivo8'>X5Pro系列</option>")
            .append("<option value='vivo9'>X5Max系列</option>").append("<option value='vivo10'>X6SPlus系列</option>");
    }
}

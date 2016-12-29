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
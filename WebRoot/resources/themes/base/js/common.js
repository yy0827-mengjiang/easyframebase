
Base={
		___contentPath:'/',
		_getContextPath:	function (){

        if (!this.___contentPath) {
            var link = document.getElementsByTagName('script');
            for (var q = 0; q < link.length; q++) {
                var h = !!document.querySelector ? link[q].src : link[q].getAttribute("src", 4), i;
                if (h && (i = h.indexOf('resources/themes/base/js/common.js')) >= 0) {
                    var j = h.indexOf('://');
                    this.___contentPath = j < 0 ? h.substring(0, i - 1) : h.substring(h.indexOf('/', j + 3), i - 1);
                    break;
                }
            };
                    }
        return this.___contentPath;
    },
    /**
     * 将action转化为全路径
     * @param {String} action 需要转化的路径
     * @param {Boolean} [addAction] 是否强制添加“.action”，默认为true
     * @return {String} 将action转化的全路径
     * @public
     */
toFullPath: function (action, addAction){
        if (action.indexOf('://') != -1) {
            return action;
        }
        var contentPath = this.getContextPath();
        if (!action || 'string' != typeof(action)) 
            return action || '';
        if (action.indexOf('/') === 0) 
            action = (contentPath === '/' ? '' : contentPath) + action;
        if (addAction === false) {
            return action;
        } else {
            var i = action.indexOf('?');
            if (i < 0) 
                i = action.length;
            if (action.substring((i - 7), i) == 'extView') 
                return action;
            return action.lastIndexOf('.', i) < 0 ? action.substring(0, i) + '.action' + action.substring(i) : action;
        }
    }

}
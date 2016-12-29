jQuery(document).ready(function($){
	var mainHeader = $('#boncEntry', window.top.document).children("div .cd-auto-hide-header");
	var iframeTop=$('#ContentIframe', window.top.document);
	var conTop=$('#con', window.parent.document);
		secondaryNavigation = $('#boncEntry', window.parent.document).has('.easyui-tabs .tabs-header'),
		//this applies only if secondary nav is below intro section
		belowNavHeroContent = $('#boncEntry', window.parent.document).has('.easyui-tabs .tabs-panels'),
		headerHeight = mainHeader.height();
	//set scrolling variables
	var scrolling = false,
		previousTop = 0,
		currentTop = 0,
		scrollDelta = 10,
		scrollOffset = 0;

	mainHeader.on('click', '.nav-trigger', function(event){
		// open primary navigation on mobile
		event.preventDefault();
		mainHeader.toggleClass('nav-open');
	});

	$(window).on('scroll', function(){
	
		if( !scrolling ) {
			scrolling = true;
			(!window.requestAnimationFrame)
				? setTimeout(autoHideHeader, 200)
				: requestAnimationFrame(autoHideHeader);
		}
	});

	$(window).on('resize', function(){
		headerHeight = mainHeader.height();
	});

	function autoHideHeader() {
		var currentTop = $(window).scrollTop();

		( belowNavHeroContent.length > 0 ) 
			? checkStickyNavigation(currentTop) // secondary navigation below intro
			: checkSimpleNavigation(currentTop);

	   	previousTop = currentTop;
		scrolling = false;
	}

	function checkSimpleNavigation(currentTop) {  
		//there's no secondary nav or secondary nav is below primary nav
	    if (previousTop - currentTop > scrollDelta) {
	    	//if scrolling up...
	    	mainHeader.removeClass('is-hidden');
	    	iframeTop.css({marginTop:"71px",height:"550px"});
	    	conTop.css({height:"550px"});
	    } else if( currentTop - previousTop > scrollDelta && currentTop > scrollOffset) {
	    	//if scrolling down...
	    	 
	    	mainHeader.addClass('is-hidden');
	    	iframeTop.css({marginTop:"0px",height:(window.screen.height-130)+'px'});
	    	conTop.css({height:(window.screen.height-180)+'px'});
	    }
	}

	function checkStickyNavigation(currentTop) {

		//secondary nav below intro section - sticky secondary nav
		var secondaryNavOffsetTop = belowNavHeroContent.offset().top - secondaryNavigation.height() - mainHeader.height();
		
		if (previousTop >= currentTop ) {
	    	//if scrolling up... 
	    	if( currentTop < secondaryNavOffsetTop ) {                                                                        b 
	    		//secondary nav is not fixed
	    		mainHeader.removeClass('is-hidden');
	    		iframeTop.css({marginTop:"71px",height:"550px"});
	    		conTop.css({height:"550px"});
	    		secondaryNavigation.removeClass('fixed slide-up');
	    		belowNavHeroContent.removeClass('secondary-nav-fixed');
	    	} else if( previousTop - currentTop > scrollDelta ) {
	    		//secondary nav is fixed
	    		mainHeader.removeClass('is-hidden');
	    		iframeTop.css({marginTop:"71px",height:"550px"});
	    		conTop.css({height:"550px"});
	    		belowNavHeroContent.addClass('secondary-nav-fixed');
	    	}
	    	
	    } else {
	    	//if scrolling down...	
	 	  	if( currentTop > secondaryNavOffsetTop + scrollOffset ) {
	 	  		//hide primary nav
	    		mainHeader.addClass('is-hidden');
	    		iframeTop.css({marginTop:"0px",height:(window.screen.height-130)+'px'});
		    	conTop.css({height:(window.screen.height-180)+'px'});
	    		secondaryNavigation.addClass('fixed slide-up');
	    		belowNavHeroContent.addClass('secondary-nav-fixed');
	    	} else if( currentTop > secondaryNavOffsetTop ) {
	    		//once the secondary nav is fixed, do not hide primary nav if you haven't scrolled more than scrollOffset 
	    		mainHeader.removeClass('is-hidden');
	    		iframeTop.css({marginTop:"71px",height:"550px"});
	    		conTop.css({height:"550px"});
	    		secondaryNavigation.addClass('fixed').removeClass('slide-up');
	    		belowNavHeroContent.addClass('secondary-nav-fixed');
	    	}

	    }
	}
});
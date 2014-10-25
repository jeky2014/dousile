//= require jquery/2.0.0/jquery.min.js
//= require jquery_ujs
//= require bootstrap/js/bootstrap.min.js
//= require admin

// 选中导航栏
$().ready(function(){
	$('ul.navbar-nav li').removeClass('active');
	var links = $('ul.navbar-nav li a');
	for(var i = links.length - 1; i >=0; i--) {
		if(location.href.indexOf(links[i].href) > -1) {
			$(links[i]).parent().addClass('active');
			break;
		}
	}
});


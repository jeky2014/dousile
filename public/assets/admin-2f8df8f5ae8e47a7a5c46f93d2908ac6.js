$().ready(function(){$("ul.navbar-nav li").removeClass("active");for(var a=$("ul.navbar-nav li a"),e=a.length-1;e>=0;e--)if(location.href.indexOf(a[e].href)>-1){$(a[e]).parent().addClass("active");break}});
/*
 * vivitics.js
 * copyright (c) @thomaswilley, 2017
 */

/*
 * stitch in the left rail menu
 */
$('<link/>', {
    rel: 'stylesheet',
    type: 'text/css',
    href: 'https://unpkg.com/purecss@0.6.2/build/pure-min.css',
    integrity: 'sha384-UQiGfs9ICog+LwheBSRCt1o5cbyKIHbwjWscjemyBMT9YCUMZffs6UqUTd0hObXD',
    crossorigin: 'anonymous'
}).prependTo('head');
$("body").children().wrapAll('<div id="layout"/>');
$(".container").addClass("content");
$('<div id="menu"/>').prependTo('#layout');
$('<a href="#" id="menuLink" class="menu-link"/>').prependTo('#layout');
$('<span/>').prependTo('#menuLink');
$('<div class="pure-menu"/>').appendTo('#menu');
$('<a id="menu-heading-link" class="pure-menu-heading" href="#">Vivitics - Home</a>').appendTo('.pure-menu');
$('#menu-heading-link').attr('href', $('a[title=dashboard]').attr('href'));
$('<ul class="pure-menu-list"/>').appendTo('.pure-menu');
/* blog */
$('<li class="pure-menu-item"><a href="/" class="pure-menu-link">Site</a></li>').appendTo('.pure-menu-list');
$('<li class="pure-menu-item"><a href="/nb/tree/_Vivitics/_Blog" class="pure-menu-link">Posts</a></li>').appendTo('.pure-menu-list');
/* shortcuts */
$('<li class="pure-menu-item"><a href="javascript:gotoDropbox()" class="pure-menu-link">Dropbox</a></li>').appendTo('.pure-menu-list');
/* logout */
$('<li class="pure-menu-item"><a href="javascript:$(\'button[id=logout]\').click()" class="pure-menu-link">Logout</a></li>').appendTo('.pure-menu-list');

/* returns bool result of test of whether given URI returns 200 */
function resourceExists(theUrl)
{
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.open( "GET", theUrl, false ); // false for synchronous request
  xmlHttp.send( null );
  return xmlHttp.status == 200 ? true : false;
}

/* redirect to canonical location for dropbox on this note; prompt to finsh install if doesnt exist */
function gotoDropbox() {
  var dbxUrl = "/nb/tree/Dropbox";
  if (resourceExists(dbxUrl)) {
    window.location.href = dbxUrl;
  } else {
    alert("Dropbox install is incomplete: to complete, run $ docker logs vvm_dropbox and follow the provided link to associate your node to your dropbox account.");
  }
}

/*
 * trim out unwanted jupyter UI elements
 */
$('#login_widget').hide();
$("a[title=dashboard]").parent().hide();

/*
 * activate left rail menu logic
 */

(function (window, document) {

    var layout = document.getElementById('layout');
    menu       = document.getElementById('menu'),
        menuLink = document.getElementById('menuLink'),
        content  = document.getElementById('ipython-main-app');

    function toggleClass(element, className) {
        var classes = element.className.split(/\s+/),
        length = classes.length,
        i = 0;

        for(; i < length; i++) {
            if (classes[i] === className) {
                classes.splice(i, 1);
                break;
            }
        }
        // The className is not found
        if (length === classes.length) {
            classes.push(className);
        }

        element.className = classes.join(' ');
    }

    function toggleAll(e) {
        var active = 'active';

        e.preventDefault();
        toggleClass(layout, active);
        toggleClass(menu, active);
        toggleClass(menuLink, active);
    }

    menuLink.onclick = function (e) {
        toggleAll(e);
    };

    content.onclick = function(e) {
        if (menu.className.indexOf('active') !== -1) {
            toggleAll(e);
        }
    };

}(this, this.document));

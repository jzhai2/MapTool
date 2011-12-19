<%@ page session="true" %>
<%@ page isErrorPage="true" import="java.io.*" import="mapTool.InformationStore" import="org.json.*" import="java.util.*" import="java.sql.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<jsp:useBean id="treeMaker" scope="session" class="mapTool.Treemaker" />
<%
	 ResultSet rs = treeMaker.getRootRS("263");
	 JSONObject obj = new JSONObject();
	 JSONObject attr = new JSONObject();
	 attr.put("id", rs.getInt(1));
	 obj.put("attr",attr);
	 obj.put("data", rs.getString(2).replace("%20"," "));
	 obj.put("state", "closed");
	 String js = obj.toString();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>

<title>XML Tree Loader</title>
<link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="jquery.jstree.js"></script>
<script src="http://ajax.cdnjs.com/ajax/libs/json2/20110223/json2.js"></script>
<script src="http://ajax.cdnjs.com/ajax/libs/underscore.js/1.1.6/underscore-min.js"></script>
<script type="text/javascript" src="http://ajax.cdnjs.com/ajax/libs/backbone.js/0.3.3/backbone-min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.8.11/jquery-ui.min.js"></script>

<style type="text/css">

div.drsElement {
 position: absolute;
 border: 1px solid #333;
}

div.drsMoveHandle {
 height: 20px;
 background-color: #CCC;
 border-bottom: 1px solid #666;
}

input.menuButton {
 font-size:10px;
 font-weight:bold;
 width:20px;
 height:20px;
 background-color:#AAAAAA;
 border-style:solid;
 border-color:#BBBBBB;
}

div.theaterMode {
 background-color: rgba(252, 252, 252, .6);
 position: fixed;
 bottom: 0;
 top: 0;
 left: 0;
 right: 0;
 overflow: auto;
 z-index: 100;
}

div.wrapper {
 text-align: center;
 position: fix;
 margin-left: 15%;
 margin-right: 15%;
 margin-top: 20px;
 overflow: auto;
 z-index: 101;
}

div.snowbox {
 background-color: white;
 text-align: center;
 overflow: auto;
 z-index: 102;
}

div.mediaDisplay {
 background-color: #EBECE4;
 text-align: center;
 position: relative;
 margin-left: 10px;
 margin-right: 10px;
 margin-top: 10px;
 overflow: auto;
 z-index: 103;
}

div.mediaDescription {
 background-color: white;
 text-align: left;
 position: relative;
 margin-left: 10px;
 margin-right: 10px;
 margin-top: 10px;
 overflow: auto;
 z-index: 103;
}

div.mediaThumbnail {
 background-color: white;
 position: relative;
 margin-left: 5px;
 margin-right: 5px;
 margin-top: 70px;
 overflow: auto;
 z-index: 102;
}

div.thumbnail-content {
	width: 2000px;
}

div.thumbnail-content-item {
 width: 100px; 
 height: 100px;
 cursor:pointer;
 background-color: #CCC;
 float: left; 
 margin: 10px;
 font-size: 3em; 
 line-height: 96px;
 text-align: center;
}

div.hilite {
 background:yellow;
}

</style>

<script type="text/javascript">

$(function() {
	var n_drag = {
		cursor: "move",
		handle: "#navigator_handler"
	}
	$("#navigator").draggable(n_drag);
	
	var a_drag = {
			cursor: "move",
			handle: "#artifact_handler"
	}
	$("#artifact").draggable(a_drag);
	
	var n_resize = {
		autoHide: true,
		handles: "all",
		maxWidth: 500,
		maxHeight: 600,
		minWidth: 200,
		minHeight: 200
	}
	$("#navigator").resizable(n_resize);
	$("#navigator").bind('resize', function() {
		var h = $("#navigator").height();
		$("#tree").height(h - 41);
	});
	
	var a_resize = {
		autoHide: true,
		handles: "all",
		maxWidth: 500,
		maxHeight: 600,
		minWidth: 200,
		minHeight: 200
	}
	$("#artifact").resizable(a_resize);
	$("#artifact").bind('resize', function() {
		var h = $("#artifact_handler").height();
		var sep = $("#sep").height();
		var up = $("#up").height();
		var down = $("#down").height();
		var ta = $("#textAreaContainer").height();
		var p = $("#artifact").height();
		var w = $("#textAreaContainer").width();
		var total = sep + up + down + ta + h;
		var t = 100 * (ta - 7) / ta;
		var tw = 100 * (w - 8) / w;
		if (p > total) {
			var downUpdate = 100 * ( down + (p - total) - 2 ) / p;
			$("#down").text("down = " + downUpdate + "%");
			$("#textArea").height(t + "%");
			$("#textArea").width(tw + "%");
			$("#down").height(downUpdate + "%");
		} else if (p < total) {
			var downUpdate = 100 * ( down - (total - p) - 2 ) / p;
			$("#down").text("down = " + downUpdate + "%");
			$("#textArea").height(t + "%");
			$("#textArea").width(tw + "%");
			$("#down").height(downUpdate + "%");
		}
	});

	$("div.thumbnail-content-item").click(function () { 
    	alert('sup'); 
	});

	$("div.thumbnail-content-item").hover(function () {
    		$(this).addClass("hilite");
		}, function () {
    		$(this).removeClass("hilite");
	});
});

function goLite(n) {
	document.getElementById(n).style.backgroundColor = "#DDDDDD";
}

function goDim(n) {
	document.getElementById(n).style.backgroundColor = "#AAAAAA";
}

</script>
</head>
<body style="font: 13px/20px sans-serif; background-color: #FFF">

<div id="navigator" class="drsElement"
 style="left: 10px; top: 7px; width: 250px; height: 250px;
 background: #00CC99; text-align: center;">
 	<div id="navigator_handler" class="drsMoveHandle">Navigator Panel</div>
 	<div id="tree" style="text-align: left; height: 209px; overflow: auto"></div>
 	<div id="navigator_menu" style="width: 100%; height: 20px; background: #CCC; text-align: left;">
 		<input type="button" id="create_node" class="menuButton" value="C" onMouseOver="goLite(this.id)" onMouseOut="goDim(this.id)"/>
 		<input type="button" id="rename_node" class="menuButton" value="N" onMouseOver="goLite(this.id)" onMouseOut="goDim(this.id)"/>
 		<input type="button" id="refresh_node" class="menuButton" value="R" onMouseOver="goLite(this.id)" onMouseOut="goDim(this.id)"/>
 		<input type="button" id="disable_resize_drag" class="menuButton" value="D" onMouseOver="goLite(this.id)" onMouseOut="goDim(this.id)"/>
 		<input type="button" id="enable_resize_drag" class="menuButton" value="E" onMouseOver="goLite(this.id)" onMouseOut="goDim(this.id)"/>
 	</div>
</div>

<div id="artifact" class="drsElement"
 style="left: 10px; top: 263px; width: 250px; height: 350px;
 background: #00CC99; text-align: center;">
 <div id="artifact_handler" class="drsMoveHandle" style="text-align: left;">Artifact - 
 	<input type="button" id="maximize" class="menuButton" value="M" onMouseOver="goLite(this.id)" onMouseOut="goDim(this.id)"  onclick="theaterOn()"/>
 </div>
 	<div id="textAreaContainer" style="width:100%; height:20%">
 	<textarea id="textArea" rows="3" readonly="true" maxlength="1024" style="width:97%; height:90%;" placeholder="Description about this submap..."></textarea>
 	</div>
 	<div id="Media" style="width:20%; height:100%; float:left;">Media</div>
 	<div id="up" style="width:80%; height:37%; background:#CCA; overflow:auto;">
 		<iframe width="560" height="345" src="http://www.youtube.com/embed/k5kPzmh0I-Q" frameborder="0" allowfullscreen></iframe>
 	</div>
 	<div id="sep" style="width:80%; height:2px; background:#00CC99;"></div>
 	<div id="down" style="width:80%; height:36.4%; background:#CCB; overflow:auto;">down</div>
</div>

<div id="background" class="theaterMode">
<div id="outer_container" class="wrapper">
	<div id="stagepage" class="snowbox">
		<div id="media_display" class="mediaDisplay">
			<iframe width="560" height="345" src="http://www.youtube.com/embed/k5kPzmh0I-Q" frameborder="0" allowfullscreen></iframe>
		</div>
		<div id="media_description" class="mediaDescription">
			<p id="eow-description">Take A Chance On Me' Out 6.11.11. UK &amp; Ireland order from iTunes <a href="http://bit.ly/TACOMiTunes" target="_blank" title="http://bit.ly/TACOMiTunes" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://bit.ly/TACOMiTunes</a> Taken from the album 'Jukebox' out 14.11.11. UK &amp; Ireland order here <a href="http://amzn.to/TakeAChanceAMZ" target="_blank" title="http://amzn.to/TakeAChanceAMZ" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://amzn.to/TakeAChanceAMZ</a><br><br>Music video by JLS performing Take A Chance On Me. (C) 2011 Sony Music Entertainment UK Limited</p>
		</div>
	</div>
	<div di="thumbnail" class="mediaThumbnail">
	<div class="thumbnail-content">
		<div class="thumbnail-content-item">1</div>
		<div class="thumbnail-content-item">2</div>
		<div class="thumbnail-content-item">3</div>
		<div class="thumbnail-content-item">4</div>
		<div class="thumbnail-content-item">5</div>
		<div class="thumbnail-content-item">6</div>
		<div class="thumbnail-content-item">7</div>
		<div class="thumbnail-content-item">8</div>
		<div class="thumbnail-content-item">9</div>
		<div class="thumbnail-content-item">10</div>
		<div class="thumbnail-content-item">11</div>
		<div class="thumbnail-content-item">12</div>
		<div class="thumbnail-content-item">13</div>
	</div>
	</div>
</div>
</div>
</div>

<script src="navigator.js"></script>
<script src="separator.js"></script>
<script type="text/javascript">

var sp = new Separator('sup', {enable: true, Logdiv: "down", Updiv: "up", Downdiv: "down", margin: 40});
sp.addHandler(document.getElementById("sep"));

</script>
</body>
</html>
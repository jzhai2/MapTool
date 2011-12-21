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

div.Upper-Wrapper {
 height: 430px;
 margin-left: 5px;
 margin-top: 5px;
 margin-right: 5px;
 overflow: auto;
}

div.Lower-Wrapper {
 position: relative;
 margin-left: 5px;
 margin-right: 5px;
 height: 170px;
 overflow: auto;
}

table.Table-upper-wrapper {
 height: 100%;
 width: 100%;
 table-layout: fixed;
 overflow: auto;
}

table.Table-upper-wrapper td {
 border: 1px solid gray;
}

table.Table-control-bar {
 height: 100%;
 width: 100%;
 table-layout: fixed;
 overflow: auto;
}

td.Media {
 width: 70%;
 height: 100%;
 background-color: #EBECE4;
 overflow: auto;
 text-align: center;
}

td.Description {
 width: 30%;
 height: 100%;
 background-color: #EBECE4;
 overflow: auto;
}

div.Media {
 overflow: auto;
 width: 100%;
 height: 100%;
}

div.Description {
 overflow: auto;
 width: 100%;
 height: 100%;
}

div.Control-Bar {
 margin-top: 3px;
 height: 35px;
 overflow: hidden;
 border: 1px solid black;
}

div.Control-Bar-Left {
 height: 100%;
 width: 40%;
 text-align: center;
 float: left;
}

div.Control-Bar-Right {
 height: 100%;
 width: 60%;
 text-align: left;
 position: relative;
 left: 50%;
 float: right;
 background-color: #EBECE4;
}

div.Zooming-Icon {
 height: 80%;
 width: 30px;
 margin-left: 10%;
 margin-top: 3px;
 float: left;
 overflow: hidden;
 position: relative;
 text-align: center;
}

div.Thumbnail {
 position: relative;
 float: clear;
 margin: 0;
 height: 130px;
 overflow: auto;
}

div.Zooming-Slider {
 width: 50%;
 margin-top: 8px;
 margin-left: 25%;
 position: relative;
 float: center;
}

div.thumbnail-wrapper {
 width: 2000px;
}

input.groovybutton1 {
   font-size:11px;
   font-family:Verdana,sans-serif;
   font-weight:bold;
   color:#888888;
   cursor: pointer;
   width:80px;
   background-color:#EEEEEE;
   border-style:solid;
   border-color:#BBBBBB;
   border-width:1px;
   float: left;
}

input.groovybutton2 {
   font-size:11px;
   font-family:Verdana,sans-serif;
   font-weight:bold;
   color:#888888;
   width:130px;
   cursor: pointer;
   background-color:#EEEEEE;
   border-style:solid;
   border-color:#BBBBBB;
   border-width:1px;
   margin-left: 10px;
   position: relative;
   float: center;
}

input.groovybutton3 {
   font-size:11px;
   font-family:Verdana,sans-serif;
   font-weight:bold;
   color:#888888;
   width:80px;
   cursor: pointer;
   background-color:#EEEEEE;
   border-style:solid;
   border-color:#BBBBBB;
   border-width:1px;
   margin-left: 10px;
   position: relative;
}

input.hide {
   font-size:11px;
   font-family:Tahoma,sans-serif;
   text-align:left;
   color:#FFFFFF;
   width:96px;
   height:26px;
   background-color:#999999;
   border-top-style:solid;
   border-top-color:#949494;
   border-top-width:1px;
   border-bottom-style:solid;
   border-bottom-color:#949494;
   border-bottom-width:1px;
   border-left-style:solid;
   border-left-color:#8A8A8A;
   border-left-width:6px;
   border-right-style:solid;
   border-right-color:#BABABA;
   border-right-width:6px;
   cursor: pointer;
}

input.show {
   font-size:11px;
   font-family:Tahoma,sans-serif;
   text-align:right;
   color:#FFFFFF;
   width:96px;
   height:26px;
   background-color:#999999;
   border-top-style:solid;
   border-top-color:#949494;
   border-top-width:1px;
   border-bottom-style:solid;
   border-bottom-color:#949494;
   border-bottom-width:1px;
   border-left-style:solid;
   border-left-color:#BABABA;
   border-left-width:6px;
   border-right-style:solid;
   border-right-color:#8A8A8A;
   border-right-width:6px;
}

#feedback { font-size: 1.4em; }
#thumbnail-content .ui-selecting { background: #FECA40; }
#thumbnail-content .ui-selected { background: #F39814; color: white; }
#thumbnail-content { list-style-type: none; margin: 0; padding: 0; }
#thumbnail-content li { cursor: pointer; background-color: #CCC; border: 1px solid #CCC; line-height: 96px; margin: 5px; padding: 1px; float: left; width: 100px; height: 100px; font-size: 3em; text-align: center; }
#thumbnail-content .ui-state-hover { border: 1px solid black; }

.ui-resizable-e { cursor: e-resize; width: 7px; right: -1px; top: 0; height: 100%; }

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
		minWidth: 600,
		minHeight: 550,
		resize: function(event, ui) {
			var h = ui.size.height - 180;
        	$('.Upper-Wrapper').css("height", h+"px");
    	}
	}
	$("#artifact").resizable(a_resize);
	
	$("#thumbnail-content").selectable();

	$("#thumbnail-content li").hover(function () {
		$(this).addClass('ui-state-hover');
	}, function () {
		$(this).removeClass('ui-state-hover');		
	});

	$("#resizeTD").resizable({
        create: function(event, ui) { 
            var nodeName = this.nodeName.toUpperCase();
            if (nodeName == 'TH' || nodeName == 'TD') {
                var self = $(this);
                self.resizable('element', self.wrapInner('<div class="ui-resizable"/>'));
                self.resizable('option', 'alsoResize', this.parentNode);
            }
        },
        handles: 'e',
        minWidth: 200,
        maxWidth: 550
    });

    $( ".Zooming-Slider" ).slider({
		value:0,
		min: -100,
		max: 100,
		step: 10,
		slide: function( event, ui ) {
			$( "#amount" ).val( ui.value );
		}
	});
	$( "#amount" ).val( $( ".Zooming-Slider" ).slider( "value" ) );
});

function goLite(n) {
	document.getElementById(n).style.backgroundColor = "#DDDDDD";
}

function goDim(n) {
	document.getElementById(n).style.backgroundColor = "#AAAAAA";
}

function goLite_groovy(n) {
   document.getElementById(n).style.color = "#6666AA";
   document.getElementById(n).style.backgroundColor = "#EEEEF4";
   document.getElementById(n).style.borderColor = "#9999DD";
}

function goDim_groovy(n) {
   document.getElementById(n).style.color = "#888888";
   document.getElementById(n).style.backgroundColor = "#EEEEEE";
   document.getElementById(n).style.borderColor = "#BBBBBB";
}

function goLite_hide(n) {
   document.getElementById(n).style.backgroundColor = "#A3A3A3";
   document.getElementById(n).style.borderTopColor = "#9C9C9C";
   document.getElementById(n).style.borderBottomColor = "#9C9C9C";
   document.getElementById(n).style.borderLeftColor = "#949494";
   document.getElementById(n).style.borderRightColor = "#C2C2C2";
}

function goDim_hide(n) {
   document.getElementById(n).style.backgroundColor = "#999999";
   document.getElementById(n).style.borderTopColor = "#949494";
   document.getElementById(n).style.borderBottomColor = "#949494";
   document.getElementById(n).style.borderLeftColor = "#8A8A8A";
   document.getElementById(n).style.borderRightColor = "#BABABA";
}

function goLite_show(n) {
   document.getElementById(n).style.backgroundColor = "#A3A3A3";
   document.getElementById(n).style.borderTopColor = "#9C9C9C";
   document.getElementById(n).style.borderBottomColor = "#9C9C9C";
   document.getElementById(n).style.borderLeftColor = "#C2C2C2";
   document.getElementById(n).style.borderRightColor = "#949494";
}

function goDim_show(n) {
   document.getElementById(n).style.backgroundColor = "#999999";
   document.getElementById(n).style.borderTopColor = "#949494";
   document.getElementById(n).style.borderBottomColor = "#949494";
   document.getElementById(n).style.borderLeftColor = "#BABABA";
   document.getElementById(n).style.borderRightColor = "#8A8A8A";
}

function hide() {
	var mw = $("#upper-wrapper").width() - 10;
	$("#resizeTD").css("max-Width", mw);
	$("#resizeTD").animate({
		width: mw
	});
	$("#resizeTD").append();
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

<div id="artifact" class="drsElement" style="left: 270px; top: 7px; width: 800px; height: 610px;">
	<div id="upper-wrapper" class="Upper-Wrapper">
		<table class="Table-upper-wrapper">
			<tbody>
				<tr>
					<td id="resizeTD" class="Media">
						<iframe width="560" height="315" src="http://www.youtube.com/embed/JIzw7BHmkN4" frameborder="0" allowfullscreen></iframe>
						<p>
							<label for="amount">Zooming amount (10 increments):</label>
							<input type="text" id="amount" style="border:0; color:#f6931f; font-weight:bold;" />
						</p>
					</td>
					<td class="Description">
						<div class="Description">
							<input type="button" id="hide_button" class="hide" value="  >> Hide" title="" onMouseOver="goLite_hide(this.id)" onMouseOut="goDim_hide(this.id)" onclick="hide()">
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="Lower-Wrapper">
		<div id="thumbnail" class="Thumbnail">
			<div class="thumbnail-wrapper">
				<ol id="thumbnail-content">
					<li>1</li>
					<li>2</li>
					<li>3</li>
					<li>4</li>
					<li>5</li>
					<li>6</li>
					<li>7</li>
					<li>8</li>
					<li>9</li>
					<li>10</li>
					<li>11</li>
					<li>12</li>
				</ol>
			</div>
		</div>
		<div class="Control-Bar">
			<table class="Table-control-bar">
			<tbody>
				<tr>
					<td style="width: 50%">
						<div class="Zooming-Icon">
							<img src="zoom.png"/>
						</div>
						<div class="Zooming-Slider"></div>
					</td>
					<td>
						<input type="button" id="groovybtn1" class="groovybutton1" value="Full Screen" title="" onMouseOver="goLite_groovy(this.id)" onMouseOut="goDim_groovy(this.id)" onClick="location.href='http://axon.cer.jhu.edu:8080/reveal-sandbox-jiefeng/XMLTester_jQuery_backbone.jsp'" value='click here to visit home page'>
						<input type="button" id="groovybtn2" class="groovybutton2" value="Current Item Info" title="" onMouseOver="goLite_groovy(this.id)" onMouseOut="goDim_groovy(this.id)">
						<input type="button" id="groovybtn3" class="groovybutton3" value="Edit Items" title="" onMouseOver="goLite_groovy(this.id)" onMouseOut="goDim_groovy(this.id)">
					</td>
				</tr>
			</tbody>
		</table>
		<div>
	<div> 
</div>

</body>
</html>
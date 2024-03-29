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
<script src="hoverIntent.js"></script>

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

table.Table-upper-wrapper {
 width: 100%;
 height: 100%;
 border-spacing: 5px;
 table-layout: fixed;
 overflow: auto;
}

table.Table-left-wrapper {
 width: 100%;
 height: 100%;
 table-layout: fixed;
 border: none;
 overflow: auto;
}

table.Table-right-wrapper {
 width: 100%;
 height: 100%;
 table-layout: fixed;
 border: none;
 overflow: auto;
}

table.Table-lower-wrapper {
 width: 100%;
 height: 100%;
 table-layout: fixed;
 overflow: auto;
}

td.Left-Inner-Wrapper {
 width: 73%;
 height: 100%;
 overflow: auto;
 text-align: center;
 border: 1px solid gray;
}

td.Right-Inner-Wrapper {
 width: 27%;
 height: 100%;
 overflow: auto;
 text-align: left;
 border: 1px solid gray;
}

td.Description {
 width: 100%;
 height: 100%;
 overflow: auto;
 background-color: #EBECE4;
}

td.Media {
 width: 100%;
 height: 460px;
 background-color: #EBECE4;
}

td.Thumbnail {
 width: 100%;
 border-style: none;
}

td.Lower-Inner-Wrapper {
 height: 30px;
 width: 100%;
 overflow: hidden;
 border: 1px solid gray;
}

td.Control-button {
 height: 100%;
 width: 60%;
}

td.Zooming {
 height: 100%;
 width: 40%;
}

div.Description {
 overflow: auto;
 width: 100%;
 height: 100%;
}

div.Media {
 overflow: auto;
 width: 100%;
 height: 100%;
}

tr.Control-Bar {
 height: 35px;
 overflow: hidden;
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
 width: 100%;
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
   float: right;
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
   position: absolute;
   top: 7px;
   z-index: 50;
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
   position: absolute;
   cursor: pointer;
   right: 4px;
   top: 4px;
   z-index: 50;
}

#feedback { font-size: 1.4em; }
#thumbnail-content .ui-selecting { background: #FECA40; }
#thumbnail-content .ui-selected { background: #F39814; color: white; }
#thumbnail-content { list-style-type: none; margin: 0; padding: 0; }
#thumbnail-content li { cursor: pointer; background-color: #CCC; border: 1px solid #CCC; line-height: 96px; margin: 5px; padding: 1px; float: left; width: 100px; height: 100px; font-size: 3em; text-align: center; }
#thumbnail-content .ui-state-hover { border: 1px solid black; }

.ui-resizable-e { cursor: e-resize; width: 10px; right: -1px; top: 0; height: 100%; }

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
		minWidth: 660,
		minHeight: 550,
		resize: function(event, ui) {
        	$("td.Media").height(ui.size.height - 200);
        	$("td.Left-Inner-Wrapper").height("100%");
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
        maxWidth: 600
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

    hiConfig = {
        sensitivity: 2, // number = sensitivity threshold (must be 1 or higher)
        interval: 200, // number = milliseconds for onMouseOver polling interval
        timeout: 200, // number = milliseconds delay before onMouseOut
        over: function() {
            $("#descriptionTD").append('<input type="button" id="hide_button" class="hide" value="  >> Hide" title="" onMouseOver="goLite_hide(this.id)" onMouseOut="goDim_hide(this.id)" onclick="hide()">');
        }, // function = onMouseOver callback (REQUIRED)
        out: function() { 
        	$("#hide_button").remove();
        } // function = onMouseOut callback (REQUIRED)
    }
    $("#descriptionTD").hoverIntent(hiConfig)
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
	var mw = $("table.Table-upper-wrapper").width();
	$("#hide_button").remove();
	$("td.Left-Inner-Wrapper").css("max-Width", mw);
	$("td.Left-Inner-Wrapper").animate({
			width: mw
		}, function () {
			$("td.Left-Inner-Wrapper").width('100%');
			$("td.Right-Inner-Wrapper").width('0%');
			$("div.Media").append('<input type="button" id="show_button" class="show" value=" << Show" title="" onMouseOver="goLite_show(this.id)" onMouseOut="goDim_show(this.id)" onclick="show()">');
	});
}

function show() {
	var w = parseInt($("table.Table-upper-wrapper").width() * 0.73);
	var mw = parseInt($("table.Table-upper-wrapper").width() * 0.9);
	$("#show_button").remove();
	$("td.Left-Inner-Wrapper").css("max-Width", mw); 
	$("table.Table-left-wrapper").css("border-right", " 1px solid black");
	$("table.Table-left-wrapper").animate({
			width: w
		}, function () {
			$("table.Table-left-wrapper").css("border-right", "none");
			$("table.Table-left-wrapper").width('100%');
			$("td.Left-Inner-Wrapper").width('73%');
			$("td.Right-Inner-Wrapper").width('27%');
	});
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

<div id="artifact" class="drsElement" style="overflow: hidden; left: 270px; top: 7px; width: 800px; height: 660px;">
		<table class="Table-upper-wrapper">
			<tbody>
				<tr>
					<td id="resizeTD" class="Left-Inner-Wrapper">
						<table class="Table-left-wrapper">
							<tr><td class="Media">
								<div class="Media">
								<iframe width="560" height="315" src="http://www.youtube.com/embed/JIzw7BHmkN4" frameborder="0" allowfullscreen></iframe>
								<p>
									<label for="amount">Zooming amount (10 increments):</label>
								<input type="text" id="amount" style="border:0; color:#f6931f; font-weight:bold;" />
								</p>
								<div>
							</td></tr>
							<tr><td class="Thumbnail">
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
							</td></tr>
						</table>
					</td>
					<td id="descriptionTD" class="Right-Inner-Wrapper">
						<table class="Table-right-wrapper">
							<tr><td class="Description">
								<div class="Description">
									<p id="eow-description">Take A Chance On Me' Out 6.11.11. UK &amp; Ireland order from iTunes <a href="http://bit.ly/TACOMiTunes" target="_blank" title="http://bit.ly/TACOMiTunes" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://bit.ly/TACOMiTunes</a> Taken from the album 'Jukebox' out 14.11.11. UK &amp; Ireland order here <a href="http://amzn.to/TakeAChanceAMZ" target="_blank" title="http://amzn.to/TakeAChanceAMZ" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://amzn.to/TakeAChanceAMZ</a><br><br>Music video by JLS performing Take A Chance On Me. (C) 2011 Sony Music Entertainment UK Limited</p>
									<p id="eow-description">Take A Chance On Me' Out 6.11.11. UK &amp; Ireland order from iTunes <a href="http://bit.ly/TACOMiTunes" target="_blank" title="http://bit.ly/TACOMiTunes" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://bit.ly/TACOMiTunes</a> Taken from the album 'Jukebox' out 14.11.11. UK &amp; Ireland order here <a href="http://amzn.to/TakeAChanceAMZ" target="_blank" title="http://amzn.to/TakeAChanceAMZ" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://amzn.to/TakeAChanceAMZ</a><br><br>Music video by JLS performing Take A Chance On Me. (C) 2011 Sony Music Entertainment UK Limited</p>
									<p id="eow-description">Take A Chance On Me' Out 6.11.11. UK &amp; Ireland order from iTunes <a href="http://bit.ly/TACOMiTunes" target="_blank" title="http://bit.ly/TACOMiTunes" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://bit.ly/TACOMiTunes</a> Taken from the album 'Jukebox' out 14.11.11. UK &amp; Ireland order here <a href="http://amzn.to/TakeAChanceAMZ" target="_blank" title="http://amzn.to/TakeAChanceAMZ" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://amzn.to/TakeAChanceAMZ</a><br><br>Music video by JLS performing Take A Chance On Me. (C) 2011 Sony Music Entertainment UK Limited</p>
									<p id="eow-description">Take A Chance On Me' Out 6.11.11. UK &amp; Ireland order from iTunes <a href="http://bit.ly/TACOMiTunes" target="_blank" title="http://bit.ly/TACOMiTunes" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://bit.ly/TACOMiTunes</a> Taken from the album 'Jukebox' out 14.11.11. UK &amp; Ireland order here <a href="http://amzn.to/TakeAChanceAMZ" target="_blank" title="http://amzn.to/TakeAChanceAMZ" rel="nofollow" dir="ltr" class="yt-uix-redirect-link">http://amzn.to/TakeAChanceAMZ</a><br><br>Music video by JLS performing Take A Chance On Me. (C) 2011 Sony Music Entertainment UK Limited</p>
								</div>
							</td></tr>
						</table
					</td>
				</tr>
				<tr>
					<td colspan="2" class="Lower-Inner-Wrapper">
						<table class="Table-lower-wrapper">
							<tr>
								<td class="Zooming">
									<div class="Zooming-Icon">
										<img src="zoom.png"/>
									</div>
									<div class="Zooming-Slider"></div>
								</td>
								<td class="Control-button">
									<input type="button" id="groovybtn1" class="groovybutton1" value="Full Screen" title="" onMouseOver="goLite_groovy(this.id)" onMouseOut="goDim_groovy(this.id)" onClick="location.href='http://axon.cer.jhu.edu:8080/reveal-sandbox-jiefeng/XMLTester_jQuery_backbone.jsp'" value='click here to visit home page'>
									<input type="button" id="groovybtn2" class="groovybutton2" value="Current Item Info" title="" onMouseOver="goLite_groovy(this.id)" onMouseOut="goDim_groovy(this.id)">
									<input type="button" id="groovybtn3" class="groovybutton3" value="Edit Items" title="" onMouseOver="goLite_groovy(this.id)" onMouseOut="goDim_groovy(this.id)">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
</div>

</body>
</html>
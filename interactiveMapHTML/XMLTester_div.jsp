<%@ page session="true" %>
<%@ page isErrorPage="true" import="java.io.*" import="mapTool.InformationStore" import="mapTool.FlashResultSet" import="java.util.List" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<jsp:useBean id="treeMaker" scope="session" class="mapTool.Treemaker" />
<%
        String xml = treeMaker.getXML("127");
        String a = "\"";
        String x = (a.concat(xml)).concat(a);
%>

<jsp:useBean id="lookupSimpleQuery" scope="session" class="mapTool.LookupSimpleQuery" />
<%
	InformationStore info = new InformationStore();
	FlashResultSet frs = lookupSimpleQuery.runQueryType("getArtifactFromID", info);
	//List<Object> list = frs.getTableRows();
	//String result = "";
	//for(Object o: list)
	//	result += o.toString();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>

<title>XML Tree Loader</title>
<script type="text/javascript" src="./_lib/jquery.js"></script>
<script type="text/javascript" src="./jquery.jstree.js"></script>
<script type="text/javascript" src="dragresize.js"></script>

<style type="text/css">

/* Required CSS classes: must be included in all pages using this script */

/* Apply the element you want to drag/resize */
.drsElement {
 position: absolute;
 border: 1px solid #333;
}

/*
 The main mouse handle that moves the whole element.
 You can apply to the same tag as drsElement if you want.
*/
.drsMoveHandle {
 height: 20px;
 background-color: #CCC;
 border-bottom: 1px solid #666;
 cursor: move;
}

/*
 The DragResize object name is automatically applied to all generated
 corner resize handles, as well as one of the individual classes below.
*/
.dragresize {
 position: absolute;
 width: 5px;
 height: 5px;
 font-size: 1px;
 background: #EEE;
 border: 1px solid #333;
}

/*
 Individual corner classes - required for resize support.
 These are based on the object name plus the handle ID.
*/
.dragresize-tl {
 top: -8px;
 left: -8px;
 cursor: nw-resize;
}
.dragresize-tm {
 top: -8px;
 left: 50%;
 margin-left: -4px;
 cursor: n-resize;
}
.dragresize-tr {
 top: -8px;
 right: -8px;
 cursor: ne-resize;
}

.dragresize-ml {
 top: 50%;
 margin-top: -4px;
 left: -8px;
 cursor: w-resize;
}
.dragresize-mr {
 top: 50%;
 margin-top: -4px;
 right: -8px;
 cursor: e-resize;
}

.dragresize-bl {
 bottom: -8px;
 left: -8px;
 cursor: sw-resize;
}
.dragresize-bm {
 bottom: -8px;
 left: 50%;
 margin-left: -4px;
 cursor: s-resize;
}
.dragresize-br {
 bottom: -8px;
 right: -8px;
 cursor: se-resize;
}

</style>

<script type="text/javascript">
var attributes;
$(document).ready(function () {
	$("#tree").jstree( {"xml_data" : {"data" : '<%= xml %>'},"plugins" : [ "themes", "xml_data", "ui" ]} )
	.bind("select_node.jstree", function (event, data) {
		var pid = data.rslt.obj.attr("pid") != 0 ? data.rslt.obj.attr("pid") : "ROOT NODE";
      	attributes = "Parent ID: " + pid + "<br>" + "Data: " + data.rslt.obj.attr("id") + "<br>" + "IsMap: " + data.rslt.obj.attr("isaMap") + "<br>" + "LocationID: " + data.rslt.obj.attr("LocationID") + "<br>" + "CategoryID: " + data.rslt.obj.attr("CategoryID") + "<br>" + "LocationArchiveDependent: " + data.rslt.obj.attr("locationArchiveDependent") + "<br>" + "Artifact Depth: " + data.rslt.obj.attr("artifactDepth") + "<br>";
        $("#textArea").html(attributes);
        })});
        
var dragresize = new DragResize('dragresize', { minWidth: 100, minHeight: 200});

dragresize.isElement = function(elm)
{
 if (elm.className && elm.className.indexOf('drsElement') > -1) return true;
};
dragresize.isHandle = function(elm)
{
 if (elm.className && elm.className.indexOf('drsMoveHandle') > -1) return true;
};

dragresize.ondragfocus = function() { };
dragresize.ondragstart = function(isResize) { };
dragresize.ondragmove = function(isResize) { };
dragresize.ondragend = function(isResize) { };
dragresize.ondragblur = function() { };

dragresize.apply(document);

</script>
</head>
<body style="font: 13px/20px sans-serif; background-color: #FFF">

<div class="drsElement"
 style="left: 10px; top: 7px; width: 250px; height: 300px;
 background: #00CC99; text-align: center;">
 	<div class="resizeButton" style="float: left">x</div>
 	<div class="drsMoveHandle">Navigator Panel</div>
 	<div id="tree" style="clear: both; text-align: left; height: 100%; overflow: auto"></div>
</div>

<div class="drsElement"
 style="left: 10px; top: 315px; width: 250px; height: 300px;
 background: #00CC99; text-align: center;">
 <div class="drsMoveHandle">Artifact Panel</div>
 	<div id="textArea" style="text-align: left; height: 100%; overflow: auto"></div>
</div>

<div style="left: 300px; top: 7px; width: 500px; height: 500px; overflow: auto; border: 1px solid #333;"><%= x %></div>

</body>
</html>


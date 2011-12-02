<%@ page session="true" %>
<%@ page isErrorPage="true" import="java.io.*" import="mapTool.InformationStore" import="mapTool.FlashResultSet" import="java.util.List" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<jsp:useBean id="treeMaker" scope="session" class="mapTool.Treemaker" />
<%
        String xml = treeMaker.getXML("127");
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
<script type="text/javascript">
var attributes;
$(document).ready(function () {
	$("#tree").jstree( {"xml_data" : {"data" : '<%= xml %>'},"plugins" : [ "themes", "xml_data", "ui" ]} )
	.bind("select_node.jstree", function (event, data) {
		var pid = data.rslt.obj.attr("pid") != 0 ? data.rslt.obj.attr("pid") : "ROOT NODE";
      	top.artifact.attributes = "Parent ID: " + pid + "<br>" + "Data: " + data.rslt.obj.attr("id") + "<br>" + "IsMap: " + data.rslt.obj.attr("isaMap") + "<br>" + "LocationID: " + data.rslt.obj.attr("LocationID") + "<br>" + "CategoryID: " + data.rslt.obj.attr("CategoryID") + "<br>" + "LocationArchiveDependent: " + data.rslt.obj.attr("locationArchiveDependent") + "<br>" + "Artifact Depth: " + data.rslt.obj.attr("artifactDepth") + "<br>";
        top.artifact.repaint();
        })});
</script>
</head>
<body>
<div id="Navigator">
<h2>Navigator Panel</h2>
</div>
<div id="tree">
</div>
</body>
</html>


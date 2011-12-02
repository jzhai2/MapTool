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
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script type="text/javascript" src="./jquery.jstree.js"></script>
<script type="text/javascript" src="dragresize.js"></script>
<script type="text/javascript" src="http://ajax.cdnjs.com/ajax/libs/backbone.js/0.3.3/backbone-min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

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

</style>

<script type="text/javascript">
$(document).ready(function () {
	$("#tree").jstree( {
		
		"core" : {
			"load_open" : "true"
		},
		
		"json_data" : {
			"data" : [<%=js %>],
			"ajax" : {
				"url" : "jstreeServer.jsp",
				"data" : function(n) {
					return {
						"operation" : "get_children",
						"id" : n.attr ? n.attr("id") : 0 
					};
				}
			},
			"correct_state" : "true",
			"progressive_render" : "true",
			"progressive_unload" : "true"
		},
		
		"contextmenu" : {
			"show_at_node" : "true",
			"select_node" : "false",
			"items" : {
				"refresh" : {
					"label" : "Refresh",
					"action" : function (obj) { this.refresh(obj); },
					"_class" : "class", // class is applied to the item LI node
					"separator_before" : "true",
					"separator_after" : "true"
				},
				"whosyourdady" : {
					"label" : "Who is your dady?",
					"action" : function (obj) { alert("Jiefeng Zhai is your freaking dady!!"); }
				}
			}
		},
		
		// hotkeys plugin conflicted or it simply doesn't work
		"plugins" : [ "themes", "json_data", "ui", "crrm", "contextmenu" ]
	} ).bind("select_node.jstree", function (e, data) { 
		var attributes = "Artifact ID = " + data.rslt.obj.attr("id");
		$("#textArea").html(attributes);
	} ).bind("create.jstree", function(e, data) {
		$.post(
			"jstreeServer.jsp",
			{ "operation" : "create_node", "title" : data.rslt.name },
			function(r) {
				alert("New Node added: " + r.title);
			},
			"json"
		);
	} ).bind("remove.jstree", function(e, data) {
		data.rslt.obj.each(function () {
			$.ajax({
				async: false,
				type: "POST",
				dataType: "json",
				url: "jstreeServer.jsp",
				data: { "operation" : "remove_node", "a_id" : $(this).attr("id") },
				success: function(data, textStatus, jqXHR) {
					alert("Removed node " + data.a_id);
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert(textStatus + ": " + errorThrown);
					data.inst.refresh();
				}
			});
		});
	} ).bind("rename.jstree", function (e, data) {
		$.post(
				"jstreeServer.jsp",
				{ "operation" : "rename_node", "title" : data.rslt.new_name },
				function(r) {
					alert("New name: " + r.title);
				},
				"json"
		);
	} ).bind("move_node.jstree", function (e, data) {
		/*
        data.rslt contains: 
        .o - the node being moved 
        .r - the reference node in the move 
        .ot - the origin tree instance 
        .rt - the reference tree instance 
        .p - the position to move to (may be a string - "last", "first", etc) 
        .cp - the calculated position to move to (always a number) 
        .np - the new parent 
        .oc - the original node (if there was a copy) 
        .cy - boolen indicating if the move was a copy 
        .cr - same as np, but if a root node is created this is -1 
        .op - the former parent 
        .or - the node that was previously in the position of the moved node 
        */
		data.rslt.o.each(function (i) {
			$.ajax({
				async: false,
				type: "POST",
				dataType: "json",
				url: "jstreeServer.jsp",
				data: { 
					"operation" : "move_node",
					"id" : $(this).attr("id"),
					"original_parent" : data.rslt.op.attr("id"),
					"new_parent" : data.rslt.np.attr("id"),
					"isCopy" : this.cy
				},
				success: function(data, textStatus, jqXHR) {
					alert("Node " + data.id + " moved from " + data.op + " to " + data.np);
				},
				error : function(jqXHR, textStatus, errorThrown) {
					alert(textStatus + ": " + errorThrown);
					data.inst.refresh();
				}
			});
		});
	});
});

$(function() {
	$("#navigator_menu input").click(function() {
		switch(this.id) {
			case "create_node":
				$("#tree").jstree("create",null,"last",{"data":"New Artifact"});
				break;
			case "rename_node":
				$("#tree").jstree("rename",null);
				break;
			case "refresh_node":
				$("#tree").jstree("refresh",null);
				break;
			case "disable_resize_drag":
				$("#navigator").draggable("disable");
				$("#navigator").resizable("disable");
				break;
			case "enable_resize_drag":
				$("#navigator").draggable("enable");
				$("#navigator").resizable("enable");
				break;
		}
	});
});

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
 <div id="artifact_handler" class="drsMoveHandle">Artifact Panel</div>
 	<div style="width:100%">
 	<textarea id="textArea" rows="3" readonly="true" maxlength="1024" style="width:98%" placeholder="Description about this submap..."></textarea>
 	</div>
 	<div id="Media" style="width:100%"></div>
</div>

</body>
</html>
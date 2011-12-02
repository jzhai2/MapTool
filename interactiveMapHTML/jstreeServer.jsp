<%@ page session="true" %>
<%@ page isErrorPage="true" import="java.io.*" import="mapTool.InformationStore" import="org.json.*" import="java.util.*" import="java.sql.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page contentType="text/xml" %>
<jsp:useBean id="treeMaker" scope="session" class="mapTool.Treemaker" />
<%
	String operation = request.getParameter("operation");

	if (operation.compareTo("get_children") == 0) {
		String ArtifactID = request.getParameter("id");
		ResultSet rs = treeMaker.getChildRS(ArtifactID);
		JSONArray jArray = new JSONArray();
		while(rs.next()) {
			JSONObject obj = new JSONObject();
			JSONObject attr = new JSONObject();
			attr.put("id", rs.getInt(1));
			obj.put("data", rs.getString(2).replace("%20"," "));
			obj.put("attr",attr);
			if (treeMaker.hasChild( Integer.toString(rs.getInt(1)) ) > 0) {
				obj.put("state","closed");
			}
			jArray.put(obj);
		}
		out.print(jArray);
		
	} else if (operation.compareTo("create_node") == 0) {
		String title = request.getParameter("title");
		JSONObject obj = new JSONObject();
		obj.put("title",title);
		out.print(obj);
	} else if (operation.compareTo("remove_node") == 0) {
		String ID = request.getParameter("a_id");
		JSONObject obj = new JSONObject();
		obj.put("a_id",ID);
		out.print(obj);
	} else if (operation.compareTo("rename_node") == 0) {
		String title = request.getParameter("title");
		JSONObject obj = new JSONObject();
		obj.put("title",title);
		out.print(obj);
	} else if (operation.compareTo("move_node") == 0) {
		String op = request.getParameter("original_parent");
		String np = request.getParameter("new_parent");
		String id = request.getParameter("id");
		JSONObject obj = new JSONObject();
		obj.put("id",id);
		obj.put("op",op);
		obj.put("np",np);
		out.print(obj);
	}
%>

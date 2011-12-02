(function($) {
	var ListView = Backbone.View.extend({

		el : $("#tree"),

		initialize : function() {
			_.bindAll(this, 'render');
			this.render();
		},

		render : function() {
			$(this.el).jstree({

				"core" : {
					"load_open" : "true"
				},

				"json_data" : {
					"data" : [ {
						"attr" : {
							"id" : "3629"
						},
						"data" : "Main Map",
						"state" : "closed"
					} ],
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
		}
	});

	var listView = new ListView();
})(jQuery);
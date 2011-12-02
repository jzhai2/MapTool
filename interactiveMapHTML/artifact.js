(function($) {
	var ListView = Backbone.View.extend({

		el : $("#tree"),

		initialize : function() {
			_.bindAll(this, 'render');
			this.render();
		},

		render : function() {
			
		}
	});

	var listView = new ListView();
})(jQuery);
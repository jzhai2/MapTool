/*

Separator v1.0
(c) 2011-2012 Jiefeng Zhai, Johns Hopkins University Center For Educational Resources

Licensed under the CC-GNU LGPL, version 2.1 or later:
http://creativecommons.org/licenses/LGPL/2.1/
This is distributed WITHOUT ANY WARRANTY; without even the implied
warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Documentation:
	constructor: var <SEPARATOR_VARIABLE> = new Separator('<SEPARATOR_NAME>', {<CONFIGURATION>});
				 {<CONFIGURATION>} is {<PROPERTY_NAME> : <PROPERTY_VALUE>, ...}
				 <PROPERTY_NAME> are
				 		margin: the minimal pixel size of the upper and lower div (px)
				 		enabled: indicate if this separator enabled (TRUE or FALSE)
				 		Logdiv: the name of div that show the info of upper and lower div height
				 		Updiv: the name of upper div
				 		Downdiv: the name of lower div
				 		showAlert: indicate if it show alert when separator is toggled and moved (TRUE or FALSE)
				 <SEPARATOR_VARIABLE>.addHandler(<SEPARATOR_DIV>);
				 		set up the separator div, <SEPARTOR_DIV> is a document node of the div
				 		
				 The upper and lower div's CSS height can be either percentage or absolute pixel.
				 However, the parent/container div can only be calculated in absolute pixel if upper and lower
				 div are calculated in percentage.
				 		
	example:
			var sp = new Separator('sup', {enable: true, Logdiv: "log", Updiv: "test1", Downdiv: "test2", margin: 40});
			sp.addHandler(document.getElementById("sep"));
 */

function Separator(myName, config) {
	var props = {
		myName : myName,
		margin : 0,
		enabled : true,
		showAlert : false,
		isMouseDown : false,
		lastMouseX : 0,
		lastMouseY : 0,
		MouseX : 0,
		MouseY : 0,
		Logdiv : "",
		Updiv : "",
		Downdiv : ""
	};

	for ( var p in props)
		this[p] = (typeof config[p] == 'undefined') ? props[p] : config[p];
};

Separator.prototype.addHandler = function(node) {
	var obj = this;
	node.addEventListener('mousedown', function(e) {
		obj.mouseDown(e);
	}, false);
	document.addEventListener('mousemove', function(e) {
		obj.mouseMove(e);
	}, false);
	document.addEventListener('mouseup', function(e) {
		obj.mouseUp(e);
	}, false);
	node.addEventListener('mouseover', function(e) {
		node.style.cursor = 'n-resize';
	}, false);
	node.addEventListener('mouseout', function(e) {
		node.style.cursor = 'default';
	}, false);
};

Separator.prototype.upperBound = function(name) {
	with (this) {
		Updiv = name;
	}
};

Separator.prototype.lowerBound = function(name) {
	with (this) {
		Downdiv = name;
	}
};

Separator.prototype.logging = function(name) {
	with (this) {
		Logdiv = name;
	}
};

Separator.prototype.mouseDown = function(e) {
	with (this) {
		isMouseDown = true;
		lastMouseX = e.pageX || e.clientX + document.documentElement.scrollLeft;
		lastMouseY = e.pageY || e.clientY + document.documentElement.scrollTop;
		e.target.style.cursor = 'n-resize';
	}
};

Separator.prototype.mouseMove = function(e) {
	with (this) {
		if (isMouseDown && Updiv.length != 0 && Downdiv.length != 0) {
			MouseX = e.pageX || e.clientX + document.documentElement.scrollLeft;
			MouseY = e.pageY || e.clientY + document.documentElement.scrollTop;
			var diffx = MouseX - lastMouseX;
			var diffy = MouseY - lastMouseY;
			lastMouseX = e.pageX || e.clientX
					+ document.documentElement.scrollLeft;
			lastMouseY = e.pageY || e.clientY
					+ document.documentElement.scrollTop;

			if (document.getElementById(Updiv).style.height.search("px") != -1
					&& document.getElementById(Downdiv).style.height
							.search("px") != -1
					&& parseInt(document.getElementById(Updiv).style.height) > (margin - diffy)
					&& parseInt(document.getElementById(Downdiv).style.height) > (diffy + margin)) {
				// height is calculated as absolute pixel
				document.getElementById(Updiv).style.height = parseInt(document
						.getElementById(Updiv).style.height)
						+ diffy + "px";
				document.getElementById(Downdiv).style.height = parseInt(document
						.getElementById(Downdiv).style.height)
						- diffy + "px";
				// log
				if (Logdiv.length != 0) {
					document.getElementById(Logdiv).innerHTML = "Log:";
					document.getElementById(Logdiv).innerHTML += "<br />"
							+ "upper div height = "
							+ document.getElementById(Updiv).style.height;
					document.getElementById(Logdiv).innerHTML += "<br />"
							+ "down div height = "
							+ document.getElementById(Downdiv).style.height;
					document.getElementById(Logdiv).innerHTML += "<br />"
						+ "parentHeight = " + parseInt(e.target.parentNode.style.height);
				}
			} else if (document.getElementById(Updiv).style.height.search("%") != -1
					&& document.getElementById(Downdiv).style.height
							.search("%") != -1) {
				var parentHeight = parseInt(e.target.parentNode.style.height);
				if (parseFloat(document.getElementById(Updiv).style.height)
						* 0.01 * parentHeight > (margin - diffy)
						&& parseFloat(document.getElementById(Downdiv).style.height)
								* 0.01 * parentHeight > (diffy + margin)) {
					document.getElementById(Downdiv).style.height = parseFloat(document
							.getElementById(Downdiv).style.height) - (diffy / parentHeight) * 100 + "%";
					document.getElementById(Updiv).style.height = parseFloat(document
							.getElementById(Updiv).style.height) + (diffy / parentHeight) * 100 + "%";
					
					// log
					if (Logdiv.length != 0) {
						document.getElementById(Logdiv).innerHTML = "Log:";
						document.getElementById(Logdiv).innerHTML += "<br />"
								+ "upper div height = "
								+ parseFloat(document.getElementById(Updiv).style.height) + "%";
						document.getElementById(Logdiv).innerHTML += "<br />"
								+ "down div height = "
								+ parseFloat(document.getElementById(Downdiv).style.height) + "%";
						document.getElementById(Logdiv).innerHTML += "<br />"
								+ "parentHeight = " + parentHeight;
					}
				}
			}
		} // end if
	}
};

Separator.prototype.mouseUp = function(e) {
	with (this) {
		if (isMouseDown == true) {
			isMouseDown = false;
			e.target.style.cursor = 'default';
			if (showAlert) {
				alert("x = " + diffx + " y = " + diffy);
			}
		} // end if
	}
};
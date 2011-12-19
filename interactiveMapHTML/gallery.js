/*

Gallery v1.0

Gallery is the maximized Artifact panel

*/



function theaterOn() {
	var stagepage = document.createElement('div');
	stagepage.setAttribute('id', "stagePage");
	stagepage.setAttribute('class', "snowbox");
	stagepage.innerHTML = '<iframe width="560" height="345" src="http://www.youtube.com/embed/a2RA0vsZXf8" frameborder="0" allowfullscreen></iframe>';
	
	var globalDiv = document.createElement('div');
	globalDiv.setAttribute('id', "globalDiv");
	globalDiv.setAttribute('class', "theaterMode");
	
	document.body.appendChild(globalDiv);
	document.getElementById("globalDiv").appendChild(stagepage);
}

function theaterClose() {
	
}
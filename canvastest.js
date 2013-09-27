$(document).ready(function() {

	var stage = new Kinetic.Stage({
		container : 'container',
		width : 600,
		height : 400
	});

	var layer = new Kinetic.Layer();

	var rectangle = new Kinetic.Rect({
		x : 0,
		y : 0,
		width : stage.getWidth(),
		height : stage.getHeight(),
		fill : 'lightgrey',
		stroke : 'grey',
		strokeWidth : 2
	});

	// add the shape to the layer
	layer.add(rectangle);
	// add the layer to the stage
	stage.add(layer);

	// JSON enters from Haskell side
	var eventFromServer = {
		"command" : "line",
		"start" : [30, 300],
		"end" : [250, 30]
	};

	var newLayer = new Kinetic.Layer();

	switch (eventFromServer.command) {
		case "line":
			drawLine(eventFromServer.start, eventFromServer.end);
			break;
		default:
			window.alert("test default");
	}
	
	var line;
	function drawLine(begin, end) {
		line = new Kinetic.Line({
			points : [begin, end],
			stroke : "blue",
			strokeWidth : 1
		});
		newLayer.add(line);
		stage.add(newLayer);
	}

	stage.on('mouseover', function() {
		line.setStroke("red");
		newLayer.draw();
	});
	
	stage.on('mouseout', function() {
		line.setStroke("blue");
		newLayer.draw();
	});

});

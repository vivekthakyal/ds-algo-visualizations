var COLOR = {
	RED: 0,
	BLACK: 1
};

function init() {
	var input = generateRandomArray(64, 0, 100);
	var tree = new Tree();
	for(var i = 0; i < input.length; i++) {
		tree.insert(input[i], input[i]);
	}

	var canvasFg = document.getElementById('layerFg');
	var canvasBg = document.getElementById('layerBg');

	canvasFg.width = canvasBg.width = canvasFg.offsetWidth;
	canvasFg.height = canvasBg.height = canvasFg.offsetHeight;

	if (canvasFg.getContext) {
		var ctxFg = canvasFg.getContext('2d');
		var ctxBg = canvasBg.getContext('2d');

		ctxFg.fillStyle = 'rgb(255, 214, 108)';
		tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height);
	}
}

function generateRandomArray(size, lo, hi) {
	var arr = [];
	for (var i = 0; i < size; i++) {
		arr.push((Math.floor(Math.random() * (hi - lo + 1)) + lo));
	}
	return arr;
}

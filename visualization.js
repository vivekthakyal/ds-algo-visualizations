var SIZE_WEIGHTED = true;

function init() {
    var canvasFg = document.getElementById('layerFg');
    var canvasBg = document.getElementById('layerBg');

    canvasFg.width = canvasBg.width = canvasFg.offsetWidth;
    canvasFg.height = canvasBg.height = canvasFg.offsetHeight;

    if (canvasFg.getContext) {
        var ctxFg = canvasFg.getContext('2d');
        var ctxBg = canvasBg.getContext('2d');

        ctxFg.lineWidth = 1.5;
        ctxBg.lineWidth = 1.5;
        var tree = generateBST();
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    }

    document.getElementById('reset').onclick = function() {
        ctxFg.clearRect(0, 0, canvasFg.width, canvasFg.height);
        ctxBg.clearRect(0, 0, canvasBg.width, canvasBg.height);
        tree = generateBST();
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    };

    document.getElementById('toggleWeighted').onclick = function() {
        SIZE_WEIGHTED = !SIZE_WEIGHTED;
        ctxFg.clearRect(0, 0, canvasFg.width, canvasFg.height);
        ctxBg.clearRect(0, 0, canvasBg.width, canvasBg.height);
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    };
}

function generateBST() {
    var input = generateRandomArray(64, 0, 150);
    var tree = new vktl.rbt.RedBlackTree();
    for(var i = 0; i < input.length; i++) {
        tree.insert(input[i], input[i]);
    }
    return tree;
}

function generateRandomArray(size, lo, hi) {
    var arr = [];
    for (var i = 0; i < size; i++) {
        arr.push((Math.floor(Math.random() * (hi - lo + 1)) + lo));
    }
    return arr;
}

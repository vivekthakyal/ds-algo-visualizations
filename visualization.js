var SIZE_WEIGHTED = true;

$(document).ready(function() {
    var canvasFg = document.getElementById('layerFg');
    var canvasBg = document.getElementById('layerBg');

    canvasFg.width = canvasBg.width = canvasFg.offsetWidth;
    canvasFg.height = canvasBg.height = canvasFg.offsetHeight;

    var tree = generateBST();

    if (canvasFg.getContext) {
        var ctxFg = canvasFg.getContext('2d');
        var ctxBg = canvasBg.getContext('2d');

        ctxFg.lineWidth = 1.5;
        ctxBg.lineWidth = 1.5;
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    }

    $('#treeKeysWrapper').hide();

    $('#treeKeys').keyup(function(event) {
        var keys = $(this).val().split(' ');

        tree = new vktl.rbt.RedBlackTree();
        for (var i = 0; i < keys.length; i++) {
            if (keys[i] !== null & keys[i].length > 0) {
                tree.insert(parseInt(keys[i], 10), parseInt(keys[i], 10));
            }
        }
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    });

    $('#manualInput').click(function() {
        $('#treeKeysWrapper').slideDown();
        $('#treeKeys').val('').focus();
        tree = new vktl.rbt.RedBlackTree();
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    });

    $('#reset').click(function() {
        tree = generateBST();
        tree.draw(ctxFg, ctxBg, canvasFg.width, canvasFg.height, SIZE_WEIGHTED);
    });
});

function generateBST() {
    var input = generateRandomArray(48, 0, 150);
    var tree = new vktl.rbt.RedBlackTree();
    var text = '';
    for(var i = 0; i < input.length; i++) {
        text += input[i] + ' ';
        tree.insert(input[i], input[i]);
    }
    $('#treeKeys').val(text);

    return tree;
}

function generateRandomArray(size, lo, hi) {
    var arr = [];
    for (var i = 0; i < size; i++) {
        arr.push((Math.floor(Math.random() * (hi - lo + 1)) + lo));
    }
    return arr;
}

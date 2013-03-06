/**
 * Creates a tree node
 *
 * key - the key
 * value - the value associated with the key
 */
function Node(key, value) {
	this.key_ = key;
	this.value_ = value;
	this.left_ = null;
	this.right_ = null;

	this.size_ = 1;
	this.height_ = 0;
}

/**
 * Creates a binary search tree object with a null root
 */
function BinarySearchTree() {
	this.root_ = null;
}

/**
 * Inserts a key with its corresponding value into the BST. Updates the value
 * associated with key if the key is already present in the BST.
 *
 * key - the key
 * value - the value associated with the key
 */
BinarySearchTree.prototype.insert = function(key, value) {
	this.root_ = insertImpl_(this.root_, key, value);
};

BinarySearchTree.prototype.remove = function(key, value) {
	// TODO Hibbard deletion
};

/**
 * Returns true if the key is present in the BST, false otherwise
 *
 * key - the key to search in the BST
 */
BinarySearchTree.prototype.containsKey = function(key) {
	var curr = this.root_;

	while (curr !== null) {
		if ( key < curr.key_) {
			curr = curr.left_;
		} else if (key > curr.key_) {
			curr = curr.right_;
		} else {
			return true;
		}
	}
	return false;
};

/**
 * Returns the height of the BST
 */
BinarySearchTree.prototype.height_ = function () {
	return heightImpl_(this.root_);
};

/**
 * Draws the BST on a canvas
 *
 * ctxFg - canvas 2d context for the foreground where the nodes are drawn
 * ctxBg - canvas 2d context for the backaground where the tree edges are drawn
 * width - width of the canvas
 * height - height of the canvas
 */
BinarySearchTree.prototype.draw = function (ctxFg, ctxBg, width, height, spreadNodes) {
	var minX = width * 0.05;
	var maxX = width - minX;
	var minY = height * 0.05;
	var maxY = height - minY;

	ctxBg.beginPath();
	drawImpl_(ctxFg, ctxBg, this.root_, minX, maxX, minY, (maxY - minY)/this.height_(), spreadNodes);
	ctxBg.stroke();
	ctxBg.closePath();
};

function drawImpl_(ctxFg, ctxBg, node, xMin, xMax, y, yIncr, spreadNodes) {
	var xSplit = xMin + (xMax - xMin) * (spreadNodes ? sizeWeightedRatio_(node) : 0.5);
	var x = (xMax + xMin) / 2;
	ctxFg.beginPath();
	ctxFg.fillStyle = '#306BA2';
	ctxFg.arc(x, y, 10, 0, Math.PI * 2, true);
	ctxFg.fill();
	ctxFg.stroke();
	ctxFg.fillStyle = '#FFFFFF';
	ctxFg.font = 'bold 12px serif';

	// the numbers used for positioning the text are a result of guided hit and trial.
	// I need a better way to auto calculate the position based on the font-family and
	// font-size
	ctxFg.fillText(node.key_, x - node.key_.toString().length * 6/2, y + 9/2);
	ctxFg.closePath();

	ctxBg.lineTo(x, y);

	if (node.left_ !== null) {
		ctxBg.moveTo(x, y);
		drawImpl_(ctxFg, ctxBg, node.left_, xMin, xSplit, y + yIncr, yIncr, spreadNodes);
	}

	if (node.right_ !== null) {
		ctxBg.moveTo(x, y);
		drawImpl_(ctxFg, ctxBg, node.right_, xSplit, xMax, y + yIncr, yIncr, spreadNodes);
	}
}

function sizeWeightedRatio_(node) {
	if (nodeSize_(node.left_) == nodeSize_(node.right_)) {
		return 0.5;
	}

	// return a non-zero ratio if the left child is null, otherwise subsequent nodes
	// with a null left child will get rendered right on the left bound all one directly
	// under the other vertically
	var alpha = 0.2; return node.left_ === null ? alpha : (nodeSize_(node.left_) / nodeSize_(node));
}

function insertImpl_(node, key, value) {
	if (node === null) {
		node = new Node(key, value);
		return node;
	}

	if (key < node.key_) {
		node.left_ = insertImpl_(node.left_, key, value);
	} else if (key > node.key_) {
		node.right_ = insertImpl_(node.right_, key, value);
	} else {
		node.value_ = value;
	}

	node.size_ = nodeSize_(node.left_) + nodeSize_(node.right_) + 1;
	node.height_ = Math.max(nodeHeight_(node.left_), nodeHeight_(node.right_)) + 1;

	return node;
}


function heightImpl_(node) {
	if (node === null) return 0;
	return Math.max(heightImpl_(node.left_), heightImpl_(node.right_)) + 1;
}

function nodeSize_(node) {
	return node === null ? 0 : node.size_;
}

function nodeHeight_(node) {
	return node === null ? 0 : node.height_;
}
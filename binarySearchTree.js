function Node(key, value) {
	this.key_ = key;
	this.value_ = value;
	this.left_ = null;
	this.right_ = null;
	this.color_ = COLOR.RED;
}

function Tree() {
	this.root_ = null;
}

Tree.prototype.insert = function(key, value) {
	this.root_ = insertImpl_(this.root_, key, value);
};

Tree.prototype.remove = function(key, value) {

};

Tree.prototype.containsKey = function(key) {
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

Tree.prototype.draw = function (ctxFg, ctxBg, width, height) {
	var minX = 5;
	var maxX = width - 5;
	var minY = 5;
	var maxY = height - 5;

	drawImpl_(ctxFg, ctxBg, this.root_, (maxX - minX)/2, minY, (maxY - minY)/this.height_(), maxX - minX);
};

Tree.prototype.height_ = function () {
	return heightImpl_(this.root_);
};

function drawImpl_(ctxFg, ctxBg, node, x, y, yIncr, width) {
	ctxFg.beginPath();
	ctxFg.arc(x, y, 4, 0, Math.PI * 2, true);
	ctxFg.fill();
	ctxFg.closePath();

	if (node.left_ !== null) {
		ctxBg.beginPath();
		ctxBg.moveTo(x, y);
		ctxBg.lineTo(x - width/4, y + yIncr);
		ctxBg.stroke();
		ctxBg.closePath();
		drawImpl_(ctxFg, ctxBg, node.left_, x - width/4, y + yIncr, yIncr, width/2);
	}

	if (node.right_ !== null) {
		ctxBg.beginPath();
		ctxBg.moveTo(x, y);
		ctxBg.lineTo(x + width/4, y + yIncr);
		ctxBg.stroke();
		ctxBg.closePath();
		drawImpl_(ctxFg, ctxBg, node.right_, x + width/4, y + yIncr, yIncr, width/2);
	}
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
	return node;
}

function heightImpl_(node) {
	if (node === null) return 0;
	return Math.max(heightImpl_(node.left_), heightImpl_(node.right_)) + 1;
}
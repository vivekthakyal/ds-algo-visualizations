var vktl = vktl || {};
vktl.rbt = {
    RED : 0,
    BLACK : 1,
    /**
     * Creates a tree node
     *
     * @param key - the key
     * @param value - the value associated with the key
     */
    Node : function(key, value) {
        this.key_ = key;
        this.value_ = value;
        this.left_ = null;
        this.right_ = null;
        this.color_ = vktl.rbt.RED;

        this.size_ = 1;
    },

    /**
     * Creates a left leaning red black tree object with a null root
     */
    RedBlackTree : function() {
        this.root_ = null;
    }
};

/**
 * Inserts a key, value pair into the tree. If the key already exist in the
 * tree then the value corresponding to the key is updated.
 *
 * @param key - the key
 * @param value - the value associated with the key
 */
vktl.rbt.RedBlackTree.prototype.insert = function (key, value) {
    this.root_ = this.insertImpl_(this.root_, key, value);
    this.root_.color_ = vktl.rbt.BLACK;
};

/**
 * Retrieves the value associated with the passed key
 *
 * @param key - the key to fetch the value for
 * @returns - the value associated with the passed key if the key exists in
 * the tree, null otherwise
 */
vktl.rbt.RedBlackTree.prototype.getValue = function(key) {
    var node = this.root_;
    while(node !== null) {
        if (key === node.key_) {
            return node.value_;
        } else if (key < node.key_) {
            node = node.left_;
        } else {
            node = node.right_;
        }
    }
    return null;
};

vktl.rbt.RedBlackTree.prototype.remove = function(key) {
    // TODO top down 2-3-4 deletion
};

vktl.rbt.RedBlackTree.prototype.containsKey = function(key) {
    var node = this.root_;
    while (node !== null) {
        if (node.key_ === key) {
            return true;
        } else if (key < node.key_) {
            node = node.left_;
        } else {
            node = node.right_;
        }
    }
    return false;
};

vktl.rbt.RedBlackTree.prototype.insertImpl_ = function(node, key, value) {
    if (node === null) {
        return new vktl.rbt.Node(key, value);
    }

    if (key === node.key_) {
        node.value_ = value;
    } else if (key < node.key_) {
        node.left_ = this.insertImpl_(node.left_, key, value);
    } else if (key > node.key_) {
        node.right_ = this.insertImpl_(node.right_, key, value);
    }

    if (this.isRed_(node.right_) && !this.isRed_(node.left_)) {
        node = this.rotateLeft_(node);
    }
    if (this.isRed_(node.left_) && this.isRed_(node.left_.left_)) {
        node = this.rotateRight_(node);
    }
    if (this.isRed_(node.left_) && this.isRed_(node.right_)) {
        this.flipColors_(node);
    }
    node.size_ = this.sizeImpl_(node.left_) + this.sizeImpl_(node.right_) + 1;
    return node;
};

vktl.rbt.RedBlackTree.prototype.rotateLeft_ = function(node) {
    var x = node.right_;
    node.right_ = x.left_;
    x.left_ = node;
    x.color_ = node.color_;
    node.color_ = vktl.rbt.RED;
    x.size_ = node.size_;

    node.size_ = this.sizeImpl_(node.left_) + this.sizeImpl_(node.right_) + 1;
    return x;
};

vktl.rbt.RedBlackTree.prototype.rotateRight_ = function(node) {
    var x = node.left_;
    node.left_ = x.right_;
    x.right_ = node;
    x.color_ = node.color_;
    node.color_= vktl.rbt.RED;
    x.size_ = node.size_;

    node.size_ = this.sizeImpl_(node.left_) + this.sizeImpl_(node.right_) + 1;
    return x;
};

vktl.rbt.RedBlackTree.prototype.flipColors_ = function(node) {
    node.left_.color_ = vktl.rbt.BLACK;
    node.right_.color_ = vktl.rbt.BLACK;
    node.color_ = vktl.rbt.RED;
};

vktl.rbt.RedBlackTree.prototype.sizeImpl_ = function(node) {
    return node === null ? 0 : node.size_;
};

vktl.rbt.RedBlackTree.prototype.height_ = function() {
    return this.heightImpl_(this.root_);
};

vktl.rbt.RedBlackTree.prototype.heightImpl_ = function (node) {
    if (node === null || (node.left_ === null && node.right_ === null)) return 0;
    return Math.max(this.heightImpl_(node.left_), this.heightImpl_(node.right_)) + 1;
};

vktl.rbt.RedBlackTree.prototype.blackHeight_ = function() {
    return this.blackHeightImpl_(this.root_);
};

vktl.rbt.RedBlackTree.prototype.blackHeightImpl_ = function(node) {
    if (node === null || (node.left_ === null && node.right_ === null)) return 0;
    return Math.max(this.blackHeightImpl_(node.left_),this.blackHeightImpl_(node.right_)) + (this.isRed_(node) ? 0 : 1);
};

vktl.rbt.RedBlackTree.prototype.isRed_ = function (node) {
    return node === null ? false : vktl.rbt.RED === node.color_;
};

/**
 * Draws the bst on a canvas
 *
 * ctxFg - canvas 2d context for the foreground where the nodes are drawn
 * ctxBg - canvas 2d context for the backaground where the tree edges are drawn
 * width - width of the canvas
 * height - height of the canvas
 */
vktl.rbt.RedBlackTree.prototype.draw = function (ctxFg, ctxBg, width, height, spreadNodes) {
    var minX = width * 0.05;
    var maxX = width - minX;
    var minY = height * 0.05;
    var maxY = height - minY;

    ctxFg.clearRect(0, 0, width, height);
    ctxBg.clearRect(0, 0, width, height);

    ctxBg.beginPath();
    this.drawImpl_(ctxFg, ctxBg, this.root_, minX, maxX, minY, (maxY - minY)/this.height_(), spreadNodes);
    ctxBg.closePath();
};

vktl.rbt.RedBlackTree.prototype.drawImpl_ = function(ctxFg, ctxBg, node, xMin, xMax, y, yIncr, spreadNodes) {
    if (node === null) return;

    var xSplit = xMin + (xMax - xMin) * (spreadNodes ? this.sizeWeightedRatio_(node) : 0.5);
    var x = (xMax + xMin) / 2;
    ctxFg.beginPath();
    ctxFg.fillStyle = '#FFFFFF';
    ctxFg.strokeStyle = this.isRed_(node) ? '#E02D00' : '#000000';
    ctxFg.arc(x, y, 11, 0, Math.PI * 2, true);
    ctxFg.fill();
    ctxFg.stroke();
    ctxFg.fillStyle = '#000000';
    ctxFg.font = 'bold 11px sans-serif';

    // the numbers used for positioning the text are a result of guided hit and trial.
    // I need a better way to auto calculate the position based on the font-family and
    // font-size
    ctxFg.fillText(node.key_, x - node.key_.toString().length * 6/2, y + 9/2);
    ctxFg.closePath();

    ctxBg.strokeStyle = this.isRed_(node) ? '#E02D00' : '#000000';
    ctxBg.lineWidth = this.isRed_(node) ? 3 : 1.5;
    ctxBg.lineTo(x, y);
    ctxBg.stroke();
    ctxBg.closePath();

    if (node.left_ !== null) {
        ctxBg.beginPath();
        ctxBg.moveTo(x, y);
        this.drawImpl_(ctxFg, ctxBg, node.left_, xMin, xSplit, y + yIncr, yIncr, spreadNodes);
    }

    if (node.right_ !== null) {
        ctxBg.beginPath();
        ctxBg.moveTo(x, y);
        this.drawImpl_(ctxFg, ctxBg, node.right_, xSplit, xMax, y + yIncr, yIncr, spreadNodes);
    }
};

vktl.rbt.RedBlackTree.prototype.sizeWeightedRatio_ = function(node) {
    if (this.sizeImpl_(node.left_) == this.sizeImpl_(node.right_)) {
        return 0.5;
    }

    // return a non-zero ratio if the left child is null, otherwise subsequent nodes
    // with a null left child will get rendered right on the left bound all one directly
    // under the other vertically
    var alpha = 0.2; return node.left_ === null ? alpha : (this.sizeImpl_(node.left_) / this.sizeImpl_(node));
};

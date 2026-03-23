extends Resource
class_name item_slot

@export var id : int
@export var type : box_variants
var current_item: Node2D

enum box_variants {
	item,
	sell,
	delete
}

func box_variants_name():
	var name : String
	match type:
		0:
			name = "item"
		1:
			name = "sell"
		2:
			name = "delete"
		_:
			name = "err"
	return name

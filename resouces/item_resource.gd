extends Resource
class_name fish_item

@export var weight : float
@export var species : type_of_fish
var default_pos : Vector2
var current_slot_id = -1

enum type_of_fish {
	tuna,
	salmon,
	swordfish
}

func name_of_type_of_fish():
	var name: String
	match species:
		0:
			name = "Tuna"
		1:
			name = "Salmon"
		2:
			name = "Swordfish"
		_:
			name = "err"
	return name

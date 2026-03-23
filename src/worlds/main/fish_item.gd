extends Node2D

var is_selected = false # is mouse hovering over it

@onready var type_of_fish_lab: Label = $type_of_fish
@onready var weight_lab: Label = $weight
@onready var area_2d: Area2D = $Area2D

@export var fish_stats : Resource

var fish_name = "e" # Idk, can probably just delete

var is_mouse_left = false # true --> picked up item; false --> placed it down

func _ready() -> void:
	#fish_stats.default_pos = position
	type_of_fish_lab.text = fish_stats.name_of_type_of_fish()
	weight_lab.text = "Weight: " + str("%0.2f" %fish_stats.weight) + "lb"
	
func area_scan(): # I don't think I used this
	var areas = area_2d.get_overlapping_areas()
	for area in areas:
		if !area.is_in_group("item"):
			return area

var a = false
func _process(delta: float) -> void:
#	if Global.mouse_is_holding_this_item != self:
#w		fish_stats.default_pos = global_position
	#print(fish_stats.current_slot_id)
	if Input.is_action_just_pressed("mouse_left") and is_selected:
		is_mouse_left = !is_mouse_left
		
	if !is_mouse_left:
		z_index = 0
		area_2d.priority = 0
		area_2d.collision_layer = 1
		if !is_area_touching_fish and a:
			global_position = fish_stats.default_pos
			a = false
		if Global.mouse_is_holding_this_item == self:
			Global.mouse_is_holding_this_item = null
			#print("--" + str(Global.mouse_is_holding_this_item))
		
	if is_mouse_left:
		a = true
		area_2d.collision_layer = 2
		Global.mouse_is_holding_this_item = self
		#print("--" + str(Global.mouse_is_holding_this_item))
		global_position = get_global_mouse_position()
		z_index = 1
		area_2d.priority = 1
		type_of_fish_lab.visible = false
		weight_lab.visible = false
		#print(Global.mouse_is_holding_this_item)
		
	elif is_selected: # shows cool item descripiton
		type_of_fish_lab.visible = true
		weight_lab.visible = true
		type_of_fish_lab.position = get_local_mouse_position() + Vector2(12, 2)
		weight_lab.position = get_local_mouse_position() + Vector2(12, 33)


func _on_area_2d_mouse_entered() -> void:
	is_selected = true


func _on_area_2d_mouse_exited() -> void:
	type_of_fish_lab.visible = false
	weight_lab.visible = false
	if !is_mouse_left:
		is_selected = false

var is_area_touching_fish = false
var is_area_touching_item_slot = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	is_area_touching_item_slot = true
	if area.is_in_group("item"):
		is_area_touching_fish = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	is_area_touching_item_slot = false
	if area.is_in_group("item"):
		is_area_touching_fish = false

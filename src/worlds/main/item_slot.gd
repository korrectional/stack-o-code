extends Panel

var is_selected = false
var has_item = false

# colors for item slot
var default_color = Color(1, 1, 1)
var selected_color = Color(1, 1, 0)

# colors for delete slot
var default_color_del = Color(1, 0.1, 0.2)
var selected_color_del = Color(1, 1, 0)

@export var item_slot_res: Resource

func _process(delta: float) -> void:
	get_parent().get_parent().rotation = 0
	#print(item_slot_res.current_item)
	if is_selected:
		self_modulate = selected_color
	else:
		if item_slot_res.box_variants_name() == "delete":
			self_modulate = default_color_del
		else:
			self_modulate = default_color
		
	# code for item slot
	if item_slot_res.box_variants_name() != "delete":
		if has_item and Input.is_action_just_pressed("mouse_left") and is_selected:	
			if Global.mouse_is_holding_this_item != null:
				item = Global.mouse_is_holding_this_item
				#item.position = position + Vector2(26, 26)
				item_slot_res.current_item = item
				item_slot_res.current_item.fish_stats.current_slot_id = item_slot_res.id
				item_slot_res.current_item.fish_stats.default_pos = global_position + Vector2(26, 26)
				has_item = true
				print(str(item_slot_res.current_item.fish_stats.weight) + str(item_slot_res.id))
				
			if item_slot_res.current_item.fish_stats.current_slot_id != item_slot_res.id:
				item_slot_res.current_item = null
				has_item = false
				print(str(item_slot_res.current_item) + str(item_slot_res.id))
		
		elif is_selected and Input.is_action_just_pressed("mouse_left") and is_the_item_touching_inventory and !has_item:
			item = Global.mouse_is_holding_this_item
			#item.position = position + Vector2(26, 26)
			item_slot_res.current_item = item
			item_slot_res.current_item.fish_stats.current_slot_id = item_slot_res.id
			item_slot_res.current_item.fish_stats.default_pos = global_position + Vector2(26, 26)
			has_item = true
			print(str(item_slot_res.current_item.fish_stats.weight) + str(item_slot_res.id))
	
	# code for delete slot
	elif item_slot_res.box_variants_name() == "delete":
		if is_selected and Input.is_action_just_pressed("mouse_left") and is_the_item_touching_inventory and !has_item:
			item = Global.mouse_is_holding_this_item
			item.queue_free()

func _on_area_2d_mouse_entered() -> void:
	is_selected = true


func _on_area_2d_mouse_exited() -> void:
	is_selected = false


var is_the_item_touching_inventory = false
var item = null 

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("item"):
		is_the_item_touching_inventory = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("item"):
		is_the_item_touching_inventory = false

extends Panel

var is_selected = false

# colors for item slot
var default_color = Color(1, 1, 1)
var selected_color = Color(1, 1, 0)

# colors for delete slot
var default_color_del = Color(1, 0.1, 0.2)
var selected_color_del = Color(1, 1, 0)

var default_color_sel = Color(0.0, 1.0, 0.259, 1.0)
var selected_color_sel = Color(1, 1, 0)

@export var item_slot_res: Resource

func _process(delta: float) -> void:
	get_parent().get_parent().rotation = 0
	#print(item_slot_res.current_item)
	if is_selected:
		self_modulate = selected_color
	else:
		if item_slot_res.box_variant_name() == "delete":
			self_modulate = default_color_del
		else:
			self_modulate = default_color
		
	# code for item slot
	if item_slot_res.box_variant_name() == "item":
				  ##################### RE FUCKNG TARDED CODE YOU HAD WRITTEN HERE - Me
		
		if is_selected and Input.is_action_just_pressed("mouse_left") and is_the_item_touching_inventory:
			item = Global.itemHeldByMouse
			#item.position = position + Vector2(26, 26)
			item_slot_res.current_item = item
			item_slot_res.current_item.fish_stats.current_slot_id = item_slot_res.id
			item_slot_res.current_item.fish_stats.default_pos = global_position + Vector2(26, 26)
			if item.fish_stats.justCaught == true:
				item.fish_stats.justCaught = false
				Global.boatPointer.inventoryEnabled(false)

	# code for delete slot
	elif item_slot_res.box_variant_name() == "delete":
		if is_selected and Input.is_action_just_pressed("mouse_left") and is_the_item_touching_inventory:
			deleteHeldItem()
	
	# code for sell slot
	elif item_slot_res.box_variant_name() == "sell":
		if is_selected and Input.is_action_just_pressed("mouse_left") and is_the_item_touching_inventory:
			SalesManager.legalDockSell(Global.itemHeldByMouse)
			deleteHeldItem()

func _on_area_2d_mouse_entered() -> void:
	is_selected = true


func _on_area_2d_mouse_exited() -> void:
	is_selected = false


var is_the_item_touching_inventory = false
var item # so we dont have to instanciate each time 

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("item"):
		is_the_item_touching_inventory = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("item"):
		is_the_item_touching_inventory = false

func deleteHeldItem():
	item = Global.itemHeldByMouse
	Global.itemHeldByMouse = null
	item_slot_res.current_item = null
	item.queue_free()

extends Node2D

@onready var indicator: Sprite2D = $indicator # the '!' thinging
@onready var inventory: Control = $inventory

var fish_meter = preload("res://scenes/worlds/main/fish_meter.tscn") # the fish meter mini game scene
var fish_item = preload("res://scenes/worlds/main/fish_item.tscn")

var fish_item_res = preload("res://resouces/fish_item1.tres")

@onready var scare_area: Area2D = $scareArea

func _ready() -> void:
	print("(main/boat.gd) Hello, Ive spawned!") #if u leave debug messages, say what script theyre in!
	create_fish_item()
	item_isnt.queue_free()
	pass

var rmomentum: float = 0 # momentum of rotation
var mmomentum: Vector2 = Vector2(0, 0) # momentum of movement
var rspeed = 0.05
var mspeed = 1

var is_inventory_on = false
var can_turn_inventory_on = true

var can_move = true

var aa

func _process(delta: float) -> void:
	inventory.position = position + Vector2(-200, -200)
	#aa = get_node("fish_meter")
	#if aa != null:
	#	print(aa)
		#aa.create_fish.connect(create_fish_item())
		
	if Global.can_create_fish: # happens when you cacth a fish
		Global.can_create_fish = false
		can_move = false
		inventory.visible = true
		inventory.top_level = true
		is_inventory_on = true
		can_turn_inventory_on = false
		create_fish_item()
		
	if Global.mouse_is_holding_this_item == null and item_isnt != null:
		#wprint(item_isnt.global_position, fish_item_default_pos)
		if item_isnt.global_position != fish_item_default_pos: # if it's not were it spaws after item release
			can_turn_inventory_on = true
			
	if item_isnt == null:
		can_turn_inventory_on = true
	
	# ui_focus_next --> TAB
	if Input.is_action_just_pressed("ui_focus_next") and !is_inventory_on and can_turn_inventory_on:
		can_move = false
		inventory.visible = true
		inventory.top_level = true
		is_inventory_on = true
	elif Input.is_action_just_pressed("ui_focus_next") and is_inventory_on and can_turn_inventory_on:
		can_move = true
		inventory.visible = false
		is_inventory_on = false
		
	if Global.can_player_fish:
		fishTime()
	else:
		if indicator.visible:
			indicator.visible = false
	
	var ileft = Input.is_action_pressed("left")
	var iright = Input.is_action_pressed("right")
	var iup = Input.is_action_pressed("up")
	var idown = Input.is_action_pressed("down")
	
	# act based on input
	if ileft:
		rmomentum -= delta * rspeed
	if iright:
		rmomentum += delta * rspeed
	if iup:
		mmomentum += Vector2.UP * mspeed * delta
	if idown:
		mmomentum += Vector2.DOWN * mspeed * delta
	
	# normalize variables (eg stop rotation from going infinitly fast)
	if rmomentum > 0.03: # 0.03 seems to work as the best speed limit!
		rmomentum = 0.03
	if rmomentum < -0.03:
		rmomentum = -0.03
	
	if mmomentum.y > 6.0: # 0.03 seems to work as the best speed limit!
		mmomentum.y = 6.0
	if mmomentum.y < -6.0:
		mmomentum.y = -6.0
	
	
	# execute momentums
	if can_move:
		rotation += rmomentum
		position += mmomentum.rotated(rotation)
	
	# decrease rotation momentum
	if not ileft and not iright:
		rmomentum *= 1-(0.05)
		if rmomentum < 0.001 and rmomentum > -0.001:
			rmomentum = 0
	
	# decrease movement momentum
	if not iup and not idown:
		mmomentum.x *= 1-(0.03) # btw we dont actually use momentum.x
		if mmomentum.x < 0.001 and mmomentum.x > -0.001:
			mmomentum.x = 0
		mmomentum.y *= exp(-0.6 * delta)
		if mmomentum.y < 0.001 and mmomentum.y > -0.001:
			mmomentum.y = 0
	
	pass

# yey here we catch the fish
func fishTime():
	indicator.visible = true
	#indicator.global_position = position + Vector2.UP*70
	#indicator.global_rotation = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		var inst = fish_meter.instantiate()
		add_child(inst)
		inst.global_position = position + Vector2(0, -45)
		
		for obj in scare_area.get_overlapping_areas():
			if obj.is_in_group("fish_spot") and obj != targetFishArea:
				obj.scare(global_position)
		

var item_isnt = null
func create_fish_item():
	item_isnt = fish_item.instantiate()
		#item_isnt.top_level = true
		
	var item_inst_res = fish_item_res.duplicate(true)
	var weight_rand = 0.0
		
	var random = randi_range(1, 100)
	if random <= 50:
		item_inst_res.species = 0
		weight_rand = randf_range(0.4, 1.9)
	elif random < 90:
		item_inst_res.species = 1
		weight_rand = randf_range(0.9, 2.6)
	elif random >= 90:
		item_inst_res.species = 2
		weight_rand = randf_range(2.9, 5.1)
	else :
		item_inst_res.species = 4
		
	item_inst_res.default_pos = global_position + Vector2(-280, 0)
	item_inst_res.weight = weight_rand
	item_isnt.fish_stats = item_inst_res
	inventory.add_child(item_isnt)
	item_isnt.global_position = global_position + Vector2(-280, 0)
	fish_item_default_pos = item_isnt.global_position


var fish_item_default_pos = Vector2.ZERO
var targetFishArea: Area2D = null
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("fish_spot"):
		area.is_active_fish_area = true
		Global.can_player_fish = true
		targetFishArea = area


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("fish_spot"):
		area.is_active_fish_area = false
		Global.can_player_fish = false

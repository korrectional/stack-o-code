extends Node2D

@onready var indicator: Sprite2D = $indicator # the '!' thinging

var fish_meter = preload("res://scenes/worlds/main/fish_meter.tscn") # the fish meter mini game scene
@onready var scare_area: Area2D = $scareArea

func _ready() -> void:
	print("(main/boat.gd) Hello, Ive spawned!") #if u leave debug messages, say what script theyre in!
	pass

var rmomentum: float = 0 # momentum of rotation
var mmomentum: Vector2 = Vector2(0, 0) # momentum of movement
var rspeed = 0.05
var mspeed = 1
func _process(delta: float) -> void:
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
	indicator.global_position = position + Vector2.UP*70
	indicator.global_rotation = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		var inst = fish_meter.instantiate()
		add_child(inst)
		
		for obj in scare_area.get_overlapping_areas():
			if obj.is_in_group("fish_spot") and obj != targetFishArea:
				obj.scare(global_position)
		
		


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

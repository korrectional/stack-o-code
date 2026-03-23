extends Node2D

# the places you have to hit
@onready var hit_1: Sprite2D = $box/hit1
@onready var hit_2: Sprite2D = $box/hit2
@onready var hit_3: Sprite2D = $box/hit3

var hit # the hit area choosen
var hit_area # the child area2D of hit

@onready var hit_detector: Sprite2D = $box/hit_detector # the hitter

@onready var miss: Label = $miss
@onready var caught: Label = $caught

var rand_hit = 1 # random select for area to hit
var rand_speed = 1 # random select for hitter speed

var can_fish = false # if the timing is correct
var has_fished = false # input recebed

var selfdestructTimer = 1.7
var can_selfdestruct = false

signal create_fish

func _ready() -> void:
	miss.visible = false
	caught.visible = false
	rand_hit = randi_range(1, 3)
	rand_speed = randf_range(0.4, 1.3)
	fish_choose()
	
func _process(delta: float) -> void:
	global_rotation = 0
	
	if can_selfdestruct:
		selfdestructTimer -= delta
		if selfdestructTimer <= 0:
			queue_free()
	
	fish_time(delta)
	
func fish_choose():
	match rand_hit:
		1:
			hit = hit_1
		2:
			hit = hit_2
		3:
			hit = hit_3
	
	hit.visible = true
	hit_area = hit.get_child(0)
	hit_area.monitorable = true # the area can now be hit
	
func fish_time(delta: float):
	if !has_fished:
		hit_detector.position += Vector2.RIGHT * rand_speed * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		if can_fish:
			caught.visible = true
			#create_fish.emit()
			Global.can_create_fish = true
		elif !can_fish:
			miss.visible = true
		has_fished = true
		can_selfdestruct = true
		hit_area.monitorable = false
	


func _on_hit_detector_zone_area_entered(area: Area2D) -> void:
	match area.name:
		"borderStart":
			queue_free()
		"borderEnd":
			rand_speed = -rand_speed
		_:
			can_fish = true
			


func _on_hit_detector_zone_area_exited(area: Area2D) -> void:
	can_fish = false

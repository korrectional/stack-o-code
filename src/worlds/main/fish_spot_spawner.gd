extends Node

var spot = preload("res://scenes/worlds/main/fish_spot.tscn")

# the limits of the spawning box
var limit_max_position = Vector2(630, 630)
var limit_min_position = Vector2(-630, -630)

var can_spawn = true
var time_until_next_spawn = 30

var spots = [ # the positions to spawn the fish spots
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
]

func _process(delta: float) -> void:
	time_until_next_spawn -= delta
	
	if time_until_next_spawn <= 0:
		can_spawn = true
		time_until_next_spawn = 30
	
	if can_spawn:
		spawn()
		can_spawn = false
		
func spawn():
	for i in spots:
		var posX = randi_range(limit_min_position.x, limit_max_position.x)
		var posY = randi_range(limit_min_position.y, limit_max_position.y)
		i = Vector2(posX, posY)
		var inst = spot.instantiate()
		add_child(inst)
		inst.position = i

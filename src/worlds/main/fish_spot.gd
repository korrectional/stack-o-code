extends Area2D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var is_active_fish_area = false # is the player inside the zone
var selfdestructTimer = 30 # how long does it take for it to die in seconds
var fishSpeed = 3

func _ready() -> void:
	animation_player.play("fish_idle")
	
	
func _process(delta: float) -> void:
	if !is_active_fish_area:
		selfdestructTimer -= delta
		
	if is_active_fish_area and Input.is_action_just_pressed("ui_accept"):
		self.get_parent().queue_free()
		
	#print(selfdestructTimer)
	if selfdestructTimer <= 0:
		self.get_parent().queue_free()
	
	
	# theyre scared, so they'll move away from the boat
	if scared:
		if(get_parent().global_position.distance_to(epicenter) > 200):
			scared = false
		get_parent().global_position += epicenter.direction_to(get_parent().global_position)*fishSpeed
		#print(get_parent().global_position.distance_to(epicenter))

#is_active_fish_area = true
#Global.can_player_fish = true



var scared = false
var epicenter: Vector2 = Vector2(0, 0)

func scare(newEpicenter: Vector2):
	epicenter = newEpicenter
	scared = true

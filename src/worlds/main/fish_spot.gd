extends Area2D

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

var is_active_fish_area = false # is the player inside the zone
var selfdestructTimer = 30 # how long does it take for it to die in seconds

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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_active_fish_area = true
		Global.can_player_fish = true


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_active_fish_area = false
		Global.can_player_fish = false

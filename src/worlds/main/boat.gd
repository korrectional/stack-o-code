extends Node2D

func _ready() -> void:
	print("(main/boat.gd) Hello, Ive spawned!") #if u leave debug messages, say what script theyre in!
	pass

var rmomentum: float = 0 # momentum of rotation
var mmomentum: Vector2 = Vector2(0, 0) # momentum of movement
var rspeed = 0.05
var mspeed = 1
func _process(delta: float) -> void:
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
	
	print(mmomentum.y)
	
	pass

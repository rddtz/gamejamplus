extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const speed = 16

var velh := 0
var velv := 0

func _physics_process(delta: float) -> void:
	# Add the gravity.

	velh = Input.get_axis("LEFT", "RIGHT")
	if velh:
		velocity.x = velh * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	#
	
	velv = Input.get_axis("UP", "DOWN")
	if velv:
		velocity.y = velv * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
		

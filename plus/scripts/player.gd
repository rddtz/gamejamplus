extends CharacterBody2D

@onready var mapa_exemplo: TileMapLayer = $"../Mapa_exemplo"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const speed = 16

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if Input.is_action_just_pressed("LEFT"):
		position.x -= speed
	elif Input.is_action_just_pressed("RIGHT"):
		position.x += speed
	elif Input.is_action_just_pressed("UP"):
		position.y -= speed
	elif Input.is_action_just_pressed("DOWN"):
		position.y += speed

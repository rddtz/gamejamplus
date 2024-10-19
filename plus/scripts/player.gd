extends CharacterBody2D

@onready var mapa_exemplo: TileMapLayer = $"../Mapa_exemplo"

var timer = 0
var timer_parry = 0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const speed = 16

const TIME = 10
var time_mov := TIME
@onready var rayan: RayCast2D = $RayCast2D

var player_has_shield = true

#Player status variables
var vida := 1

func move():
	time_mov = TIME
	rayan.force_raycast_update()
	if !rayan.is_colliding():	
		position += rayan.target_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if time_mov > 0:
		time_mov -= delta;
	
	if Input.is_action_just_pressed("LEFT") or (Input.is_action_pressed("LEFT") and !time_mov):
		rayan.target_position = Vector2(-16,0)
		move()
	elif Input.is_action_just_pressed("RIGHT") or (Input.is_action_pressed("RIGHT") and !time_mov):
		rayan.target_position = Vector2(16,0)
		move()
	elif Input.is_action_just_pressed("UP") or (Input.is_action_pressed("UP") and !time_mov):
		rayan.target_position = Vector2(0,-16)
		move()
	elif Input.is_action_just_pressed("DOWN") or (Input.is_action_pressed("DOWN") and !time_mov):
		rayan.target_position = Vector2(0,16)
		move()
	
	if timer > 0:
		timer -= delta
	if timer == 0:
		player_has_shield = true
	if timer_parry > 0:	
		timer_parry -= delta
		
func _on_dano_area_entered(area: Area2D) -> void:
	#if !player_has_shield:
		#print(area.name)
		#
		#return
	# is_action_just_pressed: parry
	if Input.is_action_just_pressed("parry_block"):
		timer_parry = 60 # (frames)
		print("parry")
		return
	# is_action_pressed: block
	if Input.is_action_pressed("parry_block"):
		print("block")
		player_has_shield = false
		timer = 180 # (frames)
		return
	# se nao tiver 
	get_tree().reload_current_scene()

extends CharacterBody2D

@onready var mapa_exemplo: TileMapLayer = $"../Mapa_exemplo"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const speed = 16

const TIME = 10
var time_mov := TIME
@onready var rayan: RayCast2D = $RayCast2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


const PTIME = 0.5
var defendendo = false
var parry_timer = PTIME


const STIME = 30
var player_has_shield = true
var timer_shield = 0


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
	
	if (Input.is_action_pressed("LEFT") and !time_mov):
		rayan.target_position = Vector2(-16,0)
		move()
	elif Input.is_action_pressed("RIGHT") and !time_mov:
		rayan.target_position = Vector2(16,0)
		move()
	elif (Input.is_action_pressed("UP") and !time_mov):
		rayan.target_position = Vector2(0,-16)
		move()
	elif (Input.is_action_pressed("DOWN") and !time_mov):
		rayan.target_position = Vector2(0,16)
		move()
	
	if Input.is_action_pressed("parry_block") && player_has_shield:
		if !defendendo:
			parry_timer = PTIME
			defendendo = true
	else:
		defendendo = false
	
	if defendendo:
		animation.play("shield")
	else:
		animation.play("idle")
		
	if parry_timer > 0:
		parry_timer -= delta
		
	if timer_shield > 0:
		timer_shield -= delta
	else:
		player_has_shield = true

func _on_dano_area_entered(area: Area2D) -> void:
	if defendendo && parry_timer > 0:
		print("parry")
		defendendo = false
		player_has_shield = false
		timer_shield = 5
		return
	elif defendendo:
		defendendo = false
		print("block")
		player_has_shield = false
		timer_shield = STIME
		return
	else:
		get_tree().reload_current_scene()


	Global.screen_shake(10.0)


	#get_tree().reload_current_scene()

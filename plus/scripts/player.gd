extends CharacterBody2D

@onready var mapa_exemplo: TileMapLayer = $"../Mapa_exemplo"

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const speed = 16

const TIME = 10
var time_mov := TIME
@onready var rayan: RayCast2D = $RayCast2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var escudo: AnimatedSprite2D = $Escudo
@onready var brilho: AnimatedSprite2D = $brilho

var last = ""

const PTIME = 0.3
var defendendo = false
var parry_timer = PTIME
var foi_parry = false

const STIME = 5
var player_has_shield = true
var timer_shield = 0

var moving := false

func move_false():
	moving = false

func move():
	time_mov = TIME
	rayan.force_raycast_update()
	if !rayan.is_colliding():
		if !moving:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + rayan.target_position, .1)
			tween.tween_callback(move_false)
		#position += rayan.target_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if time_mov > 0:
		time_mov -= delta
	
	if !defendendo:
		if (Input.is_action_pressed("LEFT") and !time_mov):
			rayan.target_position = Vector2(-16,0)
			animation.flip_h = true
			animation.play("side")
			last = "side"
			move()
		if Input.is_action_pressed("RIGHT") and !time_mov:
			rayan.target_position = Vector2(16,0)
			animation.flip_h = false
			animation.play("side")
			last = "side"
			move()
		if (Input.is_action_pressed("UP") and !time_mov):
			rayan.target_position = Vector2(0,-16)
			animation.play("up")
			last = "up"
			move()
		if (Input.is_action_pressed("DOWN") and !time_mov):
			rayan.target_position = Vector2(0,16)
			last = "down"
			animation.play("down")
			move()
	
	if Input.is_action_pressed("parry_block") && player_has_shield:
		if !defendendo:
			parry_timer = PTIME
			defendendo = true
	else:
		defendendo = false
	
	if foi_parry:
		escudo.play("sucess_parry")
		brilho.play("sucess_parry")
	elif defendendo:
		escudo.play("shield_front")
		brilho.play("null")
	else:
		escudo.play("null")
		brilho.play("null")
	
	if parry_timer > 0:
		parry_timer -= delta
		
	if timer_shield > 0:
		timer_shield -= delta
	else:
		foi_parry = false
		player_has_shield = true

func _on_dano_area_entered(area: Area2D) -> void:
	
	if area.id == "Flecha":
		area.destroy_player()
	
	if defendendo && parry_timer > 0:
		print("parry")
		foi_parry = true
		defendendo = false
		player_has_shield = false
		timer_shield = 1
		return
	elif defendendo:
		defendendo = false
		print("block")
		player_has_shield = false
		Global.screen_shake(3.0)
		timer_shield = STIME
		return
	else:
		#pass
		get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	pass


	#get_tree().reload_current_scene()

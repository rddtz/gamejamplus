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
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var escudo_animation: AnimationPlayer = $Escudo/AnimationShield

var last = ""

const PTIME = 0.2
var defendendo = false
var parry_timer = PTIME
var foi_parry = 0
var parry = false
const PS = 0.1
var set_parry = PS 

const STIME = 5
var player_has_shield = true
var timer_shield = 0

var clicou := false

var moving := false

var particle_parry := preload("res://scenes/player/particle_arrow_parry.tscn")

var shadow_scene := preload("res://scenes/player/player_shadow.tscn")
var smoke_scene := preload("res://scenes/player/smoke.tscn")
var particle_block_scene := preload("res://scenes/player/particle_break_shield.tscn")
var morto := false
@onready var escudo_cima: Node2D = $EscudoCima
var quebrou := false
@onready var cem: Node2D = $Cem

var id = "player"

@export var controller_move : Node2D
var inicial_position : Vector2


func _ready() -> void:
	animation_player.play("RESET")
	Global.contando = true
	Global.score = 0
	pos_inicial()

func move_false():
	moving = false

func move():
	time_mov = TIME
	rayan.force_raycast_update()
	if !rayan.is_colliding():
		if !moving:
			var smoke := smoke_scene.instantiate()
			smoke.position = position
			smoke.player = self
			get_tree().current_scene.add_child(smoke, true)
			smoke.animated_sprite_2d.play(animation.animation)
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + rayan.target_position, .1)#.1
			tween.tween_callback(move_false)
		#position += rayan.target_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !morto:
		if time_mov > 0:
			time_mov -= delta
		
		if !defendendo && !parry:
			if (Input.is_action_pressed("LEFT") and !time_mov):
				rayan.target_position = Vector2(-16,0)
				animation.flip_h = true
				animation.play("side")
				last = "side"
				if !controller_move.goals_moves[3]:
					controller_move.goals_moves[3] = true
				move()
			if Input.is_action_pressed("RIGHT") and !time_mov:
				rayan.target_position = Vector2(16,0)
				animation.flip_h = false
				animation.play("side")
				last = "side"
				if !controller_move.goals_moves[2]:
					controller_move.goals_moves[2] = true
				move()
			if (Input.is_action_pressed("UP") and !time_mov):
				rayan.target_position = Vector2(0,-16)
				animation.play("up")
				last = "up"
				if !controller_move.goals_moves[0]:
					controller_move.goals_moves[0] = true
				move()
			if (Input.is_action_pressed("DOWN") and !time_mov):
				rayan.target_position = Vector2(0,16)
				last = "down"
				animation.play("down")
				if !controller_move.goals_moves[1]:
					controller_move.goals_moves[1] = true
				move()
		
		if Input.is_action_just_pressed("parry_block") && player_has_shield:
			clicou = true
			parry = true
			set_parry = PS
		
		if Input.is_action_pressed("parry_block") && clicou && player_has_shield:
			if !defendendo:
				defendendo = true
		else:
			defendendo = false

		if Input.is_action_just_released("parry_block") && player_has_shield:
			if set_parry > 0:
				parry_timer = PTIME

		if set_parry > 0 || parry_timer > 0:
			parry = true
		else:
			parry = false

		if defendendo || parry:
			#escudo.play("shield_front")
			choosing_shield()
			brilho.play("null")
		else:
			escudo.play("null")
			#brilho.play("null")
		
		if parry_timer > 0:
			parry_timer -= delta
		
		if set_parry > 0:
			set_parry -= delta
			
		if foi_parry > 0:	
			foi_parry -= delta
		
		if timer_shield > 0:
			timer_shield -= delta
		else:
			player_has_shield = true
			Global.quebrado = false
			
		
		if moving:
			var shadow := shadow_scene.instantiate()
			shadow.position = position
			shadow.player = self
			get_tree().current_scene.add_child(shadow, true)
		
		if quebrou && player_has_shield:
			escudo_cima.get_node("AnimatedSprite2D").play("Voltando")
			quebrou = false
	else:
		morte()

func _on_dano_area_entered(area: Area2D) -> void:

	if(foi_parry > 0):
		return

	if !morto:
		if area.get_parent().id == "Fireball":
			area.get_parent().destroy()
		if area.name == "Damage":
			if parry:
				$parrySound.pitch_scale = randf_range(1.2,1.8)
				$parrySound.play(float(position.x))
				Global.score += 100
				foi_parry = 0.1
				defendendo = false
				player_has_shield = false
				clicou = false
				escudo_animation.stop()
				escudo_animation.play("sucess_parry")
				animation_player.stop()
				animation_player.play("parry")
				brilho.play("null")
				brilho.play("sucess_parry")
				hit_lag(0.05, .75)
				cem.get_node("AnimationPlayer").stop()
				cem.get_node("AnimationPlayer").play("up")
				
				if controller_move.parrys < 5 and controller_move.page == 3:
					controller_move.parrys += 1
				return
			elif defendendo:
				defendendo = false
				$blockSound.pitch_scale = randf_range(1.0,1.4)
				$blockSound.play(float(position.x))
				player_has_shield = false
				Global.screen_shake(5.0)
				Global.quebrado = true
				Global.create_particles(particle_block_scene, 20, 30, position.x, position.y, 0, 0, 0, 0)
				timer_shield = STIME
				clicou = false
				escudo_cima.get_node("AnimatedSprite2D").play("Quebrando")
				quebrou = true
				return
			else:
				#Global.score = 0
				Global.screen_shake(25.0)
				escudo.play("null")
				controller_move.stop_fire()
				morto = true
func _input(event: InputEvent) -> void:
	pass

func parry_part():
	Global.create_particles(particle_parry, 20, 30, position.x, position.y, 0, 0, 0, 0)

func morte():
	if animation.animation != "morte":
		$deathSound.pitch_scale = randf_range(1.0,1.15)
		$deathSound.play()
		animation.play("morte")
		

	#get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "morte":
		TransitionTutorial.controller = controller_move
		TransitionTutorial.player = self
		TransitionTutorial.fade_in()

func hit_lag(time_scale : float, duration : float):
	Engine.time_scale = time_scale
	await get_tree().create_timer(time_scale * duration).timeout
	Engine.time_scale = 1.0
	parry_part()

func choosing_shield():
	if parry:
		escudo.play("shield_parry")
	else:
		escudo.play("shield")

func pos_inicial():
	position = Vector2(int((position.x) / 16)*16 + 8, int((position.y) / 16)*16 + 8)
	controller_move.player_inicial_position = position

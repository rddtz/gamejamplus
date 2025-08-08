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

@export var cam : Camera2D

var order_dirs = ["right", "down", "left", "up"]
var order_index := 0
var state := "idle"
var walk_anim := false

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

func _ready() -> void:
	animation_player.play("RESET")
	Global.contando = true
	Global.score = 0
	Global.time = Global.time_max

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
			smoke.animated_sprite_2d.play("walk_"+order_dirs[order_index])
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + rayan.target_position, .1)#.1
			tween.tween_callback(move_false)
		#position += rayan.target_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if state !=  "dead":
		
		if !Global.tran && (state == "idle" || state == "walk"):
			if time_mov > 0:
				time_mov -= delta
			
			var _velh := int(Input.is_action_pressed("RIGHT")) - int(Input.is_action_pressed("LEFT"))
			var _velv := int(Input.is_action_pressed("DOWN")) - int(Input.is_action_pressed("UP"))
			
			choosing_dir()
			if (_velh != 0 || _velv != 0) && !time_mov:
				rayan.target_position = Vector2(_velh * 16,_velv * 16)
				state = "walk"
				walk_anim = true
				move()
			
			#if Input.is_action_just_pressed("parry_block"):
			#	state = "parry"
			
		
		if moving:
			var shadow := shadow_scene.instantiate()
			shadow.position = position
			shadow.player = self
			#get_tree().current_scene.add_child(shadow, true)
	
	state_machine()

func _on_dano_area_entered(area: Area2D) -> void:

	if state != "dead":
		if area.name != "Tran" && area.get_parent().id == "Fireball":
			area.get_parent().destroy()
		if area.name == "Damage":
			if state == "parry":
				$parrySound.pitch_scale = randf_range(1.2,1.8)
				#$parrySound.play(float(position.x))
				$parrySound.play()
				Global.score += 100
				animation.stop()
				animation.play("parry_hit")
				animation_player.stop()
				animation_player.play("parry")
				brilho.play("null")
				brilho.play("sucess_parry")
				hit_lag(0.05, .90) #0.05, .75
				cem.get_node("AnimationPlayer").stop()
				cem.get_node("AnimationPlayer").play("up")
			else:
				#Global.score = 0
				Global.screen_shake(25.0)
				escudo.play("null")
				state = "dead"
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("parry_block") && !Global.tran && (state == "idle" || state == "walk"):
		state = "parry"

func parry_part():
	Global.create_particles(particle_parry, 20, 30, position.x, position.y, 0, 0, 0, 0)

func morte():
	if animation.animation != "morte":
		$deathSound.pitch_scale = randf_range(1.0,1.15)
		$deathSound.play()
		animation.play("morte")
		Global.ordena_score()
		Global.contando = false
		

	#get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "morte":
		Global.call_transition("res://scenes/ui/restart.tscn")
	
	if state == "walk":
		state = "idle"
	
	if state == "recover" && animation.animation == "recover":
		state = "idle"

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

func state_machine():
	match state:
		"idle":
			#Condições do estado
			if animation.animation != "idle_"+order_dirs[order_index]:
				animation.stop()
				animation.play("idle_"+order_dirs[order_index])
			
			#Saindo do estado
		"walk":
			if walk_anim:
				animation.stop()
				animation.play("walk_"+order_dirs[order_index])
				walk_anim = false
		"parry":
			if animation.animation != "parry" && animation.animation != "parry_hit":
				animation.stop()
				animation.play("parry")
			
			if animation.animation == "parry":
				if animation.frame >= 4:
					state = "recover"
			
			if animation.animation == "parry_hit":
				if animation.frame >= 4:
					state = "idle"
		"recover":
			if animation.animation != "recover":
				animation.stop()
				animation.play("recover")
			
		"dead":
			morte()

func choosing_dir():
	if Input.is_action_pressed("RIGHT"):
		order_index = 0
	elif Input.is_action_pressed("LEFT"):
		order_index = 2
		
	if Input.is_action_pressed("DOWN"):
		order_index = 1
	elif Input.is_action_pressed("UP"):
		order_index = 3

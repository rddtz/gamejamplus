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

const STIME = 5
var player_has_shield = true
var timer_shield = 0

var clicou := false

var moving := false

var particle_parry := preload("res://scenes/particle_arrow_parry.tscn")

var shadow_scene := preload("res://scenes/player_shadow.tscn")
var smoke_scene := preload("res://scenes/smoke.tscn")
var particle_block_scene := preload("res://scenes/particle_break_shield.tscn")
var morto := false
@onready var escudo_cima: Node2D = $EscudoCima
var quebrou := false


func _ready() -> void:
	animation_player.play("RESET")
	Global.contando = true
	Global.score = 0

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
			tween.tween_property(self, "position", position + rayan.target_position, .1)
			tween.tween_callback(move_false)
		#position += rayan.target_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	if !morto:
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
		
		if Input.is_action_just_pressed("parry_block"):
			clicou = true
		
		if Input.is_action_pressed("parry_block") && clicou && player_has_shield:
			if !defendendo:
				parry_timer = PTIME
				defendendo = true
		else:
			defendendo = false

		if defendendo:
			#escudo.play("shield_front")
			choosing_shield()
			brilho.play("null")
		else:
			escudo.play("null")
			#brilho.play("null")
		
		if parry_timer > 0:
			parry_timer -= delta
			
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
		if area.id == "Flecha":
			area.destroy_player()
				
		if (defendendo && parry_timer > 0):
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
		Global.contando = false
		

	#get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "morte":
		Global.call_transition("res://scenes/final.tscn")

func hit_lag(time_scale : float, duration : float):
	Engine.time_scale = time_scale
	await get_tree().create_timer(time_scale * duration).timeout
	Engine.time_scale = 1.0
	parry_part()

func choosing_shield():
	if parry_timer > 0:
		escudo.play("shield_parry")
	else:
		escudo.play("shield")

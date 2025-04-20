extends Node2D


var goals_moves := [false, false, false, false]
var parrys := 0
var page := 1 
var dodges := 0

@export var canvas : CanvasLayer
@export var player : CharacterBody2D
@export var box : Control

var fireball_scene = preload("res://scenes/inimigos/fireball.tscn")
var do_fire := false
@onready var timer: Timer = $Timer
var timer_running := false
var player_inicial_position : Vector2
@onready var timer_wait: Timer = $timer_wait


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if page == 1:
		if goals_moves[0] and goals_moves[1] and goals_moves[2] and goals_moves[3]:
			if timer_wait.is_stopped():
				timer_wait.start()
	elif page == 2:
		if dodges >= 5:
			do_fire = false
			if timer_wait.is_stopped():
				timer_wait.start()
	elif page == 3:
		if parrys >= 5:
			timer.stop()
			do_fire = false
			if timer_wait.is_stopped():
				timer_wait.start()
			page = 4


func spawn_fireball(pos_y):
	var fireball := fireball_scene.instantiate()

	fireball.position = Vector2(Global.fireball_positions[2], pos_y)
	
	fireball.direction = 180
	get_tree().current_scene.add_child(fireball, true)


func _on_timer_timeout() -> void:
	if do_fire:
		if page == 2:
			spawn_fireball(player.position.y)
		elif page == 3:
			for i in 15:
				spawn_fireball((i + 1) * 16)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("help"):
		if page >= 1 && page <= 3 && !TransitionTutorial.on_tran:
			box.show_box(page)


func stop_fire():
	do_fire = false
	timer.stop()

func next_page():
	if page < 4:
		canvas.reset_color()
		timer.start()
		do_fire = true
		page += 1
		if page == 2:
			canvas.dodge_tutorial()
		else:
			canvas.parry_tutorial()
		box.show_box(page)
	else:
		Global.call_transition("res://scenes/ui/menu_principal.tscn")




func _on_timer_wait_timeout() -> void:
	next_page()

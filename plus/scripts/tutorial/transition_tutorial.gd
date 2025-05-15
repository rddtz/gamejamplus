extends CanvasLayer

@export var next_scene : String
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var on_tran := false

var controller : Node2D
var player : CharacterBody2D

var player_scene := preload("res://scenes/tutorial/player_tutorial_2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar") && on_tran:
		reset()
		tran_finished()
		animation_player.stop()
		#animation_player.play("white")
	
func fade_in():
	#reset_scene = reset
	animation_player.stop()
	animation_player.play("transition")
	on_tran = true

func reset():
		controller.parrys = 0
		controller.dodges = 0
		player.queue_free()
		var new_player := player_scene.instantiate()
		new_player.controller_move = controller
		new_player.position = controller.player_inicial_position
		get_tree().current_scene.add_child(new_player, true)
		controller.player = new_player
		player = new_player
		start_fire()

func start_fire():
	controller.do_fire = true
	controller.timer.start()

func tran_finished():
	on_tran = false

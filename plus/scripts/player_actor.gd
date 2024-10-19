extends Node2D

@onready var timer: Timer = $Timer
var qtd_pulos := 0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player_scene = preload("res://scenes/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_timer_timeout() -> void:
	if qtd_pulos < 6:
		position.y += 16
		qtd_pulos += 1

func spawn_player():
	var player = player_scene.instantiate()
	player.position.x = position.x
	player.position.y = position.y
	get_tree().current_scene.add_child(player, true)
	queue_free()

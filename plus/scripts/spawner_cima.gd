extends Node2D
var flecha_cena = preload("res://scenes/flecha.tscn")
@onready var timer: Timer = $Timer

func _on_timer_timeout() -> void:
	var flecha = flecha_cena.instantiate()
	flecha.position = Vector2(86+16*randi_range(0,14), -80)
	flecha.speed = -300
	flecha.direction = -90
	get_tree().current_scene.add_child(flecha, true)
	timer.set_wait_time(randf_range(1,3))

extends Node2D
var flecha_cena = preload("res://scenes/flecha.tscn")
@onready var timer: Timer = $Timer

@export var active: bool = true
@export var quantite: int = 1

@export var speed: int = 300

func _on_timer_timeout() -> void:
	if active:
		for i in range(quantite):
			var x_meio = 212
			var flecha = flecha_cena.instantiate()
			flecha.position = Vector2(x_meio - 500, 72+16*randi_range(0,14))
			flecha.speed = speed
			get_tree().current_scene.add_child(flecha, true)
			timer.set_wait_time(randf_range(1,3))

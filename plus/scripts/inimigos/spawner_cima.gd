extends Node2D
var flecha_cena = preload("res://scenes/inimigos/flecha.tscn")
@onready var timer: Timer = $Timer

@export var active: bool = true
@export var quantite: int = 1

@export var speed: int = 300

func _on_timer_timeout() -> void:
	if active:
		for i in range(quantite):
			
			var y_meio = 67 + 126
			
			var flecha = flecha_cena.instantiate()
			flecha.position = Vector2(92+16*randi_range(0,14), y_meio - 500)
			flecha.speed = -speed
			flecha.direction = -90
			flecha.tipo = 1
			get_tree().current_scene.add_child(flecha, true)
			timer.set_wait_time(randf_range(1,3))

extends Node2D

@onready var timer: Timer = $Timer

var bomba_scene := preload("res://scenes/explosao.tscn")

@export var active: bool = true
@export var quantite: int = 1

func _on_timer_timeout() -> void:
	if active:
		for i in range(quantite):
			var bomba := bomba_scene.instantiate()
			var y = randi_range(67,275)/16
			var x = randi_range(85, 292)/16
			bomba.position = Vector2(x*16,y*16)
			get_tree().current_scene.add_child(bomba, true)

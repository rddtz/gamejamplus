extends Node2D

@onready var timer: Timer = $Timer

var bomba_scene := preload("res://scenes/explosao.tscn")

@export var active: bool = true
@export var quantite: int = 1


func run_special(xp, yp) -> void:
	var bomba := bomba_scene.instantiate()
	bomba.position = Vector2(xp,yp)
	get_tree().current_scene.add_child(bomba, true)


func _on_timer_timeout() -> void:
	if active:
		for i in range(quantite):
			var bomba := bomba_scene.instantiate()
			var y = 67 + randi_range(0,13)*16
			var x = 85 + randi_range(0, 13)*16
			bomba.position = Vector2(x,y)
			get_tree().current_scene.add_child(bomba, true)

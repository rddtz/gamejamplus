extends Node2D

@export var active: bool = true
@export var quantite: int = 1

var armadilha_scene := preload("res://scenes/armadilha-chao.tscn")

func run_special(xp, yp) -> void:
	var bomba := armadilha_scene.instantiate()
	bomba.position = Vector2(xp,yp)
	get_tree().current_scene.add_child(bomba, true)


func _on_timer_timeout() -> void:
	
	if active:
		for i in range(quantite):
			var chao := armadilha_scene.instantiate()
			var base_x = 84
			var base_y = 75
			var y = base_y + randi_range(0,14)*16
			#var y = randi_range(80,296)/16
			#var x = randi_range(96, 328)/16
			chao.position = Vector2(base_x+8*16,y)
			get_tree().current_scene.add_child(chao, true)
		 # Replace with function body.

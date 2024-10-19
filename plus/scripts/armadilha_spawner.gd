extends Node2D

var armadilha_scene := preload("res://scenes/armadilha-chao.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	
	var chao := armadilha_scene.instantiate()
	var base_x = 84
	var base_y = 67
	var y = base_y + randi_range(0,14)*16
#	var y = randi_range(80,296)/16
	#var x = randi_range(96, 328)/16
	chao.position = Vector2(base_x+8*16,y)
	get_tree().current_scene.add_child(chao, true)
	 # Replace with function body.

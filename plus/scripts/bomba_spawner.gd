extends Node2D

@onready var timer: Timer = $Timer

var bomba_scene := preload("res://scenes/explosao.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_timer_timeout() -> void:
	var bomba := bomba_scene.instantiate()
	var y = randi_range(80,296)/16
	var x = randi_range(96, 328)/16
	bomba.position = Vector2(x*16,y*16)
	get_tree().current_scene.add_child(bomba, true)

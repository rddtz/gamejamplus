extends Node

@export var cam : Camera2D

var shake := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.shake:
		shake = Global.shake_force
		Global.shake = false
	
	if shake != 0.0:
		cam.offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
		shake *= .95
	else:
		cam.offset = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	pass

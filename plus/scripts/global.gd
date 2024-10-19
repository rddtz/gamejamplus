extends Node

var shake := false
var shake_force := 5.0
var paused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paused = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func screen_shake(force : float):
	shake = true
	shake_force = force

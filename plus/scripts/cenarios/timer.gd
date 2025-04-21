extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if Global.contando:
		Global.score += 10
		Global.time -= 1
		if Global.time <= 0:
			Global.contando = false
#	print(Global.score) 

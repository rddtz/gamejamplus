extends Control
@onready var animation: AnimationPlayer = $AnimationPlayer

func pause():
	#animation.stop()
	Global.paused = true
	get_tree().paused = true
	animation.play("blur_bg")
	#Engine.time_scale = 0

func resume():
	Global.paused = false
	get_tree().paused = false
	animation.play_backwards("blur_bg")
	#Engine.time_scale = 1

func pausa_ou_despausa():
	
	if Input.is_action_just_pressed("pause"):
		print("clicou")
	
	if Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
	elif Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
		
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pausa_ou_despausa()

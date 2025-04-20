extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.score = 0
	$YES.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar"):
		_on_yes_pressed()


func _on_yes_pressed() -> void:
	if Global.score > Global.highscore:
		Global.highscore = Global.score 
	Global.call_transition("res://scenes/mapas/main_new.tscn")


func _on_no_pressed() -> void:
	Global.call_transition("res://scenes/ui/menu_principal.tscn")
	Global.primeiro = true

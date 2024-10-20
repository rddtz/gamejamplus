extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$YES.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar"):
		_on_yes_pressed()


func _on_yes_pressed() -> void:
	if Global.score > Global.leaders.values().max():
		Global.highscore = Global.score
	Global.call_transition("res://scenes/main.tscn")


func _on_no_pressed() -> void:
	if Global.score > Global.leaders.values().max():
		Global.highscore = Global.score
	Global.call_transition("res://scenes/menu_principal.tscn")

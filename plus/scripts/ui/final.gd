extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coloca_nomes()
	coloca_scores()
	$Back.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar"):
		_on_enviar_pressed()

func coloca_nomes():
	$VBoxContainer/Container2/HBoxContainer/nomes.text = "NAMES"
	var i = Global.MAX_PLAYERS - 1
	var j = 0
	while i > -1:
		$VBoxContainer/Container2/HBoxContainer/nomes.text += "\n" + str(j+1) + ". " + Global.leaderboard["names"][i]
		j += 1
		i -= 1

func coloca_scores():
	$VBoxContainer/Container2/HBoxContainer/scores.text = "SCORES"
	var i = Global.MAX_PLAYERS - 1
	while i > -1:
		$VBoxContainer/Container2/HBoxContainer/scores.text += "\n" + str(Global.leaderboard["scores"][i])
		i -= 1


func _on_enviar_pressed() -> void: 
	
	Global.call_transition("res://scenes/ui/menu_principal.tscn")

func _on_button_pressed() -> void:
	Global.call_transition("res://scenes/ui/menu_principal.tscn")

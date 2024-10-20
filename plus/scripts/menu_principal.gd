extends Control

var menuTheme = AudioServer.get_bus_index("menu theme")
var mainTheme = AudioServer.get_bus_index("main theme")

var clicou = false

func _process(delta: float) -> void:
	
	var nome = $CanvasLayer/LineEdit.text
	
	if Input.is_action_just_pressed("enviar") && !clicou && len(nome) == 3:
		#$Jogar.grab_focus()
		Global.nome = nome
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/main.tscn")
	if len(nome) < 3:
		$CanvasLayer/Jogar.disabled = true
		pass
	else:
		$CanvasLayer/Jogar.disabled = false

func _on_jogar_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	if !clicou: 
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/main.tscn")
		
func _on_leaderboard_pressed() -> void:
	Global.call_transition("res://scenes/final.tscn")
	
	
func _on_sair_pressed() -> void:
	get_tree().quit()

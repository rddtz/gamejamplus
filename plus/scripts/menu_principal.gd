extends Control

var menuTheme = AudioServer.get_bus_index("menu theme")
var mainTheme = AudioServer.get_bus_index("main theme")

var clicou = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar") && !clicou:
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/main.tscn")

func _on_jogar_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	if !clicou: 
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/main.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()

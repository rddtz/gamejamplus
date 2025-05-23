extends Control

var menuTheme = AudioServer.get_bus_index("menu theme")
var mainTheme = AudioServer.get_bus_index("main theme")

var clicou = false

func _ready() -> void:
	Global.load_leaders()

func _process(delta: float) -> void:
	
	var nome = $CanvasLayer/LineEdit.text
	
	if Input.is_action_just_pressed("enviar") && !clicou && len(nome) == 3:
		#$Jogar.grab_focus()
		Global.nome = nome
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/ui/space.tscn")
	if len(nome) < 3 and Global.primeiro:
		$CanvasLayer/Jogar.disabled = true
		pass
	else:
		$CanvasLayer/Jogar.disabled = false
		
	if !Global.primeiro:
		$CanvasLayer/LineEdit.text = Global.nome

func _on_jogar_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	if !clicou: 
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/ui/space.tscn")
		
func _on_leaderboard_pressed() -> void:
	Global.call_transition("res://scenes/ui/final.tscn")
	
	
func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_label_tree_exiting() -> void:
	Global.primeiro = false


func _on_tutorial_pressed() -> void:
	Global.call_transition("res://scenes/tutorial/tutorial_move.tscn")

extends Control

# Assign your LineEdit and GridContainer nodes in the Inspector
@export var line_edit: LineEdit
@export var grid_container: GridContainer

# Define the layout of your keyboard
var letras = [
	"-", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P", "Q", "R", "S",
	"T", "U", "V", "W", "X", "Y", "Z"
]

func _ready():
	Global.load_leaders()
	# Only generate buttons if the scene is running, not in the editor

var menuTheme = AudioServer.get_bus_index("menu theme")
var mainTheme = AudioServer.get_bus_index("main theme")

var clicou = false
	
var i1 = 0
var i2 = 0
var i3 = 0
var letras_validas = 0

func _process(delta: float) -> void:
	
	var nome = "%s%s%s" % [letras[i1], letras[i2], letras[i3]]
	$CanvasLayer/Label.text = "%s  %s  %s" % [letras[i1], letras[i2], letras[i3]]

	letras_validas = 0
	for i in [i1, i2, i3]:
		if letras[i] != "-":
			letras_validas += 1

	
	if Input.is_action_just_pressed("enviar") && clicou && letras_validas == 3:
		#$Jogar.grab_focus()
		Global.nome = nome
		clicou = true
		AudioServer.set_bus_mute(menuTheme, true)
		AudioServer.set_bus_volume_db(mainTheme, 0)
		Global.call_transition("res://scenes/ui/space.tscn")
	if letras_validas < 3 and Global.primeiro:
		$CanvasLayer/Jogar.disabled = true
	else:
		$CanvasLayer/Jogar.disabled = false
		
	if !Global.primeiro:
		$CanvasLayer/LineEdit.text = Global.nome

func _on_jogar_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	if !clicou and letras_validas == 3: 
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


func _on_cima_1_pressed() -> void:
	i1 = (i1 + 1) % len(letras)

func _on_cima_2_pressed() -> void:
	i2 = (i2 + 1) % len(letras)

func _on_cima_3_pressed() -> void:
	i3 = (i3 + 1) % len(letras)

func _on_baixo_1_pressed() -> void:
	i1 = (i1 - 1) 
	if i1 < 0:
		i1 = len(letras) - 1

func _on_baixo_2_pressed() -> void:
	i2 = (i2 - 1) 
	if i2 < 0:
		i2 = len(letras) - 1

func _on_baixo_3_pressed() -> void:
	i3 = (i3 - 1) 
	if i3 < 0:
		i3 = len(letras) - 1
	

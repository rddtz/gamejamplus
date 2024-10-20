extends Control

var pro = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	le_csv()
	ordena_gambiarra()
	monta_string()
	coloca_nomes()
	coloca_scores()
	$Back.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar"):
		_on_enviar_pressed()

func ordena_gambiarra():
	Global.final_score = Global.leaders.values()
	if Global.score not in Global.final_score:
		Global.final_score.append(Global.score)
	Global.final_score.sort_custom(func(a, b): return a > b)

func le_csv():
	var file_holder = "res://leaderboard.csv"
	var file = FileAccess.open(file_holder, FileAccess.READ)
	if file == null:
		for i in range(10):
			Global.leaders[str(1 + i) + "th"] =  0
			Global.NUM_PLAYERS = 10
	else:
		var aux
		var linhas = 0
		while !file.eof_reached():
			aux = file.get_csv_line()
			if len(aux) == 2:
				linhas+=1
				Global.leaders[aux[0]] = int(aux[1])

		if linhas <= 10:
			Global.NUM_PLAYERS = linhas + 1
		else:
			Global.NUM_PLAYERS = 10
		file.close()

func monta_string():
	print(Global.final_names)
	print(Global.leaders)
	print(Global.final_score)
	for i in range(Global.NUM_PLAYERS):
		print(len(Global.final_score))
		if Global.leaders.find_key(Global.final_score[i]) == null:
			Global.final_names[i] = Global.nome
			#print("eh o gremoi")
		else:
			Global.final_names[i] = Global.leaders.find_key(Global.final_score[i])

func coloca_nomes():
	$VBoxContainer/Container2/HBoxContainer/nomes.text = "NAMES"
	for i in range(Global.NUM_PLAYERS-1):
		$VBoxContainer/Container2/HBoxContainer/nomes.text += "\n" + str(i+1) + ". " + Global.final_names[i]

func coloca_scores():
	$VBoxContainer/Container2/HBoxContainer/scores.text = "SCORES"
	for i in range(Global.NUM_PLAYERS-1):
		$VBoxContainer/Container2/HBoxContainer/scores.text += "\n" + str(Global.final_score[i])


func _on_enviar_pressed() -> void: 
	
	#mudara o nome de You na leaderboard pelo valor do player
	Global.leaders[Global.nome] = Global.score
	ordena_gambiarra()
	monta_string() #isso deve funcionar 
	coloca_nomes()
	#atualiza o csv com o novo valor 
	var file_holder = "res://leaderboard.csv"
	var file = FileAccess.open(file_holder, FileAccess.WRITE)
	for i in Global.leaders.keys():
		var tmp = [i, Global.leaders[i]]
		file.store_csv_line(tmp)
	file.close()
	
	Global.highscore = Global.leaders.values().max()
	
	Global.call_transition("res://scenes/menu_principal.tscn")

func _on_button_pressed() -> void:
	Global.call_transition("res://scenes/menu_principal.tscn")

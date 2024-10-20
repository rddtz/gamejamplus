extends Control

var pro = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Global.final_names)
	print(Global.final_score)
	print(Global.leaders)
	
	le_csv()
	ordena_gambiarra()
	monta_string()
	$VBoxContainer/Container/HBoxContainer/VBoxContainer2/ScorePlayer.text += str(Global.score) 
	coloca_nomes()
	coloca_scores()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enviar"):
		_on_enviar_pressed()
	if pro == 0:
		print(Global.final_names)
		print(Global.final_score)
		print(Global.leaders)
		pro = 1

func ordena_gambiarra():
	Global.final_score = Global.leaders.values()
	if Global.score not in Global.final_score:
		Global.final_score.append(Global.score)
	Global.final_score.sort_custom(func(a, b): return a > b)

func le_csv():
	var file_holder = "res://leaderboard.csv"
	var file = FileAccess.open(file_holder, FileAccess.READ)
	var aux
	var linhas = 0
	
	while !file.eof_reached():
		aux = file.get_csv_line()
		if len(aux) == 2:
			linhas+=1
			Global.leaders[aux[0]] = int(aux[1])

	if linhas <= 7:
		Global.NUM_PLAYERS = linhas + 1
	else:
		Global.NUM_PLAYERS = 7
	file.close()

func monta_string():
	for i in range(Global.NUM_PLAYERS):
		if Global.leaders.find_key(Global.final_score[i]) == null:
			Global.final_names[i] = Global.nome
			#print("eh o gremoi")
		else:
			Global.final_names[i] = Global.leaders.find_key(Global.final_score[i])


func coloca_nomes():
	$VBoxContainer/Container2/HBoxContainer/nomes.text = "Nomes"
	for i in range(Global.NUM_PLAYERS-1):
		$VBoxContainer/Container2/HBoxContainer/nomes.text += "\n" + str(i+1) + ". " + Global.final_names[i]

func coloca_scores():
	$VBoxContainer/Container2/HBoxContainer/scores.text = "Scores"
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
	
	Global.call_transition("res://scenes/menu_principal.tscn")

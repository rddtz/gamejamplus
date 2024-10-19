extends Control

var NUM_PLAYERS

var leaders = {}
var final_score = [0,0,0,0,0,0,0]
var final_names = [0,0,0,0,0,0,0]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	le_csv()
	ordena_gambiarra()
	monta_string()
	$VBoxContainer/Container/HBoxContainer/VBoxContainer2/ScorePlayer.text += str(Global.score) 
	coloca_nomes()
	coloca_scores()

func _process(delta: float) -> void:
	pass

func ordena_gambiarra():
	final_score = leaders.values()
	if Global.score not in final_score:
		final_score.append(Global.score)
	final_score.sort_custom(func(a, b): return a > b)

func le_csv():
	var file_holder = "res://leaderboard.csv"
	var file = FileAccess.open(file_holder, FileAccess.READ)
	var aux
	var linhas = 0
	
	while !file.eof_reached():
		linhas+=1
		aux = file.get_csv_line()
		if len(aux) == 2:
			leaders[aux[0]] = int(aux[1])

	if linhas <= 7:
		NUM_PLAYERS = linhas
	else:
		NUM_PLAYERS = 7
	file.close()

func monta_string():
	#zerar a array primeiro 
	
	for i in range(NUM_PLAYERS):
		if leaders.find_key(final_score[i]) == null:
			final_names[i] = Global.nome
			#print("eh o gremoi")
		else:
			final_names[i] = leaders.find_key(final_score[i])


func coloca_nomes():
	$VBoxContainer/Container2/HBoxContainer/nomes.text = "Nomes"
	for i in range(NUM_PLAYERS):
		$VBoxContainer/Container2/HBoxContainer/nomes.text += "\n" + str(i+1) + ". " + final_names[i]

func coloca_scores():
	$VBoxContainer/Container2/HBoxContainer/scores.text = "Scores"
	for i in range(NUM_PLAYERS):
		$VBoxContainer/Container2/HBoxContainer/scores.text += "\n" + str(final_score[i])


func _on_enviar_pressed() -> void: 
	
	#mudara o nome de You na leaderboard pelo valor do player
	leaders[Global.nome] = Global.score
	ordena_gambiarra()
	monta_string() #isso deve funcionar 
	coloca_nomes()
	#atualiza o csv com o novo valor 
	var file_holder = "res://leaderboard.csv"
	var file = FileAccess.open(file_holder, FileAccess.WRITE)
	for i in leaders.keys():
		var tmp = [i, leaders[i]]
		file.store_csv_line(tmp)
	file.close()

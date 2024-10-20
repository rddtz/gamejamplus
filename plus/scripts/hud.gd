extends CanvasLayer

var animando = 0
var idle = 1
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	le_csv()
	ordena_gambiarra()
	monta_string()
	mete_leaders()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$VBoxContainer/Label.text = str(Global.score)
	
	att_escudo()
	
	atualiza_tabela()
	mete_leaders()


func att_escudo():
	if Global.quebrado and !animando:
		idle = 0
		animando+=1
		#$Quebrado.play("RESET")
		$Quebrado.play("quebra")
	elif !Global.quebrado:
		animando = 0
		if !idle:
			#$Quebrado.play("RESET")
			$Quebrado.play("quebra_invert")
			idle = 1
   

func _on_quebrado_animation_finished() -> void:
	if $Quebrado.animation == "quebra_invert" or $Quebrado.animation == "idle":
		$Quebrado.play("idle")


func le_csv():
	var file_holder = "res://leaderboard.csv"
	var file = FileAccess.open(file_holder, FileAccess.READ)
	var aux
	var linhas = 0
	
	while !file.eof_reached() && linhas < 5:
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
	
	#print(Global.final_names)
	#print(Global.NUM_PLAYERS)
	for i in range(Global.NUM_PLAYERS):
		#print(Global.final_score)
		if Global.leaders.find_key(Global.final_score[i]) == null:
			index = i
			Global.final_names[i] = Global.nome
		else:
			Global.final_names[i] = Global.leaders.find_key(Global.final_score[i])


func ordena_gambiarra():
	Global.final_score = Global.leaders.values()
	if Global.score not in Global.final_score:
		Global.final_score.append(Global.score)
	Global.final_score.sort_custom(func(a, b): return a > b)


func mete_leaders():
	$Leaders.text = "NOME	        SCORE"
	for i in range(Global.NUM_PLAYERS):
		$Leaders.text += "\n" + Global.final_names[i] + "         " + str(Global.final_score[i])


func atualiza_tabela():
	Global.final_score[index] = Global.score
	if index != 0 and Global.score > Global.final_score[index-1]:
		Global.final_score[index] = Global.final_score[index-1]
		Global.final_names[index] = Global.final_names[index-1]
		Global.final_score[index-1] = Global.score
		Global.final_names[index-1] = Global.nome
		index-=1

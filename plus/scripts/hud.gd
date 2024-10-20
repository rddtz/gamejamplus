extends CanvasLayer

var animando = 0
var idle = 1
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	le_csv()
	$VBoxContainer/Highscore.text += "\n" + str(Global.highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	$VBoxContainer/Score.text = str(Global.score)

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
	
	Global.highscore = Global.leaders.values().max()

func mete_leaders():
	$Leaders.text = ""
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

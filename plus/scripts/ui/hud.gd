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
		
	var high = Global.leaders.values().max()
	if Global.highscore < Global.score:
		Global.highscore = Global.score

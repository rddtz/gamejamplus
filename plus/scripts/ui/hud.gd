extends CanvasLayer

var animando = 0
var idle = 1
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.highscore = Global.leaderboard["scores"][9]
	#$VBoxContainer/Highscore.text += "\n" + str(Global.highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.score > Global.highscore:
		Global.highscore = Global.score
	$VBoxContainer/Score.text = str(Global.score)
	$VBoxContainer/Highscore.text = "HIGHSCORE\n" + str(Global.highscore)

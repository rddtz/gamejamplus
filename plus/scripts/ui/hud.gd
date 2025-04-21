extends CanvasLayer

var animando = 0
var idle = 1
var index = 0
@onready var timer: Label = $Timer


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
	
	sec_to_minutes()

func sec_to_minutes():
	if Global.time >= 0:
		var min := Global.time / 60
		var sec := str(Global.time % 60)
		
		if int(sec) < 10:
			sec = "0"+sec
		timer.text = "TIMER\n"+ "0" + str(min) + ":" + sec

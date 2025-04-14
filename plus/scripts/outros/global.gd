extends Node

var shake := false
var shake_force := 5.0
var paused
var score = 0
var nome = "YOU"
var quebrado
var contando

var highscore = 0
var primeiro = true

const MAX_PLAYERS := 10
var leaderboard : Dictionary = {
	"names" : ["", "", "", "", "", "", "", "", "", ""],
	"scores" : [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]} 

const save_location = "user://Save.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paused = false # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func screen_shake(force : float):
	shake = true
	shake_force = force

#Funcao que vai criar as particulas
func create_particles(particles : Resource, min_amount : int, max_amount : int,
x : float, y: float, min_x : float, max_x : float, min_y : float, max_y : float):
	
	var amount := randi_range(min_amount, max_amount)
	
	for i in amount:
		var x_temp := randf_range(min_x, max_x)
		var y_temp := randf_range(min_y, max_y)
		
		var particle = particles.instantiate()
		particle.position = Vector2(x + x_temp, y + y_temp)
		get_tree().current_scene.add_child(particle, true)


func call_transition(scene : String):
	Transition.fade_in(scene)


func save_leaders():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(leaderboard.duplicate())
	file.close()

func load_leaders():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		leaderboard = data.duplicate()
	
func ordena_score():
	var i := 9
	var exit := false
	while i > -1:
		if score >= leaderboard["scores"][i] and !exit:
			exit = true
			print("ENREI")
			for j in i + 1:
				print(j)
				if j > 0:
					leaderboard["scores"][j-1] = leaderboard["scores"][j]
					leaderboard["names"][j-1] = leaderboard["names"][j]
				if j == i:
					leaderboard["scores"][j] = score
					leaderboard["names"][j] = nome
					save_leaders()
		i -= 1
	
	
	
	
	

extends Node

var shake := false
var shake_force := 5.0
var paused
var score = 0
var nome = "YOU"
var quebrado
var contando

var NUM_PLAYERS
var leaders = {}
var final_score = [0,0,0,0,0,0,0,0,0,0,0]
var final_names = [0,0,0,0,0,0,0,0,0,0,0]
var highscore = 0
var primeiro = true

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

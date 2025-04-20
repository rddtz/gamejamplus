extends Node2D


var fireball_scene = preload("res://scenes/inimigos/fireball.tscn")
#sentido trigonometrico: direita, cima, esquerda, baixo
#var fireball_positions := [673, -400, -400, 656]
#sentido: 0, 90, 180, 270 (lembrando que o eixo y eh invertido)

const size := 16
const min_position := 2
const max_position := 15
var positions := []

var bomb_scene = preload("res://scenes/inimigos/explosao_new.tscn")
@export var player : CharacterBody2D

var seconds := 0
var rng = RandomNumberGenerator.new()
var qtd_fire := 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_fireball(dir, pos_x, pos_y):
	var fireball := fireball_scene.instantiate()
	
	if dir == 0:
		fireball.position = Vector2(Global.fireball_positions[0], pos_y * size)
	elif dir == 90:
		fireball.position = Vector2(pos_x * size, Global.fireball_positions[1])
	elif dir == 180:
		fireball.position = Vector2(Global.fireball_positions[2], pos_y * size)
	else:
		fireball.position = Vector2(pos_x * size, Global.fireball_positions[3])
		
	fireball.direction = dir
	get_tree().current_scene.add_child(fireball, true)

func random_fireball(qtd):
	for i in qtd:
		var dir := rng.randi_range(0, 3) * 90
		var pos := rng.randi_range(min_position, max_position)
		spawn_fireball(dir, pos, pos)

func spawn_bomb():
	var bomb := bomb_scene.instantiate()
	bomb.position.x = player.position.x - size
	bomb.position.y = player.position.y - size
	
	#Garantindo que vai ficar na grid
	bomb.position = Vector2(int((bomb.position.x) / size)*size, int((bomb.position.y) / size)*size)
	get_tree().current_scene.add_child(bomb, true)

func _on_timer_timeout() -> void:
	seconds += 1
	
	if seconds == 1:
		spawn_fireball(180, 0, rng.randi_range(min_position, max_position))
	elif seconds == 3:
		spawn_fireball(90, rng.randi_range(min_position, max_position), 0)
		#spawn_bomb()
	elif seconds == 5:
		spawn_fireball(0, 0, rng.randi_range(min_position, max_position))
	elif seconds == 7:
		spawn_fireball(270, rng.randi_range(min_position, max_position), 0)
	elif seconds == 10 || seconds == 13 || seconds == 16:
		spawn_bomb()
	
	if seconds > 18 and seconds % 3 == 0:
		spawn_bomb()
		
	if seconds == 30 || seconds == 45 || seconds == 16:
		qtd_fire += 1
	
	if seconds > 16:
		random_fireball(rng.randi_range(1, qtd_fire))

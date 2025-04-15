extends Node2D

var id := "Fireball"
@export var direction : int
@export var speed : float

#400 pixels de distancia do mapa
var warning_scene := preload("res://scenes/inimigos/aviso_flecha.tscn")
var shadow_scene := preload("res://scenes/inimigos/fireball_shadow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pos_inicial()
	
	create_warning()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	getting_out()

func pos_inicial():
	position = Vector2(int((position.x) / 16)*16, int((position.y) / 16)*16)

func _physics_process(delta: float) -> void:
	position.x += cos(deg_to_rad(direction)) * speed * delta
	position.y += sin(deg_to_rad(direction)) * speed * delta
	
	#var shadow = shadow_scene.instantiate()
	#shadow.position.x = position.x + 8
	#shadow.position.y = position.y + 8
	#get_tree().current_scene.add_child(shadow, true)
	

func create_warning():
	var warning = warning_scene.instantiate()
	if direction == 180:
		warning.position.y = position.y + 8
		warning.position.x = 256
	elif direction == 0:
		warning.position.y = position.y + 8
		warning.position.x = 24
	elif direction == 90:
		warning.position.y = 24
		warning.position.x = position.x + 8
	elif direction == 270:
		warning.position.y = 248
		warning.position.x = position.x + 8
	
	get_tree().current_scene.add_child.call_deferred(warning, true)

func getting_out():
	if position.x >= 1000 || position.x <= -1000 || position.y >= 1000 || position.y <= -1000:
		print("SAIU")
		queue_free()

func destroy():
	queue_free()

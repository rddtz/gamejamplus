extends Node2D
@onready var c: Node2D = $"../spawner_cima"
@onready var b: Node2D = $"../spawner_baixo"
@onready var d: Node2D = $"../spawner_direita"
@onready var e: Node2D = $"../spawner esquerda"
@onready var armadilha_spawner_v: Node2D = $"../armadilha_spawner_v"
@onready var bomba_spawner: Node2D = $"../bomba_spawner"

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var flechas = 4
var bombas = 1
var espinhos = 1

func rand_arrow(f):

	b.active = false
	c.active = false
	e.active = false
	d.active = false
	var lado = randi_range(1, 4)
	var q =  randi_range(1, f)
	
	match lado:
		1:
			b.active = true
			b.quantite = q
		2:
			c.active = true
			c.quantite = q
		3:
			d.active = true
			d.quantite = q
		4:	
			e.active = true
			e.quantite = q
	
	return q


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	timer += delta
	
	if timer > 30:
		pass
	elif timer > 20:
		pass
	elif timer > 10:
		armadilha_spawner_v.active = true
		var i = flechas + 1
		while i > 0:
			i -= rand_arrow(i)
	else:
		armadilha_spawner_v.active = false
		bomba_spawner.active = false
		var i = flechas
		while i > 0:
			i -= rand_arrow(i)

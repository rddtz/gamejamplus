extends Node2D
@onready var c: Node2D = $"../spawner_cima"
@onready var b: Node2D = $"../spawner_baixo"
@onready var d: Node2D = $"../spawner_direita"
@onready var e: Node2D = $"../spawner esquerda"
@onready var armadilha_spawner_v: Node2D = $"../armadilha_spawner_v"
@onready var bomba_spawner: Node2D = $"../bomba_spawner"

const SEG = 10
var SHOOT_TIME = 1
var timer = 0
var shoot = SHOOT_TIME
var flechas := 2
var espinhos := 2
var explosao := 2

var inc_speed = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	b.active = false
	c.active = false
	e.active = false
	d.active = false
	bomba_spawner.active = false
	armadilha_spawner_v.active = false
	pass # Replace with function body.

func active_side(l, q):
	
	match l:
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

func rand_arrow(f):

	b.active = false
	c.active = false
	e.active = false
	d.active = false
	var q_lados = randi_range(1, 4)
	var q = 0
	var lado = 0
	var lado2 = 0

	print(q_lados)
	
	if q_lados == 1:
		lado = randi_range(1, 4)
		active_side(lado, f)
	
	if q_lados == 2:
		while lado == lado2:
			lado = randi_range(1, 4)
			lado2 = randi_range(1, 4)

		q = randi_range(1, f-1)
		active_side(lado, q)
		q = randi_range(1, f-q)
		active_side(lado2, q)

	if q_lados == 3:
		lado = randi_range(1, 4)
		var restam = 2
		
		if lado != 1:
			q = randi_range(1, f-restam)
			f -= q
			restam -= 1
			active_side(1, q)
		if lado != 2:
			q = randi_range(1, f-restam)
			f -= q
			restam -= 1
			active_side(2, q)
		if lado != 3:
			q = randi_range(1, f-restam)
			f -= q
			restam -= 1
			active_side(3, q)
		if lado != 4:
			q = randi_range(1, f-restam)
			f -= q
			restam -= 1
			active_side(4, q)
	if q_lados == 4:
		var restam = 3
		q = randi_range(1, f-restam)
		f -= q
		restam -= 1
		active_side(1, q)
		q = randi_range(1, f-restam)
		f -= q
		restam -= 1
		active_side(2, q)
		q = randi_range(1, f-restam)
		f -= q
		restam -= 1
		active_side(3, q)
		q = randi_range(1, f-restam)
		f -= q
		restam -= 1
		active_side(4, q)
	print("ATIROU")

func num_flechas(f, t):
	
	f = min(16, f + t/4) #min(8, f + t/5)
	return f
	
func set_arrow_speed(t):
	b.speed += 5
	c.speed += 5
	d.speed += 5
	e.speed += 5
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	flechas = num_flechas(2, timer)
	timer += delta
	shoot -= delta
	inc_speed -= delta
	
	if inc_speed <= 0:
		set_arrow_speed(timer)
		inc_speed = 10
	
	print(flechas)
	
	if timer > 10*SEG:
		pass
	elif timer > 5*SEG:
		bomba_spawner.active = true	
	elif timer > 2*SEG:
		SHOOT_TIME -= delta
		armadilha_spawner_v.active = true
		if shoot <= 0:
			rand_arrow(flechas)
			shoot = SHOOT_TIME
	else:
		armadilha_spawner_v.active = false
		bomba_spawner.active = false
		if shoot <= 0:
			rand_arrow(flechas)
			shoot = SHOOT_TIME

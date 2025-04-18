extends Node2D
@onready var c: Node2D = $"../spawner_cima"
@onready var b: Node2D = $"../spawner_baixo"
@onready var d: Node2D = $"../spawner_direita"
@onready var e: Node2D = $"../spawner esquerda"
@onready var armadilha_spawner_v: Node2D = $"../armadilha_spawner_v"
@onready var bomba_spawner: Node2D = $"../bomba_spawner"
@onready var player: CharacterBody2D = $"../Player"

const SEG = 10
var SHOOT_TIME = 1
var timer = 0
var shoot = SHOOT_TIME
var flechas := 2
var espinhos := 1
var explosao := 1

var inc_speed = 10
var inc_arm = 20
var inc_exp = 30

var tempo_parado = 0

var last_x = -29038190
var last_y = +89218941

var started_all = false
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

func verifica_parado(t, x, y, lx, ly) -> int:
	if x == lx && y == ly:
		return t + 1
	return 0

func rand_arrow(f):

	b.active = false
	c.active = false
	e.active = false
	d.active = false
	var q_lados = randi_range(1, 4)
	var q = 0
	var lado = 0
	var lado2 = 0
	
	if q_lados == 1:
		lado = randi_range(1, 4)
		active_side(lado, f)
	
	elif q_lados == 2:
		while lado == lado2:
			lado = randi_range(1, 4)
			lado2 = randi_range(1, 4)

		q = randi_range(1, f-1)
		active_side(lado, q)
		q = randi_range(1, f-q)
		active_side(lado2, q)

	elif q_lados == 3:
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
	elif q_lados == 4:
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

func num_flechas(f, t):
	
	f = min(16, f + t/10) #min(8, f + t/5)
	return f
	
func set_arrow_speed(t):
	b.speed += 1
	c.speed += 1
	d.speed += 1
	e.speed += 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
var state = 0
func _process(delta: float) -> void:

	flechas = num_flechas(1, timer)
	timer += delta
	shoot -= delta
	inc_speed -= delta
	inc_exp -= delta
	inc_exp -= delta

	tempo_parado = verifica_parado(tempo_parado, player.position.x, player.position.y, last_x, last_y)
	
	last_x = player.position.x
	last_y = player.position.y
	bomba_spawner.quantite = explosao
	armadilha_spawner_v.quantite = espinhos

	if tempo_parado >= 100:
			bomba_spawner.run_special(player.position.x - 24, player.position.y - 24)
			tempo_parado = 0

	if timer > .75*SEG:

		if !started_all:
			started_all == true
			explosao = 1
			espinhos = 1

		SHOOT_TIME = 0
		bomba_spawner.active = true
		armadilha_spawner_v.active = true
		rand_arrow(flechas)

		if inc_speed <= 0:
			set_arrow_speed(timer)
			inc_speed = 10
		else:
			inc_speed -= delta

		if inc_arm <= 0:
			espinhos += 1
			inc_arm = 10
		else:
			inc_arm -= delta

		if inc_exp <= 0:
			explosao += 1
			inc_exp = 10
		else:
			inc_exp -= delta


	elif timer > 0.5*SEG:
		bomba_spawner.active = true
		explosao = 4
		armadilha_spawner_v.active = false
		b.active = false
		c.active = false
		e.active = false
		d.active = false

	elif timer > .25*SEG:
		#SHOOT_TIME -= delta
		armadilha_spawner_v.active = true
		espinhos = 2
		b.active = false
		c.active = false
		e.active = false
		d.active = false
		#if shoot <= 0:
			#rand_arrow(flechas)
			#shoot = SHOOT_TIME
	else:
		armadilha_spawner_v.active = false
		bomba_spawner.active = false
		if shoot <= 0:
			rand_arrow(flechas)
			shoot = SHOOT_TIME

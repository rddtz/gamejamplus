class_name Particle
extends Node2D

@export var sprite : Texture
@export var color : Color = Color.WHITE
@export_range(0.0, 360.0) var min_direction : float
@export_range(0.0, 360.0) var max_direction : float
@export_range(0.0, 360.0) var min_rotation : float
@export_range(0.0, 360.0) var max_rotation : float
@export var rotate_bool : bool
@export var min_speed_rotation : float
@export var max_speed_rotation : float
@export var min_scale : float = 1
@export var max_scale : float = 1
@export var min_speed : float
@export var max_speed : float
@export var min_life : int
@export var max_life : int
@export var gravity : bool
@export var gravity_speed : float

@onready var sprite_2d: Sprite2D = $Sprite2D

var life_max : int
var life_index : int
var speed : float
var scale_index := 1.0
var direction := 0
var speed_rotation := 0
var speed_x := 0.0
var speed_y := 0.0
var alpha_inicial : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Configurando a imagem
	sprite_2d.texture = sprite
	sprite_2d.modulate = color
	alpha_inicial = color.a
	scale_index = randf_range(min_scale, max_scale)
	sprite_2d.scale = Vector2(scale_index, scale_index)
	sprite_2d.rotation_degrees = randf_range(min_rotation, max_rotation)
	
	#Configuracoes da particula
	life_max = randi_range(min_life, max_life)
	life_index = life_max
	speed = randf_range(min_speed, max_speed)
	@warning_ignore("narrowing_conversion")
	direction = randf_range(min_direction, max_direction)
	@warning_ignore("narrowing_conversion")
	speed_rotation = randf_range(min_speed_rotation, max_speed_rotation)
	
	#Pegando o angulo
	var angle_temp := direction * PI / 180
	speed_x = speed * cos(angle_temp)
	speed_y = speed * sin(angle_temp) * -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	#Movendo a particula
	position.x += speed_x * delta
	position.y += speed_y * delta
	
	#Fazendo a particula cair
	if gravity:
		speed_y += gravity_speed * delta
	
	#Diminuindo a alpha
	#sprite_2d.modulate.a = (alpha_inicial * life_index) / life_max;
	
	#Rotacionando
	if rotate_bool:
		sprite_2d.rotation_degrees += speed_rotation * delta
	
	#Morrendo
	@warning_ignore("narrowing_conversion")
	life_index -= 1 * delta
	
	if life_index <= 0:
		queue_free()

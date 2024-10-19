extends Node2D

@export var direction : int
@export var speed : float
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var flip_h = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = deg_to_rad(direction)
	if flip_h == 1: animated_sprite_2d.flip_h = 1 
	if direction == -90: animated_sprite_2d.rotation = deg_to_rad(-180)
	if direction == 90: animated_sprite_2d.rotation = deg_to_rad(180)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += cos(deg_to_rad(direction)) * speed * delta
	position.y += sin(deg_to_rad(direction)) * speed * delta
	
	#if direction == -1:
	#	position.x += sin(deg_to_rad(direction)) * speed * delta
	#	position.y += cos(deg_to_rad(direction)) * speed * delta
	

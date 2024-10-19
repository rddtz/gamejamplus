extends Node2D

@export var direction : int
@export var speed : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = deg_to_rad(direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x += cos(deg_to_rad(direction)) * speed * delta
	position.y += sin(deg_to_rad(direction)) * speed * delta

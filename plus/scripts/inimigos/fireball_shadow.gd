extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.modulate = Color.ORANGE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func  _physics_process(delta: float) -> void:
	
	scale.x -= 5 * delta
	scale.y -= 5 * delta
	
	if scale.y <= 0:
		queue_free()
	pass

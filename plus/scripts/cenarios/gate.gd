extends Node2D

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var shape: CollisionShape2D = %CollisionShape2D

var open := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !open && Global.time <= 0:
		sprite.play("open")
		open = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "open":
		shape.disabled = true

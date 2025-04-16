extends Node2D

var id := "Bomba"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var explodiu := false
@onready var collision: CollisionShape2D = $Damage/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite.animation == "explosao" && !explodiu:
		Global.screen_shake(25.0)
		$bombSound.pitch_scale = randf_range(1.0,1.2)
		$bombSound.play()
		explodiu = true
		
	if sprite.animation == "explosao" && sprite.frame == 2:
		collision.disabled = false
	else:
		collision.disabled = true

func destroy():
	queue_free()
	
	

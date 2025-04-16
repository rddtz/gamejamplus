extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var checking_box: CollisionShape2D = $Checking/CheckingBox
@onready var damage_box: CollisionShape2D = $Damage/DamageBox
@onready var damage: Area2D = $Damage

var activated := false
var player_is_on = false

var id = "spike"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_box.disabled = true
	checking_box.disabled = false
	pos_inicial()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_on and !activated:
		animated_sprite_2d.stop()
		animated_sprite_2d.play("activating")
		activated = true
	
	if animated_sprite_2d.animation == "damage":
		if animated_sprite_2d.frame > 0:
			damage_box.disabled = true


#Verificando se o player encostou no espinho e dai vamos ativar o espinho
func _on_checking_area_entered(area: Area2D) -> void:
	if area != damage:
		if area.get_parent().id == "player" and !player_is_on:
			player_is_on = true

func _on_checking_area_exited(area: Area2D) -> void:
	if area != damage:
		if area.get_parent().id == "player":
			player_is_on = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "damage":
		animated_sprite_2d.stop()
		animated_sprite_2d.play("default")
		activated = false
	
	if animated_sprite_2d.animation == "activating":
		animated_sprite_2d.stop()
		animated_sprite_2d.play("damage")
		damage_box.disabled = false

func pos_inicial():
	position = Vector2(int((position.x) / 16)*16 + 8, int((position.y) / 16)*16 + 8)

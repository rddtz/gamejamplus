extends Control

@onready var sprite: AnimatedSprite2D = $CanvasLayer/AnimatedSprite2D
@onready var press: Label = $CanvasLayer/AnimatedSprite2D/press
@onready var canvas: CanvasLayer = $CanvasLayer


var alpha := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	press.modulate.a = abs(cos(alpha))
	alpha += delta * .5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enviar"):
		if sprite.animation == "context":
			movements()
		else:
			canvas.visible = false
			get_tree().paused = false

func context():
	sprite.play("context")
	
func dodge():
	sprite.play("dodge")

func parry():
	sprite.play("parry")
	
func movements():
	sprite.play("movements")

func show_box(page):
	get_tree().paused = true
	canvas.visible = true
	
	match page:
		0:
			context()
		1:
			movements()
		2:
			dodge()
		3:
			parry()

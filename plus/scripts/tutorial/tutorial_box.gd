extends CanvasLayer

@onready var press: Label = $AnimatedSprite2D/press
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var alpha := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	press.modulate.a = abs(cos(alpha))
	alpha += delta * .5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enviar"):
		visible = false

func context():
	sprite.play("context")
	
func dodge():
	sprite.play("dodge")

func parry():
	sprite.play("parry")
	
func movements():
	sprite.play("moviments")

func show_box(page):
	visible = true
	
	match page:
		0:
			context()
		1:
			movements()
		2:
			dodge()
		3:
			parry()

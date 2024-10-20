extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.nome == "YOU":
		grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.nome = $".".text

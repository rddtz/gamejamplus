extends CanvasLayer

var animando = 0
var idle = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$VBoxContainer/Label.text = str(Global.score)
	att_escudo()


func att_escudo():
	if Global.quebrado and !animando:
		idle = 0
		animando+=1
		$Quebrado.play("RESET")
		$Quebrado.play("quebra")
	elif !Global.quebrado:
		animando = 0
		if !idle:
			$Quebrado.play("RESET")
			$Quebrado.play("quebra_invert")
			idle = 1
   

func _on_quebrado_animation_finished() -> void:
	if $Quebrado.animation == "quebra_invert" or $Quebrado.animation == "idle":
		$Quebrado.play("idle")

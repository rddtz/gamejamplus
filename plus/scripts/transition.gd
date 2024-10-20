extends CanvasLayer

@export var next_scene : String
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fade_in(next : String):
	next_scene = next
	#reset_scene = reset
	animation_player.stop()
	animation_player.play("transition")

func change_scene():
		get_tree().change_scene_to_file(next_scene)

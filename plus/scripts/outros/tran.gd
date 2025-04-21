extends Area2D


func _init() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	





func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		Global.ordena_score()
		Global.tran = true
		Global.primeiro = true
		Global.call_transition("res://scenes/ui/menu_principal.tscn")

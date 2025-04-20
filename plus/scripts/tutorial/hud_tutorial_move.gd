extends CanvasLayer


@onready var up: Label = $VBoxContainer/Up
@onready var down: Label = $VBoxContainer/Down
@onready var right: Label = $VBoxContainer/Right
@onready var left: Label = $VBoxContainer/Left

@export var color_off : Color
@export var color_on : Color

@export var controller : Node2D

var text_dodge := " - DODGE 5 TIMES: "
var text_parry := " - PARRY 5 TIMES: "

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if controller.page == 1:
		move_tutorial()
	elif controller.page == 2:
		dodge_tutorial()
	elif controller.page == 3:
		parry_tutorial()
		
func reset_color():
	up.modulate = color_off
	down.modulate = color_off
	right.modulate = color_off
	left.modulate = color_off

func move_tutorial():
	if controller.goals_moves[0]:
		up.modulate = color_on
	if controller.goals_moves[1]:
		down.modulate = color_on
	if controller.goals_moves[2]:
		right.modulate = color_on
	if controller.goals_moves[3]:
		left.modulate = color_on

func dodge_tutorial():
	down.text = ""
	right.text = ""
	left.text = ""
	
	up.text = text_dodge + str(controller.dodges)
	
	if controller.dodges >= 5:
		up.modulate = color_on

func parry_tutorial():
	up.text = text_parry + str(controller.parrys)
	
	if controller.parrys >= 5:
		up.modulate = color_on

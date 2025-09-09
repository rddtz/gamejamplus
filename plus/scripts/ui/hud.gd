extends CanvasLayer

var animando = 0
var idle = 1
var index = 0
@onready var timer: Label = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.highscore = Global.leaderboard["scores"][9]
	#$VBoxContainer/Highscore.text += "\n" + str(Global.highscore)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var scores = []
	
	var ld = Global.leaderboard
	for i in range(len(ld["scores"])):
		var entry = {"name": ld["names"][i], "score":  ld["scores"][i]} 
		scores.append(entry)
		
	var our_score = {"name": Global.nome, "score":  Global.score} 
	scores.append(our_score)
	scores.sort_custom(func(a, b): return a.score > b.score)
	
	var our_index = 0
	for i in range(scores.size()):
		if scores[i] == our_score:
			our_index = i
			
			
	var highlight_color: Color = Color.YELLOW
	var leaderboard_font = preload("res://assets/fonts/Pixellari.ttf")

	# A reference to the font size for the score entries.
	var font_size: int = 24
	for child in $VBoxContainer.get_children():
		child.queue_free()
	#
	var labelHIGH = Label.new()
	labelHIGH.text = "HIGHSCORE"
	labelHIGH.add_theme_font_size_override("font_size", font_size + 16)
	labelHIGH.add_theme_font_override("font", leaderboard_font)
	$VBoxContainer.add_child(labelHIGH)
	for i in range(scores.size()):
		var entry = scores[i]
		
		# Create a new Label node for this score entry.
		var label = Label.new()
		
		# Format the text nicely. Example: "1. KEV - 150200"
		label.text = "%d. %s - %d" % [i + 1, entry.name, entry.score]
		
		# Set font size. For a real project, you'd use theme overrides.
		label.add_theme_font_size_override("font_size", font_size)
		label.add_theme_font_override("font", leaderboard_font)
		# --- 3. The Highlighting Logic ---
		# Check if the current index 'i' is the one we need to highlight.
		if i == our_index:
			# If it is, change its color.
			label.modulate = highlight_color
		
		# Add the newly created and configured label to the VBoxContainer.
		$VBoxContainer.add_child(label)

	sec_to_minutes()

func sec_to_minutes():
	if Global.time >= 0:
		var min := Global.time / 60
		var sec := str(Global.time % 60)
		
		if int(sec) < 10:
			sec = "0"+sec
		timer.text = "TIMER\n"+ "0" + str(min) + ":" + sec

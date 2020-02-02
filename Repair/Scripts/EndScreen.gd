extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var label = "The Default Failure. How did you get here?"


	
	var poor = PlayerVariables.endgame_money <= 0
	var rich = PlayerVariables.endgame_money >= 1000
	var hated = PlayerVariables.endgame_opinion <= 0
	var loved = PlayerVariables.endgame_opinion >= 1000
	var corrupt = PlayerVariables.endgame_morality <= 0
	var lawful = PlayerVariables.endgame_morality >= 1000
	
	
	if poor:
		label = "The province is bankrupt. Don't worry, we'll get a bailout... probably."
	if rich:
		label = "Your high fares have led to an increase of car sales. You'll be backrupt within the year."
	if hated:
		label = "Online social media has declared you \"Cancelled\". You have been fired without inquiry."
	if loved:
		label = "The people love you! That threatens the executives. You've been fired and blamed for all past discretions."
	if corrupt:
		label = "While vacationing in your Bermuda golf course, you were served a warrant. You can never return."
	if lawful:
		label = "You are a perfect paragon! This scares the higher ups. At least you'll get a severance?"
		
	if poor and hated and corrupt:
		label = "Crime didn't pay, and everyone found out about it. You have been promoted to CEO!"
	if hated and corrupt:
		label = "It seems \"Let Them Eat Cake\" wasn't a good response to your bribery charges."
	if lawful and loved and rich:
		label = "Well if you're going to add your own cards, at least be realistic."
		
	add_intro_card(label, "Play Again", "Quit", "START", "EXIT")
	
func set_labels(top, bottom):
	$"VBoxContainer/Top Text".text = top
	$"VBoxContainer/Bottom Text".text = bottom

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_intro_card(content, left_choice, right_choice, left_cons, right_cons):
	var new_card = card_scene.instance()
	new_card.init(content, left_choice, right_choice, left_cons, right_cons)

	new_card.set_position(Vector2(1024/2, 600/2))

	add_child(new_card)
	new_card.connect("chose_option", self, "_play_card")
	new_card.visible = true
	return new_card

func _play_card(card):
	if card.consequence:
		match card.consequence:
			"START":
				get_tree().change_scene("res://Scenes/CardSwipe.tscn")
			"EXIT":
				get_tree().quit()
			"_":
				pass

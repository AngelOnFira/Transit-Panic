extends Control

var deck
var card_scene = preload("res://Scenes/Card.tscn")

func _ready():
	deck = []
	deck.push_front(add_intro_card("That's all you need, have fun!", "Wait!", "Ok, I'm ready", "START", "START"))
	deck.push_front(add_intro_card("You are in charge of fixing the dilapidated transit system", "", "Ok...", "", ""))
	deck.push_front(add_intro_card("If you already know how to play, you can skip the tutorial", "Skip", "Continue", "START", ""))
	deck.push_front(add_intro_card("To start the game, swipe this card", "Exit", "Start", "EXIT", ""))
	
	deck[0].visible = true

func add_intro_card(content, left_choice, right_choice, left_cons, right_cons):
	var new_card = card_scene.instance()
	new_card.init("", content, left_choice, right_choice, left_cons, right_cons, "")

	new_card.set_position(Vector2(250, 300))

	add_child(new_card)
	new_card.connect("chose_option", self, "_play_card")
	new_card.visible = false
	return new_card

func _play_card(card):
	deck.pop_front()
	if card.consequence:
		match card.consequence:
			"START":
				get_tree().change_scene("res://Scenes/CardSwipe.tscn")
			"EXIT":
				get_tree().quit()
			"_":
				pass
	if deck.size():
		deck[0].visible = true

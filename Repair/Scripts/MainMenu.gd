extends Control

var card_scene = preload("res://Scenes/Card.tscn")

func _ready():
	add_intro_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_intro_card():
	var new_card = card_scene.instance()
	new_card.init("hi", "left", "right", "", "")

	new_card.set_position(Vector2(250, 300))

	add_child(new_card)

func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/CardSwipe.tscn")

func _on_Exit_pressed():
	get_tree().quit()

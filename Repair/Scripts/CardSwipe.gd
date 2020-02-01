extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var deck = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_card()
	_add_card()
	_add_card()
	_add_card()
	_add_card()
	_add_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		_swipe("left")
	elif event.is_action_pressed("ui_right"):
		_swipe("right")
		
func _add_card():
	var new_card = card_scene.instance()
	deck.append(new_card)
	
	add_child(new_card)
	
func _pop_card():
	var top_card = deck.pop_front()
	return top_card
	
func _swipe(direction):
	var top_card = _pop_card()
	# do the top card's action
	
	top_card.queue_free()

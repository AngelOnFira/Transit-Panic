extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")
var res_eng = preload("ResourceEngine/ResourceEngine.gd").new()

var deck = []

var focused_card


enum SWIPE {
	right,
	left
}

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_card("Card1", "Left text", "Right text", "$|100", "$|-100")
	_add_card("Card2", "Left text", "Right text", "G|100", "O|-100")
	_add_card("Card3", "Left text", "Right text", "$|100", "O|-100")
	_add_card("Card4", "Left text", "Right text", "O|100", "$|-300")
	_add_card("Card5", "Left text", "Right text", "O|100", "G|10")
	_add_card("Card6", "Left text", "Right text", "$|100", "$|200")

func _process(delta):
	updateGUI()
	
func _input(event):
	if event.is_action_pressed("ui_left"):
		_swipe(SWIPE.left)
	elif event.is_action_pressed("ui_right"):
		_swipe(SWIPE.right)
	
func _add_card(content="", left="", right="", left_c="", right_c=""):
	var new_card = card_scene.instance()
	new_card.init(content, left, right, left_c, right_c)
	
	new_card.set_position(Vector2(375, 125))
	
	deck.push_front(new_card)
	
	add_child(new_card)
	
func _pop_card():
	var top_card = deck.pop_front()
	return top_card
	
func _swipe(direction):
	var top_card = _pop_card()
	
	_play_card(direction, top_card)
	
	top_card.queue_free()

func _play_card(dir, card) :
	var player = card.get_node("Card/SwipeAnimations")
	match dir:
		SWIPE.right:
			print("RIGHT")
			player.play("SwipeRight")
			res_eng.processConsequent(card.get_right_conseq())
		SWIPE.left:
			player.play("SwipeLeft")
			print("LEFT")
			res_eng.processConsequent(card.get_left_conseq())
		_:
			pass
	yield(player, "animation_finished")
	
func updateGUI() :
	var gui_container : VBoxContainer = self.get_node("GUI").get_child(0)
	
	var gold_text : Label = gui_container.get_child(0)
	gold_text.text = "Money: " + str(res_eng.getResourceValue("$"))
	
	var opinion_text : Label = gui_container.get_child(1)
	opinion_text.text = "Opinion: " + str(res_eng.getResourceValue("O"))

	var government_text : Label = gui_container.get_child(2)
	government_text.text = "Government: " + str(res_eng.getResourceValue("G"))

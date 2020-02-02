extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")
var res_eng = preload("ResourceEngine/ResourceEngine.gd").new()

var view_width = 1025
var view_height = 600

var deck = []
var focused_card

signal finished_sheets
var sheets

const SECONDS_BETWEEN_CONSEQUENCES : float = 1.0
var seconds_since_consequence : float = 0.0


var curr_card = 0

func _ready():
	randomize()
	get_sheet("1g0Qx2i5g50F-Win9-ZwN0BTlAT-7SjDR7unNdpnu05M", "Sheet1")
	yield(self, "finished_sheets")


#	print(sheets)

	var cards = []

	# CSV Parsing
	var sheets_lines = sheets.split("\n")
	for card in sheets_lines:
		var this_card = []
		for column in card.split(","):
			this_card.append(column.substr(1, column.length() - 2))
		cards.append(this_card)
	cards.pop_front()

	# Add 5 cards to the hand from a shuffled deck
	var random_card
	for i in range(5):
		cards.shuffle()
		random_card = cards.pop_front()
		print(random_card)
		_add_card(
			random_card[1],
			random_card[2],
			random_card[4],
			random_card[3],
			random_card[5]
		)
	
	#focused_card = random_card
	#deck[0].visible = true
	
	focused_card = _add_card("This is a test card!", "Lose $500?", "Gain 500 opinion?", "$|-500", "O|500")
	focused_card.visible = true
	
	for card in deck:
		card.connect("chose_option", self, "_play_card")

func _process(delta):
	check_passive_consequences(delta)
	updateGUI()
	
func check_passive_consequences(delta):
	seconds_since_consequence += delta
	if seconds_since_consequence >= SECONDS_BETWEEN_CONSEQUENCES:
		seconds_since_consequence = 0
		for card in deck:
			# Run consequences
			pass
			
func check_for_endgame() -> bool:
	# For each resource, check if it is above or below the threshold
	# If it is, call end_game with the resource identifier and a bool if it was too high
	# (false if too low)
	var money = res_eng.getResourceValue("$")
	var opinion = res_eng.getResourceValue("O")
	var morality = res_eng.getResourceValue("G")
	
	if 	(money > 1000 or money <= 0 or opinion > 1000 or money <= 0 or morality > 1000 or money <= 0):
		end_game()
		return true
	return false

	
func end_game() -> void:
	# Animation fade out, switch to an end scene with credits
	# and a specialized output based on the resource situation
	focused_card.get_node("Container/SwipeAnimations").play("Fade Out")
	$AnimationPlayer.play("Fade To Black")
	PlayerVariables.endgame_money = res_eng.getResourceValue("$")
	PlayerVariables.endgame_morality = res_eng.getResourceValue("G")
	PlayerVariables.endgame_opinion = res_eng.getResourceValue("O")
	set_process(false)
	
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scenes/EndScreen.tscn")

func _add_card(content="", left="", right="", left_c="", right_c=""):
	var new_card = card_scene.instance()
	new_card.init(content, left, right, left_c, right_c)
	
	#choose a random position on-screen
	var x_pos = randf()*(view_width - 375)+200
	var y_pos = randf()*(view_height - 375)+200

	new_card.set_position(Vector2(x_pos, y_pos))

	new_card.visible = false
	deck.push_front(new_card)
	add_child(new_card)
	return new_card

func _play_card(card) :
	# Hide the card and play out it's consequences"
	deck[curr_card].visible = false
	res_eng.processConsequent(card.consequence)
	
	if !check_for_endgame():
		draw_card()
	

func draw_card():
	# Replace with roulette selection and priority swapping
	# Remember to set the focused card correctly
	curr_card += 1
	if curr_card == len(deck):
		print("Out of cards")
	else:
		deck[curr_card].visible = true
	pass

func updateGUI() :
	var gui_container : VBoxContainer = self.get_node("GUI").get_child(0)
	
	var gold_text : Label = gui_container.get_child(0)
	gold_text.text = "Money: " + str(res_eng.getResourceValue("$"))
	
	var opinion_text : Label = gui_container.get_child(1)
	opinion_text.text = "Opinion: " + str(res_eng.getResourceValue("O"))

	var government_text : Label = gui_container.get_child(2)
	government_text.text = "Government: " + str(res_eng.getResourceValue("G"))

func get_sheet(sheet_key, sheet_name):
	var url = "https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}"
	var url_filled = url.format({
		"key": sheet_key,
		"sheet_name": sheet_name
	})
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request(url_filled)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print("Not able to load CSV")
		
	sheets = body.get_string_from_utf8()
	print(sheets)
	
	emit_signal("finished_sheets")

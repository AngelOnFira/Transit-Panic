extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")
var res_eng = preload("ResourceEngine/ResourceEngine.gd").new()

var view_width = 1025
var view_height = 600

var deck = []
var focused_card

signal finished_sheets
var sheets

var curr_card = 0

enum SWIPE {
	right,
	left
}

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
			random_card[0],
			random_card[2],
			random_card[4],
			random_card[3],
			random_card[4]
		)
		
	focused_card = random_card

	deck[0].visible = true
	for card in deck:
		card.connect("chose_option", self, "_play_card")

func _process(delta):
	updateGUI()

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
	
	curr_card += 1
	if curr_card == len(deck):
		print("Out of cards")
	else:
		deck[curr_card].visible = true

func updateGUI() :
	var gui_container : HBoxContainer = self.get_node("GUI").get_child(0)
	
	var gold_text : Label = gui_container.get_node("MoneyCounterBox/MoneyContainer/MoneyPatch/MoneyCount")
	gold_text.text = str(res_eng.getResourceValue("$"))
	
	var opinion_photo : TextureRect = gui_container.get_node("OpinionBox/OpinionContainer/OpinionPatch/OpinionIcon")
	match res_eng.getResourceValue("O"):
		'A':
			opinion_photo.texture = preload("../Assets/Images/Opinion_5.png")
		'B':
			opinion_photo.texture = preload("../Assets/Images/Opinion_4.png")
		'C':
			opinion_photo.texture = preload("../Assets/Images/Opinion_3.png")
		'D':
			opinion_photo.texture = preload("../Assets/Images/Opinion_2.png")
		'F':
			opinion_photo.texture = preload("../Assets/Images/Opinion_1.png")
		_:
			pass

	var government_status_bar : ProgressBar = gui_container.get_node("GovernmentBox/GovernmentContainer/GovernmentPatch/ProgressBar")
	government_status_bar.value = res_eng.getResourceValue("G")

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

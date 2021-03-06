extends Control

var card_scene = preload("res://Scenes/Card.tscn")
var res_eng = preload("ResourceEngine/ResourceEngine.gd").new()

var view_width = OS.get_window_size().x
var view_height = OS.get_window_size().y

var deck = []
var focused_card

signal finished_sheets
var sheets

var curr_card

enum SWIPE {
	right,
	left
}

func _ready():
	randomize()
	get_sheet("1g0Qx2i5g50F-Win9-ZwN0BTlAT-7SjDR7unNdpnu05M", "Sheet1")
	res_eng.connect("priority_change", self, "change_priority")
	yield(self, "finished_sheets")

	var cards = []

	# CSV Parsing
	var sheets_lines = sheets.split("\n")
	for card in sheets_lines:
		var this_card = []
		for column in card.split(","):
			this_card.append(column.substr(1, column.length() - 2))
		cards.append(this_card)
	cards.pop_front()

	var random_card
	cards.shuffle()
	for i in range(cards.size()):
		random_card = cards.pop_front()
		_add_card(
			random_card[0],
			random_card[1],
			random_card[2],
			random_card[4],
			random_card[3],
			random_card[5],
			random_card[6]
		)
	
	draw_card()
	
	for card in deck:
		card.connect("chose_option", self, "_play_card")

func _process(delta):
	updateGUI()

			
func check_for_endgame() -> bool:
	# For each resource, check if it is above or below the threshold
	# If it is, call end_game with the resource identifier and a bool if it was too high
	# (false if too low)
	var money = res_eng.getResourceValue("$")
	var opinion = res_eng.getResourceValue("O")
	var morality = res_eng.getResourceValue("G")
	
	if 	(money > 1000 or money <= 0 or opinion > 1000 or opinion <= 0 or morality > 1000 or morality <= 0):
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

func _add_card(id, content="", left="", right="", left_c="", right_c="", priority=1):
	var new_card = card_scene.instance()
	new_card.init(id, content, left, right, left_c, right_c, priority)
	
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
	print(curr_card.id)
	curr_card.visible = false
	curr_card.get_node("Container/SwipeAnimations").seek(0,true)
	res_eng.processConsequent(card.consequence)
	
	if !check_for_endgame():
		draw_card()
	

func draw_card():
	# Replace with roulette selection and priority swapping
	# Remember to set the focused card correctly
	var priority_sum : int = 0
	for card in deck:
		priority_sum += card.priority
	var count : int = 0
	var rand : int = randi() % priority_sum
	
	for card in deck:
		count += card.priority
		if count > rand:
			curr_card = card
			focused_card = card
			curr_card.visible = true
			return
	
	print("No card chosen!")

func change_priority(card_id, set, value):
	for card in deck:
		if card.id == card_id:
			if set:
				card.priority =  value
			else:
				card.priority = max(card.priority + value, 0)

func updateGUI() :
	var gui_container : HBoxContainer = self.get_node("GUI").get_child(0)
	var max_growth = 5
	
	var gold_progress_bar : ProgressBar = gui_container.get_node("MoneyCounterBox/MoneyContainer/MoneyPatch/ProgressBar")
	var diff = gold_progress_bar.value - res_eng.getResourceValue("$")
	if diff > max_growth:
		gold_progress_bar.value -= max_growth
	elif diff < max_growth:
		gold_progress_bar.value += max_growth
	else:
		gold_progress_bar.value = res_eng.getResourceValue("$")
	_update_progress_bar_theme(gold_progress_bar)
	
	var opinion_photo : TextureRect = gui_container.get_node("OpinionBox/OpinionContainer/OpinionPatch/OpinionIcon")
	var opinion_value = res_eng.getResourceValue("O")
	if opinion_value > 800:
		opinion_photo.texture = preload("../Assets/Images/Opinion_5.png")
	if opinion_value > 600:
		opinion_photo.texture = preload("../Assets/Images/Opinion_4.png")
	if opinion_value > 400:
		opinion_photo.texture = preload("../Assets/Images/Opinion_3.png")
	if opinion_value > 200:
		opinion_photo.texture = preload("../Assets/Images/Opinion_2.png")
	if opinion_value > 0:
		opinion_photo.texture = preload("../Assets/Images/Opinion_1.png")

	var government_status_bar : ProgressBar = gui_container.get_node("GovernmentBox/GovernmentContainer/GovernmentPatch/ProgressBar")	
	diff = government_status_bar.value - res_eng.getResourceValue("G")
	if diff > max_growth:
		government_status_bar.value -= max_growth
	elif diff < max_growth:
		government_status_bar.value += max_growth
	else:
		government_status_bar.value = res_eng.getResourceValue("G")
	_update_progress_bar_theme(government_status_bar)

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
	
	emit_signal("finished_sheets")
	
func _update_progress_bar_theme(p_bar : ProgressBar):
	if p_bar.value >= 500:
		p_bar.theme = preload("../Assets/Themes/GUI_progress_green.tres")
	elif p_bar.value >= 250:
		p_bar.theme = preload("../Assets/Themes/GUI_progress_yellow.tres")
	else:
		p_bar.theme = preload("../Assets/Themes/GUI_progress_red.tres")

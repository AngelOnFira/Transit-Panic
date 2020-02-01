extends Node


var res_eng = preload("ResourceEngine/ResourceEngine.gd").new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	testResourceEngine()

func _process(delta):
	processInput()
	updateGUI()

func testResourceEngine():
	res_eng.processConsequent("$,1000:O,-200")

func processInput():
	if(Input.is_action_just_pressed("card_swipe_left")):
		res_eng.processConsequent("$,1000")
	elif (Input.is_action_just_pressed("card_swipe_right")):
		res_eng.processConsequent("O,1000")

func updateGUI() :
	var gui_container : VBoxContainer = self.get_child(0)
	
	var gold_text : Label = gui_container.get_child(0)
	gold_text.text = "Gold: " + str(res_eng.getResourceValue("$"))
	
	var opinion_text : Label = gui_container.get_child(1)
	opinion_text.text = "Opinion: " + str(res_eng.getResourceValue("O"))

	var government_text : Label = gui_container.get_child(2)
	government_text.text = "Government: " + str(res_eng.getResourceValue("G"))
	

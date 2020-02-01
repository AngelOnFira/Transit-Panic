extends Node


var res_eng = preload("ResourceEngine.gd").new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	testResourceEngine()



func testResourceEngine():
	res_eng.processConsequent("$,1000:O,-200")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

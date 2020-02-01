extends Node

# Strings of the form A,val:B,val
var resources = preload("Resources.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func processConsequent(conseq : String):
	var all_conseq = conseq.split(":")
	for curr_conseq in all_conseq:
		activateConsquent(curr_conseq)
	
func activateConsquent(conseq : String):
	var p_conseq = conseq.split(",")
	var resource_type = resources.getResource(p_conseq[0])
	match p_conseq[0]:
		"$":
			resource_type.modify(int(p_conseq[1]))
		"O":
			resource_type.modify(int(p_conseq[1]))
		_:
			print("Not a parameter")

func getResourceValue(res_type : String):
	return resources.getResource(res_type).getValue()

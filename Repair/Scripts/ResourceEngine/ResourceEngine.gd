extends Node

signal priority_change

# Strings of the form A|val:B|val
var resources = preload("Resources.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func processConsequent(conseq : String):
	var all_conseq = conseq.split(":")
	for curr_conseq in all_conseq:
		activateConsquent(curr_conseq)
	
func activateConsquent(conseq : String):
	var p_conseq = conseq.split("|")
	var resource_type = resources.getResource(p_conseq[0])
	match p_conseq[0]:
		"$":
			resource_type.modify(int(p_conseq[1]))
		"O":
			resource_type.modify(int(p_conseq[1]))
		"G":
			resource_type.modify(int(p_conseq[1]))
		"P": # set or increase/decrease the priority of the id'ed card (card_id/set?/value)
			var priority_changes = p_conseq[1].split("/")
			emit_signal("priority_change", priority_changes[0], priority_changes[1], priority_changes[2])
		_:
			print("Not a parameter")

func getResourceValue(res_type : String):
	return resources.getResource(res_type)._getValue()

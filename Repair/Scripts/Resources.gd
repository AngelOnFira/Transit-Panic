extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resources = {}

func _init():
	resources["$"] = ResourceType.new()
	resources["O"] = ResourceType.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getResource(r_type : String):
	return resources[r_type]


class ResourceType :
	var value : int
	
	func _init():
		value = 0
	
	func modify(modifier : int) :
		value += modifier

class NumericResource : public ResourceType :
	var c_value

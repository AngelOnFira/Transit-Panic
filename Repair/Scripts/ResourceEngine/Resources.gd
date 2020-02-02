extends Node

var ResourceType = preload("ResourceType.gd")
var OpinionResource = preload("OpinionResource.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var resources = {}

func _init():
	resources["$"] = ResourceType.new()
	resources["O"] = OpinionResource.new()
	resources["G"] = ResourceType.new()
	resources["P"] = ResourceType.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getResource(r_type : String):
	return resources[r_type]

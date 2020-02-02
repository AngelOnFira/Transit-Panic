extends Node

var value : int

func _init():
	value = 500

func modify(modifier) :
	value += modifier
	
func getValue() :
	return value

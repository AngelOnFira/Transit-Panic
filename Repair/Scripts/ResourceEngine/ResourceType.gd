extends Node

var value : int

func _init():
	value = 0

func modify(modifier) :
	value += modifier
	
func _getValue() :
	return value

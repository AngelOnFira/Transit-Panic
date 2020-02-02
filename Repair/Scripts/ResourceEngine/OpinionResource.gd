extends "res://Scripts/ResourceEngine/ResourceType.gd"

func _getValue():
	if value > 80:
		return 'A'
	if value > 60:
		return 'B'
	if value > 40:
		return 'C'
	if value > 20:
		return 'D'
	return 'F'

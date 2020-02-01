var value : int

func _init():
	value = 0

func modify(modifier) :
	print(value)
	value += modifier
	print(value)

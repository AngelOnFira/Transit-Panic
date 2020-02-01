extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(content, left_choice, right_choice):
	set_content(content)
	set_left_choice(left_choice)
	set_right_choice(right_choice)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_content(text):
	$Card/Content.text = text

func set_left_choice(text):
	$Card/LeftChoice.text = text

func set_right_choice(text):
	$Card/RightChoice.text = text

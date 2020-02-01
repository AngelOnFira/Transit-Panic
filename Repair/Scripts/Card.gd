extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var left_conseq
var right_conseq

func init(title, content, left_choice, right_choice, left_cons, right_cons):
	set_title(title)
	set_content(content)
	set_left_choice(left_choice)
	set_right_choice(right_choice)
	set_left_conseq(left_cons)
	set_right_conseq(right_cons)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_title(text):
	$Card/Title.text = text

func set_content(text):
	$Card/Content.text = text

func set_left_choice(text):
	$Card/LeftChoice.text = text

func set_right_choice(text):
	$Card/RightChoice.text = text

func set_left_conseq(text):
	left_conseq = text

func set_right_conseq(text):
	right_conseq = text

func get_left_conseq():
	return left_conseq

func get_right_conseq():
	return right_conseq

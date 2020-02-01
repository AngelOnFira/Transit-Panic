extends Node2D

var left_conseq
var right_conseq

# Hacky vars to do what should be simple
var dragging : bool = false # Used to detect if it's currently being clicked on
var drag_x : int = 0  
const drag_max : int = 100        # Max distance from point of drag

# Some data for the parent to read
var swiped_left : bool = false
var consequence : String = ""

signal chose_option

func init(content, left_choice, right_choice, left_cons, right_cons):
	set_content(content)
	set_left_choice(left_choice)
	set_right_choice(right_choice)
	set_left_conseq(left_cons)
	set_right_conseq(right_cons)
	set_process_input(true)
	set_process_unhandled_input(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	init("DEFAULT_CONTENT", "DEFAULT_LEFT", "DEFAULT_RIGHT", "DEFAULT_LCONS", "DEFAULT_RCONS")

func set_content(text):
	$Content.text = text

func set_left_choice(text):
	$LeftChoice.text = text

func set_right_choice(text):
	$RightChoice.text = text

func set_left_conseq(text):
	left_conseq = text

func set_right_conseq(text):
	right_conseq = text

func get_left_conseq():
	return left_conseq

func get_right_conseq():
	return right_conseq

# Hack from https://github.com/godotengine/godot/issues/26181
func _input(event):
	get_viewport().unhandled_input(event)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		dragging = true
		drag_x = 0
	if (event is InputEventMouseButton && !event.pressed):
		dragging = false
		drag_x = 0
	if (dragging && event is InputEventMouseMotion):
		drag_x += event.relative.x
		if abs(drag_x) > drag_max:
			dragging = false
			if drag_x < 0:
				choose_left()
			else:
				choose_right()

# In these cases, since the consequences are just strings to be parsed and should
# be totally independent of the card data, we can just call our parent with the
# serialized data and it can process it for us
func choose_left():
	swiped_left = true
	consequence = left_conseq
	$SwipeAnimations.play("SwipeLeft")
	yield($SwipeAnimations, "animation_finished")
	emit_signal("chose_option", self)
	
func choose_right():
	swiped_left = false
	consequence = right_conseq
	$SwipeAnimations.play("SwipeRight")
	yield($SwipeAnimations, "animation_finished")
	emit_signal("chose_option", self)

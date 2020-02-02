extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var patrol_points
var rect
var i = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	patrol_points = $Path2D.curve.get_baked_points()
		
	rect = ColorRect.new()
	rect.set_size(Vector2(50,50))
	rect.color = Color(0.9, 0.1, 0)
	add_child(rect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	rect.set_position(patrol_points[i % (patrol_points.size())] - Vector2(25, 0))
	i+=1

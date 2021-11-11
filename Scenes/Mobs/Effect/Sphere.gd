extends Node2D

#################### VARIABLES ###############

export var NB_POINT : int = 50
export var FILL_COLOR : Color = Color(1,1,1,1)
export var OUTLINE_COLOR : Color = Color(0,1,1,1)

#################### PRIVATE METHODS ########

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	update()

func _draw():
	_draw_circle(Vector2.ZERO, 20, FILL_COLOR)
	_draw_donut(Vector2.ZERO, 20, 5, OUTLINE_COLOR)

func _draw_circle(center : Vector2, radius : float, color : Color):
	var points = PoolVector2Array()
	points.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(NB_POINT + 1):
		var angle_point = deg2rad(i * (360 - 0) / NB_POINT - 90)
		points.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points, colors)

func _draw_donut(center, radius, size, color):
	var points = PoolVector2Array()
	var colors = PoolColorArray([color])
	
	for i in range(NB_POINT + 1):
		var angle_point = deg2rad(i * (360 - 0) / NB_POINT - 90)
		points.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	for i in range(NB_POINT + 1):
		i = NB_POINT - i
		var angle_point = deg2rad(i * (360 - 0) / NB_POINT - 90)
		points.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * (radius + size))
	draw_polygon(points, colors)

extends CanvasItem

############################## VARIABLES #######################################

export var COLOR : Color = Color(1, 1, 1, 1)
export var TOP : float = 0
export var LEFT : float = 0

var position : Vector2 = Vector2.ZERO
var size : Vector2 = Vector2.ZERO
var orientation : Vector2 = Vector2.ZERO

var form : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

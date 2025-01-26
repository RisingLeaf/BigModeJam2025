extends Line2D

class_name Rope

@export
var NodeA : Node2D
@export
var NodeB : Node2D
@export_range(1, 40)
var Width : int
@export
var Stretchyness : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	points = [NodeA.position, NodeB.position]
	var length = (NodeA.position - NodeB.position).length()
	width  = max(1, Width * pow(2, -length / Stretchyness))

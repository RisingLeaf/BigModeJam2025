extends Label

@export
var PlayerInst : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Power: " + str(int(PlayerInst.Power * 10) / 10.)

extends Camera2D

class_name CameraControl

@export var PlayerInst : Player
@export var goal_zoom : float

var follow_mode   := false
var control_taken := false
const CameraSpeed := 2000.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not control_taken:
		if follow_mode:
			zoom = Vector2(goal_zoom, goal_zoom)
			var diff = PlayerInst.position - position
			position = position + (diff) * delta * 4.
		else:
			zoom = Vector2(0.2, 0.2)
			if Input.is_action_pressed("Up"):
				position += Vector2(0, -CameraSpeed) * delta
			elif Input.is_action_pressed("Down"):
				position -= Vector2(0, -CameraSpeed) * delta
			if Input.is_action_pressed("Right"):
				position += Vector2(CameraSpeed, 0.) * delta
			elif Input.is_action_pressed("Left"):
				position -= Vector2(CameraSpeed, 0.) * delta

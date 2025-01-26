extends Camera2D

class_name CameraControl

@export var PlayerInst : Player

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
			zoom = Vector2(1., 1.)
			var diff = PlayerInst.position - position
			position = position + (diff) * delta * 4.
		else:
			zoom = Vector2(0.1, 0.1)
			if Input.is_action_pressed("Up"):
				position += Vector2(0, -CameraSpeed) * delta
			elif Input.is_action_pressed("Down"):
				position -= Vector2(0, -CameraSpeed) * delta
			if Input.is_action_pressed("Right"):
				position += Vector2(CameraSpeed, 0.) * delta
			elif Input.is_action_pressed("Left"):
				position -= Vector2(CameraSpeed, 0.) * delta

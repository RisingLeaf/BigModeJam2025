extends Area2D

class_name Bubble

@export var SwingPeriod := 4. as float
@export var PlayerInst  : Player

var direction := Vector2(0., -100.)
var swing_accu := 0. as float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var swing_vector = Vector2(direction.y, direction.x)
	swing_accu += delta
	swing_accu = fmod(swing_accu, SwingPeriod)
	
	position += delta * direction + sin(swing_accu * (2. * PI / SwingPeriod)) * 0.01 * swing_vector


func _on_body_entered(body: Node2D) -> void:
	if body == PlayerInst:
		PlayerInst.Power -= 10
	call_deferred("queue_free")

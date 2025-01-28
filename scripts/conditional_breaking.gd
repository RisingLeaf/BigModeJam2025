extends StaticBody2D

class_name BreakingBarrier

@export var Collider : Area2D
@export var PlayerInst : RigidBody2D
@export var Threshold : float
@export var Sprite : Texture2D

var connected = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _draw() -> void:
	var rect = Rect2(Vector2(-0.5, -0.5), Vector2(1, 1))
	
	var fac = Threshold / 1500.
	var color = Color(1., 1. - fac, 1. - fac)
	draw_texture_rect(Sprite, rect, false, color)

func update(size : Vector2) -> void:
	scale = size
	Collider.scale = Vector2(1.2, 1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	var bodies = Collider.get_overlapping_bodies()
	if PlayerInst in bodies:
		if not connected:
			if PlayerInst.linear_velocity.length() > Threshold:
				self.queue_free()
		connected = true
	else:
		connected = false

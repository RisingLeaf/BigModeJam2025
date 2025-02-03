extends Area2D

class_name Updraft

@export var PlayerInst : Player

var inside := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inside:
		PlayerInst.apply_force(Vector2(0., -50000.))


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		inside = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		inside = false

extends Area2D

class_name Portal

@export var PlayerInst : Player
@export_file("*.tscn") var WonScene

@export var State : StateControl


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		State.end_level()

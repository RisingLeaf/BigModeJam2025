extends Node2D

@export var PlayerInst : Player
@export var PointTex : Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for p in PlayerInst.DisabledHookPoints:
		draw_texture(PointTex, p / scale - PointTex.get_size() / 2.)

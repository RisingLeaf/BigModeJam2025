extends Area2D

class_name Fish

@export var PlayerInst : Player
@export var Speed      := 100. as float
@export var AnimSpeed  := 0.4 as float
@export var Display    : Sprite2D

var anim_accu  = 0.
var anim_state = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anim_accu += delta
	if anim_accu > AnimSpeed:
		anim_accu -= AnimSpeed
		anim_state = not anim_state
		Display.frame = anim_state
		
	position += (PlayerInst.position - position).normalized() * delta * Speed


func _on_body_entered(body: Node2D) -> void:
	print(body)

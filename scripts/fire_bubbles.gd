extends Sprite2D

class_name Volcano

@export var FrameTime    := 1. as float
@export var EmissionTime := 4. as float
@export var BubblePath   : String
@export var PlayerInst   : Player


var forward   := true as bool
var time_accu := 0.   as float

var direction := Vector2(0., -100)

var emission_accu := 0. as float

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	time_accu     += delta
	emission_accu += delta
	
	if time_accu > FrameTime:
		time_accu -= FrameTime
		if forward:
			if frame >= hframes - 1:
				forward = false
				frame -= 1
			else:
				frame += 1
		else:
			if frame <= 0:
				forward = true
				frame += 1
			else:
				frame -= 1
	if emission_accu > EmissionTime:
		emission_accu -= EmissionTime
		print(EmissionTime)
		var scene = load(BubblePath)
		var instance := scene.instantiate() as Bubble
		instance.direction = direction
		instance.PlayerInst = PlayerInst
		add_child(instance)

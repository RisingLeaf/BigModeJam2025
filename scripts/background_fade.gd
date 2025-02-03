extends Control

class_name BackgroundFade

@export var main_back : TextureRect
@export var game_back : TextureRect
@export var logoa : TextureRect
@export var logob : TextureRect

@export var FadeTime := 1 as float

var fade := 0.;
var dir  := 0 as int;
var countdown := 1.;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#start_fade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dir != 0:
		countdown -= delta;
		if dir == 1:
			fade = 1. - countdown / FadeTime
		else:
			fade = countdown / FadeTime
	main_back.modulate = Color(1., 1., 1., 1. - fade)
	logoa.modulate = Color(1., 1., 1., 1. - fade)
	logob.modulate = Color(1., 1., 1., 1. - fade)
	game_back.modulate = Color(1., 1., 1., fade)
		

func start_fade() -> void:
	if fade > 0.5:
		dir = -1
	else:
		dir = 1
	countdown = FadeTime

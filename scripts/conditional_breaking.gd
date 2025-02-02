extends StaticBody2D

class_name BreakingBarrier

@export var Collider   : Area2D
@export var PlayerInst : RigidBody2D
@export var Threshold  : float
@export var Sprite     : Texture2D
@export var rect       : CollisionShape2D

@export var SoundSource : AudioStreamPlayer2D
@export_file("*.mp3") var WallbreakSounds : Array[String]
@export_file("*.mp3") var WallstableSounds : Array[String]

var dead = false
var cooldown = 2.


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _draw() -> void:
	if dead:
		return
	var rect = Rect2(Vector2(-0.5, -0.5), Vector2(1, 1))
	
	var fac = Threshold / 2200.
	var color = Color(1., 1. - fac, 1. - fac)
	draw_texture_rect(Sprite, rect, false, color)

func update(size : Vector2) -> void:
	scale = size
	Collider.scale = Vector2(1.2, 1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	if dead:
		cooldown -= delta
		if cooldown < 0.:
			self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not dead:
		if PlayerInst.linear_velocity.length() > Threshold * Autoload.PlayerForceLevel:
			dead = true
			get_node("CollisionShape2D").disabled
			var Sound = load(WallbreakSounds.pick_random())
			SoundSource.stream = Sound
			SoundSource.play()
		else:
			var Sound = load(WallstableSounds.pick_random())
			SoundSource.stream = Sound
			SoundSource.play()

extends Area2D

class_name Bubble

@export var SwingPeriod := 4. as float
@export var PlayerInst  : Player


@export var SoundSource : AudioStreamPlayer2D
@export_file("*.mp3") var BubbleHit : Array[String]

var direction := Vector2(0., -100.)
var swing_accu := 0. as float

var dead = false
var cooldown = 2.

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if dead:
		cooldown -= delta
		if cooldown < 0.:
			call_deferred("queue_free")
	var swing_vector = Vector2(direction.y, direction.x)
	swing_accu += delta
	swing_accu = fmod(swing_accu, SwingPeriod)
	
	position += delta * direction + sin(swing_accu * (2. * PI / SwingPeriod)) * 0.01 * swing_vector


func _on_body_entered(body: Node2D) -> void:
	if body == PlayerInst and not dead:
		PlayerInst.Damage(10)
		visible = false
		var Sound = load(BubbleHit.pick_random())
		SoundSource.stream = Sound
		SoundSource.play()
	else:
		dead = true
		visible = false


func _on_area_entered(area: Area2D) -> void:
	dead = true
	visible = false

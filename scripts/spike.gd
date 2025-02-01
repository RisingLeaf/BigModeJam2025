extends Area2D

class_name Spike

@export var PlayerInst : Player
@export var SoundSource : AudioStreamPlayer2D
@export_file("*.mp3") var SpikeSounds : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerInst.Damage(10)
		var Sound = load(SpikeSounds.pick_random())
		SoundSource.stream = Sound
		SoundSource.play()

extends TextureButton

@export var StateM : StateControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(StateM.start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends TextureButton

@export var StateManager : StateControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(StateManager.start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

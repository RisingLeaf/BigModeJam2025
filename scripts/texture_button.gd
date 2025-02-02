extends TextureButton

@export var ScenePath : String

func _button_pressed():
	get_tree().change_scene_to_file(ScenePath)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Autoload.reset()
	pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

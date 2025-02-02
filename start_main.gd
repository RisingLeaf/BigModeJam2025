extends TextureButton

@export var overlay_tilemap : TileMapLayer
@export var background_control : BackgroundFade

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(self.press)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func press() -> void:
	overlay_tilemap.visible = false
	overlay_tilemap.process_mode = Node.PROCESS_MODE_DISABLED
	background_control.start_fade()
	print("hi")

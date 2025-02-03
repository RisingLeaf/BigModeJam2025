extends TextureButton

@export var PlayerInst   : Player
@export var TileMapInst  : MapGen
@export var Camera       : CameraControl
@export var PointTex     : Texture2D
@export var Counter      : Label

@export var HookPoints   : int

var attached = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HookPoints = Autoload.PlacableHookpoints
	self.pressed.connect(self._button_pressed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and attached and TileMapInst.is_field_free(Camera.get_global_mouse_position()):
		PlayerInst.HookablePoints.append(Camera.get_global_mouse_position())
		PlayerInst.DisabledHookPoints = PlayerInst.HookablePoints.duplicate()
		HookPoints -= 1
		attached = false

func _button_pressed():
	if HookPoints > 0:
		attached = true

func _draw() -> void:
	if attached:
		draw_texture(PointTex, get_local_mouse_position() - PointTex.get_size() / 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Counter.text = str(HookPoints)
	queue_redraw()

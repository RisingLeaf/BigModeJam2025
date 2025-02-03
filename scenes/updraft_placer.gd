extends TextureButton


@export var PlayerInst   : Player
@export var TileMapInst  : MapGen
@export var ActionNode   : Node
@export var Camera       : CameraControl
@export var PointTex     : Texture2D
@export var Counter      : Label

@export_file("*.tscn") var UpdraftScene

@export var Drafts   : int

var attached = false
var instantiate = false
var p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Drafts = Autoload.PlayerUpdrafts
	self.pressed.connect(self._button_pressed)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and attached and TileMapInst.is_field_free(Camera.get_global_mouse_position()):
		p = Camera.get_global_mouse_position()
		instantiate = true
		Drafts -= 1
		attached = false
		
		
func _button_pressed():
	if Drafts > 0:
		attached = true

func _draw() -> void:
	if attached:
		draw_texture(PointTex, get_local_mouse_position() - PointTex.get_size() / 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if instantiate:
		instantiate = false
		var scene     = load(UpdraftScene)
		var instance := scene.instantiate() as Updraft
		instance.PlayerInst = PlayerInst
		instance.position = p
		ActionNode.add_child(instance)
	Counter.text = str(Drafts)
	queue_redraw()

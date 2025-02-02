extends TextureButton


@export var PlayerInst   : Player
@export var TileMapInst  : MapGen
@export var Camera       : CameraControl
@export var PointTex     : Texture2D
@export var Counter      : Label

@export var Breaks   : int

var attached = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Breaks = Autoload.DestroyableWalls
	self.pressed.connect(self._button_pressed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and attached:
		var p = Camera.get_global_mouse_position()
		var query = PhysicsPointQueryParameters2D.new()
		query.position = p
		var intersections = get_world_2d().direct_space_state.intersect_point(query, 32)
		for intersect in intersections:
			if intersect["collider"] is BreakingBarrier:
				intersect["collider"].queue_free()
				Breaks -= 1
				attached = false
func _button_pressed():
	if Breaks > 0:
		attached = true

func _draw() -> void:
	if attached:
		draw_texture(PointTex, get_local_mouse_position() - PointTex.get_size() / 4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	Counter.text = str(Breaks)
	queue_redraw()

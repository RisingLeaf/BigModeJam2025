extends Node2D


@export var InGameOverlay   : CanvasLayer
@export var PrestartOverlay : CanvasLayer
@export var PlayerInst      : Player
@export var ActionNode      : Node2D
@export var Camera          : CameraControl

var paused       : bool
var prestart     := false
var timer        := 1 as float
var old_cam_zoom : Vector2
var old_cam_pos  : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_prestart()

func set_prestart() -> void:
	InGameOverlay.visible   = false
	PrestartOverlay.visible = true
	
	PlayerInst.DisabledHookPoints = PlayerInst.HookablePoints
	ActionNode.process_mode       = Node.PROCESS_MODE_DISABLED
	Camera.follow_mode            = false
	paused                        = true

func start() -> void:
	paused   = false
	prestart = true
	timer    = 1.
	
	old_cam_pos  = Camera.position
	old_cam_zoom = Camera.zoom
	Camera.control_taken = true

func set_in_game() -> void:
	InGameOverlay.visible   = true
	PrestartOverlay.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hook") and paused:
		start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if prestart:
		timer -= delta
		if timer < 0.:
			prestart                = false
			ActionNode.process_mode = Node.PROCESS_MODE_INHERIT
			Camera.follow_mode      = true
			Camera.control_taken    = false
			PlayerInst.DisabledHookPoints = []
			set_in_game()
		else:
			Camera.zoom     = timer * old_cam_zoom + (1. - timer) * Vector2(Camera.goal_zoom, Camera.goal_zoom)
			Camera.position = timer * old_cam_pos  + (1. - timer) * PlayerInst.position


func _on_hook_point_placer_button_down() -> void:
	pass # Replace with function body.

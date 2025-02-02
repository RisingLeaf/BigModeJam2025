extends Node2D

class_name MainStateControl


@export var InGameOverlay   : CanvasLayer
@export var PrestartOverlay : CanvasLayer
@export var PlayerInst      : Player
@export var ActionNode      : Node
@export var Camera          : CameraControl
@export var TitleMusic           : AudioStreamPlayer
@export var Music           : AudioStreamPlayer

@export_file("*.tscn") var WonScene

var paused       : bool
var prestart     := false
var timer        := 1 as float
var old_cam_zoom : Vector2
var old_cam_pos  : Vector2

var end = false
var death = false
var countdown = 2.

func end_level(d := false) -> void:
	InGameOverlay.visible         = false
	ActionNode.process_mode       = Node.PROCESS_MODE_DISABLED
	Camera.control_taken          = true
	end = true
	death = d

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_menu()

func set_menu() -> void:
	InGameOverlay.visible   = false
	PrestartOverlay.visible = false
	
	PlayerInst.DisabledHookPoints = PlayerInst.HookablePoints
	ActionNode.process_mode       = Node.PROCESS_MODE_DISABLED
	Camera.follow_mode            = false
	paused                        = false

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if end:
		countdown -= delta
		Music.volume_db -= delta * 10
		if countdown < 0.:
			get_tree().call_deferred("change_scene_to_file", WonScene)
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

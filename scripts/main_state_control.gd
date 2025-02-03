extends Node2D

class_name MainStateControl


@export var InGameOverlay   : CanvasLayer
@export var PrestartOverlay : CanvasLayer
@export var PlayerInst      : Player
@export var ActionNode      : Node
@export var Camera          : CameraControl
@export var TitleMusic      : AudioStreamPlayer
@export var Music           : AudioStreamPlayer
@export var HookPlacer      : HookPointPlacerMain

@export var StoryInst : Story

@export_file("*.tscn") var WonScene

var paused       : bool
var prestart     := false
var timer        := 1 as float
var old_cam_zoom : Vector2
var old_cam_pos  : Vector2

var end = false
var death = false
var countdown = 2.

var preprestart = false
var prestart_countdown = 1.

var currentStage = 0

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

func set_preprestart() -> void:
	InGameOverlay.visible   = false
	PrestartOverlay.visible = false
	
	PlayerInst.DisabledHookPoints = PlayerInst.HookablePoints
	ActionNode.process_mode       = Node.PROCESS_MODE_DISABLED
	Camera.follow_mode            = false
	Camera.control_taken          = true
	paused                        = true
	old_cam_pos                   = Camera.position
	old_cam_zoom                  = Camera.zoom
	Camera.free_zoom              = Vector2(0.2, 0.2)
	preprestart                   = true

func set_prestart() -> void:
	InGameOverlay.visible   = false
	PrestartOverlay.visible = true
	
	PlayerInst.DisabledHookPoints = PlayerInst.HookablePoints
	ActionNode.process_mode       = Node.PROCESS_MODE_DISABLED
	Camera.follow_mode            = false
	Camera.control_taken          = false
	paused                        = true
	preprestart                   = false
	
	match currentStage:
		0: StoryInst.startA()
		1: StoryInst.startC()
		_: StoryInst.reset()
	

func start() -> void:
	paused   = false
	prestart = true
	timer    = 1.
	
	old_cam_pos  = Camera.position
	old_cam_zoom = Camera.zoom
	Camera.control_taken = true
	
	match currentStage:
		0: StoryInst.startB()
		_: StoryInst.reset()

func set_in_game() -> void:
	prestart                      = false
	ActionNode.process_mode       = Node.PROCESS_MODE_INHERIT
	Camera.follow_mode            = true
	Camera.control_taken          = false
	PlayerInst.DisabledHookPoints = []
	InGameOverlay.visible   = true
	PrestartOverlay.visible = false
	match currentStage:
		0: PlayerInst.position = Autoload.PlayerStageZeroPos
		1: PlayerInst.position = Autoload.PlayerStageOnePos
		2: PlayerInst.position = Autoload.PlayerStageTwoPos

func _process(delta: float) -> void:
	#print("Info " + str(prestart) + " " + str(paused) + " " + str(timer))
	if preprestart:
		prestart_countdown -= delta
		if prestart_countdown < 0.:
			set_prestart()
		else:
			Camera.zoom     = prestart_countdown * old_cam_zoom + (1. - prestart_countdown) * Camera.free_zoom
			Camera.position = prestart_countdown * old_cam_pos  + (1. - prestart_countdown) * PlayerInst.position
	if end:
		countdown -= delta
		Music.volume_db -= delta * 10
		if countdown < 0.:
			Autoload.PlayerPowerLevel = 100.
			get_tree().call_deferred("change_scene_to_file", WonScene)
	if PlayerInst.Power < 0.:
		end = false
		match currentStage:
			0: PlayerInst.position = Autoload.PlayerStageZeroPos
			1: PlayerInst.position = Autoload.PlayerStageOnePos
			2: PlayerInst.position = Autoload.PlayerStageTwoPos
		PlayerInst.Power      = Autoload.PlayerPowerLevel
		PlayerInst.HookablePoints = []
		Camera.position       = PlayerInst.position
		HookPlacer.HookPoints = Autoload.PlacableHookpoints
		set_prestart()
	if prestart:
		timer -= delta
		if timer < 0.:
			set_in_game()
		else:
			Camera.zoom     = timer * old_cam_zoom + (1. - timer) * Vector2(Camera.goal_zoom, Camera.goal_zoom)
			Camera.position = timer * old_cam_pos  + (1. - timer) * PlayerInst.position

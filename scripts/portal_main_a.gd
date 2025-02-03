extends Area2D
class_name PortalA

@export var PlayerInst : Player
@export var Camera     : CameraControl
@export var State      : MainStateControl
@export var HookPlacer : HookPointPlacerMain

@export var Stage : int

var used = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not used:
		used = true
		if Stage == 2:
			State.end_level()
			return
		match Stage:
			0: PlayerInst.position   = Autoload.PlayerStageOnePos
			1: PlayerInst.position   = Autoload.PlayerStageTwoPos
		Camera.position       = PlayerInst.position
		HookPlacer.HookPoints = Autoload.PlacableHookpoints
		State.currentStage    = Stage + 1
		State.set_prestart()

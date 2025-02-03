extends Node

var PlayerPowerLevel   := 50 as float
var PlayerDefenseLevel := 1   as float
var PlacableHookpoints := 4   as int
var PlayerAccel        := 1   as float
var DestroyableWalls   := 0   as int
var PlayerForceLevel   := 1   as float
var PlayerSaves        := 0   as int
var PlayerUpdrafts     := 0   as int


const PlayerStageZeroPos = Vector2( 661., 2084.)
const PlayerStageOnePos  = Vector2(4500., 2250.)
const PlayerStageTwoPos  = Vector2(7000., 2500.)

var Iterations = 0
func reset() -> void:
	PlayerPowerLevel   = 100
	PlayerDefenseLevel = 1
	PlacableHookpoints = 6
	PlayerAccel        = 1
	DestroyableWalls   = 0
	PlayerForceLevel   = 1
	PlayerSaves        = 0
	PlayerUpdrafts     = 0

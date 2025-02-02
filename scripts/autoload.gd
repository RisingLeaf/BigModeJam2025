extends Node

var PlayerPowerLevel   := 100 as float
var PlayerDefenseLevel := 1   as float
var PlacableHookpoints := 4   as int
var PlayerAccel        := 1   as float
var DestroyableWalls   := 0   as int
var PlayerForceLevel   := 1   as float
var PlayerSaves        := 0   as int

var Iterations = 0
func reset() -> void:
	PlayerPowerLevel   = 100
	PlayerDefenseLevel = 1
	PlacableHookpoints = 6
	PlayerAccel        = 1
	DestroyableWalls   = 0
	PlayerForceLevel   = 1
	PlayerSaves        = 0

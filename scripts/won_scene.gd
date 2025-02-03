extends Control

@export_file("*.tscn") var MainGameFile

@export var Continue : TextureRect
@export var ContinueInactiveTex : Texture2D
@export var ContinueActiveTex   : Texture2D


@export var OpATex  : TextureRect
@export var OpADesc : RichTextLabel
@export var OpABord : TextureRect
@export var OpBTex  : TextureRect
@export var OpBDesc : RichTextLabel
@export var OpBBord : TextureRect
@export var OpCTex  : TextureRect
@export var OpCDesc : RichTextLabel
@export var OpCBord : TextureRect


enum Types {
	power,
	defense,
	hook_point,
	accel,
	wall,
	force,
	save,
	updraft
}

const Descriptions = {
	Types.power      : "[b]Power Up:[/b]\nPermanent increase in power per run.",
	Types.defense    : "[b]Defense Up:[/b]\nDecrease lost power by damage.",
	Types.hook_point : "[b]Extra Hook:[/b]\nPlace one more hook per run.",
	Types.accel      : "[b]Accel Up:[/b]\nIncrease acceleration around hook.",
	Types.wall       : "[b]Wall break:[/b]\nBreak one wall before starting the run.",
	Types.force      : "[b]Force Up:[/b]\nBreak walls and kill enemies easier.",
	Types.save       : "[b]Invictus:[/b]\nSaves you from splashing once.",
	Types.updraft    : "[b]Plasma Wind:[/b]\nPushes you upwards very fast."
}

@export_category("Textures")
@export var PowerTex   : Texture2D
@export var DefenseTex : Texture2D
@export var HookTex    : Texture2D
@export var AccelTex   : Texture2D
@export var WallTex    : Texture2D
@export var ForceTex   : Texture2D
@export var SaveTex    : Texture2D
@export var UpdraftTex : Texture2D

var options : Array[Types]
var selected = -1 as int

func _ready() -> void:
	Continue.texture = ContinueInactiveTex
	for i in range(3):
		var available_types = []
		for t in Types.values():
			if t not in options:
				available_types.append(t)
		var new_type = available_types.pick_random()
		options.append(new_type)
		var tex : Texture2D
		match new_type:
			Types.power:
				tex = PowerTex
			Types.defense:
				tex = DefenseTex
			Types.hook_point:
				tex = HookTex
			Types.accel:
				tex = AccelTex
			Types.wall:
				tex = WallTex
			Types.force:
				tex = ForceTex
			Types.save:
				tex = SaveTex
			Types.updraft:
				tex = UpdraftTex
		var rec : TextureRect
		var desc : RichTextLabel
		match i:
			0: rec = OpATex; desc = OpADesc
			1: rec = OpBTex; desc = OpBDesc
			2: rec = OpCTex; desc = OpCDesc
		
		rec.texture = tex
		desc.text = Descriptions[new_type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func input(id : int) -> void:
	selected = id
	if selected >= 0:
			Continue.texture = ContinueActiveTex
	for i in range(3):
		var rec : TextureRect
		match i:
			0: rec = OpABord;
			1: rec = OpBBord;
			2: rec = OpCBord;
		rec.visible = (i + 1) == selected
		
	print(id)


func _on_option_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		input(1)

func _on_option_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		input(2)


func _on_option_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		input(3)


func _on_continue_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and selected >= 0:
		match options[selected - 1]:
			Types.power:
				Autoload.PlayerPowerLevel   += 20
			Types.defense:
				Autoload.PlayerDefenseLevel += 0.3
			Types.hook_point:
				Autoload.PlacableHookpoints += 1
			Types.accel:
				Autoload.PlayerAccel += 0.2
			Types.wall:
				Autoload.DestroyableWalls += 1
			Types.force:
				Autoload.PlayerForceLevel *= 0.9
			Types.save:
				Autoload.PlayerSaves += 1
			Types.updraft:
				Autoload.PlayerUpdrafts += 1
		Autoload.Iterations += 1
		get_tree().call_deferred("change_scene_to_file", MainGameFile)

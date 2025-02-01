extends RigidBody2D

class_name Player

@export var Sprite : Texture2D
@export var RopeInst : Rope
@export var HookPoint : PinJoint2D
@export var ScenePath : String
@export var PowerDrainOverlay : PowerDrain

@export var AudioSource : AudioStreamPlayer2D
@export_file("*.mp3") var HookAttachSounds : Array[String]
@export_file("*.mp3") var HookDetachSounds : Array[String]


var HookablePoints := [] as Array[Vector2]
var DisabledHookPoints = [] as Array[Vector2]

var hooked        := false
var Power         := 100.
var DamageCooldown = -1.


@onready var raycast : RayCast2D


func _ready() -> void:
	Power = Autoload.PlayerPowerLevel
	HookPoint.node_b = ^""
	RopeInst.visible = false
	
func _input(event):
	if event.is_action_pressed("hook") and not hooked:
		HookPoint.node_b = self.get_path()
		RopeInst.visible = true
		hooked = true
		var Sound = load(HookAttachSounds.pick_random())
		AudioSource.stream = Sound
		AudioSource.play()
	elif event.is_action_pressed("hook") and hooked:
		HookPoint.node_b = ^""
		RopeInst.visible = false
		hooked = false
		var Sound = load(HookDetachSounds.pick_random())
		AudioSource.stream = Sound
		AudioSource.play()

func _process(delta: float) -> void:
	if Power < 0.:
		if Autoload.PlayerSaves > 0:
			Autoload.PlayerSaves -= 1
			Power = 100.
		else:
			get_tree().call_deferred("change_scene_to_file", ScenePath)
	if not hooked:
		var space_state = get_world_2d().direct_space_state
		var min_length = INF
		var point = Vector2()
		for p in HookablePoints:
			# use global coordinates, not local to node
			var query = PhysicsRayQueryParameters2D.create(position, p)
			var result = space_state.intersect_ray(query)
			var l = (position - p).length()
			if l < min_length and not result:
				point = p
				min_length = l
		
		DisabledHookPoints.clear()
		for p in HookablePoints:
			if p != point:
				DisabledHookPoints.append(p)
				
		HookPoint.position = point
	
	if hooked:
		var accel = 10000. * Autoload.PlayerAccel
		if Input.is_action_pressed("accel ccw"):
			var accel_vector = (HookPoint.position - position).normalized()
			accel_vector = Vector2(-accel_vector.y, accel_vector.x)
			apply_force(accel_vector * accel)
			Power -= delta * 2.
		elif Input.is_action_pressed("accel cw"):
			var accel_vector = (position - HookPoint.position).normalized()
			accel_vector = Vector2(-accel_vector.y, accel_vector.x)
			apply_force(accel_vector * accel)
			Power -= delta * 2.
			
		var connection = position - HookPoint.position
		if Input.is_action_pressed("pull in") and connection.length() > 100.:
			position -= connection.normalized() * delta * 500.
			# not ideal but works
			HookPoint.disable_collision = !HookPoint.disable_collision
			HookPoint.disable_collision = !HookPoint.disable_collision

	DamageCooldown -= delta
	queue_redraw()

	
func _draw() -> void:
	var rect = Rect2(Vector2(-32., -32.), Vector2(64., 64.))
	var fac = linear_velocity.length() / 2200.
	var color = Color(1., 1. - fac, 1. - fac)
	draw_texture_rect(Sprite, rect, false, color)

func Damage(amount : float) -> void:
	if DamageCooldown < 0.:
		Power -= amount / Autoload.PlayerDefenseLevel
		DamageCooldown = .5
		PowerDrainOverlay.cooldow = 1.

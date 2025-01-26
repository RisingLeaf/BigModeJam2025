extends RigidBody2D

class_name Player

@export var Sprite : Texture2D
@export var RopeInst : Rope
@export var HookPoint : PinJoint2D

var HookablePoints := [] as Array[Vector2]
var DisabledHookPoints = [] as Array[Vector2]

var hooked    := false
var Power     := 100.


@onready var raycast : RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HookPoint.node_b = ^""
	RopeInst.visible = false
	
func _input(event):
	if event.is_action_pressed("hook") and not hooked:
		HookPoint.node_b = self.get_path()
		RopeInst.visible = true
		hooked = true
	elif event.is_action_pressed("hook") and hooked:
		HookPoint.node_b = ^""
		RopeInst.visible = false
		hooked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		if Input.is_action_pressed("accel ccw"):
			var accel_vector = (HookPoint.position - position).normalized()
			accel_vector = Vector2(-accel_vector.y, accel_vector.x)
			apply_force(accel_vector * 10000.)
			Power -= delta * 2.
		elif Input.is_action_pressed("accel cw"):
			var accel_vector = (position - HookPoint.position).normalized()
			accel_vector = Vector2(-accel_vector.y, accel_vector.x)
			apply_force(accel_vector * 10000.)
			Power -= delta * 2.
			
		var connection = position - HookPoint.position
		if Input.is_action_pressed("pull in") and connection.length() > 100.:
			position -= connection.normalized() * delta * 100.
			# not ideal but works
			HookPoint.disable_collision = !HookPoint.disable_collision
			HookPoint.disable_collision = !HookPoint.disable_collision


	queue_redraw()

	
func _draw() -> void:
	var rect = Rect2(Vector2(-32., -32.), Vector2(64., 64.))
	var fac = linear_velocity.length() / 3000.
	var color = Color(1., 1. - fac, 1. - fac)
	draw_texture_rect(Sprite, rect, false, color)
	#draw_circle(Vector2(0, 0), 20., Color(linear_velocity.length() / 4000., 0, 1.))

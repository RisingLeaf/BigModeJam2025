extends Area2D

class_name Fish

@export var PlayerInst : Player
@export var Speed      := 500. as float
@export var AnimSpeed  := 0.4 as float
@export var Display    : Sprite2D

var anim_accu  = 0.
var anim_state = 0

var death_spiral = false
var death_count_down = 2.

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not death_spiral:
		anim_accu += delta
		if anim_accu > AnimSpeed:
			anim_accu -= AnimSpeed
			anim_state = not anim_state
			Display.frame = anim_state
		
		var space_state = get_world_2d().direct_space_state
		var query       = PhysicsRayQueryParameters2D.create(position, PlayerInst.position)
		var result      = space_state.intersect_ray(query)
		if not result or result["collider"] is Player:
			position += (PlayerInst.position - position).normalized() * delta * Speed
	else :
		death_count_down -= delta
		if death_count_down < 0.:
			self.queue_free()
		Display.frame = Display.hframes * (1. - death_count_down / 2.)


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not death_spiral:
		if PlayerInst.linear_velocity.length() < 1000.:
			PlayerInst.Damage(10.)
		death_spiral = true

extends KinematicBody2D


var direction = Vector2()
var speed = 0
var ACCELERATION = 500
var DECCELERATION = 1000
var axis = Vector2()

var motion = Vector2()
var target_motion = Vector2()
var steering = Vector2()
const MASS = 2

const TOP_SPEED = 500

var target_angle = 0

func _physics_process(delta):
	get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(DECCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
	motion = move_and_slide(motion)
	look_at(position + motion)

func get_input_axis():
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(TOP_SPEED)

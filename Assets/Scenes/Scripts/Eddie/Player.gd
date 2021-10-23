extends KinematicBody2D


var wheel_base = 50

var steering_angle = 8

var velocity = Vector2.ZERO
var steer_angle

var f_acc = 300
var acc = Vector2.ZERO

var friction = -0.4
var drag = -0.0015
var braking = -50
var max_speed_reverse = 10

var TOP_SPEED = 300

func _physics_process(delta):
	acc = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acc * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 3
	acc += drag_force + friction_force

func get_input():
	var turn = 0
	if Input.is_action_pressed("ui_right"):
		turn += 1
	if Input.is_action_pressed("ui_left"):
		turn -= 1
	steer_angle = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("ui_up"):
		acc = transform.x * f_acc
	if Input.is_action_pressed("ui_down"):
		if velocity == Vector2.ZERO:
			pass
		else:
			acc = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

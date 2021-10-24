extends KinematicBody2D

var health = 50

var wheel_base = 70
var steering_angle = 10
var velocity = Vector2.ZERO
var steer_angle
# Acceleration variables
var f_acc = 300
var acc = Vector2.ZERO
# Slowing Forces
var friction = -0.4
var drag = -0.0015
var braking = -300
var max_speed_reverse = 50

var TOP_SPEED = 300 # Max Speed

func _physics_process(delta):
	acc = Vector2.ZERO
	get_input() # Gets inputs
	apply_friction() # Applies stopping forces
	calculate_steering(delta) # Calculates turning angle
	# This is where the velocity of the ship is actually calculated
	velocity += acc * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	
	if velocity.length() < 4.9:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	if velocity.length() < 100:
		friction_force *= 2
	acc += drag_force + friction_force

func get_input():
	# Gets movement controls and sets what the steer_angle will be
	var turn = 0 
	if Input.is_action_pressed("ui_right"):
		turn += 1
	if Input.is_action_pressed("ui_left"):
		turn -= 1
	steer_angle = turn * deg2rad(steering_angle)
	
	# Gets if the ship is accelerating or decelerating,
	# Then sets acceleration
	if Input.is_action_pressed("ui_up"):
		acc = transform.x * f_acc
	if Input.is_action_pressed("ui_down"):
		acc = transform.x * braking

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	# Below sets the direction the ship is heading
	var new_heading = (front_wheel - rear_wheel).normalized()
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = - new_heading * min(velocity.length(), max_speed_reverse)
	# Sets rotation of the ship
	rotation = new_heading.angle()

extends KinematicBody2D

onready var ram_head = get_node("Ram2/ram_head")
onready var duration = get_node("Ram2/duration")
onready var cooldown = get_node("Ram2/cooldown")

var health = 5

var mass
# var position
var velocity = Vector2.ZERO
var max_force = 1
var max_speed = 150
var steering = Vector2.ZERO
# rotation

export var angle = 1.2
var acc = 300
var speed = 150
var player = null
var ram_ready = true

func _ready():
	ram_head.disabled = true
	duration.set_wait_time(1)

func _physics_process(delta):
	var desired_velocity = Vector2.ZERO
	if health <= 0:
		queue_free()
	if player:
		desired_velocity = (player.position - position).normalized() * speed
		steering = desired_velocity
		look_at(position + desired_velocity)
	else:
		steering = position.direction_to(Vector2.ZERO) * speed
		look_at(position + steering)
	velocity = move_and_slide(steering)

func _on_Sight_body_entered(body):
	if body.name == "Player":
		player = body

func _on_Area2D_area_entered(body):
	health -= 5

func _on_Ram_body_entered(body):
	if ram_ready == true:
		print("Ramming speed")
		speed *= 4
		ram_head.disabled = false
		duration.start()


func _on_duration_timeout():
	speed = 150
	duration.stop()
	cooldown.set_wait_time(5)
	ram_head.disabled = true


func _on_cooldown_timeout():
	cooldown.stop()
	duration.set_wait_time(1)

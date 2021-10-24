extends "res://Assets/Scenes/Scripts/Eddie/Player.gd"

onready var duration = get_node("Ram/Duration")
onready var cooldown = get_node("Ram/Cooldown")
onready var camera = get_node("Camera2D")
onready var coll = get_node("Ram/CollisionPolygon2D")
var active

func _ready():
	duration.set_wait_time(1)
	active = true
	coll.disabled = true

func _physics_process(delta):
	if active == true:
		if Input.is_action_just_pressed("ui_select"):
			duration.start()
			coll.disabled = false
			f_acc = 2000
			TOP_SPEED = 1000

func _on_Timer_timeout():
	print("Duration done")
	active = false
	coll.disabled = true
	f_acc = 300
	TOP_SPEED = 300
	duration.stop()
	cooldown.set_wait_time(5)
	cooldown.start()

func _on_Cooldown_timeout():
	print("Ram Ready")
	duration.set_wait_time(0.5)
	cooldown.stop()
	active = true

extends "res://Assets/Scenes/Scripts/Eddie/Player.gd"

onready var timer = get_node("Ram/Timer")
onready var camera = get_node("Camera2D")
var smooth_zoom = 1
var target_zoom = 1

const ZOOM_SPEED = 10

func _ready():
	timer.set_wait_time(0.5)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_select"):
		timer.start()
		f_acc = 2000
		TOP_SPEED = 1000

func _on_Timer_timeout():
	print("Timer stopped")
	timer.set_wait_time(0.5)
	timer.stop()
	f_acc = 300
	TOP_SPEED = 300

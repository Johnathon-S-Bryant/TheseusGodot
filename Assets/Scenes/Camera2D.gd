extends Camera2D

onready var player = get_node("Player")

func _physics_process(delta):
	position.x = player.position.x
	position.y = player.position.y

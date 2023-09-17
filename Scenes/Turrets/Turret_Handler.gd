extends Node2D

var active = true

func _physics_process(delta):
	if active:
		turretTurn()

func turretTurn():
	var enemyPosition = get_global_mouse_position()
	get_node("Turret").look_at(enemyPosition)


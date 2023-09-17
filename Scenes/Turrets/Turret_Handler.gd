extends Node2D

var active = true
var enemy_array = []

func _physics_process(delta):
	if active:
		turretTurn()

func turretTurn():
	var enemyPosition = get_global_mouse_position()
	get_node("Turret").look_at(enemyPosition)



func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	pass # Replace with function body.

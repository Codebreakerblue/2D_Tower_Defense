extends Node2D

var active = false
var turret_ready = true
var turret_type
var turret_category
var enemy_array = []
var targeted_enemy
var counter = 0



func _ready():
	if active:
		self.get_node("Range/RangeCollisionShape").get_shape().radius = 0.5 * GameData.tower_data[self.turret_type]["range"]

func _physics_process(delta):
	if enemy_array.size() != 0 and active:
		select_enemy()
		turret_turn()
		if turret_ready:
			turret_fire()
	else:
		targeted_enemy = null



func turret_turn():
	get_node("Turret").look_at(targeted_enemy.position)

func turret_fire():
	
	turret_ready = false
	
	if turret_category == "cannon_t1":
		fire_cannon_t1()
		
	elif turret_category == "cannon_t2":
		fire_cannon_t2()
		
	elif turret_category == "missile":
		fire_missile()
	
	targeted_enemy.on_hit(GameData.tower_data[turret_type]["damage"], GameData.tower_data[turret_type]["category"])
	await get_tree().create_timer((60.0/GameData.tower_data[turret_type]["RPM"]), false).timeout
	
	turret_ready = true

func fire_cannon_t1():
	get_node("AnimationPlayer").play("CannonFireT1")
#	print("fired cannon!")

func fire_cannon_t2():
	
	if counter == 0:
		counter = 1
		get_node("AnimationPlayer").play("CannonFireT2A")
#		print("A!")
	else:
		counter = 0
		get_node("AnimationPlayer").play("CannonFireT2B")
#		print("B!")

func fire_missile():
	pass



func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
	var max_progress = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_progress)
	targeted_enemy = enemy_array[enemy_index]

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
#	print(enemy_array)

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())


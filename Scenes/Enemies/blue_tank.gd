extends PathFollow2D

var speed = 150
var max_hp = 200
var hp = max_hp
var alive = true
var dead_color = "999"

signal enemy_win

@onready var health_bar = get_node("HealthBar")
@onready var hit_container = get_node("HitContainer")

var cannon_t1_hit_effect = preload("res://Scenes/SupportScenes/cannon_t1_hit_effect.tscn")
var cannon_t2_hit_effect = preload("res://Scenes/SupportScenes/cannon_t2_hit_effect.tscn")
var destroy_effect = preload("res://Scenes/SupportScenes/destroy_hit_effect.tscn")

func _ready():
	health_bar.max_value = max_hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)
#	print(health_bar.max_value)
#	print(health_bar.value)


func _physics_process(delta):
	if alive:
		move(delta)
		
	if progress_ratio == 1:
		on_succeed()
		
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = self.position - Vector2 (30,30)

func on_hit(damage, category):
	
	hit_effect(category)
	
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func hit_effect(category, randomize_position = true, random_range = 30):
	
	var x_pos
	var y_pos
	var hit_position
	
	if randomize_position:
		randomize()
		x_pos = (randi() % random_range + 1) - random_range/2
		randomize()
		y_pos = (randi() % random_range + 1) - random_range/2
		hit_position = Vector2(x_pos,y_pos)
		
	else:
		hit_position = Vector2(0,0)
	
	if category == "cannon_t1":
		var new_hit = cannon_t1_hit_effect.instantiate()
		new_hit.position = hit_position
		hit_container.add_child(new_hit)
		
	elif category == "cannon_t2":
		var new_hit = cannon_t2_hit_effect.instantiate()
		new_hit.position = hit_position
		hit_container.add_child(new_hit)
		
	elif category == "destroy":
		var new_hit = destroy_effect.instantiate()
		new_hit.position = hit_position
		hit_container.add_child(new_hit)

func on_succeed():
	pass ## TODO make this work ;_;
	self.queue_free()
	

func on_destroy():
	
	alive = false
	get_node("CharacterBody").queue_free()
	
	get_node("Body").modulate = Color(dead_color)
	
	hit_effect("destroy", true, 16)
		
	await get_tree().create_timer(0.3, false).timeout
	self.queue_free()
	## TODO add explosion effects on death

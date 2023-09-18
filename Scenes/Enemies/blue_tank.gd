extends PathFollow2D

var speed = 150
var max_hp = 50
var hp = max_hp

@onready var health_bar = get_node("HealthBar")
@onready var hit_container = get_node("HitContainer")

var cannon_t1_hit_effect = preload("res://Scenes/SupportScenes/cannon_t1_hit_effect.tscn")
var cannon_t2_hit_effect = preload("res://Scenes/SupportScenes/cannon_t2_hit_effect.tscn")

func _ready():
	health_bar.max_value = max_hp
	health_bar.value = hp
	health_bar.set_as_top_level(true)
	
#	print(health_bar.max_value)
#	print(health_bar.value)


func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = self.position - Vector2 (30,30)

func on_hit(damage, category):
	
	hit_effect(category)
	
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func hit_effect(category):
	
	randomize()
	var x_pos = (randi() % 31) - 16
	randomize()
	var y_pos = (randi() % 31) - 16
	
	var hit_position = Vector2(x_pos,y_pos)
	
	if category == "cannon_t1":
		var new_hit = cannon_t1_hit_effect.instantiate()
		new_hit.position = hit_position
		hit_container.add_child(new_hit)
		
	elif category == "cannon_t2":
		var new_hit = cannon_t2_hit_effect.instantiate()
		new_hit.position = hit_position
		hit_container.add_child(new_hit)


func on_destroy():
	self.queue_free()
	## TODO add explosion effects on death

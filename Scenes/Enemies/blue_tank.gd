extends PathFollow2D

var speed = 150
var max_hp = 50
var hp = max_hp

@onready var health_bar = get_node("HealthBar")

func _ready():
	health_bar.max_value = max_hp
	print(health_bar.max_value)
	health_bar.value = hp
	print(health_bar.value)
	health_bar.set_as_top_level(true)

func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + speed * delta)
	health_bar.position = self.position - Vector2 (30,30)

func on_hit(damage):
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()
		

func on_destroy():
	self.queue_free()

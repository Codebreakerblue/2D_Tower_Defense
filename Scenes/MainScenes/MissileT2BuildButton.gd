extends TextureButton

var tower_type = "missile_t2"

signal build_pressed(tower_type)

func _pressed():
	build_pressed.emit(tower_type)
#	print(self.name)

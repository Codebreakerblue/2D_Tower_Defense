extends CanvasLayer

var tower_range = 350 ## TODO make this a variable based on the tower type

func set_tower_preview(tower_type, mouse_position):
	
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("26ff00aa")
	drag_tower.active = false
	
	var range_texture = Sprite2D.new()
	var scaling = tower_range / 600.0
	range_texture.set_name("RangeIndicator")
	range_texture.scale = Vector2(scaling,scaling)
	range_texture.texture = load("res://Assets/UI/range_overlay.png")
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control,true)
	move_child(get_node("TowerPreview"), 0)
	
#	print("loaded res://Scenes/Turrets/" + tower_type + ".tscn")
#	print("tower type is " + tower_type)
#	print(mouse_position.x, ",", mouse_position.y)


func ui_update_tower_preview(tile_position, hexcolor):
	
	var control = get_node("TowerPreview")
	var drag_tower = get_node("TowerPreview/DragTower")
	if control != null:
		
		control.position = tile_position
		
		if drag_tower.modulate != Color(hexcolor):
			drag_tower.modulate = Color(hexcolor)
			control.get_node("RangeIndicator").modulate = Color(hexcolor)

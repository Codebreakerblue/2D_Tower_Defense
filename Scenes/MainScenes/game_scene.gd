extends Node2D

var map_node
var ui_node

var build_mode = false
var build_valid = false
var multiple_build = false

var build_location
var build_tile
var build_type

var valid_color = "26ff00aa"
var invalid_color = "ff442288"

var current_wave = 0
var enemies_in_wave = 0


func _ready():
	
	map_node = get_node("Map1") ## TODO turn this into a variable based on selected map
	ui_node = get_node("UI")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("build_pressed", initiate_build_mode)
		print(i.name + " connected")
	

func _process(delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
		
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()

func _unhandled_key_input(event):
	if event.is_action_pressed("game_multiple_build"):
#		print("multiple build on!")
		multiple_build = true
	
	if event.is_action_released("game_multiple_build"):
#		print("multiple build off!")
		multiple_build = false

##
## Enemy Wave Functions
##

func start_next_wave():
	current_wave += 1
	var wave_data = retrieve_wave_data(current_wave)
	await get_tree().create_timer(1, false).timeout ## Padding between waves so they don't start instantly
	spawn_enemies(wave_data)

func retrieve_wave_data(current_wave):
	var wave_data = [["blue_tank", 1.0], ["blue_tank", 1.0], ["blue_tank", 1.0], ["blue_tank", 1.0], ["blue_tank", 1.0], ["blue_tank", 1.0]] ## TEMP hardcoded wave data for now
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		map_node.get_node("EnemyPath").add_child(new_enemy, true)
		await get_tree().create_timer(i[1], false).timeout
		

##
## Turret Building Functions
##

func initiate_build_mode(tower_type):
	
	if build_mode:
		cancel_build_mode()
	
	print("build mode initiated!")
	
	build_mode = true
	build_type = tower_type
	ui_node.set_tower_preview(build_type, get_global_mouse_position())
	
	print("tower type is " + build_type)

func update_tower_preview():
	
#	print("tower preview updated!")

	var tower_exclusion = map_node.get_node("TowerExclusion")
	var local_mouse_position = tower_exclusion.get_local_mouse_position()
	
	var current_tile = tower_exclusion.local_to_map(local_mouse_position)
	var tile_position = tower_exclusion.map_to_local(current_tile)

	if tower_exclusion.get_cell_source_id(0, current_tile) == -1:
		
		ui_node.ui_update_tower_preview(tile_position, valid_color)
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
		
	else:
		ui_node.ui_update_tower_preview(tile_position, invalid_color)
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		
		## TODO verify player has enough cash
		
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.turret_type = build_type
		new_tower.turret_category = GameData.tower_data[build_type]["category"]
		new_tower.active = true
		map_node.get_node("TurretContainer").add_child(new_tower, false)
		map_node.get_node("TowerExclusion").set_cell(0, build_tile, 99, Vector2i (1,0))
		map_node.get_node("Decoration").set_cell(0, build_tile, -1)
		
		## TODO deduct cash
		## TODO update cash label
		
		print("Successfully built " + build_type)
		if multiple_build == false:
			cancel_build_mode()
		
	else:
		print("Invalid placement!")









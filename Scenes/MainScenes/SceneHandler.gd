extends Node

func _ready():
	load_main_menu()

func load_main_menu():
	get_node("MainMenu/Margin/VBox/NewGameButton").connect("pressed", on_new_game_pressed)
	get_node("MainMenu/Margin/VBox/QuitButton").connect("pressed", on_quit_pressed)

func on_new_game_pressed():
	get_node("MainMenu").queue_free()
#	print("New Game pressed!")
	var game_scene = load("res://Scenes/MainScenes/game_scene.tscn").instantiate()
	add_child(game_scene)
	game_scene.get_node("UI/HUD/Margin/ExitGameButton").connect("pressed", on_exit_game_pressed)

func on_exit_game_pressed():
	get_node("GameScene").queue_free()
	print("Exit Game Pressed!")
	var main_menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	add_child(main_menu)
	load_main_menu()

func on_quit_pressed():
	get_tree().quit()


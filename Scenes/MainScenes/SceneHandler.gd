extends Node

func _ready():
	get_node("MainMenu/Margin/VBox/NewGameButton").connect("pressed", onNewGamePressed)
	get_node("MainMenu/Margin/VBox/QuitButton").connect("pressed", onQuitPressed)

func onNewGamePressed():
	get_node("MainMenu").queue_free()
#	print("New Game pressed!")
	var game_scene = load("res://Scenes/MainScenes/game_scene.tscn").instantiate()
	add_child(game_scene)

func onQuitPressed():
	get_tree().quit()


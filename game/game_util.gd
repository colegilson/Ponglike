class_name GameUtility

static func get_game() -> Game:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	print(game)
	assert(game, "Trying to get game at an invalid time!")
	return game #should serve to give us the main root node at any time
	 

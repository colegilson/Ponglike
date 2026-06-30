class_name GameUtility

static func get_game() -> Game:
	var scene_tree := Engine.get_main_loop() as SceneTree
	var game := scene_tree.current_scene as Game
	assert(game, "Trying to get game at an invalid time!")
	return game
	
static func get_UI() -> UI:
	return get_game().find_child("UI") as UI #very flimsly, no assertions necessary #boom
	
static func get_pong() -> Pong:
	var pong := get_game().find_child("Pong") as Pong
	assert(pong, "Pong is not present in the current scene tree!")
	return pong

static func get_right_p() -> Paddle:
	var r_paddle := get_pong().find_child("RightPaddle") as Paddle
	assert(r_paddle, "Right paddle is not present in the current scene tree!")
	return r_paddle

static func get_left_p() -> Paddle:
	var l_paddle := get_pong().find_child("LeftPaddle") as Paddle
	assert(l_paddle, "Left paddle is not present in the current scene tree!")
	return l_paddle

static func get_bj() -> Blackjack:
	var bj := get_game().find_child("Blackjack") as Blackjack
	#assert(bj, "Blackjack is not present in the current scene tree!")
	return bj

static func get_plinko() -> Plinko:
	var plinko := get_game().find_child("Plinko") as Plinko
	#assert(plinko, "Plinko is not present in the current scene tree!")
	return plinko

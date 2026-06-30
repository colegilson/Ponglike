class_name Pong
extends Node2D


const BALL_SCENE := preload("uid://dpieyslanfybp")

var ball: Ball = null
var left_score: int = 3
var right_score: int = 3

signal game_won(player: String)
@onready var left_score_label: Label = %LeftScoreLabel
@onready var right_score_label: Label = %RightScoreLabel
@onready var ball_spawn_position: Marker2D = %BallSpawnPosition
@onready var left_paddle: Paddle = %LeftPaddle
@onready var right_paddle: Paddle = %RightPaddle
@onready var score_sfx: AudioStreamPlayer = %ScoreSFX
@onready var music: AudioStreamPlayer2D = $BGMusic
@onready var total_score: Label = $total_score
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKO } #maybe add plinko phases and check these conditions for bugfixing?
enum state { L_RECEIVE, L_EMIT, R_RECEIVE, R_EMIT }


# Game starts with a new ball spawning
func _ready() -> void:
	total_score.text = "%d - %d" % [SaveData.left_wins, SaveData.right_wins]
	var which_side = ["Right", "Left"].pick_random()
	if which_side == "Right":
		SaveData.current_state = state.R_RECEIVE
	else: SaveData.current_state = state.L_RECEIVE
	spawn_ball(which_side)
	
	


# Control the left paddle with wasd and the right paddle with arrow keys input
func _process(_delta: float) -> void:
	if not music.is_playing():
		music.play()
	left_paddle.input = Input.get_axis("left_move_up", "left_move_down")
	right_paddle.input = Input.get_axis("right_move_up", "right_move_down")
	#var aa = SaveData.current_state
	#CONTROLLER
	match SaveData.current_state:
		state.L_RECEIVE:
			if Input.is_action_just_pressed("right_switch_paddle") and not SaveData.stick_inventory_right == []:
				right_paddle._switch_to_next()
			if Input.is_action_just_pressed("left_switch_paddle") and not SaveData.stick_inventory_left == []: #l can switch stick
				left_paddle._switch_to_next()
			if Input.is_action_just_pressed("right_switch_ball") and not SaveData.ball_inventory_right == []: #R CAN SWITCH WHEN L RECEIVING
				ball.apply_ball_data(right_switch_ball())
				ball._update_particles()
				GameUtility.get_game().print_all_in_inventory("right")
			if Input.is_action_just_pressed("left_switch_ball") and not SaveData.ball_inventory_left == []: #left can switch ball when  R receiving
				ball.apply_ball_data(left_switch_ball())
				ball._update_particles()
		state.L_EMIT:
			if Input.is_action_just_pressed("right_switch_paddle") and not SaveData.stick_inventory_right == []:
				right_paddle._switch_to_next()
				if right_paddle.name == "Pongo Bongo":
					ball.slowed = false
			if Input.is_action_just_pressed("left_switch_paddle") and not SaveData.stick_inventory_left == []: #l can switch stick
				left_paddle._switch_to_next()
				if left_paddle.name == "Pongo Bongo":
					ball.slowed = false
			if Input.is_action_just_pressed("left_switch_ball") and not SaveData.ball_inventory_left == []: #left can switch ball when emitting
				ball.apply_ball_data(left_switch_ball())
				ball._update_particles()
				GameUtility.get_game().print_all_in_inventory("left")
		state.R_RECEIVE:
			if Input.is_action_just_pressed("right_switch_paddle") and not SaveData.stick_inventory_right == []:
				right_paddle._switch_to_next()
				if right_paddle.name == "Pongo Bongo":
					ball.slowed = false
			if Input.is_action_just_pressed("left_switch_paddle") and not SaveData.stick_inventory_left == []: #l can switch stick
				left_paddle._switch_to_next()
				if left_paddle.name == "Pongo Bongo":
					ball.slowed = false
			if Input.is_action_just_pressed("left_switch_ball") and not SaveData.ball_inventory_left == []: #left can switch ball when  R receiving
				ball.apply_ball_data(left_switch_ball())
				ball._update_particles()
				GameUtility.get_game().print_all_in_inventory("left")
			if Input.is_action_just_pressed("right_switch_ball") and not SaveData.ball_inventory_right == []: #R CAN SWITCH WHEN r RECEIVING
				ball.apply_ball_data(right_switch_ball())
				ball._update_particles()
				GameUtility.get_game().print_all_in_inventory("right")
		state.R_EMIT:
			if Input.is_action_just_pressed("right_switch_paddle") and not SaveData.stick_inventory_right == []:
				right_paddle._switch_to_next()
				if right_paddle.name == "Pongo Bongo":
					ball.slowed = false
			if Input.is_action_just_pressed("left_switch_paddle") and not SaveData.stick_inventory_left == []: #l can switch stick
				left_paddle._switch_to_next()
				if left_paddle.name == "Pongo Bongo":
					ball.slowed = false
			if Input.is_action_just_pressed("right_switch_ball") and not SaveData.ball_inventory_right == []:
				ball.apply_ball_data(right_switch_ball())
				ball._update_particles()
				GameUtility.get_game().print_all_in_inventory("right")
# Spawn a new ball in a random angled direction
func spawn_ball(restart_direction: String) -> void:
	ball = BALL_SCENE.instantiate()
	ball.global_position = ball_spawn_position.global_position
	add_child(ball)
	ball.hit_paddle.connect(_on_hit_paddle)
	# choose NE, SE, SW, or NW direction based on goal scored on
	var starting_angle: float = 0.0
	if restart_direction == "Right":
		SaveData.current_state = state.R_RECEIVE
		starting_angle = [3, 5].pick_random() * PI / 4.0
	else:
		starting_angle = [1, 7].pick_random() * PI / 4.0
		SaveData.current_state = state.L_RECEIVE
	var starting_direction := Vector2.from_angle(starting_angle)
	ball.set_direction(starting_direction)

# Restart game by spawning a new ball
func restart(restart_direction: String) -> void:
	if ball:
		ball.queue_free()
	spawn_ball(restart_direction)

func left_switch_ball() -> BallData:
	print(SaveData.current_left_ball.name)
	print("index in inventory is:")
	var i = SaveData.ball_inventory_left.find(SaveData.current_left_ball)
	print(i)
	if i < (SaveData.ball_inventory_left.size() - 1):
		i+=1
	else: i = 0
	SaveData.current_left_ball = SaveData.ball_inventory_left[i]
	return SaveData.ball_inventory_left[i]
	
func right_switch_ball() -> BallData:
	var i = SaveData.ball_inventory_right.find(SaveData.current_right_ball)
	if i < (SaveData.ball_inventory_right.size() - 1):
		i+=1
	else: i = 0
	SaveData.current_right_ball = SaveData.ball_inventory_right[i]
	return SaveData.ball_inventory_right[i]
# Restart the game on either goal being entered
# Update the score
# The goals have a collision mask for just the ball and so do the sides of the court
func _on_left_goal_body_entered(_body: Node2D) -> void:
	left_score -= 1
	left_score_label.text = str(left_score)
	score_sfx.play()
	if left_score < 1:
		SaveData.right_wins += 1
		print("gere")
		if SaveData.current_right_stick.name == "The River": 
			SaveData.right_river = true
			if SaveData.current_left_stick.name == "The River": SaveData.left_river = true
		elif SaveData.current_left_stick.name == "The River": 
			SaveData.left_river = true
			SaveData.right_river = false
		game_won.emit("right")
	restart.call_deferred("Right")


func _on_right_goal_body_entered(_body: Node2D) -> void:
	right_score -= 1
	right_score_label.text = str(right_score)
	score_sfx.play()
	if right_score < 1:
		SaveData.left_wins += 1
		if SaveData.current_left_stick.name == "The River": 
			SaveData.left_river = true
			if SaveData.current_right_stick.name == "The River": SaveData.right_river = true
		elif SaveData.current_right_stick.name == "The River": 
			SaveData.left_river = false
			SaveData.right_river = true
		game_won.emit("left")
	restart.call_deferred("Left")


func _on_left_side_body_entered(body: CharacterBody2D) -> void:
	if body == ball and not SaveData.current_state == state.L_RECEIVE:
		SaveData.current_state = state.L_RECEIVE
		print(SaveData.current_state)

#TODO MAKE THESE WORK
func _on_right_side_body_entered(body: CharacterBody2D) -> void:
	if body == ball and not SaveData.current_state == state.R_RECEIVE:
		SaveData.current_state = state.R_RECEIVE
		print(SaveData.current_state)
		
func _on_hit_paddle(paddle: CharacterBody2D):
	if paddle == left_paddle and not SaveData.current_state == state.L_EMIT:
		left_paddle.collision_fx()
		SaveData.current_state = state.L_EMIT
		print(SaveData.current_state)
	elif paddle == right_paddle and not SaveData.current_state == state.R_EMIT:
		right_paddle.collision_fx()
		SaveData.current_state = state.R_EMIT
		print(SaveData.current_state)

func _on_left_side_body_exited(body: CharacterBody2D) -> void:
	if body == ball and not SaveData.current_state == state.R_RECEIVE:
		SaveData.current_state = state.R_RECEIVE
		print(SaveData.current_state)


func _on_right_side_body_exited(body: CharacterBody2D) -> void:
	if body == ball and not SaveData.current_state == state.L_RECEIVE:
		SaveData.current_state = state.L_RECEIVE
		print(SaveData.current_state)

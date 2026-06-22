extends Node2D
@export var possible_balls: Array[BallData]
@export var possible_sticks: Array[StickData]
@onready var ball: Area2D = $ShopBall
@onready var which: String = SaveData.current_user
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKO }
@onready var queue
@onready var ball_sack: Node2D = $BallSack
@onready var stick_sitch: Node2D = $SitckSitch
@onready var balls: Node2D = $Balls
@onready var sticks: Node2D = $Sticks


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not SaveData.shop_queues_done:
		SaveData.shop_queues_done = true
		queue = possible_balls.duplicate()
		queue.shuffle()
		SaveData.shop_queue_left_ball = queue
		SaveData.shop_queue_right_ball = queue
		queue = possible_sticks.duplicate()
		queue.shuffle()
		SaveData.shop_queue_left_stick = queue
		SaveData.shop_queue_right_stick = queue
		print(queue)
	if which == "left":
		SaveData.current_phase = phase.SHOPL
		GameUtility.get_UI().find_child("Player2Coins").hide()
		GameUtility.get_UI().find_child("Ringo2").hide()
		GameUtility.get_UI().find_child("Player1Coins").show()
		GameUtility.get_UI().find_child("Ringo").show()
		GameUtility.get_UI().find_child("Player").set_text("PLAYER ONE")
		GameUtility.get_UI().find_child("Player").show()
	if which == "right":
		SaveData.current_phase = phase.SHOPR
		GameUtility.get_UI().find_child("Player1Coins").hide()
		GameUtility.get_UI().find_child("Ringo").hide()
		GameUtility.get_UI().find_child("Player2Coins").show()
		GameUtility.get_UI().find_child("Ringo2").show()
		GameUtility.get_UI().find_child("Player").set_text("PLAYER TWO")
		GameUtility.get_UI().find_child("Player").show()
	populate_sticks()
	populate_balls()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func populate_sticks():
	var spots = stick_sitch.get_children()
	var i = 0
	match which:
		"left":
			queue = SaveData.shop_queue_left_stick
			for data in queue:
				var stick = data.basic_scene.instantiate()
				stick.stick_data = data
				sticks.add_child(stick)
				stick.global_position = spots[i].global_position
				stick.player_got.connect(_on_player_got_stick)
				if i < spots.size():
					i+=1
		"right":
			queue = SaveData.shop_queue_right_stick
			for data in queue:
				var stick = data.basic_scene.instantiate()
				sticks.add_child(stick)
				stick.global_position = spots[i].global_position
				stick.player_got.connect(_on_player_got_stick)
				if i < spots.size():
					i+=1		
				
func populate_balls():
	var spots = ball_sack.get_children()
	var i = 0
	match which:
		"left":
			queue = SaveData.shop_queue_left_ball
			for data in queue:
				var ball = data.basic_scene.instantiate()
				ball.ball_data = data
				balls.add_child(ball)
				ball.global_position = spots[i].global_position
				ball.player_got.connect(_on_player_got_ball)
				if i < spots.size():
					i+=1
		"right":
			queue = SaveData.shop_queue_right_ball
			for data in queue:
				var ball = data.basic_scene.instantiate()
				balls.add_child(ball)
				ball.global_position = spots[i].global_position
				ball.player_got.connect(_on_player_got_ball)
				if i < spots.size():
					i+=1		
					
func _on_player_got_ball(ball:BallData):
	match which:
		"left":
			SaveData.ball_inventory_left.append(ball)
			if ball in SaveData.shop_queue_left_ball:
				SaveData.shop_queue_left_ball.erase(ball)
			for instance in balls.get_children():
				if instance.ball_data == ball:
					instance.queue_free()
		"right":
			SaveData.ball_inventory_right.append(ball)
			if ball in SaveData.shop_queue_right_ball:
				SaveData.shop_queue_right_ball.erase(ball)
			for instance in balls.get_children():
				if instance.ball_data == ball:
					instance.queue_free()

func _on_player_got_stick(stick:StickData):
	match which:
		"left":
			if SaveData.money_left >= stick.price:
				SaveData.stick_inventory_left.append(stick)
				if ball in SaveData.shop_queue_left_stick:
					SaveData.shop_queue_left_stick.erase(stick)
				for instance in sticks.get_children():
					if instance.stick_data == stick:
						instance.queue_free()
		"right":
			if SaveData.money_right >= stick.price:
				SaveData.stick_inventory_right.append(stick)
				if ball in SaveData.shop_queue_right_stick:
					SaveData.shop_queue_right_stick.erase(stick)
				for instance in sticks.get_children():
					if instance.stick_data == stick:
						instance.queue_free()

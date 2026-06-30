extends Node2D
@export var possible_balls: Array[BallData]
@export var possible_sticks: Array[StickData]
@onready var which: String = SaveData.current_user
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKOL, PLINKOR }
var queue
@onready var ball_sack: Node2D = $BallSack
@onready var stick_sitch: Node2D = $StickSitch
@onready var balls: Node2D = $Balls
@onready var sticks: Node2D = $Sticks
@onready var player: RichTextLabel = $CanvasLayer/Player

signal shop_done(which)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not SaveData.shop_queues_done:
		SaveData.shop_queues_done = true
		queue = possible_balls.duplicate()
		queue.shuffle()
		SaveData.shop_queue_left_ball = queue.duplicate()
		SaveData.shop_queue_right_ball = queue.duplicate()
		queue = possible_sticks.duplicate()
		queue.shuffle()
		SaveData.shop_queue_left_stick = queue.duplicate()
		SaveData.shop_queue_right_stick = queue.duplicate()
		print(queue)
	if which == "left":
		SaveData.current_phase = phase.SHOPL
		GameUtility.get_UI().find_child("Player2Coins").hide()
		GameUtility.get_UI().find_child("Ringo2").hide()
		GameUtility.get_UI().find_child("Player1Coins").show()
		GameUtility.get_UI().find_child("Ringo").show()
		player.set_text("PLAYER ONE")
		player.show()
	if which == "right":
		for ball in balls.get_children():
			ball.queue_free()
		for stick in sticks.get_children():
			stick.queue_free()
		SaveData.current_phase = phase.SHOPR
		GameUtility.get_UI().find_child("Player1Coins").hide()
		GameUtility.get_UI().find_child("Ringo").hide()
		GameUtility.get_UI().find_child("Player2Coins").show()
		GameUtility.get_UI().find_child("Ringo2").show()
		player.set_text("PLAYER TWO")
		player.show()
	populate_sticks()
	populate_balls()

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func populate_sticks():
	var spots = stick_sitch.get_children()
	var i = 0
	match which:
		"left":
			queue = SaveData.shop_queue_left_stick.duplicate()
			for data in queue:
				var not_done: bool = i < spots.size()
				if not not_done: return
				var stick = data.basic_scene.instantiate()
				stick.stick_data = data
				sticks.add_child(stick)
				stick.global_position = spots[i].global_position
				stick.player_got.connect(_on_player_got_stick)
				if not_done:
					i+=1
		"right":
			queue = SaveData.shop_queue_right_stick.duplicate()
			for data in queue:
				var not_done: bool = i < spots.size()
				if not not_done: return
				var stick = data.basic_scene.instantiate()
				stick.stick_data = data
				sticks.add_child(stick)
				stick.global_position = spots[i].global_position
				stick.player_got.connect(_on_player_got_stick)
				if not_done:
					i+=1		
				
func populate_balls():
	var spots = ball_sack.get_children()
	var i = 0
	match which:
		"left":
			queue = SaveData.shop_queue_left_ball.duplicate()
			for data in queue:
				var ball = data.basic_scene.instantiate()
				ball.ball_data = data
				balls.add_child(ball)
				ball.global_position = spots[i].global_position
				ball.player_got.connect(_on_player_got_ball)
				if i < spots.size():
					i+=1
		"right":
			queue = SaveData.shop_queue_right_ball.duplicate()
			for data in queue:
				var ball = data.basic_scene.instantiate()
				ball.ball_data = data
				balls.add_child(ball)
				ball.global_position = spots[i].global_position
				ball.player_got.connect(_on_player_got_ball)
				if i < spots.size():
					i+=1		
					
func _on_player_got_ball(ball:BallData):
	#print(which)
	#print(SaveData.money_right)
	#print(ball.price)
	match which:
		"left":
			if SaveData.money_left >= ball.price:
				SaveData.lmoney_mult = ball.money_mult
				GameUtility.get_game().balance_update("left", -ball.price)
				SaveData.ball_inventory_left.append(ball)
				if ball in SaveData.shop_queue_left_ball:
					SaveData.shop_queue_left_ball.erase(ball)
				for instance in balls.get_children():
					if instance.ball_data.name == ball.name:
						instance.queue_free()
		"right":
			#print(SaveData.money_right)
			#print(ball.price) #TODO sometimes it just doesnt update right? off by one idfk how
			if SaveData.money_right >= ball.price:
				SaveData.lmoney_mult = ball.money_mult
				GameUtility.get_game().balance_update("right", -ball.price)
				SaveData.ball_inventory_right.append(ball)
				if ball in SaveData.shop_queue_right_ball:
					SaveData.shop_queue_right_ball.erase(ball)
				for instance in balls.get_children():
					if instance.ball_data.name == ball.name:
						instance.queue_free()
						

func _on_player_got_stick(stick:StickData):
	match which:
		"left":
			if SaveData.money_left >= stick.price:
				GameUtility.get_game().balance_update("left", -stick.price)
				SaveData.stick_inventory_left.append(stick)
				if stick in SaveData.shop_queue_left_stick:
					SaveData.shop_queue_left_stick.erase(stick)
				for instance in sticks.get_children():
					if instance.stick_data.name == stick.name:
						instance.queue_free()
		"right":
			if SaveData.money_right >= stick.price:
				GameUtility.get_game().balance_update("right", -stick.price)
				SaveData.stick_inventory_right.append(stick)
				if stick in SaveData.shop_queue_right_stick:
					SaveData.shop_queue_right_stick.erase(stick)
				for instance in sticks.get_children():
					if instance.stick_data.name == stick.name:
						instance.queue_free()


func _on_done_button_pressed() -> void: #emits current 
	shop_done.emit(which)
	
			

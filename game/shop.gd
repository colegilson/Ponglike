extends Node2D
@export var possible_balls: Array[BallData]
@export var possible_sticks: Array[StickData]
@onready var ball: Area2D = $ShopBall
@onready var which: String = SaveData.current_user
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKO }
@onready var queue
@onready var ball_sack: Node2D = $BallSack
@onready var stick_sitch: Node2D = $SitckSitch


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
				self.add_child(stick)
				stick.global_position = spots[i].global_position
				if i < spots.size():
					i+=1
		"right":
			queue = SaveData.shop_queue_right_stick
			for data in queue:
				var stick = data.basic_scene.instantiate()
				self.add_child(stick)
				stick.global_position = spots[i].global_position
				if i < spots.size():
					i+=1		
				

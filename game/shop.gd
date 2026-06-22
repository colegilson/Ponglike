extends Node2D
@export var possible_balls: Array[BallData]
@export var possible_sticks: Array[StickData]
@onready var ball: Area2D = $ShopBall
@onready var which: String = SaveData.current_user
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKO }
@onready var queue


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not SaveData.shop_queues_done:
		SaveData.shop_queues_done = true
		queue = possible_balls.duplicate()
		queue.shuffle()
		SaveData.shop_queue_left_ball = queue
		SaveData.shop_queue_right_ball = queue
		print(queue)
	if which == "left":
		SaveData.current_phase = phase.SHOPL
		GameUtility.get_UI().find_child("Player2Coins").hide()
		GameUtility.get_game().find_child("Ringo2").hide()
		GameUtility.get_UI().find_child("Player1Coins").show()
		GameUtility.get_game().find_child("Ringo").show()
	if which == "right":
		SaveData.current_phase = phase.SHOPR
		GameUtility.get_UI().find_child("Player1Coins").hide()
		GameUtility.get_game().find_child("Ringo").hide()
		GameUtility.get_UI().find_child("Player2Coins").show()
		GameUtility.get_game().find_child("Ringo2").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

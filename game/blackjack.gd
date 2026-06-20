extends Node2D

var left_score: int = 0
var right_score: int = 0

var suites = ["Clubs", "Diamonds", "Hearts", "Spades"]

@onready var right_hand: Node2D = $loser_hand
@onready var left_hand: Node2D = $winner_hand
@onready var winner_hand
@onready var loser_hand
@onready var winner = SaveData.recent_winner
@onready var game_over: bool = false
@export var card: PackedScene
@export var shop_scene: PackedScene

signal minigame_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if winner == "left":
		winner_hand = left_hand
		loser_hand = right_hand
	else:
		winner_hand = right_hand
		loser_hand = left_hand
	winner_hand.set_meta("blocked", true)
	winner_hand.get_child(0).text = "Waiting for other player to play"
	for i in 2:
		(right_hit(loser_hand))
		(left_hit(winner_hand))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (right_hand.get_child_count() > 4 or right_score == 21 or Input.is_action_just_released("right_move_down")) and (right_hand.get_child(0).text != "Bust!" or right_hand.get_child(0).text != "held at: %s" % right_score):
		right_hand.get_child(0).text = "held at: %s" % right_score
		if right_hand == loser_hand and left_hand.get_child(0).text != "held at: %s" % left_score:
			left_hand.set_meta("blocked", false)
		right_hand.set_meta("blocked", true)
		
	if (left_hand.get_child_count() > 4 or left_score == 21 or Input.is_action_just_released("left_move_down")) and (left_hand.get_child(0).text != "Bust!" or left_hand.get_child(0).text != "held at: %s" % left_score): 
		left_hand.get_child(0).text = "held at: %s" % left_score
		if left_hand == loser_hand and right_hand.get_child(0).text != "held at: %s" % right_score:
			right_hand.set_meta("blocked", false)
		left_hand.set_meta("blocked", true)
	
	if Input.is_action_just_released("left_move_up") and left_hand.get_meta("blocked") == false:
		left_hit(left_hand)

	if Input.is_action_just_released("right_move_up") and right_hand.get_meta("blocked") == false:
		right_hit(right_hand)
		
	if right_hand.get_meta("blocked") and left_hand.get_meta("blocked") and game_over != true:
		game_over = true
		determine_winner()
		while Input.is_action_just_released("space") != true:
			pass
		minigame_over.emit()
		

func generate_card() -> Card:
	var new_card = Card.new(suites.pick_random(), range(1, 13).pick_random())
	print(new_card.suite, new_card.value)
	return new_card
	
func right_hit(player) -> void:
	var new_card = generate_card()
	if new_card.value == 1 and right_score < 11:
		player.set_meta("has_ace", true)
		right_score += 11
	else:
		right_score += clamp(new_card.value, 1, 10)
	if right_score < 22:
		player.get_child(0).text = str(right_score)
	else:
		if player.get_meta("has_ace") == true:
			right_score += new_card.value - 10
			player.set_meta("has_ace", false)
		else:
			player.get_child(0).text = "Bust!"
			right_score = 0
			player.set_meta("blocked", true)
			
	var sprite = Sprite2D.new()
	sprite.offset = Vector2(30 * (player.get_child_count() - 1), 0)
	var png = new_card.get_png(new_card)
	sprite.texture = load("res://assets/cards/Sprites/%s" % png)
	player.add_child(sprite)

func left_hit(player) -> void:
	var new_card = generate_card()
	if new_card.value == 1 and left_score < 11:
		player.set_meta("has_ace", true)
		left_score += 11
	else:
		left_score += clamp(new_card.value, 1, 10)
		
	if left_score < 22:
		player.get_child(0).text = str(left_score)
	else:
		if player.get_meta("has_ace") == true:
			left_score += new_card.value - 10
			player.set_meta("has_ace", false)
		else:
			player.get_child(0).text = "Bust!"
			left_score = 0
			player.set_meta("blocked", true)
	
	var sprite = Sprite2D.new()
	sprite.offset = Vector2(30 * (player.get_child_count() - 1), 0)
	var png = new_card.get_png(new_card)
	sprite.texture = load("res://assets/cards/Sprites/%s" % png)
	player.add_child(sprite)

func determine_winner() -> void:
	if right_score > left_score:
		SaveData.money_right += 10
		SaveData.money_left += 4
	elif right_score < left_score:
		SaveData.money_left += 10
		SaveData.money_right += 4
	else:
		SaveData.money_left += 5
		SaveData.money_right += 5
		
	print(SaveData.money_left, " ", SaveData.money_right)

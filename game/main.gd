class_name Game
extends Node2D
@export var shop_scene: PackedScene
@export var blackjack_scene: PackedScene
@export var plinko_scene: PackedScene
@export var game_scene: PackedScene
@onready var current: Node2D = $Pong
@onready var ui: CanvasLayer = $UI
@onready var ringo_L: AnimatableBody2D = $UI/Ringo
@onready var ringo_R: AnimatableBody2D = $UI/Ringo2
enum phase { PONG, SHOPL, SHOPR, BLACKJACK, PLINKO } #maybe add plinko phases and check these conditions for bugfixing?
enum state { L_RECEIVE, L_EMIT, R_RECEIVE, R_EMIT }
@onready var round = 1
var minigame_number = 1 #0 is bj, 1 is plinko
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveData.current_phase = phase.PONG
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_game_won(player: String) -> void:
	SaveData.recent_winner = player
	balance_update(player, 5)
	current.game_won.disconnect(_on_game_game_won)
	remove_child.call_deferred(current)
	#var minigame_options = [blackjack_scene, plinko_scene]
	#minigame_number = randi_range(0, 1)
	#if minigame_number == 0: SaveData.current_phase = phase.BLACKJACK
	#else: SaveData.current_phase = phase.PLINKO
	#var minigame = minigame_options[0]
	#var minigame = plinko_scene
	#current = minigame.instantiate()
	#add_child.call_deferred(current)
	#current.minigame_over.connect(_on_minigame_over)
	#current.balance_update.connect(balance_update)
	_on_minigame_over()


func _on_minigame_over() -> void:
	remove_child.call_deferred(current)
	var shop = shop_scene
	SaveData.current_phase = phase.SHOPL
	current = shop.instantiate()
	add_child.call_deferred(current)
	

func balance_update(player: String, amount: int) -> void:
	print("updating " + player + "balance to " + str(amount))
	match player:
		"left":
			SaveData.money_left+=amount
			ringo_L.forward_flip()

		"right":
			SaveData.money_right+=amount
			ringo_R.forward_flip()

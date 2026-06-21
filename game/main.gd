extends Node2D
@export var shop_scene: PackedScene
@export var blackjack_scene: PackedScene
@export var plinko_scene: PackedScene
@export var game_scene: PackedScene
@onready var current: Node2D = $Game
@onready var ui: CanvasLayer = $UI
@onready var ringo_L: AnimatableBody2D = $UI/Ringo
@onready var ringo_R: AnimatableBody2D = $UI/Ringo2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_game_won(player: String) -> void:
	SaveData.recent_winner = player
	current.game_won.disconnect(_on_game_game_won)
	remove_child.call_deferred(current)
	#var minigame_options = [blackjack_scene, plinko_scene]
	#var minigame = minigame_options.pick_random()
	var minigame = plinko_scene
	#var minigame = blackjack_scene
	current = minigame.instantiate()
	add_child.call_deferred(current)
	current.minigame_over.connect(_on_minigame_over)
	balance_update(player, 5)


func _on_minigame_over() -> void:
	balance_update("left", SaveData.left_won)
	balance_update("right", SaveData.left_won)
	remove_child.call_deferred(current)
	var shop = shop_scene
	current = shop.instantiate()
	add_child.call_deferred(current)

func balance_update(player: String, amount: int) -> void:
	print("updating {player} balance to {amount}")
	match player:
		"left":
			SaveData.money_left+=5
			ringo_L.forward_flip()

		"right":
			SaveData.money_right+=5
			ringo_R.forward_flip()

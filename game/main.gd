extends Node2D
@export var shop_scene: PackedScene
@export var blackjack_scene: PackedScene
@export var plinko_scene: PackedScene
@export var game_scene: PackedScene
@export var possible_balls: Array[BallData]
@export var possible_sticks: Array[BallData]
@onready var current: Node2D = $Game


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

func _on_minigame_over() -> void:
	remove_child.call_deferred(current)
	var shop = shop_scene
	current = shop.instantiate()
	add_child.call_deferred(current)

extends Node2D
@export var shop_scene: PackedScene
@export var blackjack_scene: PackedScene
@export var plinko_scene: PackedScene
@export var game_scene: PackedScene
@onready var current: Node2D = $Game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func switch_scene()-> void:
	#current.game_won.disconnect(switch_to_minigames)
	#remove_child(current)
	#current = minigames_scene.instantiate()
	#add_child(current)
	#


func _on_game_game_won(player: String) -> void:
	SaveData.recent_winner = player
	get_tree().change_scene_to_file("res://game/blackjack.tscn")
	#var minigame_options = [blackjack_scene, plinko_scene]
	#var minigame = minigame_options.pick_random()
	#var minigame = plinko_scene
	#var minigame = blackjack_scene
	#current = minigame.instantiate()
	#add_child(current)
	

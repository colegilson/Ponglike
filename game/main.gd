extends Node2D
@export var shop_scene: PackedScene
@export var minigames_scene: PackedScene
@export var game_scene: PackedScene
@onready var game: Game = $Game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().change_scene_to_file("res://game/game.tscn")
	game.game_won.connect(switch_to_minigames
	)
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func switch_to_minigames()-> void:
	game.queue_free()
	minigames_scene.instantiate()
